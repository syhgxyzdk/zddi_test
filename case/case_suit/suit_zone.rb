# encoding: utf-8
require File.dirname(__FILE__) + '/../../zddi'
module ZDDI
	module DNS
		class Zone
			def case_823(args)
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:view_name]  = "view_#{@case_ID}"
				args[:zone_name]  = "zone.#{@case_ID}"
				args[:owner_list] = Node_Name_List
				begin
					# 创建视图+正向主区
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_834(args)
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:view_name]  = "view_#{@case_ID}"
				args[:owner_list] = Node_Name_List
				begin
					# 创建视图+反向主区
					r << View_er.create_view(args)
					args[:zone_name]  = "192.168.1.0/8"
					args[:zone_type]  = "in-addr"
					r << Zone_er.create_zone(args)
					args[:zone_name]  = "192.168.2.0/16"
					args[:zone_type]  = "in-addr"
					r << Zone_er.create_zone(args)
					args[:zone_name]  = "192.168.3.0/24"
					args[:zone_type]  = "in-addr"
					r << Zone_er.create_zone(args)
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_844(args)
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:view_name]  = "view_#{@case_ID}"
				args[:owner_list] = Node_Name_List
				begin
					# 创建视图+正向主区命名验证
					r << View_er.create_view(args)
					r << DNS.goto_view_page(args)
					args[:zone_name]  = "#()@)"
					args[:error_info] = "区名格式不正确"
					args[:error_type] = "before_OK"
					DNS.inputs_create_zone_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					args[:zone_name]  = " space in zone name "
					args[:error_info] = "区名格式不正确"
					args[:error_type] = "before_OK"
					DNS.inputs_create_zone_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					args[:zone_name]  = "*"
					args[:error_info] = "区名称无效"
					args[:error_type] = "after_OK"  # after OK
					DNS.inputs_create_zone_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					args[:zone_name]  = "ZoneName_CanNot_MoreThan_32Characters"
					DNS.inputs_create_zone_dialog(args)
					get_name = DNS.popwin.text_field(:name, "name").value
					DNS.popwin.button(:class, "cancel").click
					r << (get_name.size == 32) ? "succeed" : "failed"
					# 中英文下划线连字符混合区名
					args[:zone_name] = "中文-eng_区名-zonename"
					r << Zone_er.create_zone(args)
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_5919(args)
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:view_name]  = "view_#{@case_ID}"
				args[:zone_name]  = "zone.#{@case_ID}"
				args[:owner_list] = Node_Name_List
				begin
					r << View_er.create_view(args)
					r << DNS.goto_view_page(args)
					err_list = ["@!.1.!", "192.168.1.1.1","192.168.1.2#655361", "192.168.1#53"]
					err_list.each do |err|
						args[:slave_server] = err
						args[:error_info]   = "非法的服务器列表"
						args[:error_type]   = "before_OK"
						DNS.inputs_create_zone_dialog(args)
						r << DNS.error_validator_on_popwin(args)
					end
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_2743(args)
				@case_ID                    = __method__.to_s.split('_')[1]
				r                           = []
				args[:view_name]            = "view_#{@case_ID}"
				args[:zone_name]            = "zone.#{@case_ID}"
				args[:owner_list]           = Node_Name_List
				args[:owner]                = Node_Name_List
				args[:error_info]           = "请输入正确的IP地址或端口号, 例如: 192.168.1.10#53"
				args[:error_type]           = "before_OK"
				args[:source_type]          = "zone_transfer"
				args[:zone_transfer_server] = "2.7.4.3#2.3"
				begin
					r << View_er.create_view(args)
					DNS.goto_view_page(args)
					DNS.inputs_create_zone_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_869(args)
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:view_name]   = "view_#{@case_ID}"
				args[:zone_name]   = "zone.#{@case_ID}"
				args[:owner_list]  = Node_Name_List
				args[:owner]       = Node_Name_List
				args[:error_info]  = "区传送失败"
				args[:error_type]  = "after_OK"
				args[:source_type] = "zone_transfer"
				begin
					r << View_er.create_view(args)
					r << DNS.goto_view_page(args)
					args[:zone_transfer_server] = "192.168.8.69"
					DNS.inputs_create_zone_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					args[:zone_transfer_server] = "192.168.8.69#8080"
					DNS.inputs_create_zone_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_860(args)
				@case_ID              = __method__.to_s.split('_')[1]
				r                     = []
				args[:view_name]      = "view_#{@case_ID}"
				args[:zone_name]      = "zone.#{@case_ID}"
				args[:owner_list]     = Node_Name_List
				args[:source_type]    = "zone_file"
				args[:zone_file_name] = Upload_Dir + 'zone\860.txt'
				rr_list               = [
							["ns", "A", "192.168.8.60"],
							["aaaa", "AAAA", "FF::8600"],
							["mx", "MX", "8 mx.mail.com."],
							["cname", "CNAME", "cname.860.com."],
							["dname", "DNAME", "dname.zone.860."],
							["txt",	"TXT", "txt.zone.860"]
										]
				begin
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					# 检查rr
					r << DNS.goto_zone_page(args)
					rr_list.each do |rlist|
						args[:rname] = rlist[0]
						args[:rtype] = rlist[1]
						args[:rdata] = rlist[2]
						r << DNS.check_on_single_domain(args)
					end
					# 操作日志
					@nodes = "#{Master_Group}.#{Master_Device} #{Slave_Group}.#{Slave_Device}"
					args[:log_string] = "创建正向区'#{args[:view_name]}/#{args[:zone_name]}'至设备'#{@nodes}'"
				    r << System.log_validator_on_audit_log_page(args)
					r << View_er.del_view(args)
					puts r
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_8348(args)
				@case_ID            = __method__.to_s.split('_')[1]
				r                   = []
				args[:view_name]    = "view_#{@case_ID}"
				args[:zone_name]    = "zone.#{@case_ID}"
				args[:owner_list]   = Node_Name_List
				slave_ip1           = '192.168.83.48'
				slave_ip2           = '192.168.48.83'
				args[:modify_slave] = 'yes'
				begin
					args[:slave_server] = slave_ip1
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					args[:keyword]      = slave_ip1
					r << DNS.grep_keyword_named(args)
					# 编辑
					args[:slave_server] = slave_ip2
					r << Zone_er.edit_zone(args)
					args[:keyword]      = slave_ip2
					r << DNS.grep_keyword_named(args)
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_8347(args)
				@case_ID         = __method__.to_s.split('_')[1]
				r                = []
				args[:view_name] = "view_#{@case_ID}"
				args[:zone_name] = "zone.#{@case_ID}"
				begin
				    r << Zone_er.create_slave_zone_on_master(args)
					args[:modify_master] = "yes"
					args[:master_server] = "#{Slave_IP}\n192.168.83.47"
					r << Zone_er.edit_zone(args)
					# grep
					args[:keyword]       = "192.168.83.47"
					args[:owner_list]    = [Master_Device]
				    r << DNS.grep_keyword_named(args)
				    # 清理
				    r << View_er.del_view(args)
				    args[:view_name] = "default"
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_867(args)
				# 新建->区拷贝
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				view              = "view_#{@case_ID}"
				args[:zone_name]  = "zone.#{@case_ID}"
				args[:owner_list] = Node_Name_List
				begin
					args[:view_name] = view
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					# 在default视图下copy区
					args[:view_name]      = 'default'
					args[:source_type]    = 'zone_copy'
					args[:zone_copy_name] = "zone.#{@case_ID}"
					r << Zone_er.create_zone(args)
					# 清理
					args[:view_name] = 'default'
					r << Zone_er.del_zone(args)
					view = "view_#{@case_ID}"
					args[:view_name] = view
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_839(args)
				# Master上建辅区
				@case_ID         = __method__.to_s.split('_')[1]
				r                = []
				args[:view_name] = "view_#{@case_ID}"
				args[:zone_name] = "zone.#{@case_ID}"
				begin
					r << Zone_er.create_slave_zone_on_master(args)
					r << View_er.del_view(args)
					args[:view_name] = 'default'
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_840(args)
				# 建反向辅区
				@case_ID            = __method__.to_s.split('_')[1]
				r                   = []
				args[:view_name]    = "view_#{@case_ID}"
				args[:zone_type]    = "in-addr"
				args[:zone_name]    = "192.168.84.0/24"
				args[:slave_server] = Master_IP
				args[:owner_list]   = [Slave_Device]
				begin
					r << Zone_er.create_slave_zone_on_master(args)
					# 清理
					r << View_er.del_view(args)
					args[:view_name] = 'default'
					args[:zone_name] = DNS.zone_name_to_arpa(args)
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_10916(args)
				# 区传送
				@case_ID            = __method__.to_s.split('_')[1]
				r                   = []
				args[:view_name]    = "view_#{@case_ID}"
				args[:zone_name]    = "zone.#{@case_ID}"
				args[:acl_name]     = "acl_#{@case_ID}"
				args[:acl_list]     = [Master_IP]
				args[:slave_server] = Master_IP
				args[:owner_list]   = [Slave_Device]
				begin
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					# Slave节点建主区
					r << Zone_er.create_zone(args)
					# Master节点建区, 区传送地址为Slave IP
					args[:view_name]			= "default"
					args[:source_type]          = "zone_transfer"
					args[:zone_transfer_server] = Slave_IP
					args[:owner_list]           = [Master_Device]
					r << Zone_er.create_zone(args)
					# 清理
					r << Zone_er.del_zone(args)
					args[:view_name] = "view_#{@case_ID}"
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_2742(args)
				# 区拷贝,反向区
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				view              = "view_#{@case_ID}"
				args[:zone_type]  = "in-addr"
				args[:zone_name]  = "192.168.27.0/24"
				args[:owner_list] = Node_Name_List
				begin
					args[:view_name] = view
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					# 拷贝
					args[:view_name]      = 'default'
					args[:source_type]    = 'zone_copy'
					arpa_name = DNS.zone_name_to_arpa(args)
					args[:zone_copy_name] = arpa_name
					r << Zone_er.create_zone(args)
					# 清理
					args[:view_name] = view
					r << View_er.del_view(args)
					args[:view_name] = "default" # 删除default视图下的反向区
					args[:zone_name] = arpa_name
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1010(args)
				# nsupdate命令写入文件
				@case_ID = __method__.to_s.split('_')[1]
				r        = []
				begin
					args[:acl_name] = "acl_#{@case_ID}"
					args[:acl_list] = Local_Network
					r << ACL_er.create_acl(args)
					args[:view_name]  = 'default'
					args[:enable_ad]  = 'yes'
					args[:zone_name]  = "zone.#{@case_ID}"
					args[:owner_list] = [Master_Device]
					r << Zone_er.create_zone(args)
					# 调用nsupdate
					args[:rname]   = "a.#{args[:zone_name]}"
					args[:rtype]   = 'A'
					args[:rdata]   = '192.168.10.10'
					@nsupdate_file = File.new(Upload_Dir + '\nsupdate\1010.txt', 'w')
					@nsupdate_file.puts "server #{Master_IP}\nzone #{args[:zone_name]}\nupdate add #{args[:rname]} 3600 IN #{args[:rtype]} #{args[:rdata]}\nsend\n"
					@nsupdate_file.close
					nsupdate = `#{Upload_Dir}nsupdate\\nsupdate #{Upload_Dir}nsupdate\\1010.txt`
					# Dig
					args[:server_list]  = [Master_IP]
					args[:domain_name]  = args[:rname]
					args[:actual_rdata] = args[:rdata]
					r << Dig_er.compare_domain(args)
					# 清理
					r << Zone_er.del_zone(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1019(args)
				# nsupdate 数据
				@case_ID = __method__.to_s.split('_')[1]
				r        = []
				begin
					args[:view_name]  = "default"
					args[:zone_name]  = "zone.#{@case_ID}"
					args[:owner_list] = [Master_Device]
					r << Zone_er.create_zone(args)
					args[:acl_name]  = "acl_#{@case_ID}"
					args[:acl_list]  = Local_Network
					r << ACL_er.create_acl(args)
					args[:modify_ad] = 'yes'
					r << Zone_er.edit_zone(args)
					# 调用nsupdate
					args[:rname]   = "a.#{args[:zone_name]}"
					args[:rtype]   = "A"
					args[:rdata]   = "192.168.10.19"
					@nsupdate_file = File.new(Upload_Dir + '\nsupdate\1019.txt', 'w')
					@nsupdate_file.puts "server #{Master_IP}\nzone #{args[:zone_name]}\nupdate add #{args[:rname]} 3600 IN #{args[:rtype]} #{args[:rdata]}\nsend\n"
					@nsupdate_file.close
					nsupdate = `#{Upload_Dir}nsupdate\\nsupdate #{Upload_Dir}nsupdate\\1019.txt`
					# Dig
					args[:server_list]  = [Master_IP]
					args[:domain_name]  = args[:rname]
					args[:actual_rdata] = args[:rdata]
					r << Dig_er.compare_domain(args)
					# 清理
					r << Zone_er.del_zone(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1020(args)
				@case_ID = __method__.to_s.split('_')[1]
				r        = []
				begin
					args[:view_name]  = "default"
					args[:zone_name]  = "zone.#{@case_ID}"
					args[:owner_list] = [Master_Device]
					r << Zone_er.create_zone(args)
					args[:acl_name]  = "acl_#{@case_ID}"
					args[:acl_list]  = ["192.168.10.20"]
					r << ACL_er.create_acl(args)
					args[:modify_ad] = 'yes'
					r << Zone_er.edit_zone(args)
					# 调用nsupdate
					args[:rname] = "a.#{args[:zone_name]}"
					args[:rtype] = 'A'
					args[:rdata] = '192.168.10.20'
					@nsupdate_file = File.new(Upload_Dir + '\nsupdate\1020.txt', 'w')
					@nsupdate_file.puts "server #{Master_IP}\nzone #{args[:zone_name]}\nupdate add #{args[:rname]} 3600 IN #{args[:rtype]} #{args[:rdata]}\nsend\n"
					@nsupdate_file.close
					# Refused!
					puts "Case:#{@case_ID }, nsupdate should be refused as expected!"
					ns_cmd = `#{Upload_Dir}nsupdate\\nsupdate #{Upload_Dir}nsupdate\\1020.txt`
					# Dig验证NXDOMAIN
					args[:dig_ip]      = Master_IP
					args[:domain_name] = args[:rname]
					r << DNS.dig_as_nxdomain(args)
					# 清理
					r << Zone_er.del_zone(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1014(args)
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:view_name]  = "view_#{@case_ID}"
				args[:zone_name]  = "zone.#{@case_ID}"
				args[:owner_list] = Node_Name_List
				args[:keyword]    = args[:zone_name]
				begin
					# 创建区=>改节点=>dig
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					args[:owner_list] = Node_Name_List
					r << DNS.grep_keyword_named(args)
					args[:old_owner_list] = Node_Name_List
					args[:new_owner_list] = [Slave_Device]
					r << Zone_er.modify_zone_member(args)
				    args[:owner_list] = [Master_Device]
				    r << DNS.grep_keyword_named(args, keyword_gone = true)
				    args[:owner_list] = [Slave_Device]
				    r << DNS.grep_keyword_named(args)
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1012(args)
				@case_ID         = __method__.to_s.split('_')[1]
				r                = []
				args[:view_name] = "view_#{@case_ID}"
				args[:zone_name] = "zone.#{@case_ID}"
				args[:keyword]   = args[:zone_name]
				begin
					# 创建区=>改节点=>dig
					args[:owner_list] = Node_Name_List
					r << View_er.create_view(args)
					args[:owner_list] = [Master_Device]
					r << Zone_er.create_zone(args)
					r << DNS.grep_keyword_named(args)
				    args[:owner_list] = [Slave_Device]
					r << DNS.grep_keyword_named(args, keyword_gone = true)
					args[:old_owner_list] = [Master_Device]
					args[:new_owner_list] = Node_Name_List
					r << Zone_er.modify_zone_member(args)
				    args[:owner_list] = args[:new_owner_list]
				    r << DNS.grep_keyword_named(args)
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_848(args)
				# 异步数据更新(DNS关闭)
				@case_ID = __method__.to_s.split('_')[1]
				r        = []
				begin
					args[:node_name] = Slave_Device
					r << Cloud.stop_device_dns_service(args)
					args[:owner_list]  = Node_Name_List
					args[:view_name]   = "view_#{@case_ID}"
					args[:zone_name]   = "zone.#{@case_ID}"
				    r << View_er.create_view(args)
				    r << Zone_er.create_zone(args)
				    # grep master should pass
				    args[:keyword]    = args[:zone_name]
				    args[:owner_list] = [Master_Device]
				    r << DNS.grep_keyword_named(args)
				    # grep slave should fail
				    args[:owner_list] = [Slave_Device]
				    r << DNS.grep_keyword_named(args, keyword_gone = true)
	    			r << Cloud.start_device_dns_service(args)
				    # grep slave should pass after DNS start
				    args[:owner_list] = [Slave_Device]
				    r << DNS.grep_keyword_named(args)
				    # clean up
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_11625(args)
				# 异步数据更新(节点断开)
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:owner_list]  = Node_Name_List
				args[:view_name]   = "view_#{@case_ID}"
				args[:zone_name]   = "zone_#{@case_ID}"
				args[:keyword]     = args[:zone_name]
				args[:group_name]  = Slave_Group
				args[:node_name] = Slave_Device
				begin
				    r << Cloud.disconnect_device(args)
				    r << View_er.create_view(args)
				    r << Zone_er.create_zone(args)
				    # grep master should pass
				    args[:owner_list] = [Master_Device]
				    r << DNS.grep_keyword_named(args)
				    # grep slave should fail
				    args[:owner_list] = [Slave_Device]
				    r << DNS.grep_keyword_named(args, keyword_gone = true)
	    			r << Cloud.connect_device(args)
				    # grep slave should pass after DNS start
				    args[:owner_list] = [Slave_Device]
				    r << DNS.grep_keyword_named(args)
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1016(args)
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:owner_list] = Node_Name_List
				args[:view_name]  = "view_#{@case_ID}"
				args[:zone_name]  = "zone_#{@case_ID}"
				args[:keyword]    = args[:zone_name]
				begin
				    r << View_er.create_view(args)
				    r << Zone_er.create_zone(args)
				    # grep should pass
				    r << DNS.grep_keyword_named(args)
				    # 删除区
					r << Zone_er.del_zone(args)
				    # grep should fail
					r << DNS.grep_keyword_named(args, keyword_gone = true)
				    r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1018(args)
				@case_ID          = __method__.to_s.split('_')[1]
				r			    = []
				args[:view_name] = "view_#{@case_ID}"
				args[:zone_name] = "zone_#{@case_ID}"
				args[:keyword]   = args[:zone_name]
				begin
				    r << Zone_er.create_slave_zone_on_master(args)
				    # grep should pass
    				args[:owner_list] = [Master_Device]
				    r << DNS.grep_keyword_named(args)
	    			# 删除辅区
					r << Zone_er.del_zone(args)
					# grep should fail
					r << DNS.grep_keyword_named(args, keyword_gone = true)
	    			# 清理
	    			r << View_er.del_view(args)
	    			args[:view_name] = "default"
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_11573(args)
				@case_ID         = __method__.to_s.split('_')[1]
				r                = []
				args[:view_name] = "view_#{@case_ID}"
				args[:zone_type] = "in-addr"
				args[:zone_name] = "192.168.115.73/24"
				begin
				    r << Zone_er.create_slave_zone_on_master(args)
				    # grep should pass
				    args[:keyword]    = DNS.zone_name_to_arpa(args)
    				args[:owner_list] = [Master_Device]
				    r << DNS.grep_keyword_named(args) if args[:keyword]
				    # 删除辅区
				    args[:zone_name] = args[:keyword] if args[:keyword]
					r << Zone_er.del_zone(args)
					# grep should fail
					r << DNS.grep_keyword_named(args, keyword_gone = true) if args[:keyword]
				    # 清理
				    r << View_er.del_view(args)
				    args[:view_name] = "default"
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_11574(args)
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:view_name]  = "view_#{@case_ID}"
				args[:zone_type]  = "in-addr"
				args[:zone_name]  = "115.74.0.0/16"
				args[:owner_list] = Node_Name_List
				begin
					r << View_er.create_view(args)
				    r << Zone_er.create_zone(args)
				    # grep should pass
				    args[:keyword]    = DNS.zone_name_to_arpa(args)
				    r << DNS.grep_keyword_named(args) if args[:keyword]
				    # 删除辅区, 注意反向区名已经被转
				    args[:zone_name] = args[:keyword] if args[:keyword]
					r << Zone_er.del_zone(args)
					# grep should fail
					r << DNS.grep_keyword_named(args,keyword_gone = true) if args[:keyword]
				    # 删视图
				    r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1011(args)
				# 修改节点, 异步数据更新(DNS关闭/断开连接)
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:owner_list] = Node_Name_List
				args[:view_name]  = "view_#{@case_ID}"
				args[:zone_name]  = "zone_#{@case_ID}"
				begin
				    # 所有节点新建区
				    r << View_er.create_view(args)
				    r << Zone_er.create_zone(args)
				    # 关闭Slave DNS
				    args[:node_name] = Slave_Device
				    r << Cloud.stop_device_dns_service(args)
				    # 修改节点All -> Master
				    args[:old_owner_list] = Node_Name_List
					args[:new_owner_list] = [Master_Device]
				    r << Zone_er.modify_zone_member(args)
				    # Grep Slave Pass Since not synced to slave
				    args[:keyword]    = args[:zone_name]
				    args[:owner_list] = [Slave_Device]
				    r << DNS.grep_keyword_named(args)
				    # 恢复Slave DNS
				    r << Cloud.start_device_dns_service(args)
					# Grep Slave Fail after synced to slave	    
				    r << DNS.grep_keyword_named(args, keyword_gone = true)
				    # 断开Slave
				    r << Cloud.disconnect_device(args)
				    # 修改节点 Master -> All
				    args[:old_owner_list] = [Master_Device]
					args[:new_owner_list] = Node_Name_List
				    r << Zone_er.modify_zone_member(args)
				    # Grep as no zone_name since not synced back
				    args[:owner_list] = [Slave_Device]
				    r << DNS.grep_keyword_named(args, keyword_gone = true)
				    # 恢复节点
	    			r << Cloud.connect_device(args)
				    # Grep Slave Pass after synced back
				    r << DNS.grep_keyword_named(args)
				    # 清理
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_5150(args)
				@case_ID             = __method__.to_s.split('_')[1]
				r                    = []
				args[:owner_list]    = Node_Name_List
				args[:view_name]     = "default"
				args[:zone_name]     = "zone.#{@case_ID}"
				args[:exported_file] = Download_Dir + "#{args[:zone_name]}.txt"
				begin
					r << Zone_er.create_zone(args)
					r << Zone_er.export_zone(args)
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_11571(args)
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:owner_list] = Node_Name_List
				args[:view_name]  = "default"
				args[:zone_type]  = "in-addr"
				args[:zone_name]  = "192.168.115.71/16"
				begin
					r << Zone_er.create_zone(args)
					args[:zone_name] = DNS.zone_name_to_arpa(args)
					r << Zone_er.export_zone(args)
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_11572(args)
				@case_ID             = __method__.to_s.split('_')[1]
				r                    = []
				args[:view_name]     = "view_#{@case_ID}"
				args[:zone_name]     = "zone.#{@case_ID}"
				args[:exported_file] = Download_Dir + "#{args[:zone_name]}.txt"
				begin
					r << Zone_er.create_slave_zone_on_master(args)
					puts "#{args[:exported_file]}"
					r << Zone_er.export_zone(args)
					r << View_er.del_view(args)
					args[:view_name] = "default"
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_11575(args)
				@case_ID         = __method__.to_s.split('_')[1]
				r                = []
				args[:zone_type] = "in-addr"
				args[:view_name] = "view_#{@case_ID}"
				args[:zone_name] = "192.168.115.75/16"
				begin
					r << Zone_er.create_slave_zone_on_master(args)
					args[:zone_name] = DNS.zone_name_to_arpa(args)
					r << Zone_er.export_zone(args)
					r << View_er.del_view(args)
					args[:view_name] = "default"
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_5953(args)
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:view_name]  = "view_#{@case_ID}"
				args[:zone_name]  = "zone.#{@case_ID}"
				args[:owner_list] = Node_Name_List
				args[:error_info] = "非法的服务器列表"
				args[:error_type] = "before_OK"
				error_port_list   = %w[00 65535 #@! 3.4]
				begin
					# 创建视图+正向主区命名验证
					r << View_er.create_view(args)
					DNS.goto_view_page(args)
					args[:server_type]   = "slave"
					error_port_list.each do |error_port|
						args[:master_server] = Slave_IP + "#" + error_port
						r << DNS.inputs_create_zone_dialog(args)
						r << DNS.error_validator_on_popwin(args)
					end
					# 清理
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_5952(args)
				@case_ID                 = __method__.to_s.split('_')[1]
				r                        = []
				args[:view_name]         = "view_#{@case_ID}"
				args[:zone_name]         = "zone.#{@case_ID}"
				args[:owner_list]        = Node_Name_List
				args[:error_info]        = "非法的服务器列表"
				args[:error_type]        = "before_OK"
				error_master_server_list = %w[192.168.1 @#@ 192.168.5.952]
				begin
					# 创建视图+正向主区命名验证
					r << View_er.create_view(args)
					DNS.goto_view_page(args)
					args[:server_type]   = "slave"
					error_master_server_list.each do |error_master_server|
						args[:master_server] = error_master_server
						r << DNS.inputs_create_zone_dialog(args)
						r << DNS.error_validator_on_popwin(args)
					end
					# 清理
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_5945(args)
				# "无法从后台获取区数据"
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:view_name]  = "view_#{@case_ID}"
				args[:zone_name]  = "zone.#{@case_ID}"
				args[:owner_list] = [Master_Device]
				args[:error_info] = "无法从后台获取区数据"
				args[:error_type] = "after_OK"
				begin
					r << View_er.create_view(args)
					DNS.goto_view_page(args)
					args[:server_type]   = "slave"
					args[:master_server] = Slave_IP
					r << DNS.inputs_create_zone_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					# 清理
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_854(args)
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:view_name]  = "view_#{@case_ID}"
				args[:owner_list] = Node_Name_List
				args[:error_info] = "网络地址格式不正确"
				args[:error_type] = "before_OK"
				error_ip_list     = %w[256.255.255.0/8 192.168.1.1/7  FF::96/128 AZ::80/32]
				begin
					r << View_er.create_view(args)
					DNS.goto_view_page(args)
					args[:zone_type] = 'in-addr'
					error_ip_list.each do |zone_name|
						args[:zone_name] = zone_name
						r << DNS.inputs_create_zone_dialog(args)
						r << DNS.error_validator_on_popwin(args)
					end
					# 清理
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_12838(args)
				# AD集成区多个ZDNS设备
				@case_ID          = __method__.to_s.split('_')[1]
				r			      = []
				args[:acl_name]   = "acl_#{@case_ID}"
				args[:acl_list]   = Local_Network
				args[:view_name]  = "default"
				args[:enable_ad]  = 'yes'
				args[:zone_name]  = "zone.#{@case_ID}"
				args[:owner_list] = Node_Name_List
				begin
					r << ACL_er.create_acl(args)
					r << Zone_er.create_zone(args)
					# 调用nsupdate, dig Master + Slave
					args[:rname] = "a.#{args[:zone_name]}"
					args[:rtype] = 'A'
					args[:rdata] = '192.168.128.38'
					Node_IP_List.each do |ip|
						@nsupdate_file = File.new(Upload_Dir + '\nsupdate\12838.txt', 'w')
						@nsupdate_file.puts "server #{ip}\nzone #{args[:zone_name]}\nupdate add #{args[:rname]} 3600 IN #{args[:rtype]} #{args[:rdata]}\nsend\n"
						@nsupdate_file.close
						nsupdate = `#{Upload_Dir}nsupdate\\nsupdate #{Upload_Dir}nsupdate\\12838.txt`
					end
					# Dig
					args[:domain_name]  = args[:rname]
					args[:actual_rdata] = args[:rdata]
					args[:server_list]  = Node_IP_List
					r << Dig_er.compare_domain(args)
					r << Zone_er.del_zone(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_11665(args)
				# 主辅区前台数据显示一致
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				@master_view_name = "view_#{@case_ID}"
				args[:zone_name]  = "zone.#{@case_ID}"
				rdata_1           = '192.168.116.65'
				rdata_2           = '192.168.65.116'
				begin
					args[:view_name] = @master_view_name
				 	r << Zone_er.create_slave_zone_on_master(args)
				 	# 新建
				 	args[:view_name]   = 'default'
				 	args[:domain_list] = [{'rname'=>'11665','rtype'=>'A','rdata'=>rdata_1,'ttl'=>'3600'}]
				 	r << Domain_er.create_domain(args)
				 	# 验证新建
					args[:view_name] = @master_view_name
					args[:rname]     = '11665'
					args[:rtype]     = 'A'
					args[:ttl]       = '3600'
					args[:rdata]     = rdata_1
				 	DNS.goto_zone_page(args)
				 	r << DNS.check_on_single_domain(args)
					# 编辑
					args[:view_name]   = 'default'
				 	args[:domain_list] = [{'rname'=>'11665','rtype'=>'A','rdata_old'=>rdata_1,'rdata_new'=>rdata_2,'ttl'=>'3600'}]
				 	r << Domain_er.edit_domain(args)
				 	sleep 60 # waiting for the new domain sync to slave zone.
	    			# 验证编辑
					args[:domain_list] = [{'rname'=>'11665','rtype'=>'A','rdata'=>rdata_2,'ttl'=>'3600'}]
					args[:view_name]   = @master_view_name
					args[:rdata]       = rdata_2
					args[:rname]	   = '11665'
					args[:rtype]       = 'A'
					args[:ttl]         = '3600'
	    			DNS.goto_zone_page(args)
	    			r << DNS.check_on_single_domain(args)
					# 删除
					args[:view_name] = 'default'
	    			r << Domain_er.del_domain(args)
	    			# 验证删除
	    			args[:view_name] = @master_view_name
	    			DNS.goto_zone_page(args)
	    			puts "Deleted domain, could not check_on it anymore!"
	    			r << DNS.check_on_single_domain(args, false, true)
	    			args[:view_name] = 'default'
	    			DNS.goto_zone_page(args)
	    			puts "Deleted domain, could not check_on it anymore!"
	    			r << DNS.check_on_single_domain(args, false, true)
	    			# 清理
	    			args[:view_name] = @master_view_name
	    			r << View_er.del_view(args)
	    			args[:view_name] = 'default'
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_5954(args)
				# 创建已存在的主辅区
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				@master_view_name = "view_#{@case_ID}"
				args[:zone_name]  = "zone_#{@case_ID}"
				args[:error_type] = 'after_OK'
				args[:error_info] = '同名权威区已存在'
				begin
					args[:view_name] = @master_view_name
				    r << Zone_er.create_slave_zone_on_master(args)
				    # 重复新建主区
				    DNS.goto_view_page(args)
				    args[:owner_list] = [Master_Device]
				    DNS.inputs_create_zone_dialog(args)
				    r << DNS.error_validator_on_popwin(args)
				    # 重复新建辅区
					args[:server_type]   = 'slave'
					args[:master_server] = Slave_IP
				    DNS.inputs_create_zone_dialog(args)
				    r << DNS.error_validator_on_popwin(args)
		   			# 清理
		   			r << View_er.del_view(args)
		   			args[:view_name] = 'default'
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_13913(args)
				# 新建辅区续期，过期间隔后, dig返回noerror / nxdomain
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:acl_name]    = "acl_#{@case_ID}"
				args[:acl_list]    = Local_Network
				@master_view_name  = "view_#{@case_ID}"
				args[:zone_name]   = "zone.#{@case_ID}"
				rname              = "case.#{@case_ID}"
				rdata              = '192.168.139.13'
				args[:domain_list] = [{'rname'=>rname, 'rtype'=>'A', 'rdata'=>rdata, 'ttl'=>'3600'}]
				begin
					r << ACL_er.create_acl(args)
					args[:view_name] = @master_view_name
					args[:renewal]   = 'yes'
					r << Zone_er.create_slave_zone_on_master(args)
					args[:view_name] = 'default'
					r << Domain_er.create_domain(args)
					# 修改过期间隔
					args[:soa_refresh] = '300'
					args[:soa_retry]   = '300'
					args[:soa_expire]  = '800'
					args[:soa_serial]  = '3'
					r << Zone_er.edit_soa(args)
					# Dig
					args[:dig_ip]      = Master_IP
					args[:rtype]       = 'A'
					args[:domain_name] = "#{rname}.#{args[:zone_name]}"
					r << DNS.dig_as_noerror(args)
					# 停止bind
					args[:node_name] = Slave_Device
					r << Cloud.stop_device_dns_service(args)
					puts 'sleeping Slave_Zone_Expiration seconds...'
					sleep Slave_Zone_Expiration
					r << DNS.dig_as_noerror(args)
					# 恢复
					r << Cloud.start_device_dns_service(args)
					r << Zone_er.del_zone(args)
					args[:view_name] = @master_view_name
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_13944(args)
				# 编辑辅区续期，过期间隔后, dig返回noerror / nxdomain
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:acl_name]    = "acl_#{@case_ID}"
				args[:acl_list]    = Local_Network
				@master_view_name  = "view_#{@case_ID}"
				args[:zone_name]   = "zone.#{@case_ID}"
				rname              = "case.#{@case_ID}"
				rdata              = '192.168.139.44'
				args[:domain_list] = [{'rname'=>rname, 'rtype'=>'A', 'rdata'=>rdata, 'ttl'=>'3600'}]
				begin
					r << ACL_er.create_acl(args)
					args[:view_name] = @master_view_name
					r << Zone_er.create_slave_zone_on_master(args)
					args[:view_name] = 'default'
					r << Domain_er.create_domain(args)
					# 修改过期间隔
					args[:soa_refresh] = '300'
					args[:soa_retry]   = '300'
					args[:soa_expire]  = '800'
					args[:soa_serial]  = '3'
					r << Zone_er.edit_soa(args)
					# Dig
					args[:dig_ip]      = Master_IP
					args[:rtype]       = 'A'
					args[:domain_name] = "#{rname}.#{args[:zone_name]}"
					r << DNS.dig_as_noerror(args)
					# 编辑为续期
					args[:view_name] = @master_view_name
					args[:renewal]   = 'yes'
					r << Zone_er.edit_zone(args)
					# 停止bind + 等待
					args[:node_name] = Slave_Device
					r << Cloud.stop_device_dns_service(args)
					puts 'sleeping Slave_Zone_Expiration seconds...'
					sleep Slave_Zone_Expiration
					# 再Dig
					r << DNS.dig_as_noerror(args)
					# 恢复
					r << Cloud.start_device_dns_service(args)
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
					args[:view_name] = 'default'
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_13912(args)
				# 新建辅区不续期，过期间隔后, dig返回server fail
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:acl_name]    = "acl_#{@case_ID}"
				args[:acl_list]    = Local_Network
				@master_view_name  = "view_#{@case_ID}"
				args[:zone_name]   = "zone.#{@case_ID}"
				rname              = "case.#{@case_ID}"
				rdata              = '192.168.139.12'
				args[:domain_list] = [{'rname'=>rname, 'rtype'=>'A', 'rdata'=>rdata, 'ttl'=>'3600'}]
				begin
					r << ACL_er.create_acl(args)
					args[:view_name] = @master_view_name
					r << Zone_er.create_slave_zone_on_master(args)
					args[:view_name] = 'default'
					r << Domain_er.create_domain(args)
					# 修改过期间隔
					args[:soa_refresh] = '300'
					args[:soa_retry]   = '300'
					args[:soa_expire]  = '800'
					args[:soa_serial]  = '3'
					r << Zone_er.edit_soa(args)
					# Dig
					args[:dig_ip]      = Master_IP
					args[:rtype]       = 'A'
					args[:domain_name] = "#{rname}.#{args[:zone_name]}"
					r << DNS.dig_as_noerror(args)
					# 停止bind
					args[:node_name] = Slave_Device
					r << Cloud.stop_device_dns_service(args)
					puts 'sleeping Slave_Zone_Expiration seconds...'
					sleep Slave_Zone_Expiration
					r << DNS.dig_as_serverfail(args)
					# 恢复
					r << Cloud.start_device_dns_service(args)
					r << Zone_er.del_zone(args)
					args[:view_name] = @master_view_name
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_13945(args)
				# 编辑辅区不续期，过期间隔后, dig返回serverfail
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:acl_name]    = "acl_#{@case_ID}"
				args[:acl_list]    = Local_Network
				@master_view_name  = "view_#{@case_ID}"
				args[:zone_name]   = "zone.#{@case_ID}"
				rname              = "case.#{@case_ID}"
				rdata              = '192.168.139.45'
				args[:domain_list] = [{'rname'=>rname, 'rtype'=>'A', 'rdata'=>rdata, 'ttl'=>'3600'}]
				begin
					r << ACL_er.create_acl(args)
					args[:renewal]   = 'yes'
					args[:view_name] = @master_view_name
					r << Zone_er.create_slave_zone_on_master(args)
					args[:view_name] = 'default'
					r << Domain_er.create_domain(args)
					# 修改过期间隔
					args[:soa_refresh] = '300'
					args[:soa_retry]   = '300'
					args[:soa_expire]  = '800'
					args[:soa_serial]  = '3'
					r << Zone_er.edit_soa(args)
					# Dig
					args[:dig_ip]      = Master_IP
					args[:rtype]       = 'A'
					args[:domain_name] = "#{rname}.#{args[:zone_name]}"
					r << DNS.dig_as_noerror(args)
					# 修改为不续期
					args[:renewal]   = nil
					args[:view_name] = @master_view_name
					r << Zone_er.edit_zone(args)
					# Stop bind
					args[:node_name] = Slave_Device
					r << Cloud.stop_device_dns_service(args)
					puts 'sleeping Slave_Zone_Expiration seconds...'
					sleep Slave_Zone_Expiration
					r << DNS.dig_as_serverfail(args)
					# 恢复
					r << Cloud.start_device_dns_service(args)
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
					args[:view_name] = 'default'
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
        end
	end
end