#TCP

##1 重传机制

###1.1 超时重传

>在发送数据时，设定一个定时器，当超过指定的时间后，没有收到对方的 ACK 确认应答报文，就会重发该数据

主要情况就是：```数据包丢失；确认应答丢失```

超时时间的计算通过 ```RTT（数据从网络一端传送到另一端所需的时间） RTO （Retransmission Timeout 超时重传时间）公式计算```

###1.2 快速重传

>以数据为驱动 

例如：发送端发送 1 接受端 ack 里为2（1+1） 然后发送端发2 接收端ack为3（2+1）发送端发送3，如果此时接收端没有收到3  那么接收端的ack还是3，
```如果收到三次相同的ack，代表丢失了某个数据，就会触发快速重传，由于重传内容不确定 所有有SACK```

就类似一种增量的确认

### 1.3 SACK（Selective Acknowledgment 选择性确认）
>TCP 头部「选项」字段里加一个 SACK 如果要支持 SACK，必须双方都要支持

例如 发送端 发送 1 2 3 4 5  接收端没有接收到 2 ， SACK 会表明接受到 1 3 4 5，
```如果收到三次想用的SACK，会触发重传```

类似一种全量的确认

###1.4 D-SACK

>Duplicate SACK 又称 D-SACK，其主要使用了 SACK 来告诉「发送方」有哪些数据被重复接收了。

##2 滑动窗口

>为了避免一问一答的传输方式，通过接收端缓冲区和发送端缓冲区以及滑动窗口概念 实现无须立即确认应答  
窗口大小就是指无需等待确认应答，而可以继续发送数据的最大值。

TCP头部字段Window 表示窗口大小，这个字段是接收端告诉发送端自己还有多少缓冲区可以接收数据。发送端就可以根据这个接收端的处理能力来发送数据，而不会导致接收端处理不过来。
```一般是由接收端确认的```

### 2.1 发送窗口

### 2.2 接收窗口

## 3 流量控制
处于接收端 控制接收到的流量
### 3.1 操作系统缓冲区与滑动窗口的关系

>发送窗口和接收窗口中所存放的字节数，都是放在操作系统内存缓冲区中的，而操作系统的缓冲区，会被操作系统调整。

当接收端服务器非常繁忙 没法读取接收缓冲区中的内容，接收缓冲区就会减小接收窗口的大小，从而减少内存占用 ```TCP 规定是不允许同时减少缓存又收缩窗口的，而是采用先收缩窗口，过段时间在减少缓存，这样就可以避免了丢包情况```

### 3.2 窗口关闭

>如果窗口大小为 0 时，就会阻止发送方给接收方传递数据，直到窗口变为非 0 为止，这就是窗口关闭。

## 4 拥塞控制
处于发送端，减少重发
### 4.1 慢启动

>当发送方每收到一个 ACK，就拥塞窗口 cwnd 的大小就会加 1。

```拥塞窗口 cwnd是发送方维护的一个 的状态变量，它会根据网络的拥塞程度动态变化的。```

有一个叫慢启动门限 ssthresh （slow start threshold）状态变量。

当 cwnd < ssthresh 时，使用慢启动算法。

当 cwnd >= ssthresh 时，就会使用「拥塞避免算法」。

### 4.2 拥塞避免

>每当收到一个 ACK 时，cwnd 增加 1/cwnd。

### 4.3 拥塞发生

超时重传

快速重传

### 4.4 快速恢复

快速重传和快速恢复算法一般同时使用