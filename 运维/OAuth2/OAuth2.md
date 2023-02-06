## OAuth2标准为了应对不同的场景，设计了四种不同的标准模式。

####1、授权码模式是四种模式中最繁琐也是最安全的一种模式。

client向资源服务器请求资源，被重定向到授权服务器（AuthorizationServer）

浏览器向资源拥有者索要授权，之后将用户授权发送给授权服务器

授权服务器将授权码（AuthorizationCode）转经浏览器发送给client

client拿着授权码向授权服务器索要访问令牌

授权服务器返回Access     Token和Refresh Token给cilent

这种模式是四种模式中最安全的一种模式。一般用于client是Web服务器端应用或第三方的原生App调用资源服务的时候。因为在这种模式中AccessToken不会经过浏览器或移动端的App，而是直接从服务端去交换，这样就最大限度的减小了AccessToken泄漏的风险。

####2、简化模式

简化模式相对于授权码模式省略了，提供授权码，然后通过服务端发送授权码换取AccessToken的过程。

client请求资源被浏览器转发至授权服务器

浏览器向资源拥有者索要授权，之后将用户授权发送给授权服务器

授权服务器将AccessToken以Hash的形式存放在重定向uri的fargment中发送给浏览器

浏览器访问重定向URI

资源服务器返回一个脚本，用以解析Hash中的AccessToken

浏览器将Access Token解析出来

将解析出的Access Token发送给client

一般简化模式用于没有服务器端的第三方单页面应用，因为没有服务器端就无法使用授权码模式。

####3、密码模式
用户将认证密码发送给client

client拿着用户的密码向授权服务器请求Access Token

授权服务器将Access Token和Refresh Token发送给client

这种模式十分简单，但是却意味着直接将用户敏感信息泄漏给了client，因此这就说明这种模式只能用于client是我们自己开发的情况下。因此密码模式一般用于我们自己开发的，第一方原生App或第一方单页面应用。

####4、客户端模式

这是一种最简单的模式，只要client请求，我们就将AccessToken发送给它。

client向授权服务器发送自己的身份信息，并请求AccessToken

确认client信息无误后，将AccessToken发送给client

这种模式是最方便但最不安全的模式。因此这就要求我们对client完全的信任，而client本身也是安全的。因此这种模式一般用来提供给我们完全信任的服务器端服务。在这个过程中不需要用户的参与。

```
1、授权码模式：第三方Web服务器端应用与第三方原生App

2、简化模式：第三方单页面应用

3、密码模式：第一方单页应用与第一方原生App

4、客户端模式：没有用户参与的，完全信任的服务器端服务
```