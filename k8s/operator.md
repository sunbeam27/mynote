owns   代表相关资源的变动也会触发该自定义Reconcile方法

注意：思路    先确定什么去触发Reconcile        状态。

​                       触发以后进入方法 最好更新资源就update一次，避免连锁错误       

​                       没触发就退出       一般情况下不需要Requeue       直接stop，等待状态变化触发Reconcile