# encoding: utf-8
require File.dirname(__FILE__) + '/../../zddi'
module ZDDI
	module DNS
		# 宕机切换
		class Monitor_strategies
			def case_12599(args)
				# 宕机切换之参数校验
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:error_type] = "before_OK"
				begin
					DNS.open_monitor_strategies_page
					args[:strategy_name] = " with space and #@!"
					args[:error_info]    = "字符串格式不正确，只能为数字，字母，_和-"
					DNS.inputs_monitor_strategies_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					args[:strategy_name] = "case_#{@case_ID}"
					args[:strategy_timeout] = "31"
					args[:error_info]       = "请输入最大为 30 的值"
					DNS.inputs_monitor_strategies_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					args[:strategy_timeout]  = "5"
					args[:strategy_interval] = "!#*"
					args[:error_info]        = "请输入合法的整数"
					DNS.inputs_monitor_strategies_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					args[:strategy_interval] = "5"
					args[:strategy_retry_times] = "11"
					args[:error_info]       = "请输入最大为 10 的值"
					DNS.inputs_monitor_strategies_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_12598(args)
				# 宕机切换之重复新建
				@case_ID             = __method__.to_s.split('_')[1]
				r                    = []
				args[:error_type]    = "after_OK"
				args[:error_info]    = "宕机切换策略已存在"
				args[:strategy_name] = "case_#{@case_ID}"
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					DNS.open_monitor_strategies_page
					DNS.inputs_monitor_strategies_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					# Del
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_10877(args)
				# 新建策略选择"禁用"
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:strategy_name]          = "case_#{@case_ID}"
				args[:strategy_handle_method] = "禁用"
				args[:domain_name]            = "case_#{@case_ID}.com"
				args[:view_name]              = "default"
				args[:local_type]             = "重定向"
				args[:ttl]                    = "3600"
				args[:ip]                     = "192.168.108.77"
				args[:rtype]                  = "A"  
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << Recu_er.create_local_policies(args)
					sleep 300 # 等待宕机切换生效
					[Master_IP, Slave_IP].each do |ip|
						args[:dig_ip] = ip
						s = DNS.get_dig_result(args)
						r << 'failed' if s.include?(args[:ip])
					end
					r << Recu_er.del_local_policies(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_10876(args)
				# 宕机切换之重复新建
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:strategy_name]          = "case_#{@case_ID}"
				args[:strategy_handle_method] = "告警"
				args[:domain_name]            = "case_#{@case_ID}.com"
				args[:view_name]              = "default"
				args[:local_type]             = "重定向"
				args[:ttl]                    = "3600"
				args[:ip]                     = "192.168.108.76"
				args[:rtype]                  = "A"  
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << Recu_er.create_local_policies(args)
					sleep 30 # 等待宕机切换生效
					[Master_IP, Slave_IP].each do |ip|
						args[:dig_ip] = ip
						s = DNS.get_dig_result(args)
						r << 'failed' if !s.include?(args[:ip])
					end
					# Del
					r << Recu_er.del_local_policies(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_12601(args)
				# 删除被占用的宕机策略
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:strategy_name]          = "case_#{@case_ID}"
				args[:strategy_handle_method] = "告警"
				args[:domain_name]            = "case_#{@case_ID}.com"
				args[:view_name]              = "default"
				args[:local_type]             = "重定向"
				args[:ttl]                    = "3600"
				args[:ip]                     = "192.168.108.76"
				args[:error_info]             = "#{args[:strategy_name]}:删除被引用的宕机切换策略"
				args[:error_type]             = "after_OK"
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << Recu_er.create_local_policies(args)
					# Del and verify Error!
					DNS.open_monitor_strategies_page
                    DNS.check_single_monitor_strategies(args)
                    DNS.popup_right_menu("del")
                    r << DNS.error_validator_on_popwin(args)
					r << Recu_er.del_local_policies(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_12600(args)
				# 删除被占用的宕机策略
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:strategy_name]          = "case_#{@case_ID}"
				args[:strategy_handle_method] = "禁用"
				args[:domain_name]            = "case_#{@case_ID}.com"
				args[:view_name]              = "default"
				args[:local_type]             = "重定向"
				args[:ttl]                    = "3600"
				args[:ip]                     = "192.168.108.76"
				args[:error_info]             = "#{args[:strategy_name]}:删除被引用的宕机切换策略"
				args[:error_type]             = "after_OK"
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << Recu_er.create_local_policies(args)
					# Del and verify Error!
					DNS.open_monitor_strategies_page
                    DNS.check_single_monitor_strategies(args)
                    DNS.popup_right_menu("del")
                    r << DNS.error_validator_on_popwin(args)
					r << Recu_er.del_local_policies(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_10878(args)
				# 编辑 告警->禁用
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:strategy_name]          = "case_#{@case_ID}"
				args[:strategy_handle_method] = "告警"
				args[:domain_name]            = "case_#{@case_ID}.com"
				args[:view_name]              = "default"
				args[:local_type]             = "重定向"
				args[:ttl]                    = "3600"
				args[:ip]                     = "192.168.108.78"
				args[:rtype]                  = 'A'
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << Recu_er.create_local_policies(args)
					sleep 300 # 等待宕机切换生效
					[Master_IP, Slave_IP].each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_noerror(args)
					end
					# Del and verify Error!
					args[:strategy_handle_method] = "禁用"
                    r << ACL_Mng_er.edit_monitor_strategy(args)
                    sleep 300 # 等待宕机切换生效
					[Master_IP, Slave_IP].each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_nxdomain(args)
					end
					r << Recu_er.del_local_policies(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_10879(args)
				# 编辑 禁用->告警
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:strategy_name]          = "case_#{@case_ID}"
				args[:strategy_handle_method] = "禁用"
				args[:domain_name]            = "case_#{@case_ID}.com"
				args[:view_name]              = "default"
				args[:local_type]             = "重定向"
				args[:ttl]                    = "3600"
				args[:ip]                     = "192.168.108.79"
				args[:rtype]                  = 'A'
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << Recu_er.create_local_policies(args)
					sleep 300 # 等待宕机切换生效
					[Master_IP, Slave_IP].each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_nxdomain(args)
					end
					# Del and verify Error!
					args[:strategy_handle_method] = "告警"
                    r << ACL_Mng_er.edit_monitor_strategy(args)
                    sleep 300 # 等待宕机切换生效
					[Master_IP, Slave_IP].each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_noerror(args)
					end
					r << Recu_er.del_local_policies(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_10880(args)
				# 宕机'禁用' 新建-删除
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:strategy_name]          = "case_#{@case_ID}"
				args[:strategy_handle_method] = "禁用"
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_10881(args)
				# 宕机'告警' 新建-删除
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:strategy_name]          = "case_#{@case_ID}"
				args[:strategy_handle_method] = "告警"
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_14538(args)
				# 删除权威域名占用的宕机策略
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:strategy_name]          = "case_#{@case_ID}"
				args[:strategy_handle_method] = "告警"
				args[:view_name]              = 'default'
				args[:zone_name]              = "zone.#{@case_ID}"
				args[:owner_list]             = Node_Name_List
				args[:domain_list]            = [{'rname'=>"case.#{@case_ID}", 'rtype'=>'A', 'rdata'=>'192.168.145.38', 'ttl'=>'3600', 'strategy_name'=>"#{args[:strategy_name]}"}]
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					DNS.open_monitor_strategies_page
					r << DNS.check_single_monitor_strategies(args)
					DNS.popup_right_menu('del')
					args[:error_info] = 'case_14538:删除被引用的宕机切换策略'
					args[:error_type] = 'after_OK'
					r << DNS.error_validator_on_popwin(args)
					# 先域名再删宕机策略
					r << Domain_er.del_domain(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
					# 清理
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_14539(args)
				# 删除本地策略占用的宕机策略
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:strategy_name]          = "case_#{@case_ID}"
				args[:strategy_handle_method] = "告警"
				args[:domain_name]            = "case_#{@case_ID}.com"
				args[:view_name]              = "default"
				args[:local_type]             = "重定向"
				args[:ttl]                    = "3600"
				args[:ip]                     = "192.168.145.39"
				args[:rtype]                  = "A"
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << Recu_er.create_local_policies(args)
					DNS.open_monitor_strategies_page
					r << DNS.check_single_monitor_strategies(args)
					DNS.popup_right_menu('del')
					args[:error_info] = 'case_14539:删除被引用的宕机切换策略'
					args[:error_type] = 'after_OK'
					r << DNS.error_validator_on_popwin(args)
					# 先域名再删宕机策略
					r << Recu_er.del_local_policies(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_20987(args)
				# 新建并验证tcp宕机切换策略
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:strategy_name]          = "case_#{@case_ID}"
				# 用真实的baidu_ip做域名A记录来保证宕机侧率正常连通.
				baidu_ip                      = `dig @8.8.8.8 baidu.com +short`.split("\n")[0]
				args[:strategy_detect_method] = 'tcp'
				args[:strategy_handle_method] = '告警'
				args[:view_name]              = 'default'
				args[:zone_name]              = "zone.#{@case_ID}"
				args[:owner_list]             = Node_Name_List
				args[:domain_list]            = [{'rname'=>"case.#{@case_ID}", 'rtype'=>'A', 'rdata'=>baidu_ip, 'ttl'=>'3600', 'strategy_name'=>"#{args[:strategy_name]}"}]
				args[:domain_name]            = "case.#{@case_ID}.com"
				args[:local_type]             = "重定向"
				args[:ttl]                    = "3600"
				args[:ip]                     = baidu_ip
				args[:rtype]                  = "A"
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					r << Recu_er.create_local_policies(args)
					# 验证宕机策略生效
					sleep 20
					DNS.goto_zone_page(args)
					domain_status = DNS.get_cur_elem_string("case.#{@case_ID}") # 查询域名的宕机状态
					r << 'fail' if domain_status.to_s.include?(args[:strategy_handle_method])
					DNS.open_local_policies_page
					local_policy_status = DNS.get_cur_elem_string("case.#{@case_ID}") # 查询本地策略的宕机状态
					r << 'fail' if local_policy_status.to_s.include?(args[:strategy_handle_method])
					# 清理
					r << Zone_er.del_zone(args)
					r << Recu_er.del_local_policies(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_20988(args)
				# 新建并验证http宕机切换策略
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:strategy_name]          = "case_#{@case_ID}"
				# 用真实的baidu.com和真实的baidu IP做域名和对应的A记录来保证http正常连通.
				baidu_ip                      = `dig @8.8.8.8 baidu.com +short`.split("\n")[0]
				args[:strategy_detect_method] = 'http'
				args[:strategy_handle_method] = '告警'
				args[:view_name]              = 'default'
				args[:zone_name]              = 'com'
				args[:owner_list]             = Node_Name_List
				args[:domain_list]            = [{'rname'=>'baidu', 'rtype'=>'A', 'rdata'=>baidu_ip, 'ttl'=>'3600', 'strategy_name'=>"#{args[:strategy_name]}"}]
				args[:domain_name]            = 'baidu.com'
				args[:local_type]             = "重定向"
				args[:ttl]                    = "3600"
				args[:ip]                     = baidu_ip
				args[:rtype]                  = "A"
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					r << Recu_er.create_local_policies(args)
					# 验证宕机策略生效
					sleep 20
					DNS.goto_zone_page(args)
					domain_status = DNS.get_cur_elem_string("case.#{@case_ID}") # 查询域名的宕机状态
					r << 'fail' if domain_status.to_s.include?(args[:strategy_handle_method])
					DNS.open_local_policies_page
					local_policy_status = DNS.get_cur_elem_string("case.#{@case_ID}") # 查询本地策略的宕机状态
					r << 'fail' if local_policy_status.to_s.include?(args[:strategy_handle_method])
					# 清理
					r << Zone_er.del_zone(args)
					r << Recu_er.del_local_policies(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_20989(args)
				# 新建并验证https宕机切换策略
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:strategy_name]          = "case_#{@case_ID}"
				# 用master_ip做域名A记录来保证宕机侧率正常连通.
				args[:strategy_detect_method] = 'https'
				args[:strategy_handle_method] = '告警'
				args[:view_name]              = 'default'
				args[:zone_name]              = "zone.#{@case_ID}"
				args[:owner_list]             = Node_Name_List
				args[:domain_list]            = [{'rname'=>"case.#{@case_ID}", 'rtype'=>'A', 'rdata'=>Master_IP, 'ttl'=>'3600', 'strategy_name'=>"#{args[:strategy_name]}"}]
				args[:domain_name]            = "case.#{@case_ID}.com"
				args[:local_type]             = "重定向"
				args[:ttl]                    = "3600"
				args[:ip]                     = Master_IP
				args[:rtype]                  = "A"
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					r << Recu_er.create_local_policies(args)
					# 验证宕机策略生效
					sleep 20
					DNS.goto_zone_page(args)
					domain_status = DNS.get_cur_elem_string("case.#{@case_ID}") # 查询域名的宕机状态
					r << 'fail' if domain_status.to_s.include?(args[:strategy_handle_method])
					DNS.open_local_policies_page
					local_policy_status = DNS.get_cur_elem_string("case.#{@case_ID}") # 查询本地策略的宕机状态
					r << 'fail' if local_policy_status.to_s.include?(args[:strategy_handle_method])
					# 清理
					r << Zone_er.del_zone(args)
					r << Recu_er.del_local_policies(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_21307(args)
				# ping 正常 -> 异常(告警)
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:strategy_name]          = "case_#{@case_ID}"
				args[:strategy_detect_method] = 'Ping'
				args[:strategy_handle_method] = '告警'
				args[:view_name]              = 'default'
				args[:zone_name]              = "zone.#{@case_ID}"
				args[:owner_list]             = Node_Name_List
				args[:domain_list]            = [{'rname'=>"case.#{@case_ID}", 'rtype'=>'A', 'rdata'=>Master_IP, 'ttl'=>'3600', 'strategy_name'=>"#{args[:strategy_name]}"}]
				args[:domain_name]            = "case.#{@case_ID}.com"
				args[:local_type]             = "重定向"
				args[:ttl]                    = "3600"
				args[:ip]                     = Master_IP
				args[:rtype]                  = "A"
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					r << Recu_er.create_local_policies(args)
					# 验证策略为'正常'
					sleep 20
					DNS.goto_zone_page(args)
					domain_status = DNS.get_all_search_string("case.#{@case_ID}") # 查询域名的宕机状态
					DNS.open_local_policies_page
					local_policy_status = DNS.get_all_search_string("case.#{@case_ID}")
					r << 'fail' if domain_status.to_s.include?(args[:strategy_handle_method])
					r << 'fail' if local_policy_status.to_s.include?(args[:strategy_handle_method])
					# 修改域名和本地侧率的A记录不可达
					wrong_ip = '192.168.213.7'
					args[:domain_list] = [{'rname'=>"case.#{@case_ID}", 'rtype'=>'A', 'rdata_old'=>Master_IP, 'rdata_new'=>wrong_ip, 'ttl'=>'3600', 'strategy_name'=>"#{args[:strategy_name]}"}]
					r << Domain_er.edit_domain(args)
					args[:new_ip] = wrong_ip
					r << Recu_er.edit_local_policies(args)
					# 验证策略为'告警'
					sleep 300
					DNS.goto_zone_page(args)
					domain_status = DNS.get_all_search_string("case.#{@case_ID}") # 查询域名的宕机状态
					DNS.open_local_policies_page
					local_policy_status = DNS.get_all_search_string("case.#{@case_ID}")
					r << 'fail' if !domain_status.to_s.include?(args[:strategy_handle_method])
					r << 'fail' if !local_policy_status.to_s.include?(args[:strategy_handle_method])
					# dig 权威->noerror(告警), 不dig本地策略(外网递归可能有数据)
					args[:domain_name] = "case.#{@case_ID}.#{args[:zone_name]}"
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_noerror(args)
					end
					# 清理
					args[:domain_name] = "case.#{@case_ID}.com"
					r << Zone_er.del_zone(args)
					r << Recu_er.del_local_policies(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24342(args)
				# ping 正常 -> 异常(禁用)
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:strategy_name]          = "case_#{@case_ID}"
				args[:strategy_detect_method] = 'Ping'
				args[:strategy_handle_method] = '禁用'
				args[:view_name]              = 'default'
				args[:zone_name]              = "zone.#{@case_ID}"
				args[:owner_list]             = Node_Name_List
				args[:domain_list]            = [{'rname'=>"case.#{@case_ID}", 'rtype'=>'A', 'rdata'=>Master_IP, 'ttl'=>'3600', 'strategy_name'=>"#{args[:strategy_name]}"}]
				args[:domain_name]            = "case.#{@case_ID}.com"
				args[:local_type]             = "重定向"
				args[:ttl]                    = "3600"
				args[:ip]                     = Master_IP
				args[:rtype]                  = "A"
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					r << Recu_er.create_local_policies(args)
					# 验证策略为'正常'
					sleep 20
					DNS.goto_zone_page(args)
					domain_status = DNS.get_all_search_string("case.#{@case_ID}") # 查询域名的宕机状态
					DNS.open_local_policies_page
					local_policy_status = DNS.get_all_search_string("case.#{@case_ID}")
					r << 'fail' if domain_status.to_s.include?(args[:strategy_handle_method])
					r << 'fail' if local_policy_status.to_s.include?(args[:strategy_handle_method])
					# 修改域名和本地侧率的A记录不可达
					wrong_ip = '192.168.243.42'
					args[:domain_list] = [{'rname'=>"case.#{@case_ID}", 'rtype'=>'A', 'rdata_old'=>Master_IP, 'rdata_new'=>wrong_ip, 'ttl'=>'3600', 'strategy_name'=>"#{args[:strategy_name]}"}]
					r << Domain_er.edit_domain(args)
					args[:new_ip] = wrong_ip
					r << Recu_er.edit_local_policies(args)
					# 验证策略为'禁用'
					sleep 300
					DNS.goto_zone_page(args)
					domain_status = DNS.get_all_search_string("case.#{@case_ID}") # 查询域名的宕机状态
					DNS.open_local_policies_page
					local_policy_status = DNS.get_all_search_string("case.#{@case_ID}")
					r << 'fail' if !domain_status.to_s.include?(args[:strategy_handle_method])
					r << 'fail' if !local_policy_status.to_s.include?(args[:strategy_handle_method])
					# dig 权威->noerror(告警), 不dig本地策略(外网递归可能有数据)
					args[:domain_name] = "case.#{@case_ID}.#{args[:zone_name]}"
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_nxdomain(args)
					end
					# 清理
					args[:domain_name] = "case.#{@case_ID}.com"
					r << Zone_er.del_zone(args)
					r << Recu_er.del_local_policies(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_21309(args)
				# tcp正常->异常(告警)
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:strategy_name]          = "case_#{@case_ID}"
				args[:strategy_detect_method] = 'tcp'
				args[:strategy_handle_method] = '告警'
				args[:view_name]              = 'default'
				args[:zone_name]              = "zone.#{@case_ID}"
				args[:owner_list]             = Node_Name_List
				baidu_ip                      = `dig @8.8.8.8 baidu.com +short`.split("\n")[0]
				args[:domain_list]            = [{'rname'=>"case.#{@case_ID}", 'rtype'=>'A', 'rdata'=>baidu_ip, 'ttl'=>'3600', 'strategy_name'=>"#{args[:strategy_name]}"}]
				args[:domain_name]            = "case.#{@case_ID}.com"
				args[:local_type]             = "重定向"
				args[:ttl]                    = "3600"
				args[:ip]                     = baidu_ip
				args[:rtype]                  = "A"
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					r << Recu_er.create_local_policies(args)
					# 验证策略为'正常'
					sleep 20
					DNS.goto_zone_page(args)
					domain_status = DNS.get_all_search_string("case.#{@case_ID}") # 查询域名的宕机状态
					DNS.open_local_policies_page
					local_policy_status = DNS.get_all_search_string("case.#{@case_ID}")
					r << 'fail' if domain_status.to_s.include?(args[:strategy_handle_method])
					r << 'fail' if local_policy_status.to_s.include?(args[:strategy_handle_method])
					# 修改域名和本地侧率的A记录不可达
					wrong_ip = '192.168.213.9'
					args[:domain_list] = [{'rname'=>"case.#{@case_ID}", 'rtype'=>'A', 'rdata_old'=>baidu_ip, 'rdata_new'=>wrong_ip, 'ttl'=>'3600', 'strategy_name'=>"#{args[:strategy_name]}"}]
					r << Domain_er.edit_domain(args)
					args[:new_ip] = wrong_ip
					r << Recu_er.edit_local_policies(args)
					# 验证策略为'告警'
					sleep 300
					DNS.goto_zone_page(args)
					domain_status = DNS.get_all_search_string("case.#{@case_ID}") # 查询域名的宕机状态
					DNS.open_local_policies_page
					local_policy_status = DNS.get_all_search_string("case.#{@case_ID}")
					r << 'fail' if !domain_status.to_s.include?(args[:strategy_handle_method])
					r << 'fail' if !local_policy_status.to_s.include?(args[:strategy_handle_method])
					# dig 权威->noerror(告警), 不dig本地策略(外网递归可能有数据)
					args[:domain_name] = "case.#{@case_ID}.#{args[:zone_name]}"
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_noerror(args)
					end
					# 清理
					args[:domain_name] = "case.#{@case_ID}.com"
					r << Zone_er.del_zone(args)
					r << Recu_er.del_local_policies(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24343(args)
				# tcp正常->异常(禁用)
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:strategy_name]          = "case_#{@case_ID}"
				args[:strategy_detect_method] = 'tcp'
				args[:strategy_handle_method] = '禁用'
				args[:view_name]              = 'default'
				args[:zone_name]              = "zone.#{@case_ID}"
				args[:owner_list]             = Node_Name_List
				baidu_ip                      = `dig @8.8.8.8 baidu.com +short`.split("\n")[0]
				args[:domain_list]            = [{'rname'=>"case.#{@case_ID}", 'rtype'=>'A', 'rdata'=>baidu_ip, 'ttl'=>'3600', 'strategy_name'=>"#{args[:strategy_name]}"}]
				args[:domain_name]            = "case.#{@case_ID}.com"
				args[:local_type]             = "重定向"
				args[:ttl]                    = "3600"
				args[:ip]                     = baidu_ip
				args[:rtype]                  = "A"
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					r << Recu_er.create_local_policies(args)
					# 验证策略为'正常'
					sleep 20
					DNS.goto_zone_page(args)
					domain_status = DNS.get_all_search_string("case.#{@case_ID}") # 查询域名的宕机状态
					DNS.open_local_policies_page
					local_policy_status = DNS.get_all_search_string("case.#{@case_ID}")
					r << 'fail' if domain_status.to_s.include?(args[:strategy_handle_method])
					r << 'fail' if local_policy_status.to_s.include?(args[:strategy_handle_method])
					# 修改域名和本地侧率的A记录不可达
					wrong_ip = '192.168.243.43'
					args[:domain_list] = [{'rname'=>"case.#{@case_ID}", 'rtype'=>'A', 'rdata_old'=>baidu_ip, 'rdata_new'=>wrong_ip, 'ttl'=>'3600', 'strategy_name'=>"#{args[:strategy_name]}"}]
					r << Domain_er.edit_domain(args)
					args[:new_ip] = wrong_ip
					r << Recu_er.edit_local_policies(args)
					# 验证策略为'告警'
					sleep 30
					DNS.goto_zone_page(args)
					domain_status = DNS.get_all_search_string("case.#{@case_ID}") # 查询域名的宕机状态
					DNS.open_local_policies_page
					local_policy_status = DNS.get_all_search_string("case.#{@case_ID}")
					r << 'fail' if !domain_status.to_s.include?(args[:strategy_handle_method])
					r << 'fail' if !local_policy_status.to_s.include?(args[:strategy_handle_method])
					# dig 权威->noerror(告警), 不dig本地策略(外网递归可能有数据)
					args[:domain_name] = "case.#{@case_ID}.#{args[:zone_name]}"
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_nxdomain(args)
					end
					# 清理
					args[:domain_name] = "case.#{@case_ID}.com"
					r << Zone_er.del_zone(args)
					r << Recu_er.del_local_policies(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_21310(args)
				# http正常->异常(告警)
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:strategy_name]          = "case_#{@case_ID}"
				args[:strategy_detect_method] = 'http'
				args[:strategy_handle_method] = '告警'
				args[:view_name]              = 'default'
				args[:zone_name]              = "com"
				args[:owner_list]             = Node_Name_List
				baidu_ip                      = `dig @8.8.8.8 baidu.com +short`.split("\n")[0]
				args[:domain_list]            = [{'rname'=>'baidu', 'rtype'=>'A', 'rdata'=>baidu_ip, 'ttl'=>'3600', 'strategy_name'=>"#{args[:strategy_name]}"}]
				args[:domain_name]            = "baidu.com"
				args[:local_type]             = "重定向"
				args[:ttl]                    = "3600"
				args[:ip]                     = baidu_ip
				args[:rtype]                  = "A"
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					r << Recu_er.create_local_policies(args)
					# 验证策略为'正常'
					sleep 20
					DNS.goto_zone_page(args)
					domain_status = DNS.get_all_search_string(args[:domain_name]) # 查询域名的宕机状态
					DNS.open_local_policies_page
					local_policy_status = DNS.get_all_search_string(args[:domain_name])
					r << 'fail' if domain_status.to_s.include?(args[:strategy_handle_method])
					r << 'fail' if local_policy_status.to_s.include?(args[:strategy_handle_method])
					# 修改域名和本地策略使"告警"
					wrong_ip = '192.168.213.10'
					args[:domain_list] = [{'rname'=>"case.#{@case_ID}", 'rtype'=>'A', 'rdata_old'=>baidu_ip, 'rdata_new'=>wrong_ip, 'ttl'=>'3600', 'strategy_name'=>"#{args[:strategy_name]}"}]
					r << Domain_er.edit_domain(args)
					args[:new_ip] = wrong_ip
					r << Recu_er.edit_local_policies(args)
					# 验证策略为'告警'
					sleep 30
					DNS.goto_zone_page(args)
					domain_status = DNS.get_all_search_string(args[:domain_name]) # 查询域名的宕机状态
					DNS.open_local_policies_page
					local_policy_status = DNS.get_all_search_string(args[:domain_name])
					r << 'fail' if !domain_status.to_s.include?(args[:strategy_handle_method])
					r << 'fail' if !local_policy_status.to_s.include?(args[:strategy_handle_method])
					# dig 权威->noerror(告警), 不dig本地策略(外网递归可能有数据)
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_noerror(args)
					end
					# 清理
					r << Zone_er.del_zone(args)
					r << Recu_er.del_local_policies(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24344(args)
				# http正常->异常(禁用)
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:strategy_name]          = "case_#{@case_ID}"
				args[:strategy_detect_method] = 'http'
				args[:strategy_handle_method] = '禁用'
				args[:view_name]              = 'default'
				args[:zone_name]              = "com"
				args[:owner_list]             = Node_Name_List
				baidu_ip                      = `dig @8.8.8.8 baidu.com +short`.split("\n")[0]
				args[:domain_list]            = [{'rname'=>'baidu', 'rtype'=>'A', 'rdata'=>baidu_ip, 'ttl'=>'3600', 'strategy_name'=>"#{args[:strategy_name]}"}]
				args[:domain_name]            = "baidu.com"
				args[:local_type]             = "重定向"
				args[:ttl]                    = "3600"
				args[:ip]                     = baidu_ip
				args[:rtype]                  = "A"
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					r << Recu_er.create_local_policies(args)
					# 验证策略为'正常'
					sleep 20
					DNS.goto_zone_page(args)
					domain_status = DNS.get_all_search_string(args[:domain_name]) # 查询域名的宕机状态
					DNS.open_local_policies_page
					local_policy_status = DNS.get_all_search_string(args[:domain_name])
					r << 'fail' if domain_status.to_s.include?(args[:strategy_handle_method])
					r << 'fail' if local_policy_status.to_s.include?(args[:strategy_handle_method])
					# 修改域名和本地策略使"告警"
					wrong_ip = '192.168.243.44'
					args[:domain_list] = [{'rname'=>"case.#{@case_ID}", 'rtype'=>'A', 'rdata_old'=>baidu_ip, 'rdata_new'=>wrong_ip, 'ttl'=>'3600', 'strategy_name'=>"#{args[:strategy_name]}"}]
					r << Domain_er.edit_domain(args)
					args[:new_ip] = wrong_ip
					r << Recu_er.edit_local_policies(args)
					# 验证策略为'禁用'
					sleep 30
					DNS.goto_zone_page(args)
					domain_status = DNS.get_all_search_string(args[:domain_name]) # 查询域名的宕机状态
					DNS.open_local_policies_page
					local_policy_status = DNS.get_all_search_string(args[:domain_name])
					r << 'fail' if !domain_status.to_s.include?(args[:strategy_handle_method])
					r << 'fail' if !local_policy_status.to_s.include?(args[:strategy_handle_method])
					# dig 权威->noerror(告警), 不dig本地策略(外网递归可能有数据)
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_nxdomain(args)
					end
					# 清理
					r << Zone_er.del_zone(args)
					r << Recu_er.del_local_policies(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_22311(args)
				# https正常->异常(告警)
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:strategy_name]          = "case_#{@case_ID}"
				args[:strategy_detect_method] = 'https'
				args[:strategy_handle_method] = '告警'
				args[:view_name]              = 'default'
				args[:zone_name]              = "zone.#{@case_ID}"
				args[:owner_list]             = Node_Name_List
				args[:domain_list]            = [{'rname'=>"case.#{@case_ID}", 'rtype'=>'A', 'rdata'=>Master_IP, 'ttl'=>'3600', 'strategy_name'=>"#{args[:strategy_name]}"}]
				args[:domain_name]            = "case.#{@case_ID}.com"
				args[:local_type]             = "重定向"
				args[:ttl]                    = "3600"
				args[:ip]                     = Master_IP
				args[:rtype]                  = "A"
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					r << Recu_er.create_local_policies(args)
					# 验证宕机策略生效
					sleep 20
					DNS.goto_zone_page(args)
					domain_status = DNS.get_all_search_string("case.#{@case_ID}") # 查询域名的宕机状态
					DNS.open_local_policies_page
					local_policy_status = DNS.get_all_search_string("case.#{@case_ID}")
					r << 'fail' if domain_status.to_s.include?(args[:strategy_handle_method])
					r << 'fail' if local_policy_status.to_s.include?(args[:strategy_handle_method])
					# 修改域名和本地策略使"告警"
					wrong_ip = '192.168.223.11'
					args[:domain_list] = [{'rname'=>"case.#{@case_ID}", 'rtype'=>'A', 'rdata_old'=>Master_IP, 'rdata_new'=>wrong_ip, 'ttl'=>'3600', 'strategy_name'=>"#{args[:strategy_name]}"}]
					r << Domain_er.edit_domain(args)
					args[:new_ip] = wrong_ip
					r << Recu_er.edit_local_policies(args)
					# 验证策略为'告警'
					sleep 30
					DNS.goto_zone_page(args)
					domain_status = DNS.get_all_search_string("case.#{@case_ID}") # 查询域名的宕机状态
					DNS.open_local_policies_page
					local_policy_status = DNS.get_all_search_string("case.#{@case_ID}")
					r << 'fail' if !domain_status.to_s.include?(args[:strategy_handle_method])
					r << 'fail' if !local_policy_status.to_s.include?(args[:strategy_handle_method])
					# dig 权威->noerror(告警), 不dig本地策略(外网递归可能有数据)
					args[:domain_name] = "case.#{@case_ID}.#{args[:zone_name]}"
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_noerror(args)
					end
					# 清理
					r << Zone_er.del_zone(args)
					args[:domain_name] = "case.#{@case_ID}.com"
					r << Recu_er.del_local_policies(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24346(args)
				# https正常->异常(禁用)
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:strategy_name]          = "case_#{@case_ID}"
				args[:strategy_detect_method] = 'https'
				args[:strategy_handle_method] = '禁用'
				args[:view_name]              = 'default'
				args[:zone_name]              = "zone.#{@case_ID}"
				args[:owner_list]             = Node_Name_List
				args[:domain_list]            = [{'rname'=>"case.#{@case_ID}", 'rtype'=>'A', 'rdata'=>Master_IP, 'ttl'=>'3600', 'strategy_name'=>"#{args[:strategy_name]}"}]
				args[:domain_name]            = "case.#{@case_ID}.com"
				args[:local_type]             = "重定向"
				args[:ttl]                    = "3600"
				args[:ip]                     = Master_IP
				args[:rtype]                  = "A"
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					r << Recu_er.create_local_policies(args)
					# 验证宕机策略生效
					sleep 20
					DNS.goto_zone_page(args)
					domain_status = DNS.get_all_search_string("case.#{@case_ID}") # 查询域名的宕机状态
					DNS.open_local_policies_page
					local_policy_status = DNS.get_all_search_string("case.#{@case_ID}")
					r << 'fail' if domain_status.to_s.include?(args[:strategy_handle_method])
					r << 'fail' if local_policy_status.to_s.include?(args[:strategy_handle_method])
					# 修改域名和本地策略使"告警"
					wrong_ip = '192.168.243.46'
					args[:domain_list] = [{'rname'=>"case.#{@case_ID}", 'rtype'=>'A', 'rdata_old'=>Master_IP, 'rdata_new'=>wrong_ip, 'ttl'=>'3600', 'strategy_name'=>"#{args[:strategy_name]}"}]
					r << Domain_er.edit_domain(args)
					args[:new_ip] = wrong_ip
					r << Recu_er.edit_local_policies(args)
					# 验证策略为'告警'
					sleep 30
					DNS.goto_zone_page(args)
					domain_status = DNS.get_all_search_string("case.#{@case_ID}") # 查询域名的宕机状态
					DNS.open_local_policies_page
					local_policy_status = DNS.get_all_search_string("case.#{@case_ID}")
					r << 'fail' if !domain_status.to_s.include?(args[:strategy_handle_method])
					r << 'fail' if !local_policy_status.to_s.include?(args[:strategy_handle_method])
					# dig 权威->noerror(告警), 不dig本地策略(外网递归可能有数据)
					args[:domain_name] = "case.#{@case_ID}.#{args[:zone_name]}"
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_nxdomain(args)
					end
					# 清理
					r << Zone_er.del_zone(args)
					args[:domain_name] = "case.#{@case_ID}.com"
					r << Recu_er.del_local_policies(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24363(args)
				# 编辑检测方式tcp->http
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:strategy_name]          = "case_#{@case_ID}"
				args[:strategy_detect_method] = 'tcp'
				args[:strategy_handle_method] = '告警'
				args[:view_name]              = 'default'
				args[:owner_list]             = Node_Name_List
				args[:domain_name]            = "baidu.com"
				baidu_ip                      = `dig @8.8.8.8 baidu.com +short`.split("\n")[0]
				args[:local_type]             = "重定向"
				args[:ttl]                    = "3600"
				args[:ip]                     = baidu_ip
				args[:rtype]                  = "A"
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << Recu_er.create_local_policies(args)
					args[:strategy_port]          = '80'
					args[:strategy_detect_method] = 'http'
					r << ACL_Mng_er.edit_monitor_strategy(args)
					# 验证编辑后生效
					sleep 30
					DNS.open_local_policies_page
					local_policy_status = DNS.get_all_search_string(args[:domain_name])
					r << 'fail' if local_policy_status.to_s.include?(args[:strategy_handle_method])
					r << Recu_er.del_local_policies(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24352(args)
				# 编辑检测方式ping->http
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:strategy_name]          = "case_#{@case_ID}"
				args[:strategy_detect_method] = 'Ping'
				args[:strategy_handle_method] = '告警'
				args[:view_name]              = 'default'
				args[:owner_list]             = Node_Name_List
				args[:domain_name]            = "baidu.com"
				baidu_ip                      = `dig @8.8.8.8 baidu.com +short`.split("\n")[0]
				args[:local_type]             = "重定向"
				args[:ttl]                    = "3600"
				args[:ip]                     = baidu_ip
				args[:rtype]                  = "A"
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << Recu_er.create_local_policies(args)
					args[:strategy_port]          = '80'
					args[:strategy_detect_method] = 'http'
					r << ACL_Mng_er.edit_monitor_strategy(args)
					# 验证编辑后生效
					sleep 30
					DNS.open_local_policies_page
					local_policy_status = DNS.get_all_search_string(args[:domain_name])
					r << 'fail' if local_policy_status.to_s.include?(args[:strategy_handle_method])
					r << Recu_er.del_local_policies(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24362(args)
				# 编辑检测方式https->http
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:strategy_name]          = "case_#{@case_ID}"
				args[:strategy_detect_method] = 'https'
				args[:strategy_handle_method] = '告警'
				args[:view_name]              = 'default'
				args[:owner_list]             = Node_Name_List
				args[:domain_name]            = "baidu.com"
				baidu_ip                      = `dig @8.8.8.8 baidu.com +short`.split("\n")[0]
				args[:local_type]             = "重定向"
				args[:ttl]                    = "3600"
				args[:ip]                     = baidu_ip
				args[:rtype]                  = "A"
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << Recu_er.create_local_policies(args)
					args[:strategy_port]          = '80'
					args[:strategy_detect_method] = 'http'
					r << ACL_Mng_er.edit_monitor_strategy(args)
					# 验证编辑后生效
					sleep 30
					DNS.open_local_policies_page
					local_policy_status = DNS.get_all_search_string(args[:domain_name])
					r << 'fail' if local_policy_status.to_s.include?(args[:strategy_handle_method])
					r << Recu_er.del_local_policies(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24347(args)
				# 编辑检测方式http->ping
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:strategy_name]          = "case_#{@case_ID}"
				args[:strategy_detect_method] = 'http'
				args[:strategy_handle_method] = '告警'
				args[:view_name]              = 'default'
				args[:owner_list]             = Node_Name_List
				args[:domain_name]            = "baidu.com"
				baidu_ip                      = `dig @8.8.8.8 baidu.com +short`.split("\n")[0]
				args[:local_type]             = "重定向"
				args[:ttl]                    = "3600"
				args[:ip]                     = baidu_ip
				args[:rtype]                  = "A"
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << Recu_er.create_local_policies(args)
					args[:strategy_detect_method] = 'Ping'
					r << ACL_Mng_er.edit_monitor_strategy(args)
					# 验证编辑后生效
					sleep 30
					DNS.open_local_policies_page
					local_policy_status = DNS.get_all_search_string(args[:domain_name])
					r << 'fail' if local_policy_status.to_s.include?(args[:strategy_handle_method])
					r << Recu_er.del_local_policies(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24348(args)
				# 编辑检测方式tcp->ping
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:strategy_name]          = "case_#{@case_ID}"
				args[:strategy_detect_method] = 'tcp'
				args[:strategy_handle_method] = '告警'
				args[:view_name]              = 'default'
				args[:owner_list]             = Node_Name_List
				args[:domain_name]            = "baidu.com"
				baidu_ip                      = `dig @8.8.8.8 baidu.com +short`.split("\n")[0]
				args[:local_type]             = "重定向"
				args[:ttl]                    = "3600"
				args[:ip]                     = baidu_ip
				args[:rtype]                  = "A"
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << Recu_er.create_local_policies(args)
					args[:strategy_detect_method] = 'Ping'
					r << ACL_Mng_er.edit_monitor_strategy(args)
					# 验证编辑后生效
					sleep 30
					DNS.open_local_policies_page
					local_policy_status = DNS.get_all_search_string(args[:domain_name])
					r << 'fail' if local_policy_status.to_s.include?(args[:strategy_handle_method])
					r << Recu_er.del_local_policies(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24350(args)
				# 编辑检测方式https->ping
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:strategy_name]          = "case_#{@case_ID}"
				args[:strategy_detect_method] = 'https'
				args[:strategy_handle_method] = '告警'
				args[:view_name]              = 'default'
				args[:owner_list]             = Node_Name_List
				args[:domain_name]            = "baidu.com"
				baidu_ip                      = `dig @8.8.8.8 baidu.com +short`.split("\n")[0]
				args[:local_type]             = "重定向"
				args[:ttl]                    = "3600"
				args[:ip]                     = baidu_ip
				args[:rtype]                  = "A"
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << Recu_er.create_local_policies(args)
					args[:strategy_detect_method] = 'Ping'
					r << ACL_Mng_er.edit_monitor_strategy(args)
					# 验证编辑后生效
					sleep 30
					DNS.open_local_policies_page
					local_policy_status = DNS.get_all_search_string(args[:domain_name])
					r << 'fail' if local_policy_status.to_s.include?(args[:strategy_handle_method])
					r << Recu_er.del_local_policies(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24353(args)
				# 编辑检测方式ping->https
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:strategy_name]          = "case_#{@case_ID}"
				args[:strategy_detect_method] = 'Ping'
				args[:strategy_handle_method] = '告警'
				args[:view_name]              = 'default'
				args[:owner_list]             = Node_Name_List
				args[:domain_name]            = "#{@case_ID}.com"
				args[:local_type]             = "重定向"
				args[:ttl]                    = "3600"
				args[:ip]                     = Master_IP
				args[:rtype]                  = "A"
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << Recu_er.create_local_policies(args)
					args[:strategy_port]          = '443'
					args[:strategy_detect_method] = 'https'
					r << ACL_Mng_er.edit_monitor_strategy(args)
					# 验证编辑后生效
					sleep 30
					DNS.open_local_policies_page
					local_policy_status = DNS.get_all_search_string(args[:domain_name])
					r << 'fail' if local_policy_status.to_s.include?(args[:strategy_handle_method])
					r << Recu_er.del_local_policies(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24360(args)
				# 编辑检测方式ping->https
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:strategy_name]          = "case_#{@case_ID}"
				args[:strategy_detect_method] = 'tcp'
				args[:strategy_handle_method] = '告警'
				args[:view_name]              = 'default'
				args[:owner_list]             = Node_Name_List
				args[:domain_name]            = "#{@case_ID}.com"
				args[:local_type]             = "重定向"
				args[:ttl]                    = "3600"
				args[:ip]                     = Master_IP
				args[:rtype]                  = "A"
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << Recu_er.create_local_policies(args)
					args[:strategy_port]          = '443'
					args[:strategy_detect_method] = 'https'
					r << ACL_Mng_er.edit_monitor_strategy(args)
					# 验证编辑后生效
					sleep 30
					DNS.open_local_policies_page
					local_policy_status = DNS.get_all_search_string(args[:domain_name])
					r << 'fail' if local_policy_status.to_s.include?(args[:strategy_handle_method])
					r << Recu_er.del_local_policies(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24361(args)
				# 编辑检测方式ping->https
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:strategy_name]          = "case_#{@case_ID}"
				args[:strategy_detect_method] = 'http'
				args[:strategy_handle_method] = '告警'
				args[:view_name]              = 'default'
				args[:owner_list]             = Node_Name_List
				args[:domain_name]            = "#{@case_ID}.com"
				args[:local_type]             = "重定向"
				args[:ttl]                    = "3600"
				args[:ip]                     = Master_IP
				args[:rtype]                  = "A"
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << Recu_er.create_local_policies(args)
					args[:strategy_port]          = '443'
					args[:strategy_detect_method] = 'https'
					r << ACL_Mng_er.edit_monitor_strategy(args)
					# 验证编辑后生效
					sleep 30
					DNS.open_local_policies_page
					local_policy_status = DNS.get_all_search_string(args[:domain_name])
					r << 'fail' if local_policy_status.to_s.include?(args[:strategy_handle_method])
					r << Recu_er.del_local_policies(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24357(args)
				# 编辑检测方式ping->tcp
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:strategy_name]          = "case_#{@case_ID}"
				args[:strategy_detect_method] = 'Ping'
				args[:strategy_handle_method] = '告警'
				args[:view_name]              = 'default'
				args[:owner_list]             = Node_Name_List
				args[:domain_name]            = "baidu.com"
				args[:local_type]             = "重定向"
				args[:ttl]                    = "3600"
				baidu_ip                      = `dig @8.8.8.8 baidu.com +short`.split("\n")[0]
				args[:ip]                     = baidu_ip
				args[:rtype]                  = "A"
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << Recu_er.create_local_policies(args)
					args[:strategy_port]          = '80'
					args[:strategy_detect_method] = 'tcp'
					r << ACL_Mng_er.edit_monitor_strategy(args)
					# 验证编辑后生效
					sleep 30
					DNS.open_local_policies_page
					local_policy_status = DNS.get_all_search_string(args[:domain_name])
					r << 'fail' if local_policy_status.to_s.include?(args[:strategy_handle_method])
					r << Recu_er.del_local_policies(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24358(args)
				# 编辑检测方式http->tcp
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:strategy_name]          = "case_#{@case_ID}"
				args[:strategy_detect_method] = 'http'
				args[:strategy_handle_method] = '告警'
				args[:view_name]              = 'default'
				args[:owner_list]             = Node_Name_List
				args[:domain_name]            = "baidu.com"
				args[:local_type]             = "重定向"
				args[:ttl]                    = "3600"
				baidu_ip                      = `dig @8.8.8.8 baidu.com +short`.split("\n")[0]
				args[:ip]                     = baidu_ip
				args[:rtype]                  = "A"
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << Recu_er.create_local_policies(args)
					args[:strategy_port]          = '80'
					args[:strategy_detect_method] = 'tcp'
					r << ACL_Mng_er.edit_monitor_strategy(args)
					# 验证编辑后生效
					sleep 30
					DNS.open_local_policies_page
					local_policy_status = DNS.get_all_search_string(args[:domain_name])
					r << 'fail' if local_policy_status.to_s.include?(args[:strategy_handle_method])
					r << Recu_er.del_local_policies(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24359(args)
				# 编辑检测方式https->tcp
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:strategy_name]          = "case_#{@case_ID}"
				args[:strategy_detect_method] = 'https'
				args[:strategy_handle_method] = '告警'
				args[:view_name]              = 'default'
				args[:owner_list]             = Node_Name_List
				args[:domain_name]            = "baidu.com"
				args[:local_type]             = "重定向"
				args[:ttl]                    = "3600"
				baidu_ip                      = `dig @8.8.8.8 baidu.com +short`.split("\n")[0]
				args[:ip]                     = baidu_ip
				args[:rtype]                  = "A"
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << Recu_er.create_local_policies(args)
					args[:strategy_port]          = '80'
					args[:strategy_detect_method] = 'tcp'
					r << ACL_Mng_er.edit_monitor_strategy(args)
					# 验证编辑后生效
					sleep 30
					DNS.open_local_policies_page
					local_policy_status = DNS.get_all_search_string(args[:domain_name])
					r << 'fail' if local_policy_status.to_s.include?(args[:strategy_handle_method])
					r << Recu_er.del_local_policies(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
		end
	end
end