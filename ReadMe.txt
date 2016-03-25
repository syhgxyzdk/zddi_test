本工程使用ruby&watir自动化框架构建web自动化UI测试.
主要用来回归测试和服务稳定性测试.

watir库本身是selenium的再次封装.
对chrome浏览器都是调用google的webdriver.
同时还支持firefox和IE(需要iedriver).

非常完善的定位控件方法和开源学习文档.
是黑盒自动化WebUI测试的首选!!!


目录结构:
1. case/case_suit
每个suit_xxx.rb文件对应每个ZDDI功能模块.
同时每个rb文件对应一个类, 类名下的每个方法对应的每个用例.

2. case/upload
所有case中用到的测试数据, 如批量添加, nsupdate调用文件导入等. 

3. case/log
运行的结果, 最近一次测试结果, 失败用例rerun结果和历史结果.

4. case/test_dns.rb,  test_recursion.rb, test_acl_manage.rb, test_cloud.rb, test_system.rb.
权威/递归/访问控制/云中心和系统管理等主功能模块的测试集.
可以在对应的文件里找到运行的用例ID.

5. step/cloud.rb, dns.rb, recursion.rb, system.rb, acl_manage.rb
按照zdns系统的基本模块即权威, 递归, 访问控制, 云中心, 系统管理,
分别封装了页面的基本操作, 如点击, 输入, 选中等.
同时在对应的类中, 封装了对应的组合操作, 如新建, 编辑, 删除等.

6. main.rb
入口文件, 配置好对应的suit, 可以运行指定的case/set.

7. run_case.rb
负责启动浏览器, 清理前台数据, 依次运行测试集; 
最后整理测试结果并发送邮件
同时可以对FAIL用例重新执行一次测试.

8. zddi.rb / server.conf
zddi.rb定义了一些常量, 如读取的节点IP, 节点数据路径等.
server.conf是常用测试节点的配置信息.

9. install_gem.bat
需要安装的gem包列表.

10. trace_core.rb
追踪节点的bind是否crash和产生core dump文件,
在稳定性测试中和main.rb同时开机启动.


关于稳定性测试:
稳定性测试需要单独的Windows机器运行, 
目前有203.119.80.40/42/109三台测试机,
分别运行AD, Zlope和V1R1版本的稳定性测试.
三组ZDDI节点为: 

202.173.12.6/7
202.173.9.55/50
202.173.9.94/47

这些PC都已经开启了自动登录, 同时将main.rb和trace_core.rb两个文件设置为开机启动项(shortcut放在"启动"文件夹下).
每次开机后通过main.rb执行所有用例, 然后对Fail的用例做一次rerun.
最后重启Windows系统, 进入下一次循环.
