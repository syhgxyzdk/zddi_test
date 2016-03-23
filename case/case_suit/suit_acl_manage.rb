# encoding: utf-8
require File.dirname(__FILE__) + '/../../zddi'
module ZDDI
	module DNS
		class ACL
			def case_1375(args)
				@case_ID        = __method__.to_s.split('_')[1]
				r               = []
				args[:acl_name] = "acl_#{@case_ID}"
				args[:acl_list] = ["192.168.1.1","192.168.2.1"]		
				begin
					r << ACL_er.create_acl(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1384(args)
				@case_ID        = __method__.to_s.split('_')[1]
				r               = []
				args[:acl_name] = "acl_#{@case_ID}"
				args[:acl_file] = Upload_Dir + 'acl\1384.txt'
				begin
					r << ACL_er.create_acl(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1399(args)
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:acl_name]   = "acl_#{@case_ID}"
				args[:acl_list]   = ['256.0.0.0', '203.119.80/24']
				args[:error_info] = '非法的IPv4/IPv6地址或网络'
				args[:error_type] = 'before_OK'
				begin
					r << DNS.open_acl_page
					DNS.inputs_create_acl_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					r << DNS.check_on_single_acl(args, expected_fail = true)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1440(args)
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:acl_name]   = "acl_#{@case_ID}"
				args[:acl_list]   = ['202.173.0.0/16', '202.173.0.0/16']
				args[:error_info] = '请勿输入重复项'
				args[:error_type] = 'before_OK'
				begin
					r << DNS.open_acl_page
					DNS.inputs_create_acl_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					r << DNS.check_on_single_acl(args, expected_fail = true)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1465(args)
				@case_ID        = __method__.to_s.split('_')[1]
				r               = []
				args[:acl_name] = "acl_#{@case_ID}"
				args[:acl_list] = ['202.173.0.0/16', '203.119.0.0/16']
				begin
					r << ACL_er.create_acl(args)
					args[:acl_list] = ['202.173.0.0/16', '203.119.0.0/16', '2002:cb77:50a7::cb77:50a7']
					r << ACL_er.edit_acl(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1467(args)
				@case_ID        = __method__.to_s.split('_')[1]
				r               = []
				args[:acl_name] = "acl_#{@case_ID}"
				org_acl         = ['202.173.0.0/16', '203.119.0.0/16']
				new_acl         = ['202.173.9.0/24', '203.119.80.0/24', '2002:cb77:50a7::cb77:50a7']
				begin
					args[:acl_list] = org_acl
					r << ACL_er.create_acl(args)
					args[:owner_list] = Node_Name_List
					args[:acl_list]   = new_acl
					r << ACL_er.edit_acl(args)
					org_acl.each do |acl|
						args[:keyword] = acl
						r << DNS.grep_keyword_named(args, true)
					end
					new_acl.each do |acl|
						args[:keyword] = acl
						r << DNS.grep_keyword_named(args)
					end
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1466(args)
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:acl_name]   = "acl_#{@case_ID}"
				args[:acl_list]   = ['202.173.0.0/16', '203.119.0.0/16']
				args[:error_info] = '请勿输入重复项'
				args[:error_type] = 'before_OK'
				begin
					r << ACL_er.create_acl(args)
					args[:acl_list] = ['202.173.0.0/16', '203.119.0.0/16', '2002:cb77:50a7::cb77:50a7', '2002:cb77:50a7::cb77:50a7']
					r << DNS.check_on_single_acl(args)
					DNS.inputs_edit_acl_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1469(args)
				@case_ID        = __method__.to_s.split('_')[1]
				r               = []
				args[:acl_name] = "acl_#{@case_ID}"
				args[:acl_list] = ['202.173.0.0/16', '203.119.0.0/16']
				begin
					r << ACL_er.create_acl(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1472(args)
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:acl_name]   = "acl_#{@case_ID}"
				args[:acl_list]   = ['202.173.0.0/16', '203.119.0.0/16']
				args[:owner_list] = Node_Name_List
				begin
					r << ACL_er.create_acl(args)
					['202.173.0.0/16', '203.119.0.0/16'].each do |acl|
						args[:keyword] = acl
						r << DNS.grep_keyword_named(args)
					end
					r << ACL_er.del_acl(args)
					['202.173.0.0/16', '203.119.0.0/16'].each do |acl|
						args[:keyword] = acl
						r << DNS.grep_keyword_named(args, true)
					end
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_2752(args)
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:error_info] = '访问控制已存在'
				args[:error_type] = 'after_OK'
				args[:acl_list]   = ['202.173.0.0/16', '203.119.0.0/16']
				begin
					['any', 'none'].each do |name|
						args[:acl_name] = name
						r << DNS.open_acl_page
						DNS.inputs_create_acl_dialog(args)
						r << DNS.error_validator_on_popwin(args)
					end
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1449(args)
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:owner_list] = Node_Name_List
				args[:acl_name]   = "acl_#{@case_ID}"
				args[:acl_file]   = Upload_Dir + 'acl\1449.txt'
				begin
					r << ACL_er.create_acl(args)
					acl_list = IO.readlines(args[:acl_file])
					acl_list.each do |acl|
						args[:keyword] = acl
						r << DNS.grep_keyword_named(args)
					end
					r << ACL_er.del_acl(args)
					acl_list.each do |acl|
						args[:keyword] = acl.chomp
						r << DNS.grep_keyword_named(args, true)
					end
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1471(args)
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:acl_name]   = "acl_#{@case_ID}"
				args[:acl_list]   = Local_Network
				args[:view_name]  = "view_#{@case_ID}"
				args[:owner_list] = Node_Name_List
				args[:error_info] = "acl_#{@case_ID}:删除被视图应用的访问控制"
				args[:error_type] = 'after_OK'
				begin
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << DNS.open_acl_page
					r << DNS.check_on_single_acl(args)
					r << DNS.popup_right_menu('del')
					r << DNS.error_validator_on_popwin(args)
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_9733(args)
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:acl_name]   = "acl_#{@case_ID}"
				args[:acl_list]   = Local_Network
				args[:view_name]  = 'default'
				args[:zone_name]  = "zone.#{@case_ID}"
				args[:owner_list] = [Master_Device]
				args[:error_info] = "acl_#{@case_ID}:删除被AD区使用的访问控制"
				args[:error_type] = 'after_OK'
				begin
					r << ACL_er.create_acl(args)
					args[:enable_ad] = 'yes'
					r << Zone_er.create_zone(args)
					r << DNS.open_acl_page
					r << DNS.check_on_single_acl(args)
					r << DNS.popup_right_menu('del')
					r << DNS.error_validator_on_popwin(args)
					r << Zone_er.del_zone(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_2753(args)
				@case_ID        = __method__.to_s.split('_')[1]
				r               = []
				args[:acl_name] = "acl_#{@case_ID}"
				args[:acl_file] = Upload_Dir + 'acl\2753.exe'
				args[:error_info] = '非法的IPv4/IPv6地址或网络'
				args[:error_type] = 'before_OK'
				begin
					r << DNS.open_acl_page
                	DNS.inputs_create_acl_dialog(args)
                	r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_8361(args)
				@case_ID        = __method__.to_s.split('_')[1]
				r               = []
				args[:acl_name] = "acl_#{@case_ID}"
				args[:acl_list] = Local_Network
				begin
					r << ACL_er.create_acl(args)
					r << DNS.open_acl_page
                	r << DNS.input_comments('ACL备注_新建')
                	r << DNS.input_comments('ACL备注_编辑')
                	r << DNS.input_comments('ACL备注_删除')
                	r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_8362(args)
				@case_ID        = __method__.to_s.split('_')[1]
				r               = []
				args[:acl_list] = Local_Network
				begin
					3.times do |i|
						args[:acl_name] = "acl_#{@case_ID}_#{i + 1}"
						r << ACL_er.create_acl(args)
					end
					# 完整查询
					3.times do |i|
						args[:search_keyword] = "acl_#{@case_ID}_#{i + 1}"
						r << ACL_er.search_acl(args)
					end
					# 不完整查询 / 空查询
					[@case_ID, ''].each do |key|
						@keyword = key
						DNS.open_acl_page
						DNS.search_elem(@keyword)
	                	search_result = DNS.get_cur_elem_string.to_s
	                	r << 'fail' if !search_result.include?("acl_#{@case_ID}")
					end
                	r << ACL_er.del_all_acl
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
		end
    end
end			