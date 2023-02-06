意义：固定值    以达到  "约定大于配置 "  目的

# headless service:

在某些应用场景中，开发人员希望自己控制负载均衡的策略，不使用Service提供的默认负载均衡的功能，或者应用程序希望知道属于同组服务的其他实例。Kubernetes提供了Headless Service来实现这种功能，即不为Service设置ClusterIP（入口IP地址），仅通过Label Selector将后端的Pod列表返回给调用的客户端。例如：

Service对象隐藏了各Pod资源，并负责将客户端的请求流量调度至该组Pod对象之上。不过，偶尔也会存在这样一类需求：客户端需要直接访问Service资源后端的所有Pod资源，这时就应该向客户端暴露每个Pod资源的IP地址，而不再是中间层Service对象的ClusterIP，这种类型的Service资源便称为Headless Service。Headless Service对象没有ClusterIP，于是kube-proxy便无须处理此类请求，也就更没有了负载均衡或代理它的需要。在前端应用拥有自有的其他服务发现机制时，Headless Service即可省去定义ClusterIP的需求。

Headless Service对象没有ClusterIP，于是kube-proxy便无须处理此类请求，也就更没有了负载均衡或代理它的需要。在前端应用拥有自有的其他服务发现机制时，Headless Service即可省去定义ClusterIP的需求。

一般来说，一个典型、完整可用的StatefulSet通常由三个组件构成：HeadlessService、StatefulSet和volumeClaimTemplate。其中，Headless Service用于为Pod资源标识符生成可解析的DNS资源记录，StatefulSet用于管控Pod资源，volumeClaimTemplate则基于静态或动态的PV供给方式为Pod资源提供专有且固定的存储。

### 稳定的网络 ID

StatefulSet 中的每个 Pod 根据 StatefulSet 的名称和 Pod 的序号派生出它的主机名。 组合主机名的格式为`$(StatefulSet 名称)-$(序号)`。 上例将会创建三个名称分别为 `web-0、web-1、web-2` 的 Pod。 StatefulSet 可以使用 [无头服务](https://kubernetes.io/zh/docs/concepts/services-networking/service/#headless-services) 控制它的 Pod 的网络域。管理域的这个服务的格式为： `$(服务名称).$(命名空间).svc.cluster.local`，其中 `cluster.local` 是集群域。 一旦每个 Pod 创建成功，就会得到一个匹配的 DNS 子域，格式为： `$(pod 名称).$(所属服务的 DNS 域名)`，其中所属服务由 StatefulSet 的 `serviceName` 域来设定。