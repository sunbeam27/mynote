https://baijiahao.baidu.com/s?id=1651919282506404758&wfr=spider&for=pc

![image-20210416160401806](\kafka\images\image-20210416160401806.png)

#### push时  消息分发

在实际使用中，我们一般不会指定消息发送的具体partition，最多只会传入key值，类似下面这种方式：

```
producer.send(new ProducerRecord<Object, Object>(topic, key, data));
```

而kafka也会根据你传入key的hash值，通过取余的方法，尽可能保证消息能够相对均匀的分摊到每个可用的partition上；

  对于生产者要写入的一条记录，可以指定四个参数：分别是 topic、partition、key 和 value，其中 topic 和 value（要写入的数据）是必须要指定的，而 key 和 partition 是可选的。

  对于一条记录，先对其进行序列化，然后按照 Topic 和 Partition，放进对应的发送队列中。如果 Partition 没填，那么情况会是这样的：a、Key 有填。按照 Key 进行哈希，相同 Key 去一个 Partition。b、Key 没填。Round-Robin 来选 Partition。

#### pull  时  分区分配

**1、Range策略**

`range` （默认分配策略）对应的实现类是`org.apache.kafka.clients.consumer.RangeAssignor` 。

- 首先，将分区按数字顺序排行序，消费者按名称的字典序排序。
- 然后，用分区总数除以消费者总数。如果能够除尽，平均分配；若除不尽，则位于排序前面的消费者将多负责一个分区。

1. 假设，有1个主题、10个分区、3个消费者线程， 10 / 3 = 3，而且除不尽，那么消费者C1将会多消费一个分区，分配结果是：
   - C1将消费T1主题的0、1、2、3分区。
   - C2将消费T1主题的4、5、6分区。
   - C3将消费T1主题的7、8、9分区
2. 假设，有11个分区，分配结果是：
   - C1将消费T1主题的0、1、2、3分区。
   - C2将消费T1主题的4、5、 6、7分区。
   - C2将消费T1主题的8、9、10分区。
3. 假如，有2个主题（T0和T1），分别有3个分区，分配结果是：
   - C1将消费T1主题的 0、1 分区，以及T1主题的 0、1 分区。
   - C2将消费T1主题的 2、3 分区，以及T2主题的 2、3 分区。

**2、RoundRobin策略**



![image-20210416140805933](/home/troila/Desktop/学习日志/kafka/images/image-20210416140805933.png)

topic是一个逻辑概念，实际上是partition的集合

生产者在向topic中生产消息时，会按照消息分发，将消息的key按照hash算法存入不同的partition中，以达到partition的利用相同。这就导致只能保证在一个partition中offset是有序的，而不同的partition中不能保证。即：假如有一个日志producer向topic中生产，那么日志消息会均匀的分布到不同的partition中。这就导致消费者在pull时，需要对信息进行处理（比如线程池并发导致顺序不同等待）。这才能成为消费。





kafka的选举机制，直接选取最早的serverid作为leader，如果leader挂掉了，就选第二早的。如果后续原本挂掉的leader重新连接，则过一段时间会重新让他作为leader。但是这个过程有一个问题，重新上线的节点数据同步不及时。涉及到kafka的ack机制，0,1和all三种配置。代表producer生产确认，如果配置all则一旦有节点掉线，就无法通过确认，就需要一直等待节点重新上线。这就是分布式系统中的CAP定理，指的是在一个分布式系统中，一致性（Consistency）、可用性（Availability）、分区容错性（Partition tolerance）。

想要CP  则无法保证AP

