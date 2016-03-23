#encoding: utf-8
require File.dirname(__FILE__) + '/case_suit/suit_user_manage'
require File.dirname(__FILE__) + '/case_suit/suit_log_manage'
require File.dirname(__FILE__) + '/case_suit/suit_alarm_manage'
require File.dirname(__FILE__) + '/case_suit/suit_system_maintenance'

module ZDDI
    User_manage        = ZDDI::System::User_manage.new
    Log_manage         = ZDDI::System::Log_manage.new
    Alarm_manage       = ZDDI::System::Alarm_manage.new
    System_maintenance = ZDDI::System::System_maintenance.new
    
    def user_manage_suit   # ( 79 )
        r = []
        #用户权限验证
        r << User_manage.case_2306(:args=>'nil') # 参数校验
        r << User_manage.case_2307(:args=>'nil') # 参数校验
        r << User_manage.case_1029(:args=>'nil') # 参数校验
        r << User_manage.case_1030(:args=>'nil') # 参数校验
        r << User_manage.case_1031(:args=>'nil') # 参数校验
        r << User_manage.case_1032(:args=>'nil') # 参数校验
        r << User_manage.case_1033(:args=>'nil') # 参数校验
        r << User_manage.case_1034(:args=>'nil') # 参数校验
        r << User_manage.case_1035(:args=>'nil') # 参数校验
        r << User_manage.case_1036(:args=>'nil') # 参数校验
        r << User_manage.case_1037(:args=>'nil') # 参数校验
        r << User_manage.case_1038(:args=>'nil') # 参数校验
        r << User_manage.case_1039(:args=>'nil') # 参数校验
        r << User_manage.case_1040(:args=>'nil') # 参数校验
        r << User_manage.case_1041(:args=>'nil') # 参数校验
        r << User_manage.case_1042(:args=>'nil') # 参数校验
        r << User_manage.case_1043(:args=>'nil') # 参数校验
        r << User_manage.case_1044(:args=>'nil') # 参数校验
        r << User_manage.case_1045(:args=>'nil') # 参数校验
        r << User_manage.case_1046(:args=>'nil') # 参数校验
        r << User_manage.case_1047(:args=>'nil') # 参数校验
        r << User_manage.case_1048(:args=>'nil') # 参数校验
        r << User_manage.case_1049(:args=>'nil') # 参数校验
        r << User_manage.case_1024(:args=>'nil') # 新用户->中文->登录
        r << User_manage.case_1025(:args=>'nil') # 新用户->英文->登录
        r << User_manage.case_1026(:args=>'nil') # 新用户->中英混合->登录
        r << User_manage.case_1054(:args=>'nil') # 修改密码后重新登录
        r << User_manage.case_1050(:args=>'nil') # 参数校验 修改密码
        r << User_manage.case_1051(:args=>'nil') # 参数校验 修改密码
        r << User_manage.case_1052(:args=>'nil') # 参数校验 修改密码
        r << User_manage.case_1053(:args=>'nil') # 参数校验 修改密码
        r << User_manage.case_1055(:args=>'nil') # 参数校验 修改密码
        r << User_manage.case_1056(:args=>'nil') # 参数校验 修改密码
        r << User_manage.case_7002(:args=>'nil') # 新建所有视图所有区所有权限
        r << User_manage.case_1334(:args=>'nil') # 非admin权限不足
        r << User_manage.case_2970(:args=>'nil') # 非admin创建已存在的区
        r << User_manage.case_1359(:args=>'nil') # 非admin修改中文视图中文区
        r << User_manage.case_1150(:args=>'nil') # 新建重复权限(相同)
        r << User_manage.case_1151(:args=>'nil') # 新建重复权限(不同)
        r << User_manage.case_1120(:args=>'nil') # 多视图多个区的不同权限
        r << User_manage.case_1115(:args=>'nil') # 单视图多个区的不同权限
        r << User_manage.case_1109(:args=>'nil') # 单视图单个区的不同权限
        r << User_manage.case_1075(:args=>'nil') # 所有视图和区先建权限后建视图/区
        r << User_manage.case_1076(:args=>'nil') # 所有视图和区先建视图/区后建权限
        r << User_manage.case_1133(:args=>'nil') # 所有视图和区->修改权限->新建只读权限
        r << User_manage.case_1132(:args=>'nil') # 所有视图和区->修改权限->新建隐藏权限
        r << User_manage.case_1131(:args=>'nil') # 所有视图和区->只读权限->新建修改权限
        r << User_manage.case_1130(:args=>'nil') # 所有视图和区->只读权限->新建隐藏权限
        r << User_manage.case_1129(:args=>'nil') # 所有视图和区->隐藏权限->新建修改权限
        r << User_manage.case_1128(:args=>'nil') # 所有视图和区->隐藏权限->新建只读权限
        r << User_manage.case_1178(:args=>'nil') # 参数校验 所管设备选择空
        r << User_manage.case_1196(:args=>'nil') # 编辑权限 已存在权限->不同
        r << User_manage.case_1195(:args=>'nil') # 编辑权限 已存在权限->相同
        r << User_manage.case_1206(:args=>'nil') # 非admin用户不能编辑权限
        r << User_manage.case_1182(:args=>'nil') # 修改权限-> "隐藏"->"只读"-> 验证
        r << User_manage.case_1183(:args=>'nil') # 修改权限-> "隐藏"->"修改"-> 验证
        r << User_manage.case_1184(:args=>'nil') # 修改权限-> "只读"->"隐藏"-> 验证
        r << User_manage.case_1186(:args=>'nil') # 修改权限-> "修改"->"只读"-> 验证
        r << User_manage.case_1187(:args=>'nil') # 修改权限-> "修改"->"隐藏"-> 验证
        r << User_manage.case_1903(:args=>'nil') # 修改权限-> "只读"->"修改"-> 验证
        r << User_manage.case_23428(:args=>'nil') # 非admin用户的syslog配置灰显
        r << User_manage.case_1877(:args=>'nil') # 用户管理-> "创建"->"删除"用户-> 验证
        r << User_manage.case_1878(:args=>'nil') # 用户管理-> 取消删除用户-> 验证
        r << User_manage.case_1879(:args=>'nil') # 用户管理-> 批量删除用户->验证
        r << User_manage.case_1880(:args=>'nil') # 用户管理-> "查询"->空查询出所有用户-> 验证
        r << User_manage.case_1352(:args=>'nil') # 用户管理-> "查询"->用户存在->验证
        r << User_manage.case_1353(:args=>'nil') # 用户管理-> "查询"->用户不存在->验证
        r << User_manage.case_1355(:args=>'nil') # 用户管理-> "查询"->中文用户存在->验证
        r << User_manage.case_5799(:args=>'nil') # 用户登陆-> 用户名为空 ->验证
        r << User_manage.case_5800(:args=>'nil') # 用户登陆-> 密码为空->验证
        r << User_manage.case_5789(:args=>'nil') # 用户登陆-> 登陆密码错误 ->验证
        r << User_manage.case_5790(:args=>'nil') # 用户登陆-> 用户不存在 ->验证
        r << User_manage.case_5791(:args=>'nil') # 用户登陆-> 非admin账户登陆->验证
        r << User_manage.case_5792(:args=>'nil') # 用户登陆-> 用户连续四次登录失败，第五次成功->验证
        r << User_manage.case_5793(:args=>'nil') # 用户登陆-> 用户连续5次登录失败，15分钟之内禁止登陆 ->验证
        r << User_manage.case_5788(:args=>'nil') # 用户登陆-> 密码正确成功登陆->验证
        r << User_manage.case_25943(:args=>'nil') # 用户解锁admin ->非admin
        r << User_manage.case_25942(:args=>'nil') # 用户解锁非admin ->非admin
        r << User_manage.case_25945(:args=>'nil') # 用户解锁非admin ->admin
        r << User_manage.case_6857(:args=>'nil')  # 非admin账户 -> 操作日志、告警日志、区可导出->验证
        r << User_manage.case_6858(:args=>'nil')  # 非admin账户 -> 修改密码
        r << User_manage.case_6859(:args=>'nil')  # 非admin账户 -> 修改密码，参数校验
        r << User_manage.case_6860(:args=>'nil')  # 非admin账户 -> 编辑自己的用户信息校验
        r << User_manage.case_1369(:args=>'nil')  # 非admin账户 -> 成功编辑自己的用户信息
        r << User_manage.case_10865(:args=>'nil') # 非admin账户 -> 新建/编辑/删除根配置用户权限不足->验证
        r << User_manage.case_10866(:args=>'nil') # 非admin账户 -> 新建/编辑/删除本地策略用户权限不足->验证
        r << User_manage.case_10867(:args=>'nil') # 非admin账户 -> 新建/编辑/删除缓存管理用户权限不足->验证
        r << User_manage.case_1332(:args=>'nil')  # 非admin账户 -> 新建/编辑/删除重定向权限不足
        r << User_manage.case_1331(:args=>'nil')  # 非admin账户 -> 新建/编辑/删除转发区用户权限不足
        r << User_manage.case_1330(:args=>'nil')  # 非admin账户 -> 新建/编辑/删除存根区用户权限不足
        r << User_manage.case_1324(:args=>'nil')  # 非admin账户 -> 新建/编辑/删除共享记录权限不足
        r << User_manage.case_1319(:args=>'nil')  # 非admin账户 -> 新建/编辑/删除访问控制权限不足
        r << User_manage.case_1315(:args=>'nil')  # 非admin账户 -> 新建/编辑/删除视图和区权限不足
        r << User_manage.case_6982(:args=>'nil')  # 非admin账户 -> 云中心，设备操作，用户权限不足
        r << User_manage.case_1350(:args=>'nil')  # 查询用户权限存在
        r << User_manage.case_1351(:args=>'nil')  # 查询用户权限不存在
    end
    def log_manage_suit    # ( 11 )
        r = []
        # 11条日志备份参数校验
        r << Log_manage.case_2994(:args=>'nil')
        r << Log_manage.case_2995(:args=>'nil')
        r << Log_manage.case_2996(:args=>'nil')
        r << Log_manage.case_2997(:args=>'nil')
        r << Log_manage.case_1418(:args=>'nil')
        r << Log_manage.case_1419(:args=>'nil')
        r << Log_manage.case_1420(:args=>'nil')
        r << Log_manage.case_1421(:args=>'nil')
        r << Log_manage.case_1422(:args=>'nil')
        r << Log_manage.case_1423(:args=>'nil')
        r << Log_manage.case_1424(:args=>'nil')
        #r << Log_manage.case_21122(:args=>'nil') #删除日志备份
        r << Log_manage.case_21118(:args=>'nil')  #日志备份-> 默认状态检查
        r << Log_manage.case_21130(:args=>'nil')  #日志备份-> 设备备份配置已存在错误验证   

    end
    def alarm_manage_suit  # ( 28 )
        r = []
        # 18条告警阈值参数校验
        r << Alarm_manage.case_1611(:args=>'nil')
        r << Alarm_manage.case_1612(:args=>'nil')
        r << Alarm_manage.case_1613(:args=>'nil')
        r << Alarm_manage.case_1614(:args=>'nil')
        r << Alarm_manage.case_1615(:args=>'nil')
        r << Alarm_manage.case_1616(:args=>'nil')
        r << Alarm_manage.case_1617(:args=>'nil')
        r << Alarm_manage.case_1618(:args=>'nil')
        r << Alarm_manage.case_1619(:args=>'nil')
        r << Alarm_manage.case_1620(:args=>'nil')
        r << Alarm_manage.case_1621(:args=>'nil')
        r << Alarm_manage.case_1622(:args=>'nil')
        r << Alarm_manage.case_1623(:args=>'nil')
        r << Alarm_manage.case_1624(:args=>'nil')
        r << Alarm_manage.case_1625(:args=>'nil')
        r << Alarm_manage.case_1626(:args=>'nil')
        r << Alarm_manage.case_1627(:args=>'nil')
        r << Alarm_manage.case_2372(:args=>'nil')
        # 10条邮件告警参数校验
        r << Alarm_manage.case_1527(:args=>'nil')
        r << Alarm_manage.case_1528(:args=>'nil')
        r << Alarm_manage.case_1529(:args=>'nil')
        r << Alarm_manage.case_1531(:args=>'nil')
        r << Alarm_manage.case_1532(:args=>'nil')
        r << Alarm_manage.case_1533(:args=>'nil')
        r << Alarm_manage.case_1534(:args=>'nil')
        r << Alarm_manage.case_1541(:args=>'nil')
        r << Alarm_manage.case_1556(:args=>'nil')
        r << Alarm_manage.case_1604(:args=>'nil')
    end
    def system_maintenance_suit # ( 21 )
        r = []
        # 7条备份配置参数校验
        r << System_maintenance.case_1756(:args=>'nil')
        r << System_maintenance.case_1757(:args=>'nil')
        r << System_maintenance.case_1758(:args=>'nil')
        r << System_maintenance.case_1759(:args=>'nil')
        r << System_maintenance.case_1760(:args=>'nil')
        r << System_maintenance.case_1761(:args=>'nil')
        r << System_maintenance.case_1762(:args=>'nil')
        # # 7条备份恢复参数校验
        r << System_maintenance.case_1842(:args=>'nil')
        r << System_maintenance.case_1843(:args=>'nil')
        r << System_maintenance.case_1844(:args=>'nil')
        r << System_maintenance.case_1845(:args=>'nil')
        r << System_maintenance.case_1846(:args=>'nil')
        r << System_maintenance.case_1847(:args=>'nil')
        r << System_maintenance.case_1848(:args=>'nil')
        # # 7条手动备份恢复参数校验
        r << System_maintenance.case_1825(:args=>'nil')
        r << System_maintenance.case_1826(:args=>'nil')
        r << System_maintenance.case_1827(:args=>'nil')
        r << System_maintenance.case_1828(:args=>'nil')
        r << System_maintenance.case_1829(:args=>'nil')
        r << System_maintenance.case_1830(:args=>'nil')
        r << System_maintenance.case_1831(:args=>'nil')
    end
end
