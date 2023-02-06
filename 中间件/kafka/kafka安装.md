

#### 1. 下载镜像[#](https://www.cnblogs.com/hunternet/p/11017000.html#1674054270)

```
Copy//下载zookeeper
docker pull wurstmeister/zookeeper

//下载kafka
docker pull wurstmeister/kafka:2.11-0.11.0.3
```

#### 2.启动镜像[#](https://www.cnblogs.com/hunternet/p/11017000.html#1135586060)

```
Copy//启动zookeeper
docker run -d --name zookeeper --publish 2181:2181 --volume /etc/localtime:/etc/localtime wurstmeister/zookeeper

//启动kafka
docker run -d --name kafka --publish 9092:9092 \
--link zookeeper \
--env KAFKA_ZOOKEEPER_CONNECT=172.26.106.77:2181 \
--env KAFKA_ADVERTISED_HOST_NAME=172.26.106.77 \
--env KAFKA_ADVERTISED_PORT=9092  \
--volume /etc/localtime:/etc/localtime \
wurstmeister/kafka:2.11-0.11.0.3
```

#### 3.测试kafka[#](https://www.cnblogs.com/hunternet/p/11017000.html#2214602205)

```
使用
进入kafka 并进入目录
cd /opt/kafka_2.12-2.4.0/bin/

Copy//创建topic
bin/kafka-topics.sh --create --zookeeper zookeeper:2181 --replication-factor 1 --partitions 1 --topic mykafka

//查看topic
bin/kafka-topics.sh --list --zookeeper zookeeper:2181

//创建生产者
bin/kafka-console-producer.sh --broker-list zookeeper:9092 --topic mykafka 

//创建消费者
bin/kafka-console-consumer.sh --zookeeper zookeeper:2181 --topic mykafka --from-beginning
```