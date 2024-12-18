0. Install Kafka on the EC2 Instance
Before configuring Kafka, you need to install it on the EC2 instance:

sudo dnf update -y
sudo dnf install java-11-amazon-corretto -y
wget https://archive.apache.org/dist/kafka/3.2.0/kafka_2.13-3.2.0.tgz
tar -xzf kafka_2.13-3.2.0.tgz
cd kafka_2.13-3.2.0
ls -l


1. Create the client.properties File
The client.properties file is needed to configure SSL for Kafka communication. Run the following commands in the Kafka directory on the EC2 instance:

echo "ssl.endpoint.identification.algorithm=https" > client.properties
echo "security.protocol=SSL" >> client.properties

2. Create a Kafka Topic
To create a topic in the MSK cluster, use the following command:

bin/kafka-topics.sh --create \
  --bootstrap-server b-1.exterraform.5txy4l.c2.kafka.us-east-2.amazonaws.com:9094,b-2.exterraform.5txy4l.c2.kafka.us-east-2.amazonaws.com:9094 \
  --replication-factor 2 \
  --partitions 1 \
  --topic test-topic \
  --command-config client.properties

3. Start a Kafka Producer
To send messages to the test-topic, run the Kafka producer with SSL configuration:

bin/kafka-console-producer.sh --broker-list b-1.exterraform.5txy4l.c2.kafka.us-east-2.amazonaws.com:9094,b-2.exterraform.5txy4l.c2.kafka.us-east-2.amazonaws.com:9094 \
  --topic test-topic \
  --producer.config client.properties

4. Start a Kafka Consumer
To read messages from the test-topic, use the Kafka consumer:

bin/kafka-console-consumer.sh --bootstrap-server b-1.exterraform.5txy4l.c2.kafka.us-east-2.amazonaws.com:9094,b-2.exterraform.5txy4l.c2.kafka.us-east-2.amazonaws.com:9094 \
  --topic test-topic \
  --from-beginning \
  --consumer.config client.properties
