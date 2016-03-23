# encoding: utf-8
require File.dirname(__FILE__) + '/../../zddi'
module ZDDI
	module DNS
		# 域名解析限速
		class Domain_rrls
			def case_24693(args)
				# 参数校验 输入范围/重复新建
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:view_name]  = 'default'
				args[:owner_list] = Node_Name_List
				begin
					DNS.open_domain_rrls_page
					args[:error_type]   = 'before_OK'
					args[:limit_domain] = 'wrong.do@main' 
					args[:limit_qps]    = '10'
					args[:error_info]   = '域名格式不正确'
	                DNS.inputs_domain_rrls_dialog(args)
	                r << DNS.error_validator_on_popwin(args)
					args[:limit_domain] = 'baidu.com' 
					args[:limit_qps]    = '1o'
					args[:error_info]   = 'QPS值的范围为:0-2147483647'
					DNS.inputs_domain_rrls_dialog(args)
	                r << DNS.error_validator_on_popwin(args)
	                args[:limit_domain] = '24693.com' 
					args[:limit_qps]    = ''
					args[:error_info]   = '必选字段'
					DNS.inputs_domain_rrls_dialog(args)
	                r << DNS.error_validator_on_popwin(args)
	                args[:limit_domain] = '24693.com' 
					args[:limit_qps]    = '10'
					r << ACL_Mng_er.create_domain_rrls(args)
					args[:error_info]   = '解析限速策略已存在'
					args[:error_type]   = 'after_OK'
					DNS.open_domain_rrls_page
	                DNS.inputs_domain_rrls_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					r << ACL_Mng_er.del_domain_rrls(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24694(args)
				# 编辑解析限速为0
				@case_ID                   = __method__.to_s.split('_')[1]
				r                          = []
				args[:view_name]           = 'default'
				args[:owner_list]          = [Master_Device]
				args[:limit_qps]           = '20'
				args[:limit_domain]        = 'sohu.com' 
				args[:dnsperf_from_ip]     = Slave_IP
				args[:dnsperf_to_ip]       = Master_IP
				args[:dnsperf_domain_list] = ['sohu.com']
				args[:dnsperf_max_q]       = '50'
				begin
					r << ACL_Mng_er.create_domain_rrls(args)
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f).abs >= 3
					args[:limit_qps] = '0'
					r << ACL_Mng_er.edit_domain_rrls(args)
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if qps.to_f != 0
					r << ACL_Mng_er.del_domain_rrls(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24695(args)
				# 编辑解析限速为较小值
				@case_ID                   = __method__.to_s.split('_')[1]
				r                          = []
				args[:view_name]           = 'default'
				args[:owner_list]          = [Master_Device]
				args[:limit_qps]           = '20'
				args[:limit_domain]        = 'baidu.com' 
				args[:dnsperf_from_ip]     = Slave_IP
				args[:dnsperf_to_ip]       = Master_IP
				args[:dnsperf_domain_list] = ['baidu.com']
				args[:dnsperf_max_q]       = '50'
				begin
					r << ACL_Mng_er.create_domain_rrls(args)
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f).abs >= 3
					args[:limit_qps] = '10'
					r << ACL_Mng_er.edit_domain_rrls(args)
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f).abs >= 3
					r << ACL_Mng_er.del_domain_rrls(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24701(args)
				# 编辑解析限速为较大值
				@case_ID                   = __method__.to_s.split('_')[1]
				r                          = []
				args[:view_name]           = 'default'
				args[:owner_list]          = [Master_Device]
				args[:limit_qps]           = '10'
				args[:limit_domain]        = 'baidu.com' 
				args[:dnsperf_from_ip]     = Slave_IP
				args[:dnsperf_to_ip]       = Master_IP
				args[:dnsperf_domain_list] = ['baidu.com']
				args[:dnsperf_max_q]       = '50'
				begin
					r << ACL_Mng_er.create_domain_rrls(args)
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f).abs >= 3
					args[:limit_qps] = '20'
					r << ACL_Mng_er.edit_domain_rrls(args)
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f).abs >= 3
					r << ACL_Mng_er.del_domain_rrls(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24700(args)
				# 超速告警
				@case_ID                   = __method__.to_s.split('_')[1]
				r                          = []
				args[:view_name]           = 'default'
				args[:owner_list]          = [Master_Device]
				args[:limit_qps]           = '14'
				args[:limit_domain]        = 'baidu.com' 
				args[:dnsperf_from_ip]     = Slave_IP
				args[:dnsperf_to_ip]       = Master_IP
				args[:dnsperf_domain_list] = ['baidu.com']
				begin
					r << ACL_Mng_er.create_domain_rrls(args)
					args[:dnsperf_duration] = '100'
					args[:dnsperf_max_q]    = '20'
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f).abs >= 3
					cloudnode = "#{Master_Group}.#{Master_Device}(#{Master_IP})"
					args[:warning_string] = "云节点#{cloudnode}:  查询超速: 来自#{Slave_IP}的请求, 超过了#{args[:limit_domain]}限速策略(QPS:#{args[:limit_qps]}) "
					r << System.warning_validator_on_warning_records_page(args)
					r << ACL_Mng_er.del_domain_rrls(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24697(args)
				# 单个域名限速成功
				@case_ID                   = __method__.to_s.split('_')[1]
				r                          = []
				args[:view_name]           = 'default'
				args[:owner_list]          = [Master_Device]
				args[:limit_qps]           = '18'
				args[:limit_domain]        = 'sohu.com' 
				args[:dnsperf_from_ip]     = Slave_IP
				args[:dnsperf_to_ip]       = Master_IP
				args[:dnsperf_domain_list] = ['sohu.com']
				begin
					r << ACL_Mng_er.create_domain_rrls(args)
					args[:dnsperf_max_q] = '10'
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:dnsperf_max_q].to_f).abs >= 3
					args[:dnsperf_max_q] = '20'
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f).abs >= 3
					r << ACL_Mng_er.del_domain_rrls(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_23786(args)
				# IP限速和域名限速同时配置
				@case_ID                   = __method__.to_s.split('_')[1]
				r                          = []
				args[:view_name]           = 'default'
				args[:owner_list]          = [Master_Device]
				args[:limit_ip]            = Slave_IP
				args[:limit_domain]        = '163.com' 
				args[:dnsperf_from_ip]     = Slave_IP
				args[:dnsperf_to_ip]       = Master_IP
				args[:dnsperf_domain_list] = ['163.com']
				begin
					args[:limit_qps] = '50'
					r << ACL_Mng_er.create_ip_rrls(args)
					args[:limit_qps] = '20'
					r << ACL_Mng_er.create_domain_rrls(args)
					args[:dnsperf_max_q] = '100'
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f).abs >= 3
					r << ACL_Mng_er.del_domain_rrls(args)
					args[:limit_qps] = '50'
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f).abs >= 3
					args[:limit_qps] = '100'
					r << ACL_Mng_er.create_domain_rrls(args)
					args[:dnsperf_max_q] = '200'
					qps = DNS.get_qps_after_rrls(args)
					args[:limit_qps] = '50'
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f).abs >= 3
					# 清理
					r << ACL_Mng_er.del_domain_rrls(args)
					r << ACL_Mng_er.del_ip_rrls(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24698(args)
				# 域名限速权威和递归域名
				@case_ID               = __method__.to_s.split('_')[1]
				r                      = []
				args[:view_name]       = 'default'
				args[:zone_name]       = 'zone.24698'
				args[:domain_list]     = [{'rname'=>'a','rtype'=>'A','rdata'=>'192.168.246.98','ttl'=>'600'}]
				args[:owner_list]      = [Master_Device]
				args[:limit_qps]       = '20'
				args[:dnsperf_from_ip] = Slave_IP
				args[:dnsperf_to_ip]   = Master_IP
				args[:dnsperf_max_q]   = '50'
				begin
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					args[:limit_domain] = 'a.zone.24698'
					r << ACL_Mng_er.create_domain_rrls(args)
					args[:limit_domain] = 'baidu.com'
					r << ACL_Mng_er.create_domain_rrls(args)
					args[:dnsperf_domain_list] = ['a.zone.24698']
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f).abs >= 3
					args[:dnsperf_domain_list] = ['baidu.com']
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f).abs >= 3
					args[:dnsperf_max_q] = '100'
					args[:dnsperf_domain_list] = ['baidu.com', 'a.zone.24698']
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f * 2).abs >= 3
					# 清理
					r << Zone_er.del_zone(args)
					r << ACL_Mng_er.del_domain_rrls(args)
					args[:limit_domain] = 'a.zone.24698'
					r << ACL_Mng_er.del_domain_rrls(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24702(args)
				# 新建非defalut视图的域名限速
				@case_ID               = __method__.to_s.split('_')[1]
				r                      = []
				args[:acl_list]        = Local_Network
				args[:acl_name]        = "acl_#{@case_ID}"
				args[:view_name]       = "view_#{@case_ID}"
				args[:zone_name]       = "zone.#{@case_ID}"
				args[:owner_list]      = [Master_Device]
				args[:limit_qps]       = '20'
				args[:dnsperf_from_ip] = Slave_IP
				args[:dnsperf_to_ip]   = Master_IP
				args[:dnsperf_max_q]   = '50'
				begin
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					args[:limit_domain] = "a.zone.#{@case_ID}"
					r << ACL_Mng_er.create_domain_rrls(args)
					args[:dnsperf_domain_list] = ["a.zone.#{@case_ID}"]
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f).abs >= 3
					# 清理
					r << ACL_Mng_er.del_domain_rrls(args)
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24703(args)
				# 新建非defalut视图的域名限速
				@case_ID               = __method__.to_s.split('_')[1]
				r                      = []
				args[:acl_list]        = Local_Network
				args[:acl_name]        = "acl_#{@case_ID}"
				args[:view_name]       = "view_#{@case_ID}"
				args[:zone_name]       = "zone.#{@case_ID}"
				args[:owner_list]      = [Master_Device]
				args[:limit_qps]       = '20'
				args[:dnsperf_from_ip] = Slave_IP
				args[:dnsperf_to_ip]   = Master_IP
				args[:dnsperf_max_q]   = '50'
				begin
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					args[:limit_domain] = "*.zone.#{@case_ID}"
					r << ACL_Mng_er.create_domain_rrls(args)
					args[:dnsperf_domain_list] = ["rrls.zone.#{@case_ID}"]
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f).abs >= 3
					# 清理
					r << ACL_Mng_er.del_domain_rrls(args)
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24705(args)
				# 中文域名/区限速
				@case_ID               = __method__.to_s.split('_')[1]
				r                      = []
				args[:acl_list]        = Local_Network
				args[:acl_name]        = "acl_#{@case_ID}"
				args[:view_name]       = "view_#{@case_ID}"
				args[:zone_name]       = '中国'
				args[:owner_list]      = [Master_Device]
				args[:dnsperf_from_ip] = Slave_IP
				args[:dnsperf_to_ip]   = Master_IP
				args[:dnsperf_max_q]   = '200'
				tsinghua = SimpleIDN.to_ascii('清华大学.中国').gsub("\n","")
				peking = SimpleIDN.to_ascii('北京大学.中国').gsub("\n","")
				begin
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					args[:limit_qps]    = '100'
					args[:limit_domain] = "*.#{args[:zone_name]}"
					r << ACL_Mng_er.create_domain_rrls(args)
					args[:dnsperf_domain_list] = [tsinghua]
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f).abs >= 3
					args[:limit_qps]    = '20'
					args[:limit_domain] = "清华大学.中国"
					r << ACL_Mng_er.create_domain_rrls(args)
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f).abs >= 3
					args[:dnsperf_domain_list] = [peking]
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - 100).abs >= 3
					# 清理
					r << ACL_Mng_er.del_all_domain_rrls
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24044(args)
				# 区限速和子域名限速
				@case_ID               = __method__.to_s.split('_')[1]
				r                      = []
				args[:view_name]       = 'default'
				args[:owner_list]      = [Master_Device]
				args[:dnsperf_from_ip] = Slave_IP
				args[:dnsperf_to_ip]   = Master_IP
				args[:dnsperf_max_q]   = '200'
				begin
					args[:limit_qps]    = '10'
					args[:limit_domain] = "baidu.com"
					r << ACL_Mng_er.create_domain_rrls(args)
					args[:limit_qps]    = '15'
					args[:limit_domain] = "*.baidu.com"
					r << ACL_Mng_er.create_domain_rrls(args)
					args[:dnsperf_domain_list] = ["baidu.com"]
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - 10).abs >= 3
					args[:dnsperf_domain_list] = ["mp3.baidu.com"]
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - 15).abs >= 3
					args[:limit_qps]    = '20'
					args[:limit_domain] = "mp3.baidu.com"
					r << ACL_Mng_er.create_domain_rrls(args)
					args[:dnsperf_domain_list] = ["mp3.baidu.com"]
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - 20).abs >= 3
					# 清理
					r << ACL_Mng_er.del_all_domain_rrls
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_23778(args)
				# 用*.<域名>对区限速
				@case_ID               = __method__.to_s.split('_')[1]
				r                      = []
				args[:view_name]       = 'default'
				args[:owner_list]      = [Master_Device]
				args[:dnsperf_from_ip] = Slave_IP
				args[:dnsperf_to_ip]   = Master_IP
				args[:dnsperf_max_q]   = '100'
				begin
					args[:limit_qps]    = '20'
					args[:limit_domain] = "*.baidu.com"
					r << ACL_Mng_er.create_domain_rrls(args)
					args[:dnsperf_domain_list] = ['mp3.baidu.com', 'tieba.baidu.com']
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f).abs >= 3
					args[:dnsperf_domain_list] = ['tieba.baidu.com']
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f).abs >= 3
					# 清理
					r << ACL_Mng_er.del_all_domain_rrls
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24716(args)
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
					args[:limit_qps]    = '20'
					args[:limit_domain] = test_com
					args[:owner_list]   = [Master_Device]
					r << ACL_Mng_er.create_domain_rrls(args)
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
					r << ACL_Mng_er.modify_domain_rrls_owner(args)
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
					r << ACL_Mng_er.modify_domain_rrls_owner(args)
					args[:dnsperf_from_ip] = Slave_IP
					args[:dnsperf_to_ip]   = Master_IP
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - max_q.to_f).abs >= 3
					args[:dnsperf_from_ip] = Master_IP
					args[:dnsperf_to_ip]   = Slave_IP
					qps = DNS.get_qps_after_rrls(args)
					r << 'fail' if (qps.to_f - args[:limit_qps].to_f).abs >= 3
					# 清理
					r << ACL_Mng_er.del_all_domain_rrls
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
		end
	end
end