# encoding: utf-8
require File.dirname(__FILE__) + '/run_case'

ath = %w[zone_suit domain_suit share_zone_suit share_rr_suit global_search_suit feedback_suit]
re1 = %w[stub_suit forward_suit redirect_suit hint_zone_suit]
re2 = %w[local_policies_suit cache_manage_suit query_source_suit route_switch_suit]
acl = %w[view_suit acl_suit ip_rrls_suit domain_rrls_suit monitor_strategies_suit redirections_suit]
sys = %w[user_manage_suit log_manage_suit alarm_manage_suit system_maintenance_suit node_manage_suit]
ads = %w[ipam_suit dhcp_suit]

#####################
debug = %w[redirections_suit]
zddi = Run_suits.new
zddi.run_suit_list(debug, false)
zddi.send_report
#####################
#
# zddi = Run_suits.new
# zddi.run_suit_list(ath, resetData = true)
# zddi.run_suit_list(re1, true)
# zddi.run_suit_list(re2, true)
# zddi.run_suit_list(acl, true)
# zddi.run_suit_list(sys, true)
# zddi.send_report
# zddi_rerun = Run_failed_case.new
# zddi_rerun.re_run_failed_case
# zddi_rerun.send_rerun_report
# zddi.restart_pc
#
# ------------------>  用例统计 <-------------------
# 地址管理: 0    (IPAM000  + DHCP000)
# 解析管理: 385  (权威113  + 递归154 + 访问118 )
# 系统管理: 156  (用户079  + 日志011 + 告警028 + 系统021 )
# 云中心  : 019  (节点019)
# 总计    : 560
# -------------------   * 权威管理 * --->( 113/196 )
# 区管理      zone_suit                  ( 41/69 )
# 记录管理    domain_suit                ( 43/61 )
# 共享区      share_zone_suit            ( 26/31 )
# 共享记录    需要新增                   ( 01/24 )
# 全局搜索    global_search              ( 08/11 )
# 用户反馈    feed_back                  ( 01/01 )
# -------------------   * 递归管理 * --->( 154/190 )
# 存根区      stub_suit                  ( 17/25 )
# 转发区      forward_suit               ( 31/40 )
# 重定向      redirect_suit              ( 18/17 )
# 本地策略    local_policies_suit        ( 25/27 )
# 根配置      hint_zone_suit             ( 23/24 )
# 缓存管理    cache_manage_suit          ( 21/27 )
# 请求源地址  query_source_suit          ( 05/09 )
# URL转发     redirections_suit          ( 14/14 )
# -------------------   * 访问控制 * --->( 118/138 )
# 视图管理      view_suit                ( 36/42 )
# 访问控制      acls_suit                ( 16/16 )
# IP解析限速    ip_rrls_suit             ( 10/15 )
# 域名解析限速  domain_rrls_suit         ( 14/16 )
# 宕机切换      monitor_strategies_suit  ( 35/35 )
# 路由切换      route_switch_suit        ( 07/07 )
# -------------------   * 云中心 *       ( 019/270 )
# 节点管理      node_manage_suit         ( 13/99 )
# -------------------   * 系统管理 * --->( 156/322 )
# 用户管理      user_manage_suit         ( 96/118 )
# 日志管理      log_manage_suit          ( 11/043 )
# 告警管理      alarm_manage_suit        ( 28/068 )
# 系统维护      system_maintenance_suit  ( 21/067 )
# -------------------   * 用户反馈 * --->( 01/01 )
# 启动/停止ntp服务失败的问题