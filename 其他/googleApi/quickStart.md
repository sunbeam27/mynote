## api使用

[go quickStart](https://developers.google.com/docs/api/quickstart/go)

***
## 创建凭证

需要创建凭证 打开google 控制台

[google 控制台](https://console.cloud.google.com/home/dashboard)

左侧边栏 `API和服务`

1. `凭据` 创建凭据  如果没有项目就想创建一个项目

2. 选择 `服务账号`  

创建一个`服务账号` 

```
就相当于给你创建一个账号，你需要给你这个邮箱分配权限，并且启用你的api服务
还需要将你想要操作的文档，分享给这个服务账号
```
3. 在服务账号`密钥`

创建一个密钥  创建新密钥，json 下载保存下来 



---
代码示例
```golang
// path 凭证文件路径  id  google sheet表格id
//https://docs.google.com/document/d/195j9eDD3ccgjQRttHhJPymLJUCOUjs-jmwTrekvdjFE/edit
//https://docs.google.com/document/d/{sheetId}/edit
func sheet(path, id string) {
	ctx := context.Background()
	docsvc, err := sheets.NewService(ctx, option.WithCredentialsFile(path))
	if err != nil {
		fmt.Println(err)
		return
	}
	d := sheets.NewSpreadsheetsValuesService(docsvc)
	document, err := d.BatchGet(id).Do()
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Println(document.ValueRanges)
}


```