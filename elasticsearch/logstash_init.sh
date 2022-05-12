echo "============================================================"
echo "Updating apt..."
sudo apt update
echo "============================================================"

echo "============================================================"
echo "Installing Logstash..."
sudo apt install logstash
echo "============================================================"

echo "============================================================"
echo "Updating Logstash Config..."
sudo cp ./elasticsearch/logstash.conf /etc/logstash/conf.d/elasticsearch.conf
echo "============================================================"

echo "============================================================"
echo "Reloading systemctl daemon..."
sudo systemctl daemon-reload
echo "============================================================"

echo "============================================================"
echo "Starting Elasticsearch service..."
sudo systemctl start elasticsearch.service
echo "============================================================"

echo "============================================================"
echo "Starting Kibana service..."
sudo systemctl start kibana.service
echo "============================================================"

echo "============================================================"
echo "Starting Logstash service..."
sudo systemctl start logstash
echo "============================================================"

echo "============================================================"
echo "Enabling Logstash service..."
sudo systemctl enable logstash
echo "============================================================"
