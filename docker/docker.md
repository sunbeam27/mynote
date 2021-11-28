1 基本概念

镜像 容器 仓库  [dockerhub](https://registry.hub.docker.com/)

比如redis  

​                

```
docker run -p 6379:6379 -v $PWD/data:/data  -d redis:6.0 redis-server
```

 命令说明：

 -p 6379:6379 : 将容器的6379端口映射到主机的6379端口 

-v $PWD/data:/data : 将主机中当前目录下的data挂载到容器的/data              

2 网络

3 存储

4 命令

5 DOCKERFILE

6[资源隔离](https://zhuanlan.zhihu.com/p/67021108)

链接

- [osChina Docker文章](https://my.oschina.net/xiedeshou?tab=newest&catalogId=5997996)
- [知乎 Docker](https://www.zhihu.com/people/li-xiang-11-73/posts)
- [gitbook Docker](https://yeasy.gitbook.io/docker_practice/image/build)