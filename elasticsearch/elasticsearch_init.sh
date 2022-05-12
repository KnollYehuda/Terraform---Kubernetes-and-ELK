echo "============================================================"
echo "Adding GPG-KEY-elasticsearch..."
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "============================================================"

echo "============================================================"
echo "Installing apt-transport-https..."
sudo apt install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
echo "============================================================"

echo "============================================================"
echo "Updating apt..."
sudo apt update
echo "============================================================"

echo "============================================================"
echo "Installing Elasticsearch service..."
sudo apt install elasticsearch
echo "============================================================"

echo "============================================================"
echo "Updating jvm.options..."
sudo bash -c "cat ./elasticsearch/jvm.options > /etc/elasticsearch/jvm.options"
echo "============================================================"

echo "============================================================"
echo "Creating dir elasticsearch.service.d..."
sudo mkdir /etc/systemd/system/elasticsearch.service.d
echo "============================================================"

echo "============================================================"
echo "Copying elasticsearch.conf to /etc/systemd/system/elasticsearch.service.d/ ..."
sudo bash -c "cp ./elasticsearch/elasticsearch.conf /etc/systemd/system/elasticsearch.service.d/"
echo "============================================================"

echo "============================================================"
echo "Updating elasticsearch.yml..."
sudo bash -c "cat ./elasticsearch/elasticsearch.yml > /etc/elasticsearch/elasticsearch.yml"
echo "============================================================"

echo "============================================================"
echo "Reloading systemctl daemon... 01"
sudo systemctl daemon-reload
echo "============================================================"

echo "============================================================"
echo "Starting Elasticsearch service..."
sudo systemctl start elasticsearch.service
echo "============================================================"

echo "============================================================"
echo "Enabling Elasticsearch service..."
sudo systemctl enable elasticsearch.service
echo "============================================================"

echo "============================================================"
echo 'Installing Kibana Service...'
sleep 5
sudo apt install kibana
echo "============================================================"

echo "============================================================"
echo "Updating kibana.yml..."
sudo bash -c "cat ./elasticsearch/kibana.yml > /etc/kibana/kibana.yml"
echo "============================================================"

echo "============================================================"
echo "Reloading systemctl daemon... 02"
sudo systemctl daemon-reload
echo "============================================================"

echo "============================================================"
echo "Starting Kibana service..."
sudo systemctl start kibana.service
echo "============================================================"

echo "============================================================"
echo "Enabling Kibana service..."
sudo systemctl enable kibana.service
echo "============================================================"

echo 'Done.'
echo 'Setting new password...'
echo '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
echo 'PAY ATTENTION!!! USE THE PASSWORD FROM env_args.json FILE!!! (elasticsearch_password)'
echo '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
#curl -d "{\"password\":\"${NEW_PASSWORD}\"}" -H "Content-Type: application/json" -X POST http://elastic:elasticadmin@localhost:9200/_security/user/elastic/_password
sudo /usr/share/elasticsearch/bin/elasticsearch-setup-passwords interactive
echo 'Done.'
