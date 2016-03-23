# encoding: utf-8
require File.dirname(__FILE__) + '/case_suit/suit_zone'
require File.dirname(__FILE__) + '/case_suit/suit_domain'
require File.dirname(__FILE__) + '/case_suit/suit_share_zone'
require File.dirname(__FILE__) + '/case_suit/suit_share_rr'
require File.dirname(__FILE__) + '/case_suit/suit_global_search'
require File.dirname(__FILE__) + '/case_suit/suit_feedback' # 客户反馈问题补充用例

module ZDDI
    extend self
    Zone          = ZDDI::DNS::Zone.new
    Domain        = ZDDI::DNS::Domain.new
    Share_zone    = ZDDI::DNS::Share_zone.new
    Share_rr      = ZDDI::DNS::Share_rr.new
    Global_search = ZDDI::DNS::Global_search.new
    Feedback      = ZDDI::DNS::Feedback.new

    def zone_suit    # ( 41/51 )
        r = []
        r << Zone.case_5953(:args=>'nil')  # 参数校验, 主服务器端口
        r << Zone.case_5952(:args=>'nil')  # 参数校验, 主服务器输入
        r << Zone.case_854(:args=>'nil')   # 参数校验, 区新建反向区
        r << Zone.case_844(:args=>'nil')   # 参数校验, 区新建正向区
        r << Zone.case_5919(:args=>'nil')  # 参数校验, 辅服务器输入
        r << Zone.case_2743(:args=>'nil')  # 参数校验, 服务器和端口
        r << Zone.case_869(:args=>'nil')   # 参数校验, 区传送失败
        r << Zone.case_5945(:args=>'nil')  # 参数校验, 后台获取数据失败
        r << Zone.case_823(:args=>'nil')    # 新建正向主区
        r << Zone.case_834(:args=>'nil')    # 新建反向主区
        r << Zone.case_839(:args=>'nil')    # 新建正向辅区
        r << Zone.case_840(:args=>'nil')    # 新建反向辅区
        r << Zone.case_2742(:args=>'nil')   # 新建反向区=>区拷贝
        r << Zone.case_860(:args=>'nil')    # 区文件正常
        r << Zone.case_867(:args=>'nil')    # 区拷贝正常
        r << Zone.case_10916(:args=>'nil')  # 区传送正常
        r << Zone.case_8348(:args=>'nil')   # 编辑主区辅服务器地址
        r << Zone.case_8347(:args=>'nil')   # 编辑辅区主服务器地址
        r << Zone.case_1010(:args=>'nil')   # 区新建AD控制器 nsupdate, OK
        r << Zone.case_1019(:args=>'nil')   # 区编辑AD控制器 nsupdate, OK
        r << Zone.case_1020(:args=>'nil')   # 区编辑AD控制器 nsupdate, refused
        r << Zone.case_1011(:args=>'nil')   # 改节点, 数据同步
        r << Zone.case_1012(:args=>'nil')   # 改节点, Master->All
        r << Zone.case_1014(:args=>'nil')   # 改节点, All-> Slave
        r << Zone.case_1016(:args=>'nil')   # 区删除 -> 正向主区
        r << Zone.case_1018(:args=>'nil')   # 区删除 -> 正向辅区
        r << Zone.case_5954(:args=>'nil')   # 创建已存在的主辅区
        r << Zone.case_5150(:args=>'nil')   # 区导出 -> 正向主区
        r << Zone.case_11571(:args=>'nil')  # 区导出 -> 反向主区
        r << Zone.case_11572(:args=>'nil')  # 区导出 -> 正向辅区
        r << Zone.case_11573(:args=>'nil')  # 区删除 -> 反向辅区
        r << Zone.case_11574(:args=>'nil')  # 区删除 -> 反向主区
        r << Zone.case_11575(:args=>'nil')  # 区导出 -> 反向辅区
        r << Zone.case_11625(:args=>'nil')  # 异步数据, 节点断开
        r << Zone.case_848(:args=>'nil')    # 异步数据, 服务关闭
        r << Zone.case_11665(:args=>'nil')  # 主辅区前台数据一致
        r << Zone.case_12838(:args=>'nil')  # AD区指定多个设备 + nsupdate更新
        r << Zone.case_13912(:args=>'nil')  # 新建辅区不续期
        r << Zone.case_13913(:args=>'nil')  # 新建辅区续期
        r << Zone.case_13944(:args=>'nil')  # 编辑辅区续期
        r << Zone.case_13945(:args=>'nil')  # 编辑辅区不续期
    end
    def domain_suit  # ( 41/51 )
        r = []
        r << Domain.case_1100(:args=>'nil')   # 参数校验, 新建各种记录
        r << Domain.case_1116(:args=>'nil')   # 参数校验, SRV/NAPTR字段
        r << Domain.case_1022(:args=>'nil')   # 新建所有记录正常+dig
        r << Domain.case_1087(:args=>'nil')   # 自动创建AAAA记录反向记录
        r << Domain.case_5164(:args=>'nil')   # A记录自动添加PTR掩码8/16/24
        r << Domain.case_1127(:args=>'nil')   # CNAME/DNAME提示互斥
        r << Domain.case_1167(:args=>'nil')   # MX/NS新建时缺乏glue记录
        r << Domain.case_8350(:args=>'nil')   # 编辑SOA
        r << Domain.case_5165(:args=>'nil')   # 删除反向PTR成功
        r << Domain.case_1181(:args=>'nil')   # 批量添加正常
        r << Domain.case_14522(:args=>'nil')  # 新建A记录宕机切换告警
        r << Domain.case_14523(:args=>'nil')  # 新建A记录宕机切换禁用
        r << Domain.case_14524(:args=>'nil')  # 新建AAAA记录宕机切换禁用
        r << Domain.case_14525(:args=>'nil')  # 新建AAAA记录宕机切换告警
        r << Domain.case_14530(:args=>'nil')  # 添加A记录宕机切换为告警
        r << Domain.case_14531(:args=>'nil')  # 添加A记录宕机切换为禁用
        r << Domain.case_14532(:args=>'nil')  # 添加AAA记录宕机切换为禁用
        r << Domain.case_14533(:args=>'nil')  # 添加AAA记录宕机切换为告警
        r << Domain.case_14527(:args=>'nil')  # 编辑A记录宕机切换告警<->禁用
        r << Domain.case_14528(:args=>'nil')  # 编辑A记录宕机切换禁用<->告警
        r << Domain.case_14529(:args=>'nil')  # 编辑AAAA记录宕机切换告警<->禁用
        r << Domain.case_14540(:args=>'nil')  # 编辑AAAA记录宕机切换禁用<->告警
        r << Domain.case_14534(:args=>'nil')  # 删除A记录宕机切换(禁用)
        r << Domain.case_14535(:args=>'nil')  # 删除A记录宕机切换(告警)
        r << Domain.case_14536(:args=>'nil')  # 删除AAAA记录宕机切换(禁用)
        r << Domain.case_14537(:args=>'nil')  # 删除AAAA记录宕机切换(告警)
        r << Domain.case_1320(:args=>'nil')   # 编辑域名后Dig验证
        r << Domain.case_5167(:args=>'nil')   # 编辑记录，自动修改PTR成功
        r << Domain.case_2679(:args=>'nil')   # 同名同类型记录的不同TTL
        r << Domain.case_2674(:args=>'nil')   # 同名但大小写
        r << Domain.case_2764(:args=>'nil')   # 域名下有cname,创建互斥记录
        r << Domain.case_2763(:args=>'nil')   # 域名下有A,创建互斥cname记录
        r << Domain.case_2770(:args=>'nil')   # 新建ns记录rdata为相对域名
        r << Domain.case_1134(:args=>'nil')   # 新建ns记录rdata为相对域名
        r << Domain.case_1097(:args=>'nil')   # 新建记录rname和ttl输入范围
        r << Domain.case_2765(:args=>'nil')   # 批量添加非本区记录
        r << Domain.case_1226(:args=>'nil')   # 批量添加记录大小限制
        r << Domain.case_1215(:args=>'nil')   # 批量添记录格式无效
        r << Domain.case_1338(:args=>'nil')   # 删除单条/多条记录
        r << Domain.case_1285(:args=>'nil')   # 编辑单条记录
        r << Domain.case_22502(:args=>'nil')   # 批量添加中英数字组合相对域名
    end
    def share_zone_suit    # ( 26/31 )
        r = []
        r << Share_zone.case_23146(:args=>'nil')  # default视图下新建共享区
        r << Share_zone.case_23147(:args=>'nil')  # default+非default视图下新建共享区
        r << Share_zone.case_24814(:args=>'nil')  # 新建反向区的共享区
        r << Share_zone.case_24730(:args=>'nil')  # 批量添加共享区记录
        r << Share_zone.case_24736(:args=>'nil')  # 批量添加参数校验
        r << Share_zone.case_23164(:args=>'nil')  # 新建共享区后删除部分权威区记录
        r << Share_zone.case_23166(:args=>'nil')  # 新建共享区后删除全部权威区记录
        r << Share_zone.case_23183(:args=>'nil')  # 编辑共享区记录
        r << Share_zone.case_24711(:args=>'nil')  # 编辑共享区TTL
        r << Share_zone.case_24710(:args=>'nil')  # 编辑共享区记录TTL
        r << Share_zone.case_24707(:args=>'nil')  # 编辑记录后丢弃宕机切换
        r << Share_zone.case_24753(:args=>'nil')  # 编辑所属视图
        r << Share_zone.case_24731(:args=>'nil')  # 联动删除共享区
        r << Share_zone.case_24714(:args=>'nil')  # 删除共享区新建记录
        r << Share_zone.case_24713(:args=>'nil')  # 删除共享区后新建重复记录
        r << Share_zone.case_24712(:args=>'nil')  # 删除共享区保留原记录
        r << Share_zone.case_23159(:args=>'nil')  # 删除多个共享区
        r << Share_zone.case_23162(:args=>'nil')  # 共享区记录前台增删改查
        r << Share_zone.case_23145(:args=>'nil')  # 批量添加中文共享区记录
        r << Share_zone.case_23170(:args=>'nil')  # 共享区权限验证
        r << Share_zone.case_23322(:args=>'nil')  # 共享区记录查询(中文*多类型)
        r << Share_zone.case_23157(:args=>'nil')  # 选择根区为共享区
        r << Share_zone.case_23205(:args=>'nil')  # 在权威区编辑保留后的共享区记录
        r << Share_zone.case_23303(:args=>'nil')  # 共享区记录和本地策略重定向等记录重复
        r << Share_zone.case_24706(:args=>'nil')  # 修改视图保留记录
        r << Share_zone.case_23318(:args=>'nil')  # 权威区共享区全局搜索交叉编辑记录
    end
    def share_rr_suit  # ( 05/05 )
        r = []
        r << Share_rr.case_1484(:args=>'nil')   # 参数校验
        r << Share_rr.case_1475(:args=>'nil')   # 共享记录新建/编辑/删除
        r << Share_rr.case_1631(:args=>'nil')   # 修改所属区A->A+B->B
        r << Share_rr.case_14288(:args=>'nil')   # 新建记录后添加节点
        r << Share_rr.case_25959(:args=>'nil')   # 新建中文共享记录
    end
    def global_search_suit # ( 08/11 )
        r = []
        r << Global_search.case_1660(:args=>'nil')   # 全局搜索编辑
        r << Global_search.case_1649(:args=>'nil')   # 全局搜索*cn*
        r << Global_search.case_1661(:args=>'nil')   # 全局搜索编辑异常
        r << Global_search.case_1667(:args=>'nil')   # 删除ns记录失败
        r << Global_search.case_1685(:args=>'nil')   # 搜索错误关键字
        r << Global_search.case_21104(:args=>'nil')   # 全局搜索'ip*'
        r << Global_search.case_21102(:args=>'nil')   # 全局搜索'domain*'
        r << Global_search.case_21105(:args=>'nil')   # 搜索并编辑IPv6地址
    end
    def feedback_suit    # ( 01/01 )
        r = []
        r << Feedback.case_23433(:args=>'nil')   # 启动/停止NTP服务
    end
end
