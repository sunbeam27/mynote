#### append

`make`([]int,3,4)      申请一个len3cap4的内存

当`append`一个时，不会发生扩容，

`make`([]int,3)          申请一个len3cap3的内存

当`append`一个时，会发生扩容，变成len4cap6,两倍扩容，地址变更(发生扩容代表原来地址内存不足，需要开辟新的内存地址)。

无论什么操作  都是基于slice，通过slice去完成动作。

slice结构{

ptr(指向数组地址)

len

cap

}

#### remove

```
a:=[]int{1,2,3,4,5,6,7,8}
for i,v:=range a{
   if v==3 {
      a = append(a[:i], a[i+1:]...)
      fmt.Println(i)
   }
   fmt.Println(a[i])
}
```

不要这么干！！

for 循环中去减  但是i，v都已经被声明出来，这样删除会导致 index out of range

**正确做法：**声明一个新的slice   把想要的重新拼接出来