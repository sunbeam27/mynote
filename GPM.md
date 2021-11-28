GPM

G goroutine   轻量级的线程，包括调用栈、重要的调度信息

P  procesoer  M所需的上下文环境，也是处理用户级代码逻辑的处理器，负责衔接M和G的调度上下文，将等待执行的G和M对接

M machine   直接关联一个内核线程，由操作系统管理

> DO NOT COMMUNICATE BY SHARING MEMORY; INSTEAD, SHARE MEMORY BY COMMUNICATING.
>
> 不要以共享内存的方式来通信，相反，要通过通信来共享内存。

P有GOMAXPROCSS决定，可以自己调用设置，一般来说4core的服务器上会启动4个线程，通常每个P通过一个queue队列来负责管理G。

两个线程的情况

![image-20210717183950006](C:\Users\12415\Desktop\学习日记\GPM\images\image-20210717183950006.png)

蓝色的 代表正在运行的goroutine，灰色的为排队队列

P（上下文）的存在，是为了保证goroutine不会因为阻塞导致程序阻塞，一个很简单的例子就是系统调用`sysall`，一个线程肯定不能同时执行代码和系统调用被阻塞，这个时候，此线程M需要放弃当前的上下文环境P，以便可以让其他的`Goroutine`被调度执行。

![image-20210717185754347](C:\Users\12415\Desktop\学习日记\GPM\images\image-20210717185754347.png)

M0去执行sysall命令，然后M0抛弃了P，由M1接管，继续执行，M0执行完回来后，会继续和M1分配goroutine

##### 均衡的工作分配

上下文P会定期的检查全局的goroutine 队列中的goroutine，以便自己在消费掉自身Goroutine队列的时候有事可做。假如全局goroutine队列中的goroutine也没了呢？就从其他运行的中的P的runqueue里偷。对半分。。

