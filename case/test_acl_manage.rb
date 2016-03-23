# encoding: utf-8
require File.dirname(__FILE__) + '/case_suit/suit_view'
require File.dirname(__FILE__) + '/case_suit/suit_ip_rrls'
require File.dirname(__FILE__) + '/case_suit/suit_domain_rrls'
require File.dirname(__FILE__) + '/case_suit/suit_acl_manage'
require File.dirname(__FILE__) + '/case_suit/suit_route_switch'
require File.dirname(__FILE__) + '/case_suit/suit_redirections'
require File.dirname(__FILE__) + '/case_suit/suit_monitor_strategies'

module ZDDI
    View               = ZDDI::DNS::View.new
    ACL                = ZDDI::DNS::ACL.new
    IP_rrls            = ZDDI::DNS::IP_rrls.new
    Domain_rrls        = ZDDI::DNS::Domain_rrls.new
    Route_switch       = ZDDI::DNS::Route_switch.new
    Monitor_strategies = ZDDI::DNS::Monitor_strategies.new
    Redirections       = ZDDI::DNS::Redirections.new

    def view_suit    # ( 36/42 )
        r = []
        r << View.case_672(:args=>'nil')   # 参数校验, 视图名
        r << View.case_973(:args=>'nil')   # 参数校验, DNS64
        r << View.case_981(:args=>'nil')   # 参数校验, 视图顺序
        r << View.case_14541(:args=>'nil') # 参数校验, 记录排序
        r << View.case_8352(:args=>'nil')   # 备注和备注修改
        r << View.case_671(:args=>'nil')    # 视图正常
        r << View.case_695(:args=>'nil')    # 编辑正常
        r << View.case_804(:args=>'nil')    # 删除正常
        r << View.case_990(:args=>'nil')    # 删除后台验证
        r << View.case_673(:args=>'nil')    # 异步数据正常
        r << View.case_969(:args=>'nil')    # 新建DNS64正常
        r << View.case_810(:args=>'nil')    # 查询功能正常
        r << View.case_811(:args=>'nil')    # 查询不支持通配符
        r << View.case_978(:args=>'nil')    # 优先级修改正确
        r << View.case_987(:args=>'nil')    # 新建后台校验
        r << View.case_989(:args=>'nil')    # 编辑后台校验
        r << View.case_976(:args=>'nil')    # 节点Master->Slave正常
        r << View.case_991(:args=>'nil')    # 节点All->Master正常
        r << View.case_10975(:args=>'nil')  # 节点Master->All正常
        r << View.case_10976(:args=>'nil')  # 节点All->Slave正常
        r << View.case_11483(:args=>'nil')  # 异常数据成功
        r << View.case_14542(:args=>'nil')  # 权威记录排序生效
        r << View.case_14543(:args=>'nil')  # 递归记录录排序生效
        r << View.case_14544(:args=>'nil')  # 编辑递归记录排序生效
        r << View.case_14545(:args=>'nil')  # 编辑权威记录排序生效
        r << View.case_14546(:args=>'nil')  # 删除最小范围后次小范围生效
        r << View.case_14547(:args=>'nil')  # 编辑优先地址为不存在地址
        r << View.case_14548(:args=>'nil')  # 不同源地址的不同排序
        r << View.case_12148(:args=>'nil')  # 新建重复记录排序
        r << View.case_16182(:args=>'nil')  # 用'any'代表所有源地址
        r << View.case_25854(:args=>'nil')  # default视图新增节点后自动生效
        r << View.case_11116(:args=>'nil')  # 新建视图失败转发
        r << View.case_12612(:args=>'nil')  # 编辑视图失败转发
        r << View.case_10901(:args=>'nil')  # 视图配置失败转发
        r << View.case_10896(:args=>'nil')  # DNS页面配置失败转发
        r << View.case_10897(:args=>'nil')  # 节点DNS和视图页面配置失败转发
    end
    def acl_suit   # ( 16 )
        r = []
        r << ACL.case_1375(:args=>'nil')  # 新建正常, 输入IP
        r << ACL.case_1384(:args=>'nil')  # 新建正常, 导入文件
        r << ACL.case_1399(:args=>'nil')  # 参数校验, 非法IP
        r << ACL.case_1440(:args=>'nil')  # 参数校验, 重复IP
        r << ACL.case_1465(:args=>'nil')  # 编辑ACL OK
        r << ACL.case_1467(:args=>'nil')  # 编辑 + 后台grep
        r << ACL.case_1466(:args=>'nil')  # 参数校验 编辑ACL
        r << ACL.case_1469(:args=>'nil')  # 删除ACL
        r << ACL.case_1472(:args=>'nil')  # 删除ACL, 后台grep named
        r << ACL.case_2752(:args=>'nil')  # ACL不能和any/none重名
        r << ACL.case_1449(:args=>'nil')  # 新建选择ACL文件, 后台grep
        r << ACL.case_1471(:args=>'nil')  # 删除被视图占用的ACL
        r << ACL.case_9733(:args=>'nil')  # 删除被AD区占用的ACL
        r << ACL.case_2753(:args=>'nil')  # 选择ACL文件不可用
        r << ACL.case_8361(:args=>'nil')  # 修改备注
        r << ACL.case_8362(:args=>'nil')  # 搜索ACL名字
    end
    def ip_rrls_suit   # ( 10/15 )
        r = []
        r << IP_rrls.case_10903(:args=>'nil')  # 参数校验, 速度输入范围
        r << IP_rrls.case_10904(:args=>'nil')  # 参数校验, 地址输入范围
        r << IP_rrls.case_10905(:args=>'nil')  # 参数校验, 创建重复策略
        r << IP_rrls.case_10906(:args=>'nil')  # 单个IP限速成功
        r << IP_rrls.case_10907(:args=>'nil')  # 不区分权威和递归域名
        r << IP_rrls.case_23706(:args=>'nil')  # 超速告警
        r << IP_rrls.case_12592(:args=>'nil')  # 修改所属节点master->all->slave
        r << IP_rrls.case_12593(:args=>'nil')  # 编辑解析限速为较大值
        r << IP_rrls.case_12594(:args=>'nil')  # 编辑解析限速为较小值
        r << IP_rrls.case_12595(:args=>'nil')  # 编辑解析限速为零
    end
    def domain_rrls_suit   # ( 14/16 )
        r = []
        r << Domain_rrls.case_24693(:args=>'nil')  # 参数校验
        r << Domain_rrls.case_24694(:args=>'nil')  # 编辑解析限速为零
        r << Domain_rrls.case_24695(:args=>'nil')  # 编辑解析限速为较小值
        r << Domain_rrls.case_24701(:args=>'nil')  # 编辑解析限速为较大值
        r << Domain_rrls.case_24700(:args=>'nil')  # 超速告警
        r << Domain_rrls.case_24697(:args=>'nil')  # 单个域名限速成功
        r << Domain_rrls.case_23786(:args=>'nil')  # IP限速和域名限速同时存在
        r << Domain_rrls.case_24698(:args=>'nil')  # 不区分权威和递归域名
        r << Domain_rrls.case_24702(:args=>'nil')  # 新建非defalut视图的域名限速
        r << Domain_rrls.case_24703(:args=>'nil')  # 新建非defalut视图的区限速
        r << Domain_rrls.case_24705(:args=>'nil')  # 中文域名和区限速
        r << Domain_rrls.case_24044(:args=>'nil')  # 区限速和同域名限速
        r << Domain_rrls.case_23778(:args=>'nil')  # 用*.<域名>对区限速
        r << Domain_rrls.case_24716(:args=>'nil')  # 修改所属节点master->all->slave
    end
    def route_switch_suit   # ( 7 )
        r = []
        r << Route_switch.case_10911(:args=>'nil')   # bind进程和ospfd && zebra进程联动
        r << Route_switch.case_10910(:args=>'nil')   # bind进程和ospfd && zebra进程联动
        r << Route_switch.case_20774(:args=>'nil')   # zdns:log_server进程重启
        r << Route_switch.case_20790(:args=>'nil')   # zdns:bind进程自动重启
        r << Route_switch.case_20791(:args=>'nil')   # Route_switch进程自动重启
        r << Route_switch.case_20775(:args=>'nil')   # zdns:mas_am进程自动重启
        r << Route_switch.case_20773(:args=>'nil')   # zdns:dcp_agent/cms_cloud进程触发整个服务重启
    end
    def monitor_strategies_suit  # ( 35 )
        r = []
        r << Monitor_strategies.case_12599(:args=>'nil')  # 参数校验, 输入
        r << Monitor_strategies.case_12598(:args=>'nil')  # 参数校验, 新建重复策略
        r << Monitor_strategies.case_10877(:args=>'nil')  # 新建策略选择"禁用"
        r << Monitor_strategies.case_10876(:args=>'nil')  # 新建策略选择"告警"
        r << Monitor_strategies.case_12601(:args=>'nil')  # 参数校验, 删除占用的"告警"
        r << Monitor_strategies.case_12600(:args=>'nil')  # 参数校验, 删除占用的"禁用"
        r << Monitor_strategies.case_10878(:args=>'nil')  # 编辑"告警" -> "禁用"
        r << Monitor_strategies.case_10879(:args=>'nil')  # 编辑"禁用" -> "告警"
        r << Monitor_strategies.case_10880(:args=>'nil')  # 删除"告警"正常
        r << Monitor_strategies.case_10881(:args=>'nil')  # 删除"禁用"正常
        r << Monitor_strategies.case_14538(:args=>'nil')  # 联级测试:权威域名的联动
        r << Monitor_strategies.case_14539(:args=>'nil')  # 联级测试:本地策略的联动
        r << Monitor_strategies.case_20987(:args=>'nil')  # 新建并验证tcp宕机切换策略
        r << Monitor_strategies.case_20988(:args=>'nil')  # 新建并验证http宕机切换策略
        r << Monitor_strategies.case_20989(:args=>'nil')  # 新建并验证https宕机切换策略
        r << Monitor_strategies.case_21307(:args=>'nil')  # ping正常->异常(告警)
        r << Monitor_strategies.case_21309(:args=>'nil')  # tcp正常->异常(告警)
        r << Monitor_strategies.case_21310(:args=>'nil')  # http正常->异常(告警)
        r << Monitor_strategies.case_22311(:args=>'nil')  # https正常->异常(告警)
        r << Monitor_strategies.case_24342(:args=>'nil')  # ping正常->异常(禁用)
        r << Monitor_strategies.case_24343(:args=>'nil')  # tcp正常->异常(禁用)
        r << Monitor_strategies.case_24344(:args=>'nil')  # http正常->异常(禁用)
        r << Monitor_strategies.case_24346(:args=>'nil')  # https正常->异常(禁用)
        r << Monitor_strategies.case_24352(:args=>'nil')  # 编辑检测方式ping->http
        r << Monitor_strategies.case_24362(:args=>'nil')  # 编辑检测方式https->http
        r << Monitor_strategies.case_24363(:args=>'nil')  # 编辑检测方式tcp->http
        r << Monitor_strategies.case_24347(:args=>'nil')  # 编辑检测方式http->ping
        r << Monitor_strategies.case_24348(:args=>'nil')  # 编辑检测方式tcp->ping
        r << Monitor_strategies.case_24350(:args=>'nil')  # 编辑检测方式https->ping
        r << Monitor_strategies.case_24357(:args=>'nil')  # 编辑检测方式ping->tcp
        r << Monitor_strategies.case_24358(:args=>'nil')  # 编辑检测方式http->tcp
        r << Monitor_strategies.case_24359(:args=>'nil')  # 编辑检测方式https->tcp
        r << Monitor_strategies.case_24353(:args=>'nil')  # 编辑检测方式ping->https
        r << Monitor_strategies.case_24360(:args=>'nil')  # 编辑检测方式tcp->https
        r << Monitor_strategies.case_24361(:args=>'nil')  # 编辑检测方式http->https
    end
    def redirections_suit   # ( 14/14 )
        r = []
        r << Redirections.case_19108(:args=>'nil')  # 新建 -> 删除 -> 后台验证
        r << Redirections.case_19111(:args=>'nil')  # 新建 -> 编辑 -> 查数据库
        r << Redirections.case_19115(:args=>'nil')  # 导出
        r << Redirections.case_19114(:args=>'nil')  # 搜索
        r << Redirections.case_19112(:args=>'nil')  # 修改节点
        r << Redirections.case_19107(:args=>'nil')  # 参数检验-新建
        r << Redirections.case_19190(:args=>'nil')  # 参数检验-批量
        r << Redirections.case_19110(:args=>'nil')  # 批量添加OK
        r << Redirections.case_19255(:args=>'nil')  # 批量添加含中文
        r << Redirections.case_20233(:args=>'nil')  # 视图联动删除
        r << Redirections.case_19221(:args=>'nil')  # 选择节点过滤列表
        r << Redirections.case_19220(:args =>'nil')  # 权限和视图绑定
        r << Redirections.case_22503(:args =>'nil')  # 删除绝对域名
        r << Redirections.case_22505(:args =>'nil')  # 新建中文域名的URL转发
    end
end
