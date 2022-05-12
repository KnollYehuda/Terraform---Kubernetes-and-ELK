#!/usr/bin/env bash

echo "Deploying a new environment with the following configuration ::"

echo "========================================================="
echo 'Global configuration ::'
jq . < json/env_args.json
echo "========================================================="
echo 'Google Cloud Service Account Details ::'
jq . < json/google_service_account_credentials.json
echo "========================================================="

if [[ ${AGREE} != 1 ]]; then
    echo -n "Continue (Y/n)? "
    read continue
fi;

if [[ ${continue:-'y'} != *[yY]* ]]; then
    echo "Canceled"
    exit;
fi

environment_name=$(jq -r .environment_name < json/env_args.json)
main_region_name=$(jq -r .main_region_name < json/env_args.json)

google_service_account_email=$(jq -r .client_email < json/google_service_account_credentials.json)
gcloud auth activate-service-account $google_service_account_email --key-file=json/google_service_account_credentials.json

terraform init
terraform apply

# retrieve Elasticache host
elasticache_host=$(aws elasticache --region $main_region_name describe-cache-clusters \
    --cache-cluster-id $environment_name --show-cache-node-info  | \
                                      jq -c -r ".CacheClusters | .[].CacheNodes | .[].Endpoint | .Address")

# retrieve MySQL host
mysql_host=$(aws rds describe-db-cluster-endpoints --region $main_region_name \
                                      --db-cluster-identifier $environment_name | \
                                      jq -c -r '.DBClusterEndpoints | .[] | select(.EndpointType=="WRITER") | .Endpoint')

# retrieve MQ host
mq_broker_host=$(aws mq describe-broker --region $main_region_name --broker-id $environment_name | \
                                      jq -c -r ".BrokerInstances | .[] | .Endpoints | .[0]")
amqps_prefix="amqps://"
mq_broker_host_credentials="amqps://$(jq -r .mq_username < json/env_args.json):$(jq -r .mq_password < json/env_args.json)@"
mq_broker_host="${mq_broker_host/$amqps_prefix/$mq_broker_host_credentials}"

# retrieve Elasticsearch host
elasticsearch_host=$(aws ec2 describe-instances --region $main_region_name \
                      --filters "Name=tag:Name,Values=$environment_name-search-and-kibana" "Name=instance-state-name,Values=running" \
                      | jq -c -r '.Reservations[0].Instances[0].NetworkInterfaces[0].Association.PublicIp')

# retrieve Logstash host
logstash_host=$(aws ec2 describe-instances --region $main_region_name \
                      --filters "Name=tag:Name,Values=$environment_name-logs-and-kibana" "Name=instance-state-name,Values=running" \
                      | jq -c -r '.Reservations[0].Instances[0].NetworkInterfaces[0].Association.PublicIp')

echo -e\
  "elasticache_host: $elasticache_host\n"\
  "mysql_host: $mysql_host\n"\
  "mq_broker_host: $mq_broker_host\n"\
  "elasticsearch_host: $elasticsearch_host\n"\
  "logstash_host: $logstash_host\n"\
| column -t -s' '

echo "Generating environment configuration ..."
mysql_env_config=$(jq -n \
                      --arg Value_01     "Value_01" \
                      --arg Value_02     "Value_02" \
                      --arg Value_03     "Value_03" \
'{
    Value_01: $Value_01,
    Value_02: $Value_02,
    Value_03: $Value_03
}' )

echo $mysql_env_config > "./${environment_name}-configuration-hosts.json"

echo "Initializing Elasticsearch ..."
sleep 5
yq -i ".\"elasticsearch.password\"=\"$(jq -r .elasticsearch_password < json/env_args.json)\"" ./elasticsearch/kibana.yml
scp -r -i "~/.ssh/$environment_name-elasticsearch.pem" ./elasticsearch ubuntu@$elasticsearch_host:~/
ssh -i "~/.ssh/$environment_name-elasticsearch.pem" ubuntu@$elasticsearch_host bash -c "cd ~/; " "sudo ./elasticsearch/elasticsearch_init.sh"
echo "======================================================================================="

echo "======================================================================================="
echo "Initializing Logstash ..."
sleep 5
echo "input {
   http {
         host => \"0.0.0.0\"
         port => \"5044\"
   }
}

output {
    elasticsearch {
      hosts => [\"http://localhost:9200\"]
      user => [\"elastic\"]
      password => [\"$(jq -r .elasticsearch_password < json/env_args.json)\"]
      index => \"logs\"
    }

    stdout { codec => rubydebug }
}
" > ./elasticsearch/logstash.conf
scp -r -i "~/.ssh/$environment_name-elasticsearch.pem" ./elasticsearch ubuntu@$logstash_host:~/
ssh -i "~/.ssh/$environment_name-elasticsearch.pem" ubuntu@$logstash_host bash -c "cd ~/; " "sudo ./elasticsearch/elasticsearch_init.sh"
ssh -i "~/.ssh/$environment_name-elasticsearch.pem" ubuntu@$logstash_host bash -c "cd ~/; " "sudo ./elasticsearch/logstash_init.sh"
echo "======================================================================================="

echo "======================================================================================="
echo "Waiting for EKS to be ready... Sleeping."
sleep 20
./init_kubernetes_files.sh $main_region_name $environment_name $elasticache_host $mysql_host $mysql_username $mysql_password
echo "======================================================================================="