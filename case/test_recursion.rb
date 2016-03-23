# encoding: utf-8
require File.dirname(__FILE__) + '/case_suit/suit_stub'
require File.dirname(__FILE__) + '/case_suit/suit_forward'
require File.dirname(__FILE__) + '/case_suit/suit_redirect'
require File.dirname(__FILE__) + '/case_suit/suit_hint_zone'
require File.dirname(__FILE__) + '/case_suit/suit_local_policies'
require File.dirname(__FILE__) + '/case_suit/suit_cache_manage'
require File.dirname(__FILE__) + '/case_suit/suit_query_source'


module ZDDI
    Stub           = ZDDI::DNS::Stub.new
    Forward        = ZDDI::DNS::Forward.new
    Redirect       = ZDDI::DNS::Redirect.new
    Hint_zone      = ZDDI::DNS::Hint_zone.new
    Local_policies = ZDDI::DNS::Local_policies.new
    Cache_manage   = ZDDI::DNS::Cache_manage.new
    Query_source   = ZDDI::DNS::Query_source.new

    def stub_suit           # ( 17/25 )
        r = []
        r << Stub.case_5116(:args=>'nil')  # 参数校验, 区名称格式错误
        r << Stub.case_5115(:args=>'nil')  # 参数校验, 提示"必须字段"
        r << Stub.case_5133(:args=>'nil')  # 参数校验, 服务器输入错误
        r << Stub.case_5122(:args=>'nil')  # 参数校验, 配置区已存在
        r << Stub.case_5141(:args=>'nil')   # 删除单个正常
        r << Stub.case_5142(:args=>'nil')   # 删除多个正常
        r << Stub.case_7142(:args=>'nil')   # 删除中文存根区
        r << Stub.case_7144(:args=>'nil')   # 删除视图触发存根区删除
        r << Stub.case_7140(:args=>'nil')   # 新建中文存根区
        r << Stub.case_9497(:args=>'nil')   # 域名含下划线
        r << Stub.case_9505(:args=>'nil')   # 配置后重启服务
        r << Stub.case_5027(:args=>'nil')   # 存根区配置为根区
        r << Stub.case_5121(:args=>'nil')   # 配置多个服务器IP地址
        r << Stub.case_7141(:args=>'nil')   # 编辑存根区后的更新
        r << Stub.case_5139(:args=>'nil')   # 节点master->all
        r << Stub.case_5138(:args=>'nil')   # 节点all->slave
        r << Stub.case_7145(:args=>'nil')   # 节点master->slave
    end
    def forward_suit        # ( 31/40 )
        r = []
        r << Forward.case_4944(:args=>'nil')  # 参数校验, 配置格式错误
        r << Forward.case_4946(:args=>'nil')  # 参数校验, 配置为空
        r << Forward.case_4958(:args=>'nil')  # 参数校验, 服务器已存在
        r << Forward.case_4959(:args=>'nil')  # 参数校验, 重复配置
        r << Forward.case_14512(:args=>'nil') # 参数校验, 导入导出格式错误
        r << Forward.case_14516(:args=>'nil') # 参数校验, 存在重复项
        r << Forward.case_4961(:args=>'nil')   # 配置转发区再配置权威区
        r << Forward.case_4991(:args=>'nil')   # 转发区配置根区@
        r << Forward.case_4996(:args=>'nil')   # 编辑default视图的转发配置
        r << Forward.case_4997(:args=>'nil')   # 编辑非default视图转发配置
        r << Forward.case_5000(:args=>'nil')   # 对Only和First的验证
        r << Forward.case_5002(:args=>'nil')   # 配置权威区后再配置转发区
        r << Forward.case_5007(:args=>'nil')   # 节点从多变少
        r << Forward.case_5008(:args=>'nil')   # 节点从少变多
        r << Forward.case_5009(:args=>'nil')   # 删除单个转发区配置
        r << Forward.case_5010(:args=>'nil')   # 删除多个转发区配置
        r << Forward.case_8399(:args=>'nil')   # 更改服务器端口号正常
        r << Forward.case_9498(:args=>'nil')   # 域名含下划线
        r << Forward.case_9504(:args=>'nil')   # 配置后重启服务
        r << Forward.case_4954(:args=>'nil')   # 同一服务器多个区
        r << Forward.case_9229(:args=>'nil')   # 同一配置的不同服务器
        r << Forward.case_9506(:args=>'nil')   # 编辑以前记录为根区
        r << Forward.case_7146(:args=>'nil')   # 删除视图导致配置被删除
        r << Forward.case_7147(:args=>'nil')   # 修改视图节点触发转发区删除
        r << Forward.case_11679(:args=>'nil')  # 新建根配置后再新建根的转发
        r << Forward.case_14511(:args=>'nil')  # 导入导出中文域名+中文备注
        r << Forward.case_14513(:args=>'nil')  # 导入导出后dig验证
        r << Forward.case_15891(:args=>'nil')  # 转发配置编辑为no
        r << Forward.case_15892(:args=>'nil')  # 转发配置no导入导出
        r << Forward.case_20759(:args=>'nil')  # 导入@验证后删除OK
        r << Forward.case_20042(:args=>'nil')   # 转发黑名单
    end
    def redirect_suit       # ( 18/18 )
        r = []
        r << Redirect.case_1911(:args=>'nil')  # 参数校验, 新建重复的重定向记录
        r << Redirect.case_1906(:args=>'nil')  # 参数校验, 新建记录对话框输入异常值
        r << Redirect.case_1917(:args=>'nil')  # 参数校验, 重定向编辑
        r << Redirect.case_9194(:args=>'nil')   # 新建正常
        r << Redirect.case_1921(:args=>'nil')   # 编辑正常
        r << Redirect.case_9499(:args=>'nil')   # 域名含下划线
        r << Redirect.case_9503(:args=>'nil')   # 配置后重启服务
        r << Redirect.case_5152(:args=>'nil')   # 新建视图 + 重定向记录
        r << Redirect.case_9778(:args=>'nil')   # 编辑TTL, <> 5s的验证
        r << Redirect.case_9757(:args=>'nil')   # 批量编辑TTL
        r << Redirect.case_8731(:args=>'nil')   # 改节点master->all->slave
        r << Redirect.case_1887(:args=>'nil')   # 新建, 后台检查
        r << Redirect.case_1927(:args=>'nil')   # 删除, 后台校验
        r << Redirect.case_2766(:args=>'nil')   # 非default视图，acl范围内
        r << Redirect.case_7164(:args=>'nil')   # 非default视图，acl范围外
        r << Redirect.case_8365(:args=>'nil')   # 记录查询
        r << Redirect.case_1926(:args=>'nil')   # 异步数据, 节点断开
        r << Redirect.case_12622(:args=>'nil')  # 异步数据, 服务关闭
    end
    def hint_zone_suit      # ( 23/24 )
        r = []
        r << Hint_zone.set_ttl_5(:args=>'nil')  # set TTL to 5s!
        r << Hint_zone.case_5805(:args=>'nil')  # 参数校验, 导入内容错误
        r << Hint_zone.case_5807(:args=>'nil')  # 参数校验, 导入200条
        r << Hint_zone.case_5809(:args=>'nil')  # 参数校验, 导入内重复记录
        r << Hint_zone.case_5822(:args=>'nil')  # 参数校验, 导入非A/AAAA/NS
        r << Hint_zone.case_5820(:args=>'nil')  # 参数校验, 新建非A/AAAA/NS
        r << Hint_zone.case_5804(:args=>'nil')  # 参数校验, 资源记录格式无效
        r << Hint_zone.case_5803(:args=>'nil')  # 参数校验, 空或重复根配置
        r << Hint_zone.case_5827(:args=>'nil')  # 参数校验, 删除所有的ns记录
        r << Hint_zone.case_5828(:args=>'nil')  # 参数校验, 删除所有A或AAAA记录
        r << Hint_zone.case_5832(:args=>'nil')  # 用导出的文件创建根区
        r << Hint_zone.case_5819(:args=>'nil')  # 新建
        r << Hint_zone.case_5814(:args=>'nil')  # 删除
        r << Hint_zone.case_5813(:args=>'nil')  # 导出
        r << Hint_zone.case_5818(:args=>'nil')  # 备注
        r << Hint_zone.case_5811(:args=>'nil')  # 修改节点Master > All > Slave
        r << Hint_zone.case_9502(:args=>'nil')  # 配置后重启服务
        r << Hint_zone.case_9771(:args=>'nil')  # 指向真实IP
        r << Hint_zone.case_9500(:args=>'nil')  # 域名含下划线
        r << Hint_zone.case_5826(:args=>'nil')  # 多条NS/A/AAA查询
        r << Hint_zone.case_5825(:args=>'nil')  # 编辑TTL和记录值
        r << Hint_zone.case_11680(:args=>'nil') # 权威区建根后再建根配置
        r << Hint_zone.reset_ttl(:args=>'nil')  # reset TTL!
    end
    def local_policies_suit # ( 25/28 )
        r = []
        r << Local_policies.case_8378(:args=>'nil')   # 参数校验, 编辑记录值非法
        r << Local_policies.case_14517(:args=>'nil')  # 参数校验, 导入导出字段
        r << Local_policies.case_14519(:args=>'nil')  # 参数校验, 导入重复
        r << Local_policies.case_7956(:args=>'nil')   # 参数校验, 输入项
        r << Local_policies.case_8010(:args=>'nil')   # 参数校验, 重复项
        r << Local_policies.case_7972(:args=>'nil')    # 配置重定向
        r << Local_policies.case_7987(:args=>'nil')    # 配置无域名
        r << Local_policies.case_7986(:args=>'nil')    # 配置无记录
        r << Local_policies.case_8002(:args=>'nil')    # 重定向-中文域名
        r << Local_policies.case_8003(:args=>'nil')    # 无域名-中文域名
        r << Local_policies.case_8004(:args=>'nil')    # 无记录-中文域名
        r << Local_policies.case_8005(:args=>'nil')    # 非Default视图
        r << Local_policies.case_8008(:args=>'nil')    # 对应视图被删除
        r << Local_policies.case_8379(:args=>'nil')    # 编辑重定向>无域名>无记录
        r << Local_policies.case_8380(:args=>'nil')    # 编辑无记录>重定向>无域名
        r << Local_policies.case_8381(:args=>'nil')    # 编辑无域名>无记录>重定向
        r << Local_policies.case_8382(:args=>'nil')    # 删除本
        r << Local_policies.case_8385(:args=>'nil')    # 查询
        r << Local_policies.case_9496(:args=>'nil')    # 域名含下划线
        r << Local_policies.case_9501(:args=>'nil')    # 配置后重启服务
        r << Local_policies.case_14520(:args=>'nil')   # 导入导出中文 + 备注
        r << Local_policies.case_14521(:args=>'nil')   # 导入后dig验证
        r << Local_policies.case_20144(:args=>'nil')   # 新建本地策略配置白名单
        r << Local_policies.case_20145(:args=>'nil')   # 编辑重定向本地策略为白名单
        r << Local_policies.case_20146(:args=>'nil')   # 删除本地策略后检查dig和操作日志(翻译bug)
    end
    def cache_manage_suit   # ( 21/28 )
        r = []
        r << Cache_manage.case_8001(:args=>'nil')  # 参数校验, 配置项输入
        r << Cache_manage.case_8020(:args=>'nil')  # 参数校验, 域名输入
        r << Cache_manage.case_8016(:args=>'nil')   # 清除所有设备缓存
        r << Cache_manage.case_8017(:args=>'nil')   # 清除所有视图缓存
        r << Cache_manage.case_8023(:args=>'nil')   # 清除所有域名缓存
        r << Cache_manage.case_8019(:args=>'nil')   # 清除中英文域名且有下划线
        r << Cache_manage.case_8022(:args=>'nil')   # 清除单个域名缓存不影响其他域名
        r << Cache_manage.case_8018(:args=>'nil')   # 清除单个设备缓存不影响其他设备
        r << Cache_manage.case_8014(:args=>'nil')   # 清除单个视图缓存不影响其他视图
        r << Cache_manage.case_8006(:args=>'nil')   # 更改记录缓存默认时间生效
        r << Cache_manage.case_8009(:args=>'nil')   # 更改否定缓存默认时间生效
        r << Cache_manage.case_16166(:args=>'nil')  # 删除查询到的缓存
        r << Cache_manage.case_16167(:args=>'nil')  # 清除一个域名缓存查询其他域名缓存
        r << Cache_manage.case_16165(:args=>'nil')  # 清除一个视图缓存查询其他视图缓存
        r << Cache_manage.case_16168(:args=>'nil')  # 清除一个设备缓存查询其他设备缓存
        r << Cache_manage.case_16169(:args=>'nil')  # 清除所有设备缓存后查询
        r << Cache_manage.case_16170(:args=>'nil')  # 清除所有视图缓存后查询
        r << Cache_manage.case_16171(:args=>'nil')  # 清除所有域名缓存后查询
        r << Cache_manage.case_16160(:args=>'nil')  # 选择错误类型查询
        r << Cache_manage.case_16161(:args=>'nil')  # 输入错误域名查询
        r << Cache_manage.case_22510(:args=>'nil')  # 输入中文域名查询
    end
    def query_source_suit   # ( 5/9 )
        r = []
        r << Query_source.case_12283(:args=>'nil')  # 错误的请求源地址不写入named.conf
        r << Query_source.case_10902(:args=>'nil')  # 修改视图节点导致源地址被删除
        r << Query_source.case_21085(:args=>'nil')  # 备用地址参数校验
        r << Query_source.case_21841(:args=>'nil')  # 请求源地址告警
        r << Query_source.case_23363(:args=>'nil')  # 请求源地址切换
    end
end
