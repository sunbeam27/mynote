```go
func main() {
	var a interface{}
	a = []int(nil)
	fmt.Println(a == nil)
	fmt.Println(reflect.ValueOf(a).IsNil())
}
```

```go
false
true
```

interface底层上是分别由两个struct实现：iface和eface。eface表示empty  interface，不包含任何方法，iface 表示 non-empty  interface，即包含方法的接口。从概念上来讲，iface和eface均由两部分组成：type和value，type表示interface的类型描述，主要提供concrete type相关的信息，value指向interface绑定的具体数据。

![img](images/v2-65b8f924593aee208a4db35fac25af92_720w.jpg)

具体类型实例传递给接口称为接口的实例化，这里有个地方值得注意，Interface变量默认值为nil，需要初始化后才有意义。

### **eface**

先从较简单的eface看起，空接口eface结构比较简单，由两个属性构成，一个是类型信息_type，一个是数据信息。其数据结构声明如下：

```go
type eface struct {
  _type *_type
  data  unsafe.Pointer
}
```

其中_type是GO语言中所有类型的公共描述，Go语言几乎所有的数据结构都可以抽象成 _type，是所有类型的公共描述，**type负责决定data应该如何解释和操作，**type的结构代码如下:

```go
type _type struct {
  size       uintptr 
  ptrdata    uintptr    // size of memory prefix holding all pointers
  hash       uint32     // 类型哈希
  tflag      tflag
  align      uint8      // _type作为整体变量存放时的对齐字节数
  fieldalign uint8
  kind       uint8
  alg        *typeAlg
  // gcdata stores the GC type data for the garbage collector.
  // If the KindGCProg bit is set in kind, gcdata is a GC program.
  // Otherwise it is a ptrmask bitmap. See mbitmap.go for details.
  gcdata    *byte
  str       nameOff
  ptrToThis typeOff  // type for pointer to this type, may be zero
}
```

data表示指向具体的实例数据，由于Go的参数传递规则为值传递，如果希望可以通过interface对实例数据修改，则需要传入指针，此时data指向的是指针的副本，但指针指向的实例地址不变，仍然可以对实例数据产生修改。

![img](images/v2-40a262c072903cf36b808ecb84b62349_720w.jpg)Eface的结构



### **iface**

iface 表示 non-empty interface 的数据结构，非空接口初始化的过程就是初始化一个iface类型的结构，其中data的作用同eface的相同，这里不再多加描述。

```go
type iface struct {
  tab  *itab
  data unsafe.Pointer
}
```

iface结构中最重要的是itab结构（结构如下），每一个 `itab` 都占 32 字节的空间。itab可以理解为pair<interface type, concrete type> 。itab里面包含了interface的一些关键信息，比如method的具体实现。

```go
// layout of Itab known to compilers
// allocated in non-garbage-collected memory
// Needs to be in sync with
// ../cmd/compile/internal/gc/reflect.go:/^func.dumptypestructs.
type itab struct {
  inter  *interfacetype   // 接口自身的元信息
  _type  *_type           // 具体类型的元信息
  link   *itab
  bad    int32
  hash   int32            // _type里也有一个同样的hash，此处多放一个是为了方便运行接口断言
  fun    [1]uintptr       // 函数指针，指向具体类型所实现的方法
}

type interfacetype struct {
  typ     _type
  pkgpath name
  mhdr    []imethod
}

type imethod struct {   //这里的 method 只是一种函数声明的抽象，比如  func Print() error
  name nameOff
  ityp typeOff
}
```

其中值得注意的字段，个人理解如下：

1. interface  type包含了一些关于interface本身的信息，比如package  path，包含的method。上面提到的iface和eface是数据类型转换成interface之后的实体struct结构，而这里的interfacetype是定义interface的一种抽象表示。
2. type表示具体化的类型，与eface的 *type类型相同。*
3. hash字段其实是对_type.hash的拷贝，它会在interface的实例化时，用于快速判断目标类型和接口中的类型是否一致。另，Go的interface的Duck-typing机制也是依赖这个字段来实现。
4. fun字段其实是一个动态大小的数组，虽然声明时是固定大小为1，但在使用时会直接通过fun指针获取其中的数据，并且不会检查数组的边界，所以该数组中保存的元素数量是不确定的。

补充，fun个人理解是类似于C++中的虚函数指针的存在，当通过接口调用函数时，实际操作就是s.itab->func()。但不同与C++的虚表之处是，GO是在运行时生成虚表，保障了唯一性，避免了C++中可能存在的同一个接口在不同层次被多次继承实现的等一系列问题，但这里会产生额外的时间消耗。

Iface结构如下：

![img](images/v2-5965d55b50ac6f26615e75e00ac1beeb_720w.jpg)Iface结构



### **interface设计的优缺点**

优点，非侵入式设计，写起来更自由，无需显式实现，只要实现了与 interface 所包含的所有函数签名相同的方法即可。

缺点，duck-typing风格并不关注接口的规则和含义，也没法检查，不确定某个struct具体实现了哪些interface。只能通过goru工具查看。

上篇：

[罗晓：GO如何支持泛型25 赞同 · 7 评论文章](https://zhuanlan.zhihu.com/p/74525591)

参考：

https://research.swtch.com/interfaces

https://golang.org/doc/asm

知乎文章：

https://zhuanlan.zhihu.com/p/76354559