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
>源码位置 `schema/utils.go`
```go
func ParseTagSetting(str string, sep string) map[string]string {
	settings := map[string]string{}
	names := strings.Split(str, sep)

	for i := 0; i < len(names); i++ {
		j := i
		if len(names[j]) > 0 {
			for {
				if names[j][len(names[j])-1] == '\\' {
					i++
					names[j] = names[j][0:len(names[j])-1] + sep + names[i]
					names[i] = ""
				} else {
					break
				}
			}
		}

		values := strings.Split(names[j], ":")
		k := strings.TrimSpace(strings.ToUpper(values[0]))

		if len(values) >= 2 {
			settings[k] = strings.Join(values[1:], ":")
		} else if k != "" {
			settings[k] = k
		}
	}

	return settings
} // 将 column : id 变成 map[string]string={"COLUMN":"id"}
```
>源码位置 `schema/field.go`
```go
	if dbName, ok := field.TagSettings["COLUMN"]; ok {
		field.DBName = dbName
	}
```
### 2、gorm 插入时返回自增id
```golang
	if db.Debug().Create(&p).Error != nil {
		log.Errorln(p)
	}
	fmt.Println(p.Uid) // 这里Uid的对应列名是上面的 id 字段
```
  >>只支持当 自增ID的字段名为 `id` 时，才能够成功返回