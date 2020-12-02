# git-webhook-service
自动部署github代码到服务器

1. push代码到git时，git会通过webhook发送一个post请求
2. 部署在服务器的这个node服务会对上述post请求作出响应
3. 执行shell脚本，进行代码的备份及替换，然后重启服务器
4. 记得star。
