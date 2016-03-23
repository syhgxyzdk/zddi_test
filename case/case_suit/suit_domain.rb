# encoding: utf-8
require File.dirname(__FILE__) + '/../../zddi'

module ZDDI
	module DNS
		class Domain
			def case_1022(args)
				# 创建10个记录类型, dig...
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:view_name]   = 'default'
				args[:zone_name]   = "zone.#{@case_ID}"
				args[:owner_list]  = Node_Name_List
				args[:domain_list] = [
					{'rname'=>'a', 'rtype'=>'A', 'rdata'=>'203.119.10.22', 'ttl'=>'3600'},
					{'rname'=>'ns', 'rtype'=>'NS', 'rdata'=>'2nd.ns.com.', 'ttl'=>'3600'},
					{'rname'=>'aaaa', 'rtype'=>'AAAA', 'rdata'=>'fe80::4c0b', 'ttl'=>'3600'},
					{'rname'=>'mx', 'rtype'=>'MX', 'rdata'=>'2 mx.com.', 'ttl'=>'3600'}, 
					{'rname'=>'cname', 'rtype'=>'CNAME', 'rdata'=>'dns.zdns.cn.', 'ttl'=>'3600'},
					{'rname'=>'dname', 'rtype'=>'DNAME', 'rdata'=>'ip6.tla-1.net.', 'ttl'=>'3600'},
					{'rname'=>'txt', 'rtype'=>'TXT', 'rdata'=>'text_record', 'ttl'=>'3600'},
					{'rname'=>'srv', 'rtype'=>'SRV', 'rdata'=>'1 0 9 sysadmins-box.zdns.cn.', 'ttl'=>'3600'},
					{'rname'=>'ptr', 'rtype'=>'PTR', 'rdata'=>'dns.zdns.cn.', 'ttl'=>'3600'},
					{'rname'=>'naptr', 'rtype'=>'NAPTR', 'rdata'=>'101 10 "u" "sip+E2U" "!^.*$!sip:userA@zdns.cn!" .', 'ttl'=>'3600'}
				]
				begin
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					args[:dig_ip] = Master_IP
					args[:domain_list].each do |domain|
						args[:domain_name] = domain['rname'] + '.' + args[:zone_name]
						args[:rtype]       = domain['rtype']
						r << DNS.dig_as_noerror(args) if args[:rtype] != 'NS'
					end
					r << Zone_er.del_zone(args)				
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1100(args)
				# 创建10个记录类型 参数校验
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:view_name]   = 'default'
				args[:zone_name]   = "zone.#{@case_ID}"
				args[:owner_list]  = Node_Name_List
				args[:error_type]  = 'before_OK'
				rtype_error_info   = {
					'A'     =>'输入合法的IPv4地址，例如：192.168.1.1',
					'AAAA'  =>'输入合法的IPv6地址，例如：2401:8d00:3:2:5054:ff:fe5f:7763',
					'CNAME' =>'输入一个全称域名，例如：dns.zdns.cn.',
					'DNAME' =>'输入一个全称域名，例如：ip6.tla-1.net.',
					'SRV'   =>'依次输入：优先级（0-65535） 权重（0-65535） 端口（1-65535） 全称域名，例如：1 0 9 sysadmins-box.zdns.cn.',
					'MX'    =>'依次输入 优先级（0-65535） 邮件服务器的全称域名，例如：10 mx30.zdns.cn.',
					'PTR'   =>'输入一个全称域名，例如：dns.zdns.cn.',
					'NAPTR' =>'依次输入 顺序号（0-65535） 优先级（0-65535） 标志（A-Z，0-9） 正则表达式 服务参数 用于替换的全称域名，例如：101 10 "u" "sip+E2U" "!^.*$!sip:userA@zdns.cn!" .'
				}
				begin
					r << Zone_er.create_zone(args)
					r << DNS.goto_zone_page(args)
					rtype_error_info.each_pair do |rtype, error_info|
						domain = {}
						domain['rname']   = rtype.downcase
						domain['rdata']   = '@#%#'
						domain['rtype']   = rtype
						domain['ttl']     = '3600'
						args[:error_info] = error_info
						DNS.inputs_domain_dialog(domain)
						r << DNS.error_validator_on_popwin(args)
					end
					r << Zone_er.del_zone(args)				
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1116(args)
				# NAPTR字段内容不合法提示
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:view_name]  = 'default'
				args[:zone_name]  = "zone.#{@case_ID}"
				args[:owner_list] = Node_Name_List
				args[:error_type] = 'before_OK'
				srv_err_info      = '依次输入：优先级（0-65535） 权重（0-65535） 端口（1-65535） 全称域名，例如：1 0 9 sysadmins-box.zdns.cn.'
				naptr_err_info    = '依次输入 顺序号（0-65535） 优先级（0-65535） 标志（A-Z，0-9） 正则表达式 服务参数 用于替换的全称域名，例如：101 10 "u" "sip+E2U" "!^.*$!sip:userA@zdns.cn!" .'
				srv_rdata_list    = [
					'99999 0 9 sysadmins-box.zdns.cn.',
					'1 99999 9 sysadmins-box.zdns.cn.',
					'1 0 99999 sysadmins-box.zdns.cn.',
					'1 0 9 Thi!s Is Not a DoM@!n'
				]
				naptr_rdata_list  = [
					'65536 10 "u" "sip+E2U" "!^.*$!sip:userA@zdns.cn!" .',
					'101 65536 "u" "sip+E2U" "!^.*$!sip:userA@zdns.cn!" .',
					'101 10 "()" "sip+E2U" "!^.*$!sip:userA@zdns.cn!" .',
					'101 10 "u" regularExp "!^.*$!sip:userA@zdns.cn!" .',
					'101 10 "u" "sip+E2U" wrongserverArgs .',
					'101 10 "u" "sip+E2U" "!^.*$!sip:userA@zdns.cn!" ']
				begin
					r << Zone_er.create_zone(args)
					r << DNS.goto_zone_page(args)
					domain        = {}
					domain['ttl'] = '3600'
					# SRV字段错误
					domain['rname'] = 'srv'
					domain['rtype'] = 'SRV'
					args[:error_info] = srv_err_info
					srv_rdata_list.each do |rdata|
						domain['rdata'] = rdata
						DNS.inputs_domain_dialog(domain)
						r << DNS.error_validator_on_popwin(args)
					end
					# NAPTR字段错误
					domain['rname'] = 'naptr'
					domain['rtype'] = 'NAPTR'
					args[:error_info] = naptr_err_info
					naptr_rdata_list.each do |rdata|
						domain['rdata'] = rdata
						DNS.inputs_domain_dialog(domain)
						r << DNS.error_validator_on_popwin(args)
					end
					r << Zone_er.del_zone(args)			
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1127(args)
				# CNAME/DNAME提示互斥
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:view_name]   = 'default'
				args[:zone_name]   = "zone.#{@case_ID}"
				args[:owner_list]  = Node_Name_List
				args[:error_type]  = 'after_OK'
				args[:error_info]  = '增加互斥的资源记录'
				args[:domain_list] = [{'rname'=>'dname', 'rtype'=>'DNAME', 'rdata'=>'d.name.1.', 'ttl'=>'3600'}]
				domain             = {}
				domain['ttl']      = '3600'
				cname_input        = ['ns', 'CNAME', 'c.name']
				dname_input        = ['dname', 'DNAME', 'd.name.2.']
				begin
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					r << DNS.goto_zone_page(args)
					[cname_input, dname_input].each do |input|
						domain['rname'] = input[0]
						domain['rtype'] = input[1]
						domain['rdata'] = input[2]
						DNS.inputs_domain_dialog(domain)
						r << DNS.error_validator_on_popwin(args)
					end
					r << Zone_er.del_zone(args)				
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1167(args)
				# MX/NS新建时缺乏glue记录
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:view_name]  = 'default'
				args[:zone_name]  = "zone.#{@case_ID}"
				args[:owner_list] = Node_Name_List
				args[:error_type] = 'after_OK'
				args[:error_info] = '缺乏glue记录'
				domain            = {}
				domain['ttl']     = '3600'
				ns_input          = ['ns.no.glue', 'NS', 'ns.a.test']
				mx_input          = ['mx.no.glue', 'MX', '9 mx.a.test']
				begin
					r << Zone_er.create_zone(args)
					r << DNS.goto_zone_page(args)
					[ns_input, mx_input].each do |input|
						domain['rname'] = input[0]
						domain['rtype'] = input[1]
						domain['rdata'] = input[2]
						DNS.inputs_domain_dialog(domain)
						r << DNS.error_validator_on_popwin(args)
					end
					r << Zone_er.del_zone(args)				
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1087(args)
				# 自动创建反向AAAA记录
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:acl_name]    = "acl_#{@case_ID}"
				args[:acl_list]    = Local_Network
				args[:view_name]   = "view_#{@case_ID}"
				positive_zname     = "zone.#{@case_ID}"
				args[:owner_list]  = Node_Name_List
				rdata              = '1234:5678::ABCD:1087'
				rdomain_4a         = '7.8.0.1.d.c.b.a.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.8.7.6.5.4.3.2.1.ip6.arpa.'
				rdomain_rtype_list = [
					{'rdomain'=>'case.1087.zone.1087.', 'rtype'=>'AAAA'},
					{'rdomain'=>rdomain_4a, 'rtype'=>'PTR'}]
				begin
					# 创建AAAA反向区
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					args[:zone_type] = 'in-addr'
					args[:zone_name] = '1234:5678::/64'
					r << Zone_er.create_zone(args)
					# 正向区 + AAAA记录
					args[:zone_type] = 'positive'
					args[:zone_name] = positive_zname
					r << Zone_er.create_zone(args)
					args[:domain_list] = [
						{'rname'=>'case.1087','rtype'=>'AAAA','rdata'=>rdata,'ttl'=>'600','auto_ptr'=>'yes'}]
					r << Domain_er.create_domain(args)
					# Dig AAAA记录和反向记录
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						rdomain_rtype_list.each do |rdomain_rtype|
							args[:domain_name] = rdomain_rtype['rdomain']
							args[:rtype]       = rdomain_rtype['rtype']
							r << DNS.dig_as_noerror(args)
						end
					end
					# 清理
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_5164(args)
				# A记录自动添加PTR掩码8/16/24
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:acl_name]   = "acl_#{@case_ID}"
				args[:acl_list]   = Local_Network
				args[:view_name]  = "view_#{@case_ID}"
				positive_zname    = "zone.#{@case_ID}"
				args[:owner_list] = Node_Name_List
				rdata_list        = ['192.51.64.0', '192.168.51.64', '192.168.0.51']
				begin
					# 创建3个反向区
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					args[:zone_type] = 'in-addr'
					zone_name_prefix = '192.168.0.0'
					['8', '16', '24'].each do |sub_network_mask|
						args[:zone_name] = zone_name_prefix + '/' + sub_network_mask
						r << Zone_er.create_zone(args)
					end
					# 正向区 + A记录
					args[:zone_type] = 'positive'
					args[:zone_name] = positive_zname
					r << Zone_er.create_zone(args)
					args[:domain_list] = []
					rdata_list.each do |rdata|
						args[:domain_list] << {'rname'=>'case.5164', 'rtype'=>'A', 'rdata'=>rdata, 
						 'ttl'=>'600', 'auto_ptr'=>'yes'}
					end
					r << Domain_er.create_domain(args)
					# Dig A记录和反向记录
					rdomain_rtype_list  = []
					rdomain_rtype_list << {'rdomain'=>'case.5164.zone.5164', 'rtype'=>'A'}
					rdomain_rtype_list << {'rdomain'=>'0.64.51.192.in-addr.arpa.', 'rtype'=>'PTR'}
					rdomain_rtype_list << {'rdomain'=>'64.51.168.192.in-addr.arpa.', 'rtype'=>'PTR'}
					rdomain_rtype_list << {'rdomain'=>'51.0.168.192.in-addr.arpa.', 'rtype'=>'PTR'}
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						rdomain_rtype_list.each do |rdomain_rtype|
							args[:domain_name] = rdomain_rtype['rdomain']
							args[:rtype]       = rdomain_rtype['rtype']
							r << DNS.dig_as_noerror(args)
						end
					end
					# 清理
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_8350(args)
				# 编辑SOA
				@case_ID              = __method__.to_s.split('_')[1]
				r                     = []
				args[:view_name]      = "default"
				args[:zone_name]      = "zone.#{@case_ID}"
				args[:owner_list]     = Node_Name_List
				args[:soa_ttl]        = '3600'
				mname                 = "soa.zone.#{@case_ID}"
				rname                 = "soa.mail.zone.#{@case_ID}"
				serial                = '2'
				refresh               = '3600'
				re_try                = '600'
				expire                = '500'
				minimum               = '400'
				args[:soa_mname]      = mname
				args[:soa_rname]      = rname
				args[:soa_serial]     = serial
				args[:soa_refresh]    = refresh
				args[:soa_retry]      = re_try
				args[:soa_expire]     = expire
				args[:soa_minimum]    = minimum
				args[:soa_value_list] = ["#{mname}", "#{rname}","#{refresh} #{re_try} #{expire} #{minimum}"]
				begin
					# 编辑SOA
					r << Zone_er.create_zone(args)
					r << Zone_er.edit_soa(args)
					# dig 验证
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_soa(args)
					end
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_5165(args)
				# 删除A记录时, 连带删除反向记录
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:acl_name]   = "acl_#{@case_ID}"
				args[:acl_list]   = Local_Network
				args[:view_name]  = "view_#{@case_ID}"
				positive_zname    = "zone.#{@case_ID}"
				args[:owner_list] = Node_Name_List
				rdata             = '192.168.51.65'
				begin
					# 创建反向区
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					args[:zone_type] = 'in-addr'
					args[:zone_name] = '192.168.0.0/16'
					r << Zone_er.create_zone(args)
					arpa_name = DNS.zone_name_to_arpa(args)
					# 正向区 + A记录
					args[:zone_type] = 'positive'
					args[:zone_name] = positive_zname
					r << Zone_er.create_zone(args)
					args[:domain_list] = [{'rname'=>'case.5165', 'rtype'=>'A', 'rdata'=>rdata, 
						 'ttl'=>'600', 'auto_ptr'=>'yes'}]
					r << Domain_er.create_domain(args)
					# Dig验证添加PTR成功
					rdomain_rtype_list  = []
					rdomain_rtype_list << {'rdomain'=>'case.5165.zone.5165', 'rtype'=>'A'}
					rdomain_rtype_list << {'rdomain'=>'65.51.168.192.in-addr.arpa.', 'rtype'=>'PTR'}
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						rdomain_rtype_list.each do |rdomain_rtype|
							args[:domain_name] = rdomain_rtype['rdomain']
							args[:rtype]       = rdomain_rtype['rtype']
							r << DNS.dig_as_noerror(args)
						end
					end
					# 删除A记录, 连带删除反向记录
					args[:del_ptr] = 'yes'
					r << Domain_er.del_domain(args)
					# Dig验证删除PTR成功
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						rdomain_rtype_list.each do |rdomain_rtype|
							args[:domain_name] = rdomain_rtype['rdomain']
							args[:rtype]       = rdomain_rtype['rtype']
							r << DNS.dig_as_nxdomain(args)
						end
					end
					# 清理
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1181(args)
				# 批量添加记录
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:acl_name]   = "acl_#{@case_ID}"
				args[:acl_list]   = Local_Network
				args[:view_name]  = "view_#{@case_ID}"
				args[:owner_list] = Node_Name_List
				args[:zone_name]  = "zone.#{@case_ID}"
				args[:file_name]  = Upload_Dir + 'zone\1181.txt'
				domain_rtype_list = [
					{'rdomain' =>'a.zone.1181.', 'rtype'=>'A'},
					{'rdomain' =>'aaaa.zone.1181.', 'rtype'=>'AAAA'},
					{'rdomain' =>'cname.zone.1181.', 'rtype'=>'CNAME'},
					{'rdomain' =>'ptr.zone.1181.', 'rtype'=>'PTR'}
				]
				begin
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.batch_add_domain(args)
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						domain_rtype_list.each do |domain_rtype|
							args[:domain] = domain_rtype['rdomain']
							args[:rtype] = domain_rtype['rtype']
							r << DNS.dig_as_noerror(args)
						end
					end
					# 清理
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_14530(args)
				# 先新建A记录, 再编辑添加宕机切换策略
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:acl_name]               = "acl_#{@case_ID}"
				args[:acl_list]               = Local_Network
				args[:view_name]              = "view_#{@case_ID}"
				args[:zone_name]              = "zone.#{@case_ID}"
				args[:owner_list]             = Node_Name_List
				args[:strategy_name]          = "strategy_for_#{@case_ID}"
				args[:strategy_handle_method] = "告警"
				args[:domain_list]            = [{'rname'=>'case.14530', 'rtype'=>'A', 'rdata'=>'192.168.145.30'}]
				args[:domain_name]            = 'case.14530.zone.14530.'
				args[:rtype]                  = 'A'
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_noerror(args)
					end
					# 编辑域名, 添加宕机切换策略
					args[:domain_list]  = [{'rname'=>'case.14530', 'rtype'=>'A', 'rdata_old'=>'192.168.145.30', 'strategy_name'=>"strategy_for_#{@case_ID}"}]
					r << Domain_er.edit_domain(args)
					sleep Monitor_Strtime # 等待宕机切换探测生效.
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_noerror(args, sleepfirst = false)
					end
					# 清理
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_14531(args)
				# 先新建A记录, 再编辑添加宕机切换策略
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:acl_name]               = "acl_#{@case_ID}"
				args[:acl_list]               = Local_Network
				args[:view_name]              = "view_#{@case_ID}"
				args[:zone_name]              = "zone.#{@case_ID}"
				args[:owner_list]             = Node_Name_List
				args[:strategy_name]          = "strategy_for_#{@case_ID}"
				args[:strategy_handle_method] = "禁用"
				args[:domain_list]            = [{'rname'=>'case.14531', 'rtype'=>'A', 'rdata'=>'192.168.145.31'}]
				args[:domain_name]            = 'case.14531.zone.14531.'
				args[:rtype]                  = 'A'
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_noerror(args)
					end
					# 编辑域名, 添加宕机切换策略
					args[:domain_list]  = [{'rname'=>'case.14531', 'rtype'=>'A', 'rdata_old'=>'192.168.145.31', 'strategy_name'=>"strategy_for_#{@case_ID}"}]
					r << Domain_er.edit_domain(args)
					sleep Monitor_Strtime # 等待宕机切换探测生效.
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_nxdomain(args, sleepfirst = false)
					end
					# 清理
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_14532(args)
				# 先新建AAAA记录, 再编辑添加宕机切换策略
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:acl_name]               = "acl_#{@case_ID}"
				args[:acl_list]               = Local_Network
				args[:view_name]              = "view_#{@case_ID}"
				args[:zone_name]              = "zone.#{@case_ID}"
				args[:owner_list]             = Node_Name_List
				args[:strategy_name]          = "strategy_for_#{@case_ID}"
				args[:strategy_handle_method] = "禁用"
				args[:domain_list]            = [{'rname'=>'case.14532', 'rtype'=>'AAAA', 'rdata'=>'192:168:145::32'}]
				args[:domain_name]            = 'case.14532.zone.14532.'
				args[:rtype]                  = 'AAAA'
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_noerror(args)
					end
					# 编辑域名, 添加宕机切换策略
					args[:domain_list]  = [{'rname'=>'case.14532', 'rtype'=>'AAAA', 'rdata_old'=>'192:168:145::32', 'strategy_name'=>"strategy_for_#{@case_ID}"}]
					r << Domain_er.edit_domain(args)
					sleep Monitor_Strtime # 等待宕机切换探测生效.
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_nxdomain(args, sleepfirst = false)
					end
					# 清理
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_14533(args)
				# 先新建AAAA记录, 再编辑添加宕机切换策略
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:acl_name]               = "acl_#{@case_ID}"
				args[:acl_list]               = Local_Network
				args[:view_name]              = "view_#{@case_ID}"
				args[:zone_name]              = "zone.#{@case_ID}"
				args[:owner_list]             = Node_Name_List
				args[:strategy_name]          = "strategy_for_#{@case_ID}"
				args[:strategy_handle_method] = "告警"
				args[:domain_list]            = [{'rname'=>'case.14533', 'rtype'=>'AAAA', 'rdata'=>'192:168:145::33'}]
				args[:domain_name]            = 'case.14533.zone.14533.'
				args[:rtype]                  = 'AAAA'
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_noerror(args)
					end
					# 编辑域名, 添加宕机切换策略
					args[:domain_list]  = [{'rname'=>'case.14533', 'rtype'=>'AAAA', 'rdata_old'=>'192:168:145::33', 'strategy_name'=>"strategy_for_#{@case_ID}"}]
					r << Domain_er.edit_domain(args)
					sleep Monitor_Strtime # 等待宕机切换探测生效.
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_noerror(args, sleepfirst = false)
					end
					# 清理
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_14527(args)
				# 编辑A记录宕机切换告警<->禁用
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:acl_name]    = "acl_#{@case_ID}"
				args[:acl_list]    = Local_Network
				args[:view_name]   = "view_#{@case_ID}"
				args[:zone_name]   = "zone.#{@case_ID}"
				args[:owner_list]  = Node_Name_List
				name_warning       = "宕机_告警_#{@case_ID}"
				name_disable       = "宕机_禁用_#{@case_ID}"
				strategy_hash      = {name_warning => '告警', name_disable => '禁用'}
				args[:domain_list] = [{'rname'=>'case.14527', 'rtype'=>'A', 'rdata'=>'192.168.145.27', 'strategy_name'=>name_warning}]
				args[:domain_name] = 'case.14527.zone.14527.'
				args[:rtype]       = 'A'
				begin
					strategy_hash.each_pair do |strategy_name, strategy_method|
						args[:strategy_name] = strategy_name
						args[:strategy_handle_method] = strategy_method
						r << ACL_Mng_er.create_monitor_strategy(args)
					end
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					sleep Monitor_Strtime # 等待宕机切换探测生效.
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_noerror(args)
					end
					args[:warning_string] = '目标服务失败: 资源记录view_14527/zone.14527/case.14527.zone.14527 3600 A 192.168.145.27'
					r << System.warning_validator_on_warning_records_page(args)
					args[:domain_list] = [{'rname'=>'case.14527', 'rtype'=>'A', 'rdata_old'=>'192.168.145.27', 'strategy_name'=>name_disable}]
					r << Domain_er.edit_domain(args)
					sleep Monitor_Strtime # 等待宕机切换探测生效.
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_nxdomain(args, sleepfirst = false)
					end
					# 查看日志
					args[:warning_string] = '目标服务失败: 禁用资源记录view_14527/zone.14527/case.14527.zone.14527 3600 A 192.168.145.27'
					r << System.warning_validator_on_warning_records_page(args)
					# 清理
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
					[name_warning, name_disable].each do |strategy_name|
						args[:strategy_name] = strategy_name
						r << ACL_Mng_er.del_monitor_strategy(args)
					end
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_14528(args)
				# 编辑A记录宕机切换禁用<->告警
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:acl_name]    = "acl_#{@case_ID}"
				args[:acl_list]    = Local_Network
				args[:view_name]   = "view_#{@case_ID}"
				args[:zone_name]   = "zone.#{@case_ID}"
				args[:owner_list]  = Node_Name_List
				name_warning       = "宕机_告警_#{@case_ID}"
				name_disable       = "宕机_禁用_#{@case_ID}"
				strategy_hash      = {name_warning => '告警', name_disable => '禁用'}
				args[:domain_list] = [{'rname'=>'case.14528', 'rtype'=>'A', 'rdata'=>'192.168.145.28', 'strategy_name'=>name_disable}]
				args[:domain_name] = 'case.14528.zone.14528.'
				args[:rtype]       = 'A'
				begin
					strategy_hash.each_pair do |strategy_name, strategy_method|
						args[:strategy_name] = strategy_name
						args[:strategy_handle_method] = strategy_method
						r << ACL_Mng_er.create_monitor_strategy(args)
					end
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					sleep Monitor_Strtime # 等待宕机切换探测生效.
					# 查看日志
					args[:warning_string] = '目标服务失败: 禁用资源记录view_14528/zone.14528/case.14528.zone.14528 3600 A 192.168.145.28'
					r << System.warning_validator_on_warning_records_page(args)
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_nxdomain(args)
					end
					args[:domain_list] = [{'rname'=>'case.14528', 'rtype'=>'A', 'rdata_old'=>'192.168.145.28', 'strategy_name'=>name_warning}]
					r << Domain_er.edit_domain(args)
					sleep Monitor_Strtime # 等待宕机切换探测生效.
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_noerror(args, sleepfirst = false)
					end
					# 查看日志
					args[:warning_string] = '目标服务失败: 资源记录view_14528/zone.14528/case.14528.zone.14528 3600 A 192.168.145.28'
					r << System.warning_validator_on_warning_records_page(args)
					# 清理
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
					[name_warning, name_disable].each do |strategy_name|
						args[:strategy_name] = strategy_name
						r << ACL_Mng_er.del_monitor_strategy(args)
					end
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_14529(args)
				# 编辑AAAA记录宕机切换告警<->禁用
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:acl_name]    = "acl_#{@case_ID}"
				args[:acl_list]    = Local_Network
				args[:view_name]   = "view_#{@case_ID}"
				args[:zone_name]   = "zone.#{@case_ID}"
				args[:owner_list]  = Node_Name_List
				name_warning       = "宕机_告警_#{@case_ID}"
				name_disable       = "宕机_禁用_#{@case_ID}"
				strategy_hash      = {name_warning => '告警', name_disable => '禁用'}
				args[:domain_list] = [{'rname'=>'case.14529', 'rtype'=>'AAAA', 'rdata'=>'192:168:145::29', 'strategy_name'=>name_warning}]
				args[:domain_name] = 'case.14529.zone.14529.'
				args[:rtype]       = 'AAAA'
				begin
					strategy_hash.each_pair do |strategy_name, strategy_method|
						args[:strategy_name] = strategy_name
						args[:strategy_handle_method] = strategy_method
						r << ACL_Mng_er.create_monitor_strategy(args)
					end
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_noerror(args)
					end
					args[:domain_list] = [{'rname'=>'case.14529', 'rtype'=>'AAAA', 'rdata_old'=>'192:168:145::29', 'strategy_name'=>name_disable}]
					r << Domain_er.edit_domain(args)
					sleep Monitor_Strtime # 等待宕机切换探测生效.
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_nxdomain(args, sleepfirst = false)
					end
					# 查看日志
					args[:warning_string] = '目标服务失败: 资源记录view_14529/zone.14529/case.14529.zone.14529 3600 AAAA 192:168:145::29'
					r << System.warning_validator_on_warning_records_page(args)
					args[:warning_string] = '目标服务失败: 禁用资源记录view_14529/zone.14529/case.14529.zone.14529 3600 AAAA 192:168:145::29'
					r << System.warning_validator_on_warning_records_page(args)
					# 清理
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
					[name_warning, name_disable].each do |strategy_name|
						args[:strategy_name] = strategy_name
						r << ACL_Mng_er.del_monitor_strategy(args)
					end
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_14540(args)
				# 编辑AAAA记录宕机切换禁用<->告警
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:acl_name]    = "acl_#{@case_ID}"
				args[:acl_list]    = Local_Network
				args[:view_name]   = "view_#{@case_ID}"
				args[:zone_name]   = "zone.#{@case_ID}"
				args[:owner_list]  = Node_Name_List
				name_warning       = "宕机_告警_#{@case_ID}"
				name_disable       = "宕机_禁用_#{@case_ID}"
				strategy_hash      = {name_warning => '告警', name_disable => '禁用'}
				args[:domain_list] = [{'rname'=>'case.14540', 'rtype'=>'AAAA', 'rdata'=>'192:168:145::40', 'strategy_name'=>name_disable}]
				args[:domain_name] = 'case.14540.zone.14540.'
				args[:rtype]       = 'AAAA'
				begin
					strategy_hash.each_pair do |strategy_name, strategy_method|
						args[:strategy_name] = strategy_name
						args[:strategy_handle_method] = strategy_method
						r << ACL_Mng_er.create_monitor_strategy(args)
					end
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					sleep Monitor_Strtime # 等待宕机切换探测生效.
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_nxdomain(args)
					end
					args[:domain_list] = [{'rname'=>'case.14540', 'rtype'=>'AAAA', 'rdata_old'=>'192:168:145::40', 'strategy_name'=>name_warning}]
					r << Domain_er.edit_domain(args)
					sleep Monitor_Strtime # 等待宕机切换探测生效.
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_noerror(args, sleepfirst = false)
					end
					# 查看日志
					args[:warning_string] = '目标服务失败: 资源记录view_14540/zone.14540/case.14540.zone.14540 3600 AAAA 192:168:145::40'
					r << System.warning_validator_on_warning_records_page(args)
					args[:warning_string] = '目标服务失败: 禁用资源记录view_14540/zone.14540/case.14540.zone.14540 3600 AAAA 192:168:145::40'
					r << System.warning_validator_on_warning_records_page(args)
					# 清理
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
					[name_warning, name_disable].each do |strategy_name|
						args[:strategy_name] = strategy_name
						r << ACL_Mng_er.del_monitor_strategy(args)
					end
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_14534(args)
				# 删除A记录宕机切换(告警)
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:acl_name]               = "acl_#{@case_ID}"
				args[:acl_list]               = Local_Network
				args[:view_name]              = "view_#{@case_ID}"
				args[:zone_name]              = "zone.#{@case_ID}"
				args[:owner_list]             = Node_Name_List
				args[:strategy_name]          = "宕机_禁用_#{@case_ID}"
				args[:strategy_handle_method] = "告警"
				args[:domain_list]            = [{'rname'=>'case.14534', 'rtype'=>'A', 'rdata'=>'192.168.145.34'}]
				args[:domain_name]            = 'case.14534.zone.14534.'
				args[:rtype]                  = 'A'
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					args[:domain_list] = [{'rname'=>'case.14534', 'rtype'=>'A', 'rdata_old'=>'192.168.145.34', 'strategy_name'=>args[:strategy_name]}]
					r << Domain_er.edit_domain(args)
					sleep Monitor_Strtime # 等待宕机切换探测生效.
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_noerror(args, sleepfirst = false)
					end
					# 删除宕机切换
					args[:domain_list] = [{'rname'=>'case.14534', 'rtype'=>'A', 'rdata_old'=>'192.168.145.34', 'strategy_name'=>'请选择切换策略'}]
					r << Domain_er.edit_domain(args)
					# Dig验证
					sleep Monitor_Strtime
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_noerror(args, sleepfirst = false)
					end
					# 清理
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_14535(args)
				# 删除A记录宕机切换(禁用)
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:acl_name]               = "acl_#{@case_ID}"
				args[:acl_list]               = Local_Network
				args[:view_name]              = "view_#{@case_ID}"
				args[:zone_name]              = "zone.#{@case_ID}"
				args[:owner_list]             = Node_Name_List
				args[:strategy_name]          = "宕机_禁用_#{@case_ID}"
				args[:strategy_handle_method] = "禁用"
				args[:domain_list]            = [{'rname'=>'case.14535', 'rtype'=>'A', 'rdata'=>'192.168.145.35'}]
				args[:domain_name]            = 'case.14535.zone.14535.'
				args[:rtype]                  = 'A'
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					args[:domain_list] = [{'rname'=>'case.14535', 'rtype'=>'A', 'rdata_old'=>'192.168.145.35', 'strategy_name'=>args[:strategy_name]}]
					r << Domain_er.edit_domain(args)
					sleep Monitor_Strtime # 等待宕机切换探测生效.
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_nxdomain(args, sleepfirst = false)
					end
					# 删除宕机切换
					args[:domain_list] = [{'rname'=>'case.14535', 'rtype'=>'A', 'rdata_old'=>'192.168.145.35', 'strategy_name'=>'请选择切换策略'}]
					r << Domain_er.edit_domain(args)
					# Dig验证
					sleep Monitor_Strtime
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_noerror(args, sleepfirst = false)
					end
					# 清理
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_14536(args)
				# 删除AAAA记录宕机切换(告警)
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:acl_name]               = "acl_#{@case_ID}"
				args[:acl_list]               = Local_Network
				args[:view_name]              = "view_#{@case_ID}"
				args[:zone_name]              = "zone.#{@case_ID}"
				args[:owner_list]             = Node_Name_List
				args[:strategy_name]          = "宕机_禁用_#{@case_ID}"
				args[:strategy_handle_method] = "告警"
				args[:domain_list]            = [{'rname'=>'case.14536', 'rtype'=>'AAAA', 'rdata'=>'192:168:145::36'}]
				args[:domain_name]            = 'case.14536.zone.14536.'
				args[:rtype]                  = 'AAAA'
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					args[:domain_list] = [{'rname'=>'case.14536', 'rtype'=>'AAAA', 'rdata_old'=>'192:168:145::36', 'strategy_name'=>args[:strategy_name]}]
					r << Domain_er.edit_domain(args)
					sleep Monitor_Strtime # 等待宕机切换探测生效.
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_noerror(args, sleepfirst = false)
					end
					# 删除宕机切换
					args[:domain_list] = [{'rname'=>'case.14536', 'rtype'=>'AAAA', 'rdata_old'=>'192:168:145::36', 'strategy_name'=>'请选择切换策略'}]
					r << Domain_er.edit_domain(args)
					# Dig验证
					sleep Monitor_Strtime
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_noerror(args, sleepfirst = false)
					end
					# 清理
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_14537(args)
				# 删除A记录宕机切换(禁用)
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:acl_name]               = "acl_#{@case_ID}"
				args[:acl_list]               = Local_Network
				args[:view_name]              = "view_#{@case_ID}"
				args[:zone_name]              = "zone.#{@case_ID}"
				args[:owner_list]             = Node_Name_List
				args[:strategy_name]          = "宕机_禁用_#{@case_ID}"
				args[:strategy_handle_method] = "禁用"
				args[:domain_list]            = [{'rname'=>'case.14537', 'rtype'=>'AAAA', 'rdata'=>'192:168:145::37'}]
				args[:domain_name]            = 'case.14537.zone.14537.'
				args[:rtype]                  = 'AAAA'
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					args[:domain_list] = [{'rname'=>'case.14537', 'rtype'=>'AAAA', 'rdata_old'=>'192:168:145::37', 'strategy_name'=>args[:strategy_name]}]
					r << Domain_er.edit_domain(args)
					sleep Monitor_Strtime # 等待宕机切换探测生效.
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_nxdomain(args, sleepfirst = false)
					end
					# 删除宕机切换
					args[:domain_list] = [{'rname'=>'case.14537', 'rtype'=>'AAAA', 'rdata_old'=>'192:168:145::37', 'strategy_name'=>'请选择切换策略'}]
					r << Domain_er.edit_domain(args)
					# Dig验证
					sleep Monitor_Strtime
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_noerror(args, sleepfirst = false)
					end
					# 清理
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_14522(args)
				# 新建A记录宕机切换告警
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:acl_name]               = "acl_#{@case_ID}"
				args[:acl_list]               = Local_Network
				args[:view_name]              = "view_#{@case_ID}"
				args[:zone_name]              = "zone.#{@case_ID}"
				args[:owner_list]             = Node_Name_List
				args[:strategy_name]          = "宕机_告警_#{@case_ID}"
				args[:strategy_handle_method] = '告警'
				args[:domain_list]            = [{'rname'=>'case.14522', 'rtype'=>'A', 'rdata'=>'192.168.145.22', 'strategy_name'=>args[:strategy_name]}]
				args[:domain_name]            = 'case.14522.zone.14522.'
				args[:rtype]                  = 'A'
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					sleep Monitor_Strtime # 等待宕机切换探测生效.
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_noerror(args)
					end
					# 查看日志
					args[:warning_string] = '目标服务失败: 资源记录view_14522/zone.14522/case.14522.zone.14522 3600 A 192.168.145.22'
					r << System.warning_validator_on_warning_records_page(args)
					# 清理
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_14523(args)
				# 新建A记录宕机切换禁用
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:acl_name]               = "acl_#{@case_ID}"
				args[:acl_list]               = Local_Network
				args[:view_name]              = "view_#{@case_ID}"
				args[:zone_name]              = "zone.#{@case_ID}"
				args[:owner_list]             = Node_Name_List
				args[:strategy_name]          = "宕机_禁用_#{@case_ID}"
				args[:strategy_handle_method] = '禁用'
				args[:domain_list]            = [{'rname'=>'case.14523', 'rtype'=>'A', 'rdata'=>'192.168.145.23', 'strategy_name'=>args[:strategy_name]}]
				args[:domain_name]            = 'case.14523.zone.14523.'
				args[:rtype]                  = 'A'
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					sleep Monitor_Strtime # 等待宕机切换探测生效.
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_nxdomain(args)
					end
					# 查看日志
					args[:warning_string] = '目标服务失败: 禁用资源记录view_14523/zone.14523/case.14523.zone.14523 3600 A 192.168.145.23'
					r << System.warning_validator_on_warning_records_page(args)
					# 清理
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_14524(args)
				# 新建AAAA记录宕机切换禁用
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:acl_name]               = "acl_#{@case_ID}"
				args[:acl_list]               = Local_Network
				args[:view_name]              = "view_#{@case_ID}"
				args[:zone_name]              = "zone.#{@case_ID}"
				args[:owner_list]             = Node_Name_List
				args[:strategy_name]          = "宕机_禁用_#{@case_ID}"
				args[:strategy_handle_method] = '禁用'
				args[:domain_list]            = [{'rname'=>'case.14524', 'rtype'=>'AAAA', 'rdata'=>'192A:168B:145C::24DE', 'strategy_name'=>args[:strategy_name]}]
				args[:domain_name]            = 'case.14524.zone.14524.'
				args[:rtype]                  = 'AAAA'
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					sleep Monitor_Strtime # 等待宕机切换探测生效.
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_nxdomain(args)
					end
					# 查看日志
					args[:warning_string] = '目标服务失败: 禁用资源记录view_14524/zone.14524/case.14524.zone.14524 3600 AAAA 192A:168B:145C::24DE'
					r << System.warning_validator_on_warning_records_page(args)
					# 清理
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_14525(args)
				# 新建AAAA记录宕机切换告警
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:acl_name]               = "acl_#{@case_ID}"
				args[:acl_list]               = Local_Network
				args[:view_name]              = "view_#{@case_ID}"
				args[:zone_name]              = "zone.#{@case_ID}"
				args[:owner_list]             = Node_Name_List
				args[:strategy_name]          = "宕机_告警_#{@case_ID}"
				args[:strategy_handle_method] = '告警'
				args[:domain_list]            = [{'rname'=>'case.14525', 'rtype'=>'AAAA', 'rdata'=>'192A:168B:145C::25DE', 'strategy_name'=>args[:strategy_name]}]
				args[:domain_name]            = 'case.14525.zone.14525.'
				args[:rtype]                  = 'AAAA'
				begin
					r << ACL_Mng_er.create_monitor_strategy(args)
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					sleep Monitor_Strtime # 等待宕机切换探测生效.
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_noerror(args)
					end
					# 查看日志
					args[:warning_string] = '目标服务失败: 资源记录view_14525/zone.14525/case.14525.zone.14525 3600 AAAA 192A:168B:145C::25DE'
					r << System.warning_validator_on_warning_records_page(args)
					# 清理
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1320(args)
				# 编辑A记录
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:acl_name]    = "acl_#{@case_ID}"
				args[:acl_list]    = Local_Network
				args[:view_name]   = "view_#{@case_ID}"
				args[:zone_name]   = "zone.#{@case_ID}"
				args[:owner_list]  = Node_Name_List
				args[:domain_list] = [{'rname'=>'case.1320', 'rtype'=>'A', 'rdata'=>'192.168.13.20'}]
				args[:domain_name] = 'case.1320.zone.1320.'
				args[:rtype]       = 'A'
				begin
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_noerror(args)
					end
					# 编辑
					rdata_new = '192.168.20.13'
					args[:domain_list] = [{'rname'=>'case.1320', 'rtype'=>'A', 'rdata_old'=>'192.168.13.20', 'rdata_new'=>rdata_new}]
					r << Domain_er.edit_domain(args)
					args[:actual_rdata] = rdata_new
					args[:server_list] = Node_IP_List
					r << Dig_er.compare_domain(args)
					# 清理
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_5167(args)
				# 编辑A记录，自动修改PTR.
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:acl_name]    = "acl_#{@case_ID}"
				args[:acl_list]    = Local_Network
				args[:view_name]   = "view_#{@case_ID}"
				positive_zname     = "zone.#{@case_ID}"
				args[:owner_list]  = Node_Name_List
				rdomain_rtype_list = [
					{'rdomain'=>'case.5167.zone.5167', 'rtype'=>'A'},
					{'rdomain'=>'67.51.168.192.in-addr.arpa', 'rtype'=>'PTR'}
				]
				begin
					# 创建反向区
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					args[:zone_type] = 'in-addr'
					args[:zone_name] = '192.168.0.0/16'
					r << Zone_er.create_zone(args)
					# 添加A记录到正向区和反向区
					args[:zone_type] = 'positive'
					args[:zone_name] = positive_zname
					r << Zone_er.create_zone(args)
					args[:domain_list] = [{'rname'=>'case.5167', 'rtype'=>'A', 'rdata'=>'192.168.51.67', 
						 'ttl'=>'600', 'auto_ptr'=>'yes'}]
					r << Domain_er.create_domain(args)
					# Dig A记录和反向记录
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						rdomain_rtype_list.each do |rdomain_rtype|
							args[:domain_name] = rdomain_rtype['rdomain']
							args[:rtype]       = rdomain_rtype['rtype']
							r << DNS.dig_as_noerror(args)
						end
					end
					# 编辑A记录并自动修改PTR
					rdata_new = '192.168.67.51'
					args[:domain_list] = [{'rname'=>'case.5167', 'rtype'=>'A', 'rdata_old'=>'192.168.51.67', 
						 'rdata_new'=>rdata_new,'ttl'=>'600', 'auto_ptr'=>'yes'}]
					r << Domain_er.edit_domain(args)
					# Dig 编辑后的值
					args[:server_list]  = Node_IP_List
					args[:domain_name]  = 'case.5167.zone.5167'
					args[:rtype]        = 'A'
					args[:actual_rdata] = rdata_new
					r << Dig_er.compare_domain(args)
					args[:domain_name]  = '51.67.168.192.in-addr.arpa'
					args[:rtype]        = 'PTR'
					args[:actual_rdata] = 'case.5167.zone.5167.'
					r << Dig_er.compare_domain(args)
					# 清理
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_2679(args)
				# 同名同类型记录的不同TTL, rset联动
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:acl_name]   = "acl_#{@case_ID}"
				args[:acl_list]   = Local_Network
				args[:view_name]  = "view_#{@case_ID}"
				args[:zone_name]  = "zone.#{@case_ID}"
				args[:owner_list] = Node_Name_List
				domain_list       = [
					{'rname'=>'case.2679', 'rtype'=>'A', 'rdata'=>'192.168.26.79', 'ttl'=>'600'},
					{'rname'=>'case.2679', 'rtype'=>'A', 'rdata'=>'192.168.79.26', 'ttl'=>'3600'}
				]
				begin
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					# 添加两条同名不同ttl的A记录
					domain_list.each do |domain|
						args[:domain_list] = [domain]
						r << Domain_er.create_domain(args)
					end
					# 前台验证第一条A记录的TTL被第二条联动修改
					args[:rname] = domain_list[0]["rname"]
                    args[:rtype] = domain_list[0]["rtype"]
                    args[:rdata] = domain_list[0]["rdata"]
                    args[:ttl]   = domain_list[1]["ttl"]
                    r << DNS.goto_zone_page(args)
                    r << DNS.check_on_single_domain(args)
					# 清理
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_2674(args)
				# 同名大小写
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:acl_name]   = "acl_#{@case_ID}"
				args[:acl_list]   = Local_Network
				args[:view_name]  = "view_#{@case_ID}"
				args[:zone_name]  = "zone.#{@case_ID}"
				args[:owner_list] = Node_Name_List
				domain_list       = [
					{'rname'=>'case.2674', 'rtype'=>'A', 'rdata'=>'192.168.26.74', 'ttl'=>'600'},
					{'rname'=>'CASE.2674', 'rtype'=>'A', 'rdata'=>'192.168.74.26', 'ttl'=>'600'}
				]
				begin
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					# 添加两条同名不同ttl的A记录
					domain_list.each do |domain|
						args[:domain_list] = [domain]
						r << Domain_er.create_domain(args)
					end
					# 前台大写自动转成小写
					args[:rname] = domain_list[0]["rname"]
                    args[:rtype] = domain_list[0]["rtype"]
                    args[:rdata] = domain_list[1]["rdata"]
                    args[:ttl]   = domain_list[1]["ttl"]
                    r << DNS.goto_zone_page(args)
                    r << DNS.check_on_single_domain(args)
					# 清理
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_2764(args)
				# 域名下有cname,创建互斥记录
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:view_name]  = 'default'
				args[:zone_name]  = "zone.#{@case_ID}"
				args[:owner_list] = Node_Name_List
				args[:error_info] = '增加互斥的资源记录'
				args[:error_type] = 'after_OK'
				rname             = 'case.2764'
				domain_cname      = {'rname'=>rname, 'rtype'=>'CNAME', 'rdata'=>'2764.com.'}
				domain_a          = {'rname'=>rname, 'rtype'=>'A', 'rdata'=>'192.168.27.64'}
				begin
					r << Zone_er.create_zone(args)
					# 新建CNAME
					args[:domain_list] = [domain_cname]
					r << Domain_er.create_domain(args)
					# 新建互斥记录
					r << DNS.goto_zone_page(args)
					r << DNS.inputs_domain_dialog(domain_a)
					r << DNS.error_validator_on_popwin(args)
					# 清理
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_2763(args)
				# 域名下有A,创建互斥CNAME记录
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:view_name]  = 'default'
				args[:zone_name]  = "zone.#{@case_ID}"
				args[:owner_list] = Node_Name_List
				args[:error_info] = '增加互斥的资源记录'
				args[:error_type] = 'after_OK'
				rname             = 'case.2763'
				domain_a          = {'rname'=>rname, 'rtype'=>'A', 'rdata'=>'192.168.27.63'}
				domain_cname      = {'rname'=>rname, 'rtype'=>'CNAME', 'rdata'=>'2763.com.'}
				begin
					r << Zone_er.create_zone(args)
					# 新建A
					args[:domain_list] = [domain_a]
					r << Domain_er.create_domain(args)
					# 新建互斥CNAME
					r << DNS.goto_zone_page(args)
					r << DNS.inputs_domain_dialog(domain_cname)
					r << DNS.error_validator_on_popwin(args)
					# 清理
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_2770(args)
				# 新建ns记录rdata为相对域名
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:view_name]  = 'default'
				args[:zone_name]  = "zone.#{@case_ID}"
				args[:owner_list] = Node_Name_List
				domain_list       = [
					{'rname'=>'cname1', 'rtype'=>'CNAME', 'rdata'=>'2770.cname'},
					{'rname'=>'cname2', 'rtype'=>'CNAME', 'rdata'=>'2770.cname.'},
					{'rname'=>'dname1', 'rtype'=>'DNAME', 'rdata'=>'2770.dname'},
					{'rname'=>'dname2', 'rtype'=>'DNAME', 'rdata'=>'2770.dname.'}
				]
				begin
					r << Zone_er.create_zone(args)
					# 新建
					domain_list.each do |domain|
						args[:domain_list] = [domain]
						r << Domain_er.create_domain(args)
					end
					# 清理
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1134(args)
				# 创建反向A/AAAA记录 提示无反向区
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:view_name]  = "default"
				args[:zone_name]  = "zone.#{@case_ID}"
				args[:owner_list] = Node_Name_List
				args[:error_info] = '无相应反向区，请取消PTR联动后提交'
				args[:error_type] = 'after_OK'
				domain_list       = [
					{'rname'=>'case.1134', 'rtype'=>'A', 'rdata'=>'192.168.11.34', 'auto_ptr'=>'yes'},
					{'rname'=>'case.1134', 'rtype'=>'AAAA', 'rdata'=>'ABCE::1234', 'auto_ptr'=>'yes'}
				]
				begin
					r << Zone_er.create_zone(args)
					r << DNS.goto_zone_page(args)
					domain_list.each do |domain|
						r << DNS.inputs_domain_dialog(domain)
						r << DNS.error_validator_on_popwin(args)
					end
					# 清理
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1097(args)
				# 新建记录rname和ttl输入范围
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:view_name]  = "default"
				args[:zone_name]  = "zone.#{@case_ID}"
				args[:owner_list] = Node_Name_List
				args[:error_type] = 'before_OK'
				rdata             = '192.168.10.97'
				error_rname       = '域名格式不正确'
				error_ttl         = 'TTL值的范围为:0-2147483647'
				rname_0  = 'case.1097'
				rname_1  = 'mamashuojiusuannizhucedeyumingzaichangbaidudounengsousuochulaide'
				rname_2  = '妈妈说就算你注册的域名再长百度都能搜索出来'
				rname_3  = 'm@m@shu0*&^%$'
				rname_4  = '妈妈说有空 格不行'
				domain_1 = {'rname'=>rname_1, 'rtype'=>'A', 'rdata'=>rdata}
				domain_2 = {'rname'=>rname_2, 'rtype'=>'A', 'rdata'=>rdata}
				domain_3 = {'rname'=>rname_3, 'rtype'=>'A', 'rdata'=>rdata}
				domain_4 = {'rname'=>rname_4, 'rtype'=>'A', 'rdata'=>rdata}
				ttl_1    = '2147483648'
				ttl_2    = '-1'
				ttl_3    = 'ttl = -1'
				domain_5 = {'rname'=>rname_0, 'rtype'=>'A', 'rdata'=>rdata, 'ttl'=>ttl_1}
				domain_6 = {'rname'=>rname_0, 'rtype'=>'A', 'rdata'=>rdata, 'ttl'=>ttl_3}
				domain_7 = {'rname'=>rname_0, 'rtype'=>'A', 'rdata'=>rdata, 'ttl'=>ttl_2}
				err_pair = {
					domain_1 => error_rname,
					domain_2 => error_rname,
					domain_3 => error_rname,
					domain_4 => error_rname,
					domain_5 => error_ttl,
					domain_6 => error_ttl,
					domain_7 => error_ttl
				}
				begin
					r << Zone_er.create_zone(args)
					# 输入范围
					r << DNS.goto_zone_page(args)
					err_pair.each_pair do |domain, error_info|
						args[:error_info] = error_info
						r << DNS.inputs_domain_dialog(domain)
						r << DNS.error_validator_on_popwin(args)
					end
					# 创建'-'和'_' (开头/连续/结尾)的域名
					rdata_2_underline   = '__case__1097__'
					rdata_2_dash        = '--case--1097--'
					rdata_2_dash_trsf   = '\-\-case\-\-1097\-\-'
					domain_8            = {'rname'=>rdata_2_dash, 'rtype'=>'A', 'rdata'=>rdata}
					domain_9            = {'rname'=>rdata_2_underline, 'rtype'=>'A', 'rdata'=>rdata}
					args[:domain_list]  = [domain_8, domain_9]
					r << Domain_er.create_domain(args)
					# Dig双下划线域名
					args[:server_list]  = Node_IP_List
					args[:domain_name]  = "#{rdata_2_underline}.#{args[:zone_name]}"
					args[:actual_rdata] = rdata
					args[:rtype]        = 'A'
					r << Dig_er.compare_domain(args)
					# Dig双破折号域名
					args[:domain_name]  = "#{rdata_2_dash_trsf}.#{args[:zone_name]}"
					args[:actual_rdata] = rdata
					r << Dig_er.compare_domain(args)
					# 清理
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_2765(args)
				# 批量添加非本区记录
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:view_name]  = "default"
				args[:zone_name]  = "zone.#{@case_ID}"
				args[:owner_list] = Node_Name_List
				args[:error_info] = "记录不属于要加入的区\n记录序列号:1\n资源记录:case.2765. 3600 A 192.168.11.34"
				args[:error_type] = 'after_OK'
				begin
					r << Zone_er.create_zone(args)
					# 绝对域名rname带'.'不属于本区
					args[:domain_list] = [
						{'rname'=>'case.2765.', 'rtype'=>'A', 'rdata'=>'192.168.11.34', 'ttl'=>'3600'}]
					r << DNS.goto_zone_page(args)
					r << DNS.inputs_batch_domain_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					# 清理
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1226(args)
				# 批量添加201条
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:view_name]  = "default"
				args[:zone_name]  = "zone.#{@case_ID}"
				args[:owner_list] = Node_Name_List
				args[:error_info] = '超过最大输入限制(200条)'
				args[:error_type] = 'before_OK'
				begin
					r << Zone_er.create_zone(args)
					# 绝对域名rname带'.'不属于本区
					args[:file_name] = Upload_Dir + 'zone\1226.txt'
					r << DNS.goto_zone_page(args)
					r << DNS.inputs_batch_domain_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					# 清理
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1215(args)
				# 批量添加资源记录格式无效
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:view_name]  = "default"
				args[:zone_name]  = "zone.#{@case_ID}"
				args[:owner_list] = Node_Name_List
				err_info_1 = "资源记录类型不支持\n记录序列号:1\n资源记录:"
				err_info_2 = "资源记录格式无效\n记录序列号:1\n资源记录:"
				args[:error_type] = 'after_OK'
				d_1 = {'rname'=>'1215', 'rtype'=>'A', 'rdata'=>'192.168.12.15', 'ttl'=>'36oo'}
				d_2 = {'rname'=>'1215', 'rtype'=>'A', 'rdata'=>'19@.168.12.15', 'ttl'=>'3600'}
				d_3 = {'rname'=>'1215', 'rtype'=>'Q', 'rdata'=>'192.168.12.15', 'ttl'=>'3600'}
				d_4 = {'rname'=>'', 'rtype'=>'A', 'rdata'=>'192.168.12.15', 'ttl'=>'3600'}
				begin
					r << Zone_er.create_zone(args)
					r << DNS.goto_zone_page(args)
					# 资源记录类型不支持
					args[:error_info]  = "#{err_info_1}1215.zone.1215. 36 ANY oo IN A 192.168.12.15"
					args[:domain_list] = [d_1]
					r << DNS.inputs_batch_domain_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					# 资源记录格式无效
					[d_2, d_3, d_4].each do |rr|
						args[:domain_list] = [rr]
						r << DNS.inputs_batch_domain_dialog(args)
						args[:error_info] = "#{err_info_2}#{rr['rname']} #{rr['ttl']} #{rr['rtype']} #{rr['rdata']}"
						r << DNS.error_validator_on_popwin(args)
					end
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1338(args)
				# 删除单条/多条记录
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:view_name]   = "view_#{@case_ID}"
				args[:zone_name]   = "zone.#{@case_ID}"
				args[:owner_list]  = Node_Name_List
				@ttl               = '3600'
				args[:domain_list] = [
					{'rname'=>'a', 'rtype'=>'A', 'rdata'=>'192.168.13.38', 'ttl'=>@ttl},
					{'rname'=>'mx', 'rtype'=>'MX', 'rdata'=>'2 mx.com.', 'ttl'=>@ttl},
					{'rname'=>'ns', 'rtype'=>'NS', 'rdata'=>'2nd.ns.com.', 'ttl'=>@ttl},
					{'rname'=>'aaaa', 'rtype'=>'AAAA', 'rdata'=>'fe80::4c0b:1338', 'ttl'=>@ttl},
					{'rname'=>'cname', 'rtype'=>'CNAME', 'rdata'=>'dns.zdns.cn.', 'ttl'=>@ttl},
					{'rname'=>'dname', 'rtype'=>'DNAME', 'rdata'=>'ip6.tla-1.net.', 'ttl'=>@ttl},
					{'rname'=>'srv', 'rtype'=>'SRV', 'rdata'=>'1 0 9 sysadmins-box.zdns.cn.', 'ttl'=>@ttl},
					{'rname'=>'ptr', 'rtype'=>'PTR', 'rdata'=>'dns.zdns.cn.', 'ttl'=>@ttl},
					{'rname'=>'naptr', 'rtype'=>'NAPTR', 'rdata'=>'101 10 "u" "sip+E2U" "!^.*$!sip:userA@zdns.cn!" .', 'ttl'=>@ttl}]
				begin
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					r << Domain_er.del_domain(args)
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1285(args)
				# 编辑单条记录
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:acl_name]    = "acl_#{@case_ID}"
				args[:acl_list]    = Local_Network
				args[:view_name]   = "view_#{@case_ID}"
				args[:zone_name]   = "zone.#{@case_ID}"
				args[:owner_list]  = Node_Name_List
				args[:domain_list] = [
					{'rname'=>'a', 'rtype'=>'A', 'rdata'=>'192.168.12.85', 'ttl'=>'3600'},
					{'rname'=>'ns', 'rtype'=>'NS', 'rdata'=>'2nd.ns.com.', 'ttl'=>'3600'},
					{'rname'=>'aaaa', 'rtype'=>'AAAA', 'rdata'=>'fe80::4c0b', 'ttl'=>'3600'},
					{'rname'=>'mx', 'rtype'=>'MX', 'rdata'=>'2 mx.com.', 'ttl'=>'3600'}, 
					{'rname'=>'cname', 'rtype'=>'CNAME', 'rdata'=>'dns.zdns.cn.', 'ttl'=>'3600'},
					{'rname'=>'dname', 'rtype'=>'DNAME', 'rdata'=>'ip6.tla-1.net.', 'ttl'=>'3600'},
					{'rname'=>'txt', 'rtype'=>'TXT', 'rdata'=>'text_record', 'ttl'=>'3600'},
					{'rname'=>'srv', 'rtype'=>'SRV', 'rdata'=>'1 0 9 sysadmins-box.zdns.cn.', 'ttl'=>'3600'},
					{'rname'=>'ptr', 'rtype'=>'PTR', 'rdata'=>'dns.zdns.cn.', 'ttl'=>'3600'},
					{'rname'=>'naptr', 'rtype'=>'NAPTR', 'rdata'=>'101 10 "u" "sip+E2U" "!^.*$!sip:userA@zdns.cn!" .', 'ttl'=>'3600'}]
				begin
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					args[:domain_list].each do |domain|
						args[:domain_name] = domain['rname'] + ".#{args[:zone_name]}"
						args[:rtype]       = domain['rtype']
						Node_IP_List.each do |ip|
							args[:dig_ip] = ip
							r << DNS.dig_as_noerror(args, sleepfirst = false) if args[:rtype] != 'NS'
						end
					end
					args[:domain_list] = [
					{'rname'=>'a', 'rtype'=>'A', 'rdata_old'=>'192.168.12.85', 'rdata_new'=>'192.168.85.12','ttl'=>'3600'},
					{'rname'=>'ns', 'rtype'=>'NS', 'rdata_old'=>'2nd.ns.com.', 'rdata_new'=>'2nd.ns.com.new.','ttl'=>'3600'},
					{'rname'=>'aaaa', 'rtype'=>'AAAA', 'rdata_old'=>'fe80::4c0b', 'rdata_new'=>'fe80::4c0b:1285','ttl'=>'3600'},
					{'rname'=>'mx', 'rtype'=>'MX', 'rdata_old'=>'2 mx.com.', 'rdata_new'=>'2 mx.com.new.', 'ttl'=>'3600'}, 
					{'rname'=>'cname', 'rtype'=>'CNAME', 'rdata_old'=>'dns.zdns.cn.', 'rdata_new'=>'dns.zdns.cn.new.','ttl'=>'3600'},
					{'rname'=>'dname', 'rtype'=>'DNAME', 'rdata_old'=>'ip6.tla-1.net.','rdata_new'=>'ip6.tla-1.net.new.', 'ttl'=>'3600'},
					{'rname'=>'txt', 'rtype'=>'TXT', 'rdata_old'=>'text_record', 'rdata_new'=>'text_record_new', 'ttl'=>'3600'},
					{'rname'=>'srv', 'rtype'=>'SRV', 'rdata_old'=>'1 0 9 sysadmins-box.zdns.cn.', 'rdata_new'=>'1 1 9 sysadmins-box.zdns.cn.', 'ttl'=>'3600'},
					{'rname'=>'ptr', 'rtype'=>'PTR', 'rdata_old'=>'dns.zdns.cn.', 'rdata_new'=>'dns.zdns.com.', 'ttl'=>'3600'},
					{'rname'=>'naptr', 'rtype'=>'NAPTR', 'rdata_old'=>'101 10 "u" "sip+E2U" "!^.*$!sip:userA@zdns.cn!" .', 'rdata_new'=>'11 11 "u" "sip+E2U" "!^.*$!sip:userA@zdns.cn!" .','ttl'=>'3600'}]
					r << Domain_er.edit_domain(args)
					# Dig验证
					args[:domain_list].each do |domain|
						args[:domain_name] = domain['rname'] + ".#{args[:zone_name]}"
						args[:rtype]       = domain['rtype']
						Node_IP_List.each do |ip|
							args[:dig_ip] = ip
							r << DNS.dig_as_noerror(args, sleepfirst = false) if args[:rtype] != 'NS'
						end
					end
					# 清理
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_22502(args)
				# 批量添加中英数字组合相对域名
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:acl_name]   = "acl_#{@case_ID}"
				args[:acl_list]   = Local_Network
				args[:view_name]  = "view_#{@case_ID}"
				args[:owner_list] = Node_Name_List
				args[:zone_name]  = "zone.#{@case_ID}"
				args[:file_name]  = Upload_Dir + 'zone\22502.txt'
				dname_1           = SimpleIDN.to_ascii("2s师.#{args[:zone_name]}").gsub("\n","")
				dname_2           = SimpleIDN.to_ascii("师2s.#{args[:zone_name]}").gsub("\n","")
				dname_list        = [dname_1, dname_2]
				rtype_list        = %w[A AAAA MX SRV DNAME TXT PTR NAPTR]
				begin
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.batch_add_domain(args)
					# 批量添加后查询中文
					r << DNS.goto_zone_page(args)
					['2s师', '师2s'].each do |search_name|
						search_result = DNS.get_all_search_string(search_name)
						r << 'fail' if search_result.size != 9
					end
					# dig
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						rtype_list.each do |rtype|
							args[:rtype] = rtype
							dname_list.each do |dname|
								args[:domain] = dname
								r << DNS.dig_as_noerror(args)
							end
						end
					end
					# 清理
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
        end
	end
end