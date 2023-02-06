## RequestBody只能读取一次的问题

body 是流 只能读取一次，就到了末尾

解决方法：

1  使用中间变量存储  `ctx.Set()`

2  使用gin提供打的方法 `ctx.ShouldBindBodyWith(&info, binding.JSON)`

3  使用golang自带的方法 用完以后给body赋值  
```golang
 	ctx.Request.Body = ioutil.NopCloser(bytes.NewBuffer(data)) // 关键点
```