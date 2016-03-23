# encoding: utf-8
require File.dirname(__FILE__) + '/../../zddi'

module ZDDI
	module DNS
		class Share_rr
				def case_1484(args) 
				# 参数校验
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				@v                = "v#{@case_ID}"
				@z                = "z#{@case_ID}"
				args[:zone_name]  = @z
				args[:owner_list] = Node_Name_List
				rr = {'rname'=>'a', 'rtype'=>'A', 'rdata'=>'192.168.14.84'}
				err_mtl = '增加互斥的资源记录'
				err_rdt = '创建已存在的共享资源记录'
				err_ttl = 'TTL值的范围为:0-2147483647'
				err_ip4 = '输入合法的IPv4地址，例如：192.168.1.1'
				err_ip6 = '输入合法的IPv6地址，例如：2401:8d00:3:2:5054:ff:fe5f:7763'
				begin
					args[:view_name] = @v
					r << View_er.create_view(args)
					[@v, 'default'].each do |vname|
						args[:view_name] = vname
						r << Zone_er.create_zone(args)
					end
					args[:share_rr_owner] = ["default/#{@z}"]
					args[:share_rr] = rr
					r << Share_rr_er.create_share_rr(args)
					# 参数校验
					DNS.open_share_rr_page
					err_list = [
						['A', 'ipv4', '3600', 'before_OK', err_ip4],
						['AAAA', 'ipv6', '3600', 'before_OK', err_ip6],
						['CNAME', 'c.name.', '3600', 'after_OK', err_mtl],
						['A', '192.168.14.84', 'ttl', 'before_OK', err_ttl],
						['A', '192.168.14.84', '3600', 'after_OK', err_rdt]
					]
					err_list.each do |inputs|
						rr['rtype'] = inputs[0]
						rr['rdata'] = inputs[1]
						rr['ttl'] = inputs[2]
						args[:share_rr] = rr
	                	DNS.inputs_share_rr_dialog(args)
	                	args[:error_type] = inputs[3]
	                	args[:error_info] = inputs[4]
	                	r << DNS.error_validator_on_popwin(args)
	                end
					# 清理
					r << Share_rr_er.del_all_share_rr(args)
					args[:view_name] = @v
					r << View_er.del_view(args)
					args[:view_name] = 'default'
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1475(args)
				# 共享记录新建 (ALL Type * 两个视图 * 一个区) / 编辑/ 删除
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				@v                = "v#{@case_ID}"
				@z                = "z#{@case_ID}"
				args[:zone_name]  = @z
				args[:owner_list] = Node_Name_List
				begin
					args[:view_name] = @v
					r << View_er.create_view(args)
					[@v, 'default'].each do |vname|
						args[:view_name] = vname
						r << Zone_er.create_zone(args)
					end
					rr_list = [
					{'rname'=>'a', 'rtype'=>'A', 'rdata'=>'192.168.14.75'},
					{'rname'=>'4a', 'rtype'=>'AAAA', 'rdata'=>'192:168:1475::ADEF'},
					{'rname'=>'mx', 'rtype'=>'MX', 'rdata'=>'2 mx.com.'}, 
					{'rname'=>'cn', 'rtype'=>'CNAME', 'rdata'=>'dns.zdns.cn.'},
					{'rname'=>'dn', 'rtype'=>'DNAME', 'rdata'=>'ip6.tla-1.net.'},
					{'rname'=>'txt', 'rtype'=>'TXT', 'rdata'=>'text_record'},
					{'rname'=>'srv', 'rtype'=>'SRV', 'rdata'=>'1 0 9 sysadmins-box.zdns.cn.'},
					{'rname'=>'ptr', 'rtype'=>'PTR', 'rdata'=>'dns.zdns.cn.'},
					{'rname'=>'nptr', 'rtype'=>'NAPTR', 'rdata'=>'101 10 "u" "sip+E2U" "!^.*$!sip:user@knet.cn!" .'}]
					args[:share_rr_owner] = ["default/#{@z}", "#{@v}/#{@z}"]
					rr_list.each do |rr|
						args[:share_rr] = rr
						r << Share_rr_er.create_share_rr(args)
					end
					# Dig
					args[:server_list] = Node_IP_List
					rr_list.each do |domain|
            			args[:rtype] = domain['rtype']
            			args[:domain_name] = domain['rname'] + '.' + @z
            			args[:actual_rdata] = domain['rdata']
						r << Dig_er.compare_domain(args)
					end
					# 编辑
					rr_list = [
					{'rname'=>'a', 'rtype'=>'A', 'rdata'=>'192.168.14.75', 'rdata_new'=>'192.168.75.41'},
					{'rname'=>'4a', 'rtype'=>'AAAA', 'rdata'=>'192:168:1475::ADEF', 'rdata_new'=>'192:168:7541::ADEF'},
					{'rname'=>'mx', 'rtype'=>'MX', 'rdata'=>'2 mx.com.', 'rdata_new'=>'3 mxmail.com.'}, 
					{'rname'=>'cn', 'rtype'=>'CNAME', 'rdata'=>'dns.zdns.cn.', 'rdata_new'=>'zdns.cn.'},
					{'rname'=>'dn', 'rtype'=>'DNAME', 'rdata'=>'ip6.tla-1.net.', 'rdata_new'=>'ip4.tla-1.net.'},
					{'rname'=>'txt', 'rtype'=>'TXT', 'rdata'=>'text_record', 'rdata_new'=>'strings'},
					{'rname'=>'srv', 'rtype'=>'SRV', 'rdata'=>'1 0 9 sysadmins-box.zdns.cn.', 'rdata_new'=>'9 1 1 box.zdns.cn.'},
					{'rname'=>'ptr', 'rtype'=>'PTR', 'rdata'=>'dns.zdns.cn.', 'rdata_new'=>'ptr.zdns.cn.'},
					{'rname'=>'nptr', 'rtype'=>'NAPTR', 'rdata'=>'101 10 "u" "sip+E2U" "!^.*$!sip:user@knet.cn!" .', 'rdata_new'=>'10 101 "u" "sip+E2U" "!^.*$!sip:someone@knet.cn!" .'}]
					rr_list.each do |rr|
						args[:share_rr] = rr
						r << Share_rr_er.edit_share_rr(args)
					end
					# Dig
					args[:server_list] = Node_IP_List
					rr_list.each do |domain|
            			args[:rtype] = domain['rtype']
            			args[:domain_name] = domain['rname'] + '.' + @z
            			args[:actual_rdata] = domain['rdata_new']
						r << Dig_er.compare_domain(args)
					end
					# 删除
					r << Share_rr_er.del_all_share_rr(args)
					# Dig
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						rr_list.each do |domain|
	            			args[:rtype] = domain['rtype']
	            			args[:domain_name] = domain['rname'] + '.' + @z
							r << DNS.dig_as_nxdomain(args)
						end
					end
					# 清理
					args[:view_name] = @v
					r << View_er.del_view(args)
					args[:view_name] = 'default'
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1631(args) 
				# 修改所属区
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				@v                = "v#{@case_ID}"
				@z                = "z#{@case_ID}"
				args[:zone_name]  = @z
				args[:owner_list] = Node_Name_List
				begin
					args[:view_name] = @v
					r << View_er.create_view(args)
					[@v, 'default'].each do |vname|
						args[:view_name] = vname
						r << Zone_er.create_zone(args)
					end
					rr_list = [
					{'rname'=>'a', 'rtype'=>'A', 'rdata'=>'192.168.14.75'},
					{'rname'=>'aaaa', 'rtype'=>'AAAA', 'rdata'=>'192:168:1475::ADEF'},
					{'rname'=>'mx', 'rtype'=>'MX', 'rdata'=>'2 mx.com.'}, 
					{'rname'=>'cname', 'rtype'=>'CNAME', 'rdata'=>'dns.zdns.cn.'},
					{'rname'=>'dname', 'rtype'=>'DNAME', 'rdata'=>'ip6.tla-1.net.'},
					{'rname'=>'txt', 'rtype'=>'TXT', 'rdata'=>'text_record'},
					{'rname'=>'srv', 'rtype'=>'SRV', 'rdata'=>'1 0 9 sysadmins-box.zdns.cn.'},
					{'rname'=>'ptr', 'rtype'=>'PTR', 'rdata'=>'dns.zdns.cn.'},
					{'rname'=>'naptr', 'rtype'=>'NAPTR', 'rdata'=>'101 10 "u" "sip+E2U" "!^.*$!sip:userA@zdns.cn!" .'}]
					args[:share_rr_owner] = ["default/#{@z}"]
					rr_list.each do |rr|
						args[:share_rr] = rr
						r << Share_rr_er.create_share_rr(args)
					end
					# 修改所属区 A -> A + B
					args[:old_share_rr_owner] = ["default/#{@z}"]
					args[:new_share_rr_owner] = ["default/#{@z}", "#{@v}/#{@z}"]
					rr_list.each do |rr|
						args[:share_rr] = rr
						r << Share_rr_er.modify_share_rr_owner(args)
					end
					# Dig
					args[:server_list] = Node_IP_List
					rr_list.each do |domain|
            			args[:rtype] = domain['rtype']
            			args[:domain_name] = domain['rname'] + '.' + @z
            			args[:actual_rdata] = domain['rdata']
						r << Dig_er.compare_domain(args)
					end
					# 修改所属区  A + B -> B
					args[:old_share_rr_owner] = ["default/#{@z}", "#{@v}/#{@z}"]
					args[:new_share_rr_owner] = ["#{@v}/#{@z}"]
					rr_list.each do |rr|
						args[:share_rr] = rr
						r << Share_rr_er.modify_share_rr_owner(args)
					end
					# Dig
					args[:server_list] = Node_IP_List
					rr_list.each do |domain|
            			args[:rtype] = domain['rtype']
            			args[:domain_name] = domain['rname'] + '.' + @z
            			args[:actual_rdata] = domain['rdata']
						r << Dig_er.compare_domain(args)
					end
					# 清理
					r << Share_rr_er.del_all_share_rr(args)
					args[:view_name] = @v
					r << View_er.del_view(args)
					args[:view_name] = 'default'
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_14288(args) 
				# 添加节点
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				@v                = "v#{@case_ID}"
				@z                = "z#{@case_ID}"
				args[:zone_name]  = @z
				args[:owner_list] = [Master_Device]
				# begin
					# 删除节点
					args[:node_name] = Slave_Device
					Cloud.del_device(args)
					args[:view_name] = @v
					r << View_er.create_view(args)
					[@v, 'default'].each do |vname|
						args[:view_name] = vname
						r << Zone_er.create_zone(args)
					end
					rr_list = [
					{'rname'=>'a', 'rtype'=>'A', 'rdata'=>'192.168.14.75'},
					{'rname'=>'aaaa', 'rtype'=>'AAAA', 'rdata'=>'192:168:1475::ADEF'},
					{'rname'=>'mx', 'rtype'=>'MX', 'rdata'=>'2 mx.com.'}, 
					{'rname'=>'cname', 'rtype'=>'CNAME', 'rdata'=>'dns.zdns.cn.'},
					{'rname'=>'dname', 'rtype'=>'DNAME', 'rdata'=>'ip6.tla-1.net.'},
					{'rname'=>'txt', 'rtype'=>'TXT', 'rdata'=>'text_record'},
					{'rname'=>'srv', 'rtype'=>'SRV', 'rdata'=>'1 0 9 sysadmins-box.zdns.cn.'},
					{'rname'=>'ptr', 'rtype'=>'PTR', 'rdata'=>'dns.zdns.cn.'},
					{'rname'=>'naptr', 'rtype'=>'NAPTR', 'rdata'=>'101 10 "u" "sip+E2U" "!^.*$!sip:userA@zdns.cn!" .'}]
					args[:share_rr_owner] = ["default/#{@z}", "#{@v}/#{@z}"]
					rr_list.each do |rr|
						args[:share_rr] = rr
						r << Share_rr_er.create_share_rr(args)
					end
					# 添加节点
					args[:new_group_name] = Slave_Group
					args[:node_name]      = Slave_Device
					args[:node_ip]        = Slave_IP
					Cloud.add_device(args)
					# 修改区所属节点
					args[:view_name] = 'default'
					args[:old_owner_list] = [Master_Device]
            		args[:new_owner_list] = Node_Name_List
					r << Zone_er.modify_zone_member(args)
					# Dig
					args[:server_list] = Node_IP_List
					rr_list.each do |domain|
            			args[:rtype] = domain['rtype']
            			args[:domain_name] = domain['rname'] + '.' + @z
            			args[:actual_rdata] = domain['rdata']
						r << Dig_er.compare_domain(args)
					end
					# 清理
					r << Share_rr_er.del_all_share_rr(args)
					args[:view_name] = @v
					r << View_er.del_view(args)
					args[:view_name] = 'default'
					r << Zone_er.del_zone(args)
				# rescue
				# 	puts "unknown error on #{@case_ID}"
				# 	return "failed case #{@case_ID}"
				# end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_25959(args)
				# 中文共享记录新建 (ALL Type * 两个视图 * 一个区) / 编辑/ 删除
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				@v                = "共享记录视图"
				@z                = "共享记录区"
				args[:zone_name]  = @z
				args[:owner_list] = Node_Name_List
				# begin
					args[:view_name] = @v
					r << View_er.create_view(args)
					[@v, 'default'].each do |vname|
						args[:view_name] = vname
						r << Zone_er.create_zone(args)
					end
					rr_list = [
					{'rname'=>'中文', 'rtype'=>'A', 'rdata'=>'192.168.14.75'},
					{'rname'=>'中文', 'rtype'=>'AAAA', 'rdata'=>'192:168:1475::ADEF'},
					{'rname'=>'中文', 'rtype'=>'MX', 'rdata'=>'2 mx.com.'}, 
					{'rname'=>'中文别名', 'rtype'=>'CNAME', 'rdata'=>'dns.zdns.cn.'},
					{'rname'=>'中文', 'rtype'=>'DNAME', 'rdata'=>'ip6.tla-1.net.'},
					{'rname'=>'中文', 'rtype'=>'TXT', 'rdata'=>'text_record'},
					{'rname'=>'中文', 'rtype'=>'SRV', 'rdata'=>'1 0 9 sysadmins-box.zdns.cn.'},
					{'rname'=>'中文', 'rtype'=>'PTR', 'rdata'=>'dns.zdns.cn.'},
					{'rname'=>'中文', 'rtype'=>'NAPTR', 'rdata'=>'101 10 "u" "sip+E2U" "!^.*$!sip:user@knet.cn!" .'}]
					args[:share_rr_owner] = ["default/#{@z}", "#{@v}/#{@z}"]
					rr_list.each do |rr|
						args[:share_rr] = rr
						r << Share_rr_er.create_share_rr(args)
					end
					# Dig
					args[:server_list] = Node_IP_List
					rr_list.each do |domain|
            			args[:rtype] = domain['rtype']
            			args[:domain_name] = SimpleIDN.to_ascii(domain['rname'] + '.' + @z)
            			args[:actual_rdata] = domain['rdata']
						r << Dig_er.compare_domain(args)
					end
					# 编辑
					rr_list = [
					{'rname'=>'中文', 'rtype'=>'A', 'rdata'=>'192.168.14.75', 'rdata_new'=>'192.168.75.41'},
					{'rname'=>'中文', 'rtype'=>'AAAA', 'rdata'=>'192:168:1475::ADEF', 'rdata_new'=>'192:168:7541::ADEF'},
					{'rname'=>'中文', 'rtype'=>'MX', 'rdata'=>'2 mx.com.', 'rdata_new'=>'3 mxmail.com.'}, 
					{'rname'=>'中文别名', 'rtype'=>'CNAME', 'rdata'=>'dns.zdns.cn.', 'rdata_new'=>'zdns.cn.'},
					{'rname'=>'中文', 'rtype'=>'DNAME', 'rdata'=>'ip6.tla-1.net.', 'rdata_new'=>'ip4.tla-1.net.'},
					{'rname'=>'中文', 'rtype'=>'TXT', 'rdata'=>'text_record', 'rdata_new'=>'strings'},
					{'rname'=>'中文', 'rtype'=>'SRV', 'rdata'=>'1 0 9 sysadmins-box.zdns.cn.', 'rdata_new'=>'9 1 1 box.zdns.cn.'},
					{'rname'=>'中文', 'rtype'=>'PTR', 'rdata'=>'dns.zdns.cn.', 'rdata_new'=>'ptr.zdns.cn.'},
					{'rname'=>'中文', 'rtype'=>'NAPTR', 'rdata'=>'101 10 "u" "sip+E2U" "!^.*$!sip:user@knet.cn!" .', 'rdata_new'=>'10 101 "u" "sip+E2U" "!^.*$!sip:someone@knet.cn!" .'}]
					rr_list.each do |rr|
						args[:share_rr] = rr
						r << Share_rr_er.edit_share_rr(args)
					end
					# Dig
					args[:server_list] = Node_IP_List
					rr_list.each do |domain|
            			args[:rtype] = domain['rtype']
            			args[:domain_name] = SimpleIDN.to_ascii(domain['rname'] + '.' + @z)
            			args[:actual_rdata] = domain['rdata_new']
						r << Dig_er.compare_domain(args)
					end
					# 删除
					r << Share_rr_er.del_all_share_rr(args)
					# Dig
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						rr_list.each do |domain|
	            			args[:rtype] = domain['rtype']
	            			args[:domain_name] = SimpleIDN.to_ascii(domain['rname'] + '.' + @z)
							r << DNS.dig_as_nxdomain(args)
						end
					end
					# 清理
					args[:view_name] = @v
					r << View_er.del_view(args)
					args[:view_name] = 'default'
					r << Zone_er.del_zone(args)
				# rescue
				# 	puts "unknown error on #{@case_ID}"
				# 	return "failed case #{@case_ID}"
				# end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
		end
	end
end