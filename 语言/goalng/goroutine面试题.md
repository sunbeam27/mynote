
## gmp逻辑
```golang 
type P struct｛
   runnext  guintptr下一个运行的
   runq   [256]guintptr
      
   /*
   先从本地 runq 运行队列中获取
   再从 全局runq 中获取
   再去 其他p哪里steal 来运行
   */
｝
```

```golang
func main() {
	runtime.GOMAXPROCS(1)
	// 只有p 相当于单核，然后携程第一个进去runnext，第二个抢占runnext,第一个进去runq，第三个抢占，前两个排队，所以结果是 3 1 2
	//test1p()
	// 当 超过257（runnext 1+runq 256）个时，第258个回抢占257的runnext，但是runq已满，257就会和runq中1-128（runq的前一半）一起进入全局runq，
	// 每隔 61个schedule tick 会去 全局runq中尝试获取，为了避免 全局runq一直得不到调用
	testnp()
}
func test1p() {
	group := sync.WaitGroup{}
	group.Add(3)
	go func(i int) {
		fmt.Println(i)
		group.Done()
	}(1)
	go func(i int) {
		fmt.Println(i)
		group.Done()
	}(2)
	go func(i int) {
		fmt.Println(i)
		group.Done()
	}(3)
	group.Wait()
}
func testnp() {
	var wg sync.WaitGroup
	wg.Add(258)
	for i := 0; i < 258; i++ {
		go func(x int) {
			fmt.Println(x)
			wg.Done()
		}(i)
	}
	wg.Wait()
}
```

结果
```
257
128-255 (中间穿插这 0 1)
2-127 256 （中间穿插）
```