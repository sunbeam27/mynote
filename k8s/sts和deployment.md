对于数据库等要求有状态的pod需要statefulset加headless  完成DNS解析。{pod}.{service}.{namespace}.svc.cluster.local

如果是只需要一个节点的数据库，使用statefulset和deployment也有所不同

statefulset的机制是确定上一个pod已经挂了，才会生成新的

而deployment的机制是集群中pod的个数不等于副本数，就会生成新的。

这就导致可能在集群某个节点网络不通后，那么这个节点下属于deployment的pod 会在其他节点重启。

而属于statefulset的pod由于无法确认pod是否已经挂了，不会重新生成。



## sts

#### 部署和扩缩保证

- 对于包含 N 个 副本的 StatefulSet，当部署 Pod 时，它们是依次创建的，顺序为 `0..N-1`。
- 当删除 Pod 时，它们是逆序终止的，顺序为 `N-1..0`。
- 在将缩放操作应用到 Pod 之前，它前面的所有 Pod 必须是 Running 和 Ready 状态。
- 在 Pod 终止之前，所有的继任者必须完全关闭。

StatefulSet 不应将 `pod.Spec.TerminationGracePeriodSeconds` 设置为 0。 这种做法是不安全的，要强烈阻止。更多的解释请参考 [强制删除 StatefulSet Pod](https://kubernetes.io/zh/docs/tasks/run-application/force-delete-stateful-set-pod/)。

在上面的 nginx 示例被创建后，会按照 web-0、web-1、web-2 的顺序部署三个 Pod。 在 web-0 进入 [Running 和 Ready](https://kubernetes.io/zh/docs/concepts/workloads/pods/pod-lifecycle/) 状态前不会部署 web-1。在 web-1 进入 Running 和 Ready 状态前不会部署 web-2。 如果 web-1 已经处于 Running 和 Ready 状态，而 web-2 尚未部署，在此期间发生了 web-0 运行失败，那么 web-2 将不会被部署，要等到 web-0 部署完成并进入 Running 和 Ready 状态后，才会部署 web-2。

如果用户想将示例中的 StatefulSet 收缩为 `replicas=1`，首先被终止的是 web-2。 在 web-2 没有被完全停止和删除前，web-1 不会被终止。 当 web-2 已被终止和删除、web-1 尚未被终止，如果在此期间发生 web-0 运行失败， 那么就不会终止 web-1，必须等到 web-0 进入 Running 和 Ready 状态后才会终止 web-1。