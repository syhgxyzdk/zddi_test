# encoding: utf-8
require File.dirname(__FILE__) + '/../../zddi'

module ZDDI
	module DNS
		class View
			def case_671(args)
				@case_ID		   = __method__.to_s.split('_')[1]
				r            	   = []
				args[:view_name]   = "view_#{@case_ID}"
				args[:owner_list]  = [Master_Device]
				begin
					r << View_er.create_view(args)
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_672(args)
				@case_ID		  = __method__.to_s.split('_')[1]
				r            	  = []
				args[:owner_list] = Node_Name_List
				# 输入default 提示已存在
				args[:view_name]  = "default"
				args[:error_type] = "after_OK"
				args[:error_info] = "视图已存在"
				begin
					r << DNS.open_view_manage_page
					# default视图已存在
					r << DNS.inputs_create_view_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					# 输入格式错误
					args[:view_name]  = "！！#￥%"
					args[:error_type] = "before_OK"
					args[:error_info] = "视图名格式不正确,只能输入字母、汉字、数字、下划线"
					DNS.inputs_create_view_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					# 最多输入32个字符
					args[:view_name]  = "ViewName_CanNot_MoreThan_32Characers"
					DNS.inputs_create_view_dialog(args)
					get_view_name = DNS.popwin.text_field(:name, "name").value
					DNS.popwin.button(:class, "cancel").click
					r << (get_view_name.size == 32) ? "succeed" : "failed"
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_804(args)
				@case_ID		  = __method__.to_s.split('_')[1]
				r            	  = []
				args[:view_list]  = [
					"view_#{@case_ID}_1",
					"view_#{@case_ID}_2",
					"view_#{@case_ID}_3",
					"view_#{@case_ID}_4"
				]
				args[:owner_list] = [Master_Device]
				begin
					args[:view_list].each do |view_name|
						args[:view_name] = view_name
						r << View_er.create_view(args)
					end
					# 勾选多个视图删除
					r << DNS.check_on_multiple_view(args)
					r << DNS.del_checked_item
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_973(args)
				@case_ID		  = __method__.to_s.split('_')[1]
				r            	  = []
				args[:owner_list] = [Master_Device]
				args[:view_name]  = "view_#{@case_ID}"
				args[:error_type] = "after_OK"
				# DNS64输入错误
				args[:dns64_list] = ["fe80::f9e6:488:4eb6:22be/96"]
				args[:error_info] = "DNS64前缀应该是ipv6地址"
				begin
					r << DNS.open_view_manage_page
					r << DNS.inputs_create_view_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					args[:dns64_list] = ["k1k2:2380:/96"]
					args[:error_info] = "非法的IP地址"
					DNS.inputs_create_view_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_976(args)
				# 视图更新所属节点Master->Slave正常
				@case_ID		  = __method__.to_s.split('_')[1]
				r            	  = []
				args[:owner_list] = [Master_Device]
				args[:view_name]  = "view_#{@case_ID}"
				args[:keyword]	  = args[:view_name]
				begin
					r << View_er.create_view(args)
					# grep master should pass and slave failed
					r << DNS.grep_keyword_named(args)
					args[:owner_list] = [Slave_Device]
					r << DNS.grep_keyword_named(args, keyword_gone = true)
					# check view and modify its members
					args[:old_owner_list] = [Master_Device]
					args[:new_owner_list] = [Slave_Device] 		
					r << View_er.modify_view_member(args)
					# grep master should be failed, and slave pass
					args[:owner_list]   = [Master_Device]
					r << DNS.grep_keyword_named(args, keyword_gone = true)
					args[:owner_list]   = [Slave_Device]
					r << DNS.grep_keyword_named(args)
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_991(args)
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:owner_list] = Node_Name_List
				args[:view_name]  = "view_#{@case_ID}"
				args[:keyword]    = args[:view_name]
				begin
					r << View_er.create_view(args)
					# grep all should pass
					r << DNS.grep_keyword_named(args)
					args[:old_owner_list] = Node_Name_List
					args[:new_owner_list] = [Master_Device]			
					r << View_er.modify_view_member(args)
					# grep master should pass
					args[:owner_list] = [Master_Device]
					r << DNS.grep_keyword_named(args)
					# grep slave should fail
					args[:owner_list] = [Slave_Device]
					r << DNS.grep_keyword_named(args, keyword_gone = true)
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_10975(args)
				@case_ID		  = __method__.to_s.split('_')[1]
				r            	  = []
				args[:owner_list] = [Master_Device]
				args[:view_name]  = "view_#{@case_ID}"
				args[:keyword]	  = args[:view_name]
				begin
					r << View_er.create_view(args)
					# grep master should pass
					r << DNS.grep_keyword_named(args)
					# modify member				
					args[:old_owner_list] = [Master_Device]
					args[:new_owner_list] = Node_Name_List
					r << View_er.modify_view_member(args)
					# grep all nodes should pass
					args[:owner_list]	 = Node_Name_List
					r << DNS.grep_keyword_named(args)
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_10976(args)
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:owner_list] = Node_Name_List
				args[:view_name]  = "view_#{@case_ID}"
				args[:keyword]    = args[:view_name]
				begin
					r << View_er.create_view(args)
					# grep all should pass
					r << DNS.grep_keyword_named(args)
					# check on view then modify its member
					args[:old_owner_list] = Node_Name_List
					args[:new_owner_list] = [Slave_Device]			
					r << View_er.modify_view_member(args)
					# grep master should fail
					args[:owner_list] = [Master_Device]
					r << DNS.grep_keyword_named(args, keyword_gone = true)
					# grep slave should pass
					args[:owner_list] = [Slave_Device]
					r << DNS.grep_keyword_named(args)
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_990(args)
				@case_ID		  = __method__.to_s.split('_')[1]
				r                 = []
				args[:owner_list] = Node_Name_List
				args[:view_name]  = "view_#{@case_ID}"
				args[:keyword]    = args[:view_name]
				begin
					r << View_er.create_view(args)
					# grep all should pass
					r << DNS.grep_keyword_named(args)
					r << View_er.del_view(args)
					# grep all should fail
					r << DNS.grep_keyword_named(args, keyword_gone = true)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_987(args)
				@case_ID		  = __method__.to_s.split('_')[1]
				r            	  = []
				args[:view_name]  = "view_#{@case_ID}"
				args[:owner_list] = Node_Name_List
				args[:keyword]	  = args[:view_name]
				begin
					r << View_er.create_view(args)
					# 后台检查named
					r << DNS.grep_keyword_named(args)
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_989(args)
				@case_ID		  = __method__.to_s.split('_')[1]
				r            	  = []
				args[:view_name]  = "view_#{@case_ID}"
				args[:owner_list] = Node_Name_List
				begin
					# 建视图>>编辑视图(添加加ACL和DNS64)>>后台检查named
					r << View_er.create_view(args)
					args[:acl_name]     = "acl_989"
					args[:acl_list]     = ["192.168.9.89"]
					args[:dns64_list]   = ["ff::/96"]
					args[:add_acl_list] = [args[:acl_name]]
					r << ACL_er.create_acl(args)
					r << View_er.edit_view(args)
					args[:keyword]	= args[:view_name]
					r << DNS.grep_keyword_named(args)
					args[:keyword]	= args[:dns64_list][0]
					r << DNS.grep_keyword_named(args)
					args[:keyword]	= args[:acl_list][0]
					r << DNS.grep_keyword_named(args)
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_695(args)
				@case_ID		  = __method__.to_s.split('_')[1]
				r            	  = []
				args[:acl_name]   = "acl_695"
				args[:acl_list]   = ["192.168.6.95"]
				args[:view_name]  = "view_#{@case_ID}"
				args[:owner_list] = Node_Name_List
				begin
					# 建ACL + 视图
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					# 编辑视图(删ACL, 加DNS64)
					args[:del_acl_list] = [args[:acl_name]]
					args[:dns64_list]   = ["ff::/96"]
					r << View_er.edit_view(args)
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_981(args)
				@case_ID		  = __method__.to_s.split('_')[1]
				r            	  = []
				args[:view_name]  = "view_#{@case_ID}"
				args[:owner_list] = Node_Name_List
				args[:error_info] = "只能输入整数"
				args[:error_type] = "before_OK"
				begin
					# 创建视图, 调整排序, 连续输入非整数格式
					r << View_er.create_view(args)
					r << DNS.check_on_single_view(args)
					DNS.popup_right_menu("reorder")
					DNS.popwin.text_field(:name, "priority").set("!@#") # 非法字符
					r << DNS.error_validator_on_popwin(args)
					DNS.popup_right_menu("reorder")
					DNS.popwin.text_field(:name, "priority").set("abc") # 非整数
					r << DNS.error_validator_on_popwin(args)
					DNS.popup_right_menu("reorder")
					DNS.popwin.text_field(:name, "priority").set("abc123") # 非整数
					r << DNS.error_validator_on_popwin(args)
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_673(args)
				# 异步数据更新(DNS关闭)
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:owner_list]  = Node_Name_List
				args[:view_name]   = "view_#{@case_ID}"
				args[:keyword]     = args[:view_name]
				args[:node_name] = Slave_Device
				# begin
					r << Cloud.stop_device_dns_service(args)
					r << View_er.create_view(args)
					# grep master should pass
					args[:owner_list] = [Master_Device]
					r << DNS.grep_keyword_named(args)
					# grep slave should fail
					args[:owner_list] = [Slave_Device]
					r << DNS.grep_keyword_named(args, keyword_gone = true)
					r << Cloud.start_device_dns_service(args)
					# grep slave should pass after DNS start
					args[:owner_list] = [Slave_Device]
					r << DNS.grep_keyword_named(args)
					r << View_er.del_view(args)
				# rescue
				# 	puts "unknown error on #{@case_ID}"
				# 	return "failed case #{@case_ID}"
				# end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_11483(args)
				# 异步数据更新(节点断开)
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:owner_list]  = Node_Name_List
				args[:view_name]   = "view_#{@case_ID}"
				args[:keyword]     = args[:view_name]
				args[:group_name]  = Slave_Group
				args[:node_name] = Slave_Device
				begin
					r << Cloud.disconnect_device(args)
					r << View_er.create_view(args)
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
			def case_810(args)
				# 查询
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:owner_list] = Node_Name_List
				view_name_list    = ["view_#{@case_ID}_Eng","view_#{@case_ID}_中文"]
				begin
					view_name_list.each do |view_name|
						args[:view_name] = view_name
						r << View_er.create_view(args)
					end
					@view_prefix = "#{@case_ID}"
					DNS.search_elem(@view_prefix)
					view_name_list.each do |view_name|
						args[:view_name] = view_name
						r << DNS.check_on_single_view(args)
					end
					r << View_er.del_view_list(view_name_list)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_978(args)
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:owner_list] = Node_Name_List
				view_name_list    = ["view_#{@case_ID}_1","view_#{@case_ID}_2"]
				begin
					view_name_list.each do |view_name|
						args[:view_name] = view_name
						r << View_er.create_view(args)
					end
					# 修改优先级
					args[:priority] = "2"
					r << View_er.order_view(args)
					r << View_er.del_view_list(view_name_list)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_8352(args)
				@case_ID		 = __method__.to_s.split('_')[1]
				r            	 = []
				args[:view_name] = "view_#{@case_ID}"
				args[:zone_name] = "zone.#{@case_ID}"
				@comtAdd		 = "#{@case_ID}_input_comments"
				@comtEdit		 = "#{@case_ID}_edit_comments"
				begin
					DNS.open_view_manage_page
					# 添加修改备注
					r << DNS.input_comments(@comtAdd)
					r << DNS.input_comments(@comtEdit)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_969(args)
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:view_name]  = "view_#{@case_ID}"
				args[:zone_name]  = "zone.#{@case_ID}"
				args[:owner_list] = Node_Name_List
				args[:acl_name]   = "acl_969"
				args[:acl_list]   = Local_Network
				args[:dns64_list] = ["ff::/96"]
				begin
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					# dig DNS64下A => AAAA记录
					args[:rname] = "ns.#{args[:zone_name]}"
					args[:ip]	= "FF::7F00:1"
					r << Dig_er.compare_domain(:server_list=>Node_IP_List, :domain_name=>args[:rname], :rtype=>"AAAA", :port=>DNS_Port, :actual_rdata=>args[:ip])
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_811(args)
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				view_name_list    = ["view_#{@case_ID}", "#{@case_ID}_view"]
				search_name_list  = ['*view', '*', 'view*']
				args[:owner_list] = [Master_Device]
				begin
					# 新建
					view_name_list.each do |view_name|
						args[:view_name] = view_name
						r << View_er.create_view(args)
					end
					# 查询
					search_name_list.each do |search_name|
						args[:search_name] = search_name
						r << DNS.search_name(args, search_ok=false)
					end
					# 删除
					r << View_er.del_view_list(view_name_list)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			# 记录排序
			def case_14541(args)
				@case_ID		 = __method__.to_s.split('_')[1]
				r            	 = []
				args[:view_name] = 'default'
				err_list = ['非法的源地址','非法的IPv4/IPv6地址或网络','必选字段','有重复的记录排序']
				wrong_source_ip_list = {
					'192.168.145.444/8'=>err_list[0],
					'192.168.145.41/36'=>err_list[0],
					'192_168.1.2'=>err_list[0],
					''=>err_list[2]
				}
				wrong_prefered_ips_list = {
					['192.168.145.444/8']=>err_list[1],
					['192.168.145.41/36']=>err_list[1],
					['192_168.1.2']=>err_list[1]
				}
				begin
					DNS.goto_sortlist_page(args)
					args[:error_type] = 'before_OK'
					# 源地址
					args[:sortlists_prefered_ips]  = ['192.168.145.41']
					wrong_source_ip_list.each_pair do |source_ip, err|
						args[:sortlists_source_ip] = source_ip
						args[:error_info]		   = err
						DNS.inputs_create_sortlist(args)
						r << DNS.error_validator_on_popwin(args)
					end
					# 优先地址
					args[:sortlists_source_ip] = '192.168.145.41'
					wrong_prefered_ips_list.each do |prefered_ips, err|
						args[:sortlists_prefered_ips] = prefered_ips
						args[:error_info]			 = err
						DNS.inputs_create_sortlist(args)
						r << DNS.error_validator_on_popwin(args)
					end
					# 重复
					args[:sortlists_source_ip]	  = '192.168.145.41'
					args[:sortlists_prefered_ips] = ['192.168.145.41']
					r << View_er.create_sortlist_on_view(args)
					DNS.goto_sortlist_page(args)
					DNS.inputs_create_sortlist(args)
					args[:error_type] = 'after_OK' 
					args[:error_info] = err_list[3]
					r << DNS.error_validator_on_popwin(args)
					# 删除
					r << View_er.del_sortlist_on_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_14542(args)
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:view_name]              = 'default'
				args[:zone_name]              = "zone.#{@case_ID}"
				args[:owner_list]             = Node_Name_List
				args[:domain_name]            = "case.#{@case_ID}.zone.#{@case_ID}"
				args[:sortlists_source_ip]    = '203.119.80.0/16'
				args[:sortlists_prefered_ips] = ['203.119.80.0/24', '202.173.9.0/24', '192.168.0.0/16']
				domain_rdata_list             = ['203.119.80.42', '202.173.9.42', '192.168.145.42']
				begin
					r << Zone_er.create_zone(args)
					domain_rdata_list.each do |rdata|
						args[:domain_list] = [{"rname"=>"case.#{@case_ID}", "rtype"=>"A", "rdata"=>rdata, "ttl"=>"3600"}]
						r << Domain_er.create_domain(args)
					end
					r << View_er.create_sortlist_on_view(args)
					r << View_er.dig_sortlist_order(args)
					# 删除
					r << Zone_er.del_zone(args)
					r << View_er.del_sortlist_on_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_14543(args)
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:acl_name]               = "acl_#{@case_ID}"
				args[:acl_list]               = Local_Network
				args[:view_name]              = "view_#{@case_ID}"
				args[:owner_list]             = Node_Name_List
				args[:domain_name]            = "case.#{@case_ID}"
				args[:sortlists_source_ip]    = '203.119.80.0/16'
				args[:sortlists_prefered_ips] = ['203.119.80.0/24', '202.173.9.0/24', '192.168.0.0/16']
				domain_rdata_list             = ['203.119.80.43', '202.173.9.43', '192.168.145.43']
				begin
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					args[:rname] = args[:domain_name]
					args[:rtype] = 'A'
					domain_rdata_list.each do |rdata|
						args[:rdata] = rdata
						r << Recu_er.create_redirect(args)
					end
					r << View_er.create_sortlist_on_view(args)
					r << View_er.dig_sortlist_order(args)
					# 删除
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_14544(args)
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:acl_name]               = "acl_#{@case_ID}"
				args[:acl_list]               = Local_Network
				args[:view_name]              = "view_#{@case_ID}"
				args[:owner_list]             = Node_Name_List
				args[:domain_name]            = "case.#{@case_ID}"
				args[:sortlists_source_ip]    = '203.119.80.0/16'
				args[:sortlists_prefered_ips] = ['203.119.80.0/24', '202.173.9.0/24', '192.168.0.0/16']
				domain_rdata_list             = ['203.119.80.44', '202.173.9.44', '192.168.145.44']
				begin
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					args[:rname] = args[:domain_name]
					args[:rtype] = 'A'
					domain_rdata_list.each do |rdata|
						args[:rdata] = rdata
						r << Recu_er.create_redirect(args)
					end
					r << View_er.create_sortlist_on_view(args)
					r << View_er.dig_sortlist_order(args)
					# 编辑
					args[:new_sortlists_prefered_ips] = ['192.168.0.0/16','202.173.0.0/16','203.119.0.0/16']
					args[:sortlists_prefered_ips] = args[:new_sortlists_prefered_ips]
					r << View_er.edit_sortlist_on_view(args)
					r << View_er.dig_sortlist_order(args)
					# 删除
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_14545(args)
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:view_name]              = 'default'
				args[:zone_name]              = "zone.#{@case_ID}"
				args[:owner_list]             = Node_Name_List
				args[:domain_name]            = "case.#{@case_ID}.zone.#{@case_ID}"
				args[:sortlists_source_ip]    = '203.119.80.0/16'
				args[:sortlists_prefered_ips] = ['203.119.80.0/24', '202.173.9.0/24', '192.168.0.0/16']
				domain_rdata_list             = ['203.119.80.45', '202.173.9.45', '192.168.145.45']
				begin
					r << Zone_er.create_zone(args)
					domain_rdata_list.each do |rdata|
						args[:domain_list] = [{"rname"=>"case.#{@case_ID}", "rtype"=>"A", "rdata"=>rdata, "ttl"=>"3600"}]
						r << Domain_er.create_domain(args)
					end
					r << View_er.create_sortlist_on_view(args)
					r << View_er.dig_sortlist_order(args)
					# 编辑
					args[:new_sortlists_prefered_ips] = ['192.168.0.0/16', '202.173.9.0/24', '203.119.80.0/24']
					args[:sortlists_prefered_ips] = args[:new_sortlists_prefered_ips]
					r << View_er.edit_sortlist_on_view(args)
					r << View_er.dig_sortlist_order(args)
					# 删除
					r << Zone_er.del_zone(args)
					r << View_er.del_sortlist_on_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_14546(args)
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:view_name]   = 'default'
				args[:zone_name]   = "zone.#{@case_ID}"
				args[:owner_list]  = Node_Name_List
				args[:domain_name] = "case.#{@case_ID}.zone.#{@case_ID}"
				domain_rdata_list  = ['203.119.80.46', '202.173.9.46', '192.168.145.46']
				range_8            = '203.0.0.0/8'
				range_16           = '203.119.0.0/16'
				range_24           = '203.119.80.0/24'
				sort_203           = '203.119.80.0/24'
				sort_202           = '202.173.9.0/24'
				sort_192           = '192.168.0.0/16'
				sort_list_1        = [sort_203, sort_202, sort_192]
				sort_list_2        = [sort_202, sort_192, sort_203]
				sort_list_3        = [sort_192, sort_203, sort_202]
				begin
					r << Zone_er.create_zone(args)
					domain_rdata_list.each do |rdata|
						args[:domain_list] = [{"rname"=>"case.#{@case_ID}", "rtype"=>"A", "rdata"=>rdata, "ttl"=>"3600"}]
						r << Domain_er.create_domain(args)
					end
					# 新建三个范围的排序
					{range_8=>sort_list_1, range_16=>sort_list_2, range_24=>sort_list_3}.each_pair do |rg, sl|
						args[:sortlists_source_ip]	  = rg
						args[:sortlists_prefered_ips] = sl
						r << View_er.create_sortlist_on_view(args)
					end
					# 此时Dig, 最小范围的排序sort_list_3生效
					args[:sortlists_prefered_ips] = sort_list_3
					r << View_er.dig_sortlist_order(args)
					# 删除range_24后, 次小范围sort_list_2生效
					args[:sortlists_source_ip] = range_24
					r << View_er.del_sortlist_on_view(args)
					args[:sortlists_prefered_ips] = sort_list_2
					r << View_er.dig_sortlist_order(args)
					# 清理
					r << Zone_er.del_zone(args)
					[range_8, range_16].each do |range|
						args[:sortlists_source_ip] = range
						r << View_er.del_sortlist_on_view(args)
					end
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_14547(args)
				# 编辑为不存在
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:view_name]              = 'default'
				args[:zone_name]              = "zone.#{@case_ID}"
				args[:owner_list]             = Node_Name_List
				args[:domain_name]            = "case.#{@case_ID}.zone.#{@case_ID}"
				args[:sortlists_source_ip]    = '203.119.80.0/16'
				args[:sortlists_prefered_ips] = ['203.119.80.0/24', '202.173.9.0/24', '192.168.0.0/16']
				domain_rdata_list             = ['203.119.80.47', '202.173.9.47', '192.168.145.47']
				begin
					r << Zone_er.create_zone(args)
					domain_rdata_list.each do |rdata|
						args[:domain_list] = [{"rname"=>"case.#{@case_ID}", "rtype"=>"A", "rdata"=>rdata, "ttl"=>"3600"}]
						r << Domain_er.create_domain(args)
					end
					r << View_er.create_sortlist_on_view(args)
					r << View_er.dig_sortlist_order(args)
					# 编辑
					args[:new_sortlists_prefered_ips] = ['1.168.0.0/16', '2.173.9.0/24', '3.119.80.0/24']
					args[:sortlists_prefered_ips] = args[:new_sortlists_prefered_ips]
					r << View_er.edit_sortlist_on_view(args)
					r << View_er.dig_sortlist_order(args, expected_fail=true)
					# 删除
					r << Zone_er.del_zone(args)
					r << View_er.del_sortlist_on_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_14548(args)
				@case_ID		   = __method__.to_s.split('_')[1]
				r            	   = []
				args[:view_name]   = 'default'
				args[:zone_name]   = "zone.#{@case_ID}"
				args[:owner_list]  = Node_Name_List
				args[:domain_name] = "case.#{@case_ID}.zone.#{@case_ID}"
				begin
					r << Zone_er.create_zone(args)
					domain_rdata_list  = ['203.119.80.48', '202.173.9.48', '192.168.145.48']
					domain_rdata_list.each do |rdata|
						args[:domain_list] = [{"rname"=>"case.#{@case_ID}", "rtype"=>"A", "rdata"=>rdata, "ttl"=>"3600"}]
						r << Domain_er.create_domain(args)
					end
					# 203网段新建记录排序
					args[:sortlists_source_ip]	= '203.119.80.0/16'
					args[:sortlists_prefered_ips] = ['203.119.80.0/24', '202.173.9.0/24', '192.168.0.0/16']
					r << View_er.create_sortlist_on_view(args)
					r << View_er.dig_sortlist_order(args)
					# 202网段新建记录排序
					args[:sortlists_source_ip]	= '202.173.9.0/16'
					args[:sortlists_prefered_ips] = ['202.173.9.0/24', '203.119.80.0/24', '192.168.0.0/16']
					r << View_er.create_sortlist_on_view(args)
					r << View_er.dig_sortlist_order_on_master(args)
					# 删除(2个记录排序)
					r << Zone_er.del_zone(args)
					args[:sortlists_source_ip] = '203.119.80.0/16'
					r << View_er.del_sortlist_on_view(args)
					args[:sortlists_source_ip] = '202.173.9.0/16'
					r << View_er.del_sortlist_on_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_12148(args)
				@case_ID		  = __method__.to_s.split('_')[1]
				r            	  = []
				args[:view_name]  = 'default'
				args[:error_type] = 'after_OK'
				args[:error_info] = '有重复的记录排序'
				begin
					args[:sortlists_source_ip] = '203.119.0.0/16'
					args[:sortlists_prefered_ips] = ['192.168.121.48']
					r << View_er.create_sortlist_on_view(args)
					DNS.goto_sortlist_page(args)
	                DNS.inputs_create_sortlist(args)
	                r << DNS.error_validator_on_popwin(args)
	                r << View_er.del_sortlist_on_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_16182(args)
				# 用'any'代表所有源地址
				@case_ID		  = __method__.to_s.split('_')[1]
				r            	  = []
				args[:owner_list] = Node_Name_List
				args[:view_name]  = 'default'
				begin
					args[:domain_name] = '16182.com'
					['192.168.1.1', '10.10.10.2'].each do |ip|
						args[:ip] = ip
						r << Recu_er.create_local_policies(args)
					end
					args[:sortlists_source_ip] = 'any'
					args[:sortlists_prefered_ips] = ['10.10.0.0/16','192.168.0.0/16']
					r << View_er.create_sortlist_on_view(args)
					# 本地 + master验证
					r << View_er.dig_sortlist_order(args)
					r << View_er.dig_sortlist_order_on_master(args)
					# 清理
					r << Recu_er.del_all_local_policies
	                r << View_er.del_sortlist_on_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_25854(args)
				# default视图新增节点后自动生效
				@case_ID         = __method__.to_s.split('_')[1]
				r                = []
				begin
					# 先删除Slave节点
					args[:node_name] = Slave_Device
					Cloud.del_device(args)
					args[:view_name] = 'default'
					args[:domain_name] = '25854.com'
					['192.168.1.1', '10.10.10.2'].each do |ip|
						args[:ip] = ip
						r << Recu_er.create_local_policies(args)
					end
					args[:sortlists_source_ip] = 'any'
					args[:sortlists_prefered_ips] = ['10.10.0.0/16','192.168.0.0/16']
					r << View_er.create_sortlist_on_view(args)
					# 添加节点后验证
					args[:owner_list] = [Master_Device]
					r << View_er.dig_sortlist_order(args)
					args[:new_group_name] = Slave_Group
					args[:node_name]      = Slave_Device
					args[:node_ip]        = Slave_IP
					Cloud.add_device(args)
					args[:owner_list] = Node_Name_List
					r << View_er.dig_sortlist_order(args)
					# 清理
					r << Recu_er.del_all_local_policies
	                r << View_er.del_sortlist_on_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			##################  Fail Forward #############
			def case_11116(args)
				@case_ID = __method__.to_s.split('_')[1]
				r        = []
				begin
					# default视图, slave节点下建区和记录
					args[:view_name]   = "default"
					args[:zone_name]   = "zone.#{@case_ID}"
					args[:owner_list]  = [Slave_Device]
					@rdata             = "192.168.111.16"
					@rname             = "ffwdr"
					args[:domain_list] = [{"rname"=>@rname, "rtype"=>"A", "rdata"=>@rdata, "ttl"=>"3600"}]
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					# 新建ACL+视图+触发Servfail的转发区
					args[:acl_name] = "acl_#{@case_ID}"
					args[:acl_list] = Local_Network
					r << ACL_er.create_acl(args)
					args[:view_name]      = "view_#{@case_ID}"
					args[:owner_list]     = [Master_Device]
					args[:fail_forwarder] = Slave_IP
					r << View_er.create_view(args)
					args[:forward_server_list] = [@rdata]
					args[:forward_style]       = 'only'
					r << Recu_er.create_forward_zone(args)
					# Dig
					args[:server_list]  = [Master_IP]
					args[:domain_name]  = "#{@rname}.#{args[:zone_name]}"
					args[:actual_rdata] = @rdata 
					args[:rtype]        = 'A'
					args[:sleepfirst]   = 'yes'
					r << Dig_er.compare_domain(args)
					# 清理
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
			def case_12612(args)
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:view_name]   = "default"
				args[:zone_name]   = "zone.#{@case_ID}"
				args[:owner_list]  = [Slave_Device]
				@rdata             = "192.168.126.12"
				@rname             = "ffwdr"
				args[:domain_list] = [{"rname"=>@rname, "rtype"=>"A", "rdata"=>@rdata, "ttl"=>"3600"}]
				begin
					# default视图slave节点建区和记录
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					# 新建ACL+视图+触发Servfail的转发区
					args[:acl_name] = "acl_#{@case_ID}"
					args[:acl_list] = Local_Network
					r << ACL_er.create_acl(args)
					args[:view_name]  = "view_#{@case_ID}"
					args[:owner_list] = [Master_Device]
					r << View_er.create_view(args)
					args[:fail_forwarder] = Slave_IP
					r << View_er.edit_view(args)
					args[:forward_server_list] = [@rdata]
					args[:forward_style]       = 'only'
					r << Recu_er.create_forward_zone(args)
					# Dig
					args[:server_list]  = [Master_IP]
					args[:domain_name]  = "#{@rname}.#{args[:zone_name]}"
					args[:actual_rdata] = @rdata 
					args[:rtype]        = 'A'
					args[:sleepfirst]   = 'yes'
					r << Dig_er.compare_domain(args)
					# 清理数据
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
					args[:view_name] = "default"
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_10901(args)
				# default视图的失败转发.
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:acl_name]    = "acl_#{@case_ID}"
				args[:acl_list]    = [Master_IP]
				@forward_view_name = "view_#{@case_ID}"
				args[:view_name]   = @forward_view_name
				args[:owner_list]  = [Slave_Device]
				args[:zone_name]   = "zone.#{@case_ID}"
				@rname             = "ffwdr"
				@rdata             = "192.168.109.1"
				args[:domain_list] = [{"rname"=>@rname, "rtype"=>"A", "rdata"=>@rdata, "ttl"=>"3600"}]
				begin
					# 为slave建ACL/view/zone和rrdata
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					args[:view_name]      = "default"
					args[:fail_forwarder] = Slave_IP
					r << View_er.edit_view(args)
					args[:forward_server_list] = [@rdata]
					args[:forward_style]       = 'only'
					args[:owner_list]          = [Master_Device]
					r << Recu_er.create_forward_zone(args)
					# Dig
					args[:server_list]  = [Master_IP]
					args[:domain_name]  = "#{@rname}.#{args[:zone_name]}"
					args[:actual_rdata] = @rdata 
					args[:rtype]        = 'A'
					args[:sleepfirst]   = 'yes'
					r << Dig_er.compare_domain(args)
					# 清理
					args[:view_name] = @forward_view_name
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
					args[:view_name]      = "default"
					args[:fail_forwarder] = ""
					r << View_er.edit_view(args) # 删除失败转发IP
					r << Recu_er.del_forward_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_10896(args)
				# 在节点DNS页面配置失败转发
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:acl_name]    = "acl_#{@case_ID}"
				args[:acl_list]    = [Master_IP]
				@forward_view_name = "view_#{@case_ID}"
				args[:view_name]   = @forward_view_name
				args[:owner_list]  = [Slave_Device]
				args[:zone_name]   = "zone.#{@case_ID}"
				@rname             = "ffwdr"
				@rdata             = "192.168.108.96"
				args[:domain_list] = [{"rname"=>@rname, "rtype"=>"A", "rdata"=>@rdata, "ttl"=>"3600"}]
				begin
					# slave建ACL/view/zone和rrdata
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					args[:view_name]           = "default"
					args[:forward_server_list] = [@rdata]
					args[:forward_style]       = 'only'
					args[:owner_list]          = [Master_Device]
					r << Recu_er.create_forward_zone(args)
					args[:node_name]      = Master_Device
					args[:fail_forwarder] = Slave_IP
					r << Cloud.change_dns_fail_forwarder(args)
					# Dig
					args[:server_list]  = [Master_IP]
					args[:domain_name]  = "#{@rname}.#{args[:zone_name]}"
					args[:actual_rdata] = @rdata 
					args[:rtype]        = 'A'
					args[:sleepfirst]   = 'yes'
					r << Dig_er.compare_domain(args)
					# 清理
					r << Recu_er.del_forward_zone(args)
					args[:view_name] = @forward_view_name
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
					args[:fail_forwarder] = ""
					r << Cloud.change_dns_fail_forwarder(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_10897(args)
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:acl_name]    = "acl_#{@case_ID}"
				args[:acl_list]    = [Master_IP]
				@forward_view_name = "view_#{@case_ID}"
				args[:view_name]   = @forward_view_name
				args[:owner_list]  = [Slave_Device]
				args[:zone_name]   = "zone.#{@case_ID}"
				@rname             = "ffwdr"
				@rdata             = "192.168.108.97"
				args[:domain_list] = [{"rname"=>@rname, "rtype"=>"A", "rdata"=>@rdata, "ttl"=>"3600"}]
				begin
					# 为slave建ACL/view/zone和rrdata
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					args[:view_name]		   = 'default'
					args[:forward_server_list] = [@rdata]
					args[:forward_style]       = 'only'
					args[:owner_list]          = [Master_Device]
					r << Recu_er.create_forward_zone(args)
					args[:node_name]    = Master_Device
					args[:fail_forwarder] = "8.8.8.8" # DNS页面配置google dns.
					r << Cloud.change_dns_fail_forwarder(args)
					args[:view_name]      = "default"
					args[:fail_forwarder] = Slave_IP  # view页面配置slave ffwdr.
					r << View_er.edit_view(args)
					# Dig
					args[:server_list]  = [Master_IP]
					args[:domain_name]  = "#{@rname}.#{args[:zone_name]}"
					args[:actual_rdata] = @rdata 
					args[:rtype]        = 'A'
					args[:sleepfirst]   = 'yes'
					r << Dig_er.compare_domain(args)
					# 清理
					args[:view_name] = @forward_view_name
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
					args[:view_name]      = "default"
					args[:fail_forwarder] = ""
					r << View_er.edit_view(args)
					r << Cloud.change_dns_fail_forwarder(args)
					r << Recu_er.del_forward_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
		end
	end
end