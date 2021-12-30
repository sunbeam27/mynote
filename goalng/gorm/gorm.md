# gorm坑点

### 1、gorm tag 错误
```golang
   type Per struct {
	Uid  int    `gorm:"column:id"`
	Name string `gorm:"column:name"`
	Pwd  string `gorm:"column:pwd"`
    }
 // 需要写成 gorm:"column:id" 并非 官网 gorm:"id" (经试验，这样不能指定列名)
```
### 2、gorm 插入时返回自增id
```golang
	if db.Debug().Create(&p).Error != nil {
		log.Errorln(p)
	}
	fmt.Println(p.Uid) // 这里Uid的对应列名是上面的 id 字段
```
  >>只支持当 自增ID的字段名为 `id` 时，才能够成功返回