#### map复制指针

```go
var mm = map[string]bool{
	"1": true,
	"2": false,
}

func main() {
	cc := make(map[string]bool)
	for i, v := range mm {
		cc[i] = v
	}
	cc["1"] = false
	fmt.Println(mm, cc)
	dd := mm
	dd["1"] = false
	fmt.Println(mm, dd)
}
```

结果

```go
map[1:true 2:false] map[1:false 2:false]
map[1:false 2:false] map[1:false 2:false]
```

结论：

map复制时会复制底层数据指针，直接修改会造成原map发生变化，只能采用for循环复制的办法

//学习map底层



#### map[i]可以返回两个结果，第一个是对应的值，第二个是是否存在



