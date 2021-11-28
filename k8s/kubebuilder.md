代码生成

```go
func (r *AppReconciler) SetupWithManager(mgr ctrl.Manager) error {
   return ctrl.NewControllerManagedBy(mgr).
      For(&webappv1beta1.App{}).
      Owns(&v1.Deployment{}).
      Owns(&v1.StatefulSet{}).
      Complete(r)
}
```

在添加owns时，需要指定controller字段为true  才能生效。

```bash
 ownerReferences:

  - apiVersion: webapp.my.domain/v1beta1
    controller: true     //这个字段表示级联  即该资源的create update delete 操作会触发Reconcile
    kind: App
    name: app
    uid: f79b55b3-e40d-4c21-82ed-34a42f16bb81
```

