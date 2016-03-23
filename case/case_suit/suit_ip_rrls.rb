# encoding: utf-8
require File.dirname(__FILE__) + '/../../zddi'
module ZDDI
	module DNS
		# IP解析限速
		class IP_rrls
			def case_10912(args)
				# 新建999条解析限速之"超过"
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:owner_list] = [Master_Device]
				args[:limit_qps]  = "10"
				args[:error_info] = "限速策略超过系统最大值(999)"
				args[:error_type] = "after_OK"
				begin
					for i in 1..9
						for j in 1..111
							args[:limit_ip] = "192.168.#{i}.#{j}"
							r << ACL_Mng_er.create_ip_rrls(args)
						end
					end
					args[:limit_ip] = "192.168.109.12"
					r << DNS.inputs_ip_rrls_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					# 清理999条记录/每页30条.
					for i in 1..34
						DNS.open_ip_rrls_page
						r << DNS.check_all_and_delete
					end
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_10903(args)
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:owner_list] = [Master_Device]
				args[:limit_qps]  = "10x"
				args[:limit_ip]   = "192.168.109.3"
				args[:error_info] = "QPS值的范围为:0-2147483647"
				args[:error_type] = "before_OK"
				begin
					DNS.open_ip_rrls_page
					DNS.inputs_ip_rrls_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_10904(args)
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:owner_list] = [Master_Device]
				args[:limit_qps]  = "10"
				args[:limit_ip]   = "192.168.10.904"
				args[:error_info] = "IP或网络地址格式不正确"
				args[:error_type] = "before_OK"
				begin
					DNS.open_ip_rrls_page
					DNS.inputs_ip_rrls_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_10905(args)
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:owner_list] = [Master_Device]
				args[:limit_qps]  = "10"
				limit_ip_list     = ["192.168.109.5", "192.168.109.0/24"]
				args[:error_info] = "解析限速策略已存在"
				args[:error_type] = "after_OK"
				begin
					limit_ip_list.each do |limit_ip|
						args[:limit_ip] = limit_ip
						r << ACL_Mng_er.create_ip_rrls(args)
						DNS.open_ip_rrls_page
						DNS.inputs_ip_rrls_dialog(args)
						r << DNS.error_validator_on_popwin(args)
						r << ACL_Mng_er.del_ip_rrls(args)
					end
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_10906(args)
				# 单个IP限速成功
				@case_ID                   = __method__.to_s.split('_')[1]
				r                          = []
				args[:owner_list]          = [Master_Device]
				args[:limit_qps]           = '20'
				args[:limit_ip]            = Slave_IP
				args[:dnsperf_from_ip]     = Slave_IP
				args[:dnsperf_to_ip]       = Master_IP
				args[:dnsperf_domain_list] = ['baidu.com']
				begin
					r << ACL_Mng_er.create_ip_rrls(args)
					args[:dnsperf_max_q] = '50'
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f).abs >= 3
					args[:dnsperf_max_q] = '10'
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:dnsperf_max_q].to_f).abs >= 3
					r << ACL_Mng_er.del_ip_rrls(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_10907(args)
				# IP限速不区分权威和递归域名
				@case_ID               = __method__.to_s.split('_')[1]
				r                      = []
				args[:view_name]       = 'default'
				args[:zone_name]       = 'zone.10907'
				args[:domain_list]     = [{'rname'=>'a','rtype'=>'A','rdata'=>'192.168.109.7','ttl'=>'600'}]
				args[:owner_list]      = [Master_Device]
				args[:limit_qps]       = '20'
				args[:limit_ip]        = Slave_IP
				args[:dnsperf_from_ip] = Slave_IP
				args[:dnsperf_to_ip]   = Master_IP
				args[:dnsperf_max_q]   = '50'
				begin
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					r << ACL_Mng_er.create_ip_rrls(args)
					args[:dnsperf_domain_list] = ['a.zone.10907']
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f).abs >= 3
					args[:dnsperf_domain_list] = ['baidu.com']
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f).abs >= 3
					args[:dnsperf_domain_list] = ['a.zone.10907','baidu.com']
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f).abs >= 3
					# 清理
					r << Zone_er.del_zone(args)
					r << ACL_Mng_er.del_ip_rrls(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_23706(args)
				# 超速告警
				@case_ID                   = __method__.to_s.split('_')[1]
				r                          = []
				args[:owner_list]          = [Master_Device]
				args[:limit_qps]           = '13'
				args[:limit_ip]            = Slave_IP
				args[:dnsperf_from_ip]     = Slave_IP
				args[:dnsperf_to_ip]       = Master_IP
				args[:dnsperf_domain_list] = ['baidu.com']
				begin
					r << ACL_Mng_er.create_ip_rrls(args)
					args[:dnsperf_duration] = '100'
					args[:dnsperf_max_q]    = '60'
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f).abs >= 3
					cloudnode = "#{Master_Group}.#{Master_Device}(#{Master_IP})"
					args[:warning_string] = "云节点#{cloudnode}:  查询超速: 来自#{Slave_IP}的请求, 超过了#{Slave_IP}/32限速策略(QPS:#{args[:limit_qps]}) "
					sleep 60
					r << System.warning_validator_on_warning_records_page(args)
					r << ACL_Mng_er.del_ip_rrls(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_12593(args)
				# 编辑解析限速为较大值
				@case_ID                   = __method__.to_s.split('_')[1]
				r                          = []
				args[:owner_list]          = [Master_Device]
				args[:limit_qps]           = '10'
				args[:limit_ip]            = Slave_IP
				args[:dnsperf_from_ip]     = Slave_IP
				args[:dnsperf_to_ip]       = Master_IP
				args[:dnsperf_domain_list] = ['baidu.com']
				args[:dnsperf_max_q]       = '50'
				begin
					r << ACL_Mng_er.create_ip_rrls(args)
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f).abs >= 3
					args[:limit_qps] = '20'
					r << ACL_Mng_er.edit_ip_rrls(args)
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f).abs >= 3
					r << ACL_Mng_er.del_ip_rrls(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_12594(args)
				# 编辑解析限速为较小值
				@case_ID                   = __method__.to_s.split('_')[1]
				r                          = []
				args[:owner_list]          = [Master_Device]
				args[:limit_qps]           = '20'
				args[:limit_ip]            = Slave_IP
				args[:dnsperf_from_ip]     = Slave_IP
				args[:dnsperf_to_ip]       = Master_IP
				args[:dnsperf_domain_list] = ['baidu.com']
				args[:dnsperf_max_q]       = '50'
				begin
					r << ACL_Mng_er.create_ip_rrls(args)
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f).abs >= 3
					args[:limit_qps] = '10'
					r << ACL_Mng_er.edit_ip_rrls(args)
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f).abs >= 3
					r << ACL_Mng_er.del_ip_rrls(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_12595(args)
				# 编辑解析限速为0
				@case_ID                   = __method__.to_s.split('_')[1]
				r                          = []
				args[:owner_list]          = [Master_Device]
				args[:limit_qps]           = '20'
				args[:limit_ip]            = Slave_IP
				args[:dnsperf_from_ip]     = Slave_IP
				args[:dnsperf_to_ip]       = Master_IP
				args[:dnsperf_domain_list] = ['baidu.com']
				args[:dnsperf_max_q]       = '50'
				begin
					r << ACL_Mng_er.create_ip_rrls(args)
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f).abs >= 3
					args[:limit_qps] = '0'
					r << ACL_Mng_er.edit_ip_rrls(args)
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if qps.to_f != 0
					r << ACL_Mng_er.del_ip_rrls(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_12592(args)
				# 修改所属节点master->all->slave
				@case_ID                   = __method__.to_s.split('_')[1]
				r                          = []
				args[:view_name]           = 'default'
				test_com                   = 'test.com'
				max_q                      = '100'
				args[:dnsperf_max_q]       = max_q
				args[:dnsperf_domain_list] = [test_com]
				begin
					# Master上限速, Master QPS == limit_qps
					args[:limit_qps]  = '20'
					args[:limit_ip]   = '202.173.0.0/16'
					args[:owner_list] = [Master_Device]
					r << ACL_Mng_er.create_ip_rrls(args)
					args[:dnsperf_from_ip] = Slave_IP
					args[:dnsperf_to_ip]   = Master_IP
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f).abs >= 3
					args[:dnsperf_from_ip] = Master_IP
					args[:dnsperf_to_ip]   = Slave_IP
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - max_q.to_f).abs >= 3
					# 修改为ALL, Master QPS == Slave QPS == limit_qps
					args[:old_owner_list] = [Master_Device]
					args[:new_owner_list] = Node_Name_List
					r << ACL_Mng_er.modify_ip_rrls_owner(args)
					args[:dnsperf_from_ip] = Slave_IP
					args[:dnsperf_to_ip]   = Master_IP
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f).abs >= 3
					args[:dnsperf_from_ip] = Master_IP
					args[:dnsperf_to_ip]   = Slave_IP
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f).abs >= 3
					# 修改为Slave, Slave QPS == limit_qps
					args[:old_owner_list] = Node_Name_List
					args[:new_owner_list] = [Slave_Device]
					r << ACL_Mng_er.modify_ip_rrls_owner(args)
					args[:dnsperf_from_ip] = Slave_IP
					args[:dnsperf_to_ip]   = Master_IP
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - max_q.to_f).abs >= 3
					args[:dnsperf_from_ip] = Master_IP
					args[:dnsperf_to_ip]   = Slave_IP
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f).abs >= 3
					# 清理
					r << ACL_Mng_er.del_all_ip_rrls
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
		end
	end
end