# encoding: utf-8
require File.dirname(__FILE__) + '/../../zddi'
module ZDDI
	module DNS
		class Share_zone
			def case_23146(args)
				# default视图下新建共享区
				@case_ID                 = __method__.to_s.split('_')[1]
				r                        = []
				args[:view_name]         = 'default'
				args[:zone_name]         = @case_ID
				args[:owner_list]        = Node_Name_List
				args[:share_zone_name]   = @case_ID
				args[:share_zone_views]  = ['default']
				args[:share_zone_domain] = {'rname'=>@case_ID, 'rtype'=>'A', 'rdata'=>'192.168.231.46'}
				begin
					r << Zone_er.create_zone(args)
					r << Share_zone_er.create_share_zone(args)
					r << Share_zone_er.create_share_zone_rr(args)
					# dig 权威区
					args[:expected_dig_fail] = false
					args[:sleepfirst]        = false
					args[:server_list]       = Node_IP_List
					args[:domain_name]       = "#{@case_ID}.#{@case_ID}"
					args[:rtype]             = 'A'
					args[:actual_rdata]      = '192.168.231.46'
					r << Dig_er.compare_domain(args)
					# 清理
					r << Share_zone_er.del_share_zone_rr(args)
					r << Share_zone_er.del_share_zone(args)
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_23147(args)
				# default+非default视图下新建共享区
				@case_ID                 = __method__.to_s.split('_')[1]
				r                        = []
				args[:acl_name]          = "acl_#{@case_ID}"
				args[:acl_list]          = Local_Network
				share_view               = "view_#{@case_ID}"
				args[:zone_name]         = "zone.#{@case_ID}"
				args[:owner_list]        = Node_Name_List
				args[:share_zone_name]   = args[:zone_name]
				args[:share_zone_views]  = ['default', share_view]
				rdata                    = '192.168.231.47'
				args[:share_zone_domain] = {'rname'=>@case_ID, 'rtype'=>'A', 'rdata'=>rdata}
				begin
					r << ACL_er.create_acl(args)
					args[:view_name] = share_view
					r << View_er.create_view(args)
					['default', share_view].each do |view_name|
						args[:view_name] = view_name
						r << Zone_er.create_zone(args)
					end
					r << Share_zone_er.create_share_zone(args)
					r << Share_zone_er.create_share_zone_rr(args)
					# dig 权威区
					args[:expected_dig_fail] = false
					args[:sleepfirst]        = false
					args[:server_list]       = Node_IP_List
					args[:domain_name]       = "#{@case_ID}.#{args[:zone_name]}"
					args[:rtype]             = 'A'
					args[:actual_rdata]      = rdata
					r << Dig_er.compare_domain(args)
					# 清理
					r << Share_zone_er.del_share_zone(args)
					args[:view_name] = share_view
					r << View_er.del_view(args)
					args[:view_name] = 'default'
					r << Zone_er.del_zone(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24814(args)
				# 新建反向区的共享区
				@case_ID                 = __method__.to_s.split('_')[1]
				r                        = []
				args[:acl_name]          = "acl_#{@case_ID}"
				args[:acl_list]          = Local_Network
				share_view               = "view_#{@case_ID}"
				args[:zone_name]         = "192.168.0.0/16"
				args[:zone_type]         = 'in-addr'
				args[:owner_list]        = Node_Name_List
				args[:share_zone_views]  = ['default', share_view]
				rdata                    = '192.168.248.14'
				args[:share_zone_domain] = {'rname'=>@case_ID, 'rtype'=>'A', 'rdata'=>rdata}
				begin
					r << ACL_er.create_acl(args)
					args[:view_name] = share_view
					r << View_er.create_view(args)
					['default', share_view].each do |view_name|
						args[:view_name] = view_name
						r << Zone_er.create_zone(args)
					end
					args[:zone_name]         = DNS.zone_name_to_arpa(args)
					args[:share_zone_name]   = args[:zone_name]
					r << Share_zone_er.create_share_zone(args)
					r << Share_zone_er.create_share_zone_rr(args)
					# dig 权威区
					args[:expected_dig_fail] = false
					args[:sleepfirst]        = false
					args[:server_list]       = Node_IP_List
					args[:domain_name]       = "#{@case_ID}.#{args[:zone_name]}"
					args[:rtype]             = 'A'
					args[:actual_rdata]      = rdata
					r << Dig_er.compare_domain(args)
					# 清理
					r << Share_zone_er.del_share_zone(args)
					args[:view_name] = share_view
					r << View_er.del_view(args)
					args[:view_name] = 'default'
					r << Zone_er.del_zone(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24730(args)
				# 批量添加共享区记录
				@case_ID                 = __method__.to_s.split('_')[1]
				r                        = []
				args[:acl_name]          = "acl_#{@case_ID}"
				args[:acl_list]          = Local_Network
				share_view               = "view_#{@case_ID}"
				args[:zone_name]         = "zone.#{@case_ID}"
				args[:owner_list]        = Node_Name_List
				args[:share_zone_name]   = args[:zone_name]
				args[:share_zone_views]  = ['default', share_view]
				begin
					r << ACL_er.create_acl(args)
					args[:view_name] = share_view
					r << View_er.create_view(args)
					['default', share_view].each do |view_name|
						args[:view_name] = view_name
						r << Zone_er.create_zone(args)
					end
					r << Share_zone_er.create_share_zone(args)
					args[:imported_file] = Upload_Dir + 'zone\24730.txt'
					r << Share_zone_er.import_share_zone_rr(args)
					# dig 权威区
					args[:sleepfirst]        = false
					args[:server_list]       = Node_IP_List
					args[:expected_dig_fail] = false
					imported_file = File.open(args[:imported_file], 'r')
					imported_file.each_line do |line|
						domain = line.split("\s")
						args[:domain_name]  = "#{domain[0]}.#{args[:zone_name]}"
						args[:rtype]        = domain[2]
						args[:actual_rdata] = domain[3]
						s = Dig_er.compare_domain(args)
						r << 'fail' if s == 'failed'
					end
					# 清理
					args[:view_name] = share_view
					r << View_er.del_view(args)
					args[:view_name] = 'default'
					r << Zone_er.del_zone(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24736(args)
				# 批量添加参数校验
				@case_ID                 = __method__.to_s.split('_')[1]
				r                        = []
				share_view               = "view_#{@case_ID}"
				args[:zone_name]         = "zone.#{@case_ID}"
				args[:owner_list]        = Node_Name_List
				args[:share_zone_name]   = args[:zone_name]
				args[:share_zone_views]  = ['default', share_view]
				rdata                    = '192.168.247.36'
				args[:share_zone_domain] = {'rname'=>@case_ID, 'rtype'=>'A', 'rdata'=>rdata}
				begin
					args[:view_name] = share_view
					r << View_er.create_view(args)
					['default', share_view].each do |view_name|
						args[:view_name] = view_name
						r << Zone_er.create_zone(args)
					end
					r << Share_zone_er.create_share_zone(args)
					r << Share_zone_er.create_share_zone_rr(args)
					file_list  = ['201', 'dup-item', 'err', 'dup-domain']
					error_list = [
						['before_OK','超过最大输入限制(200条)'], 
						['before_OK','请勿输入重复项'],
						['after_OK', "资源记录格式无效\n记录序列号:20\n资源记录:d@19 3600 A 192.168.258.19"], 
						['after_OK', "创建重复的资源记录\n记录序列号:1\n资源记录:24736.zone.24736. 3600 A 192.168.247.36"]
					]
					r << DNS.goto_share_zone_page(args)
					4.times do |i|
						args[:imported_file] = Upload_Dir + 'zone\24736-' + file_list[i] +'.txt'
						DNS.popup_right_menu('batchCreate')
	            		DNS.choose_file(args)
						args[:error_type] = error_list[i][0]
						args[:error_info] = error_list[i][1]
						r << DNS.error_validator_on_popwin(args)
					end
					# 清理
					r << Share_zone_er.del_share_zone(args)
					args[:view_name] = share_view
					r << View_er.del_view(args)
					args[:view_name] = 'default'
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_23164(args)
				# 新建共享区后删除部分权威区记录
				@case_ID                 = __method__.to_s.split('_')[1]
				r                        = []
				args[:acl_name]          = "acl_#{@case_ID}"
				args[:acl_list]          = Local_Network
				share_view               = "view_#{@case_ID}"
				args[:zone_name]         = "zone.#{@case_ID}"
				args[:owner_list]        = Node_Name_List
				args[:share_zone_name]   = args[:zone_name]
				args[:share_zone_views]  = ['default', share_view]
				rdata_1                  = '192.168.231.64'
				rdata_2                  = '192.168.23.164'
				begin
					r << ACL_er.create_acl(args)
					args[:view_name] = share_view
					r << View_er.create_view(args)
					['default', share_view].each do |view_name|
						args[:view_name] = view_name
						r << Zone_er.create_zone(args)
					end
					r << Share_zone_er.create_share_zone(args)
					[rdata_1, rdata_2].each do |rdata|
						args[:share_zone_domain] = {'rname'=>@case_ID, 'rtype'=>'A', 'rdata'=>rdata}
						r << Share_zone_er.create_share_zone_rr(args)
					end
					# 删除权威区的rdata_1后验证共享区记录rdata_1也联动删除
					args[:domain_list] = [{'rname'=>@case_ID, 'rtype'=>'A', 'rdata'=>rdata_1}]
					r << Domain_er.del_domain(args)
					r << DNS.goto_share_zone_page(args)
					args[:share_zone_domain] = {'rname'=>@case_ID, 'rtype'=>'A', 'rdata'=>rdata_1}
					r << DNS.check_on_single_share_zone_rr(args, checkon = false, expected_fail = true)
					# 清理
					r << Share_zone_er.del_share_zone(args)
					args[:view_name] = share_view
					r << View_er.del_view(args)
					args[:view_name] = 'default'
					r << Zone_er.del_zone(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_23166(args)
				# 新建共享区后删除全部权威区记录
				@case_ID                 = __method__.to_s.split('_')[1]
				r                        = []
				args[:acl_name]          = "acl_#{@case_ID}"
				args[:acl_list]          = Local_Network
				share_view               = "view_#{@case_ID}"
				args[:zone_name]         = "zone.#{@case_ID}"
				args[:owner_list]        = Node_Name_List
				args[:share_zone_name]   = args[:zone_name]
				args[:share_zone_views]  = ['default', share_view]
				rdata_1                  = '192.168.231.64'
				rdata_2                  = '192.168.23.164'
				begin
					r << ACL_er.create_acl(args)
					args[:view_name] = share_view
					r << View_er.create_view(args)
					['default', share_view].each do |view_name|
						args[:view_name] = view_name
						r << Zone_er.create_zone(args)
					end
					r << Share_zone_er.create_share_zone(args)
					[rdata_1, rdata_2].each do |rdata|
						args[:share_zone_domain] = {'rname'=>@case_ID, 'rtype'=>'A', 'rdata'=>rdata}
						r << Share_zone_er.create_share_zone_rr(args)
					end
					# 删除权威区记录后验证共享区记录联动删除
					[rdata_1, rdata_2].each do |rdata|
						args[:domain_list] = [{'rname'=>@case_ID, 'rtype'=>'A', 'rdata'=>rdata}]
						r << Domain_er.del_domain(args)
					end
					r << DNS.goto_share_zone_page(args)
					[rdata_1, rdata_2].each do |rdata|
						args[:share_zone_domain] = {'rname'=>@case_ID, 'rtype'=>'A', 'rdata'=>rdata}
						r << DNS.check_on_single_share_zone_rr(args, checkon = false, expected_fail = true)
					end
					# 清理
					r << Share_zone_er.del_share_zone(args)
					args[:view_name] = share_view
					r << View_er.del_view(args)
					args[:view_name] = 'default'
					r << Zone_er.del_zone(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_23183(args)
				# 编辑共享区记录
				@case_ID                 = __method__.to_s.split('_')[1]
				r                        = []
				args[:acl_name]          = "acl_#{@case_ID}"
				args[:acl_list]          = Local_Network
				share_view               = "view_#{@case_ID}"
				args[:zone_name]         = "zone.#{@case_ID}"
				args[:owner_list]        = Node_Name_List
				args[:share_zone_name]   = args[:zone_name]
				args[:share_zone_views]  = ['default', share_view]
				rdata_1                  = '192.168.231.83'
				rdata_2                  = '192.168.23.183'
				begin
					r << ACL_er.create_acl(args)
					args[:view_name] = share_view
					r << View_er.create_view(args)
					['default', share_view].each do |view_name|
						args[:view_name] = view_name
						r << Zone_er.create_zone(args)
					end
					r << Share_zone_er.create_share_zone(args)
					args[:share_zone_domain] = {'rname'=>@case_ID, 'rtype'=>'A', 'rdata'=>rdata_1}
					r << Share_zone_er.create_share_zone_rr(args)
					# 新建后dig
					args[:expected_dig_fail] = false
					args[:sleepfirst]        = false
					args[:server_list]       = Node_IP_List
					args[:domain_name]       = "#{@case_ID}.zone.#{@case_ID}"
					args[:rtype]             = 'A'
					args[:actual_rdata]      = rdata_1
					r << Dig_er.compare_domain(args)
					# 编辑后dig
					args[:share_zone_domain] = {'rname'=>@case_ID, 'rtype'=>'A', 'rdata'=>rdata_1, 'rdata_new'=>rdata_2}
					r << Share_zone_er.edit_share_zone_rr(args)
					args[:actual_rdata]      = rdata_2
					r << Dig_er.compare_domain(args)
					# 清理
					r << Share_zone_er.del_share_zone(args)
					args[:view_name] = share_view
					r << View_er.del_view(args)
					args[:view_name] = 'default'
					r << Zone_er.del_zone(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24711(args)
				# 编辑共享区TTL
				@case_ID                = __method__.to_s.split('_')[1]
				r                       = []
				args[:acl_name]         = "acl_#{@case_ID}"
				args[:acl_list]         = Local_Network
				share_view              = "view_#{@case_ID}"
				args[:zone_name]        = "zone.#{@case_ID}"
				args[:owner_list]       = Node_Name_List
				args[:share_zone_name]  = args[:zone_name]
				args[:share_zone_views] = ['default', share_view]
				rdata                   = '192.168.247.11'
				new_ttl                 = '600'
				org_domain              = {'rname'=>@case_ID, 'rtype'=>'A', 'rdata'=>rdata}
				ttl_domain              = {'rname'=>@case_ID, 'rtype'=>'A', 'rdata'=>rdata, 'ttl'=>new_ttl}
				begin
					r << ACL_er.create_acl(args)
					args[:view_name] = share_view
					r << View_er.create_view(args)
					['default', share_view].each do |view_name|
						args[:view_name] = view_name
						r << Zone_er.create_zone(args)
					end
					r << Share_zone_er.create_share_zone(args)
					# 编辑TTL
					args[:share_zone_ttl] = new_ttl
					r << Share_zone_er.edit_share_zone(args)
					# 验证变化
					args[:share_zone_domain] = org_domain
					r << Share_zone_er.create_share_zone_rr(args)
					DNS.goto_share_zone_page(args)
					args[:share_zone_domain] = ttl_domain
					r << DNS.check_on_single_share_zone_rr(args)
					args[:rname] = @case_ID
					args[:rtype] = 'A'
					args[:rdata] = rdata
					args[:ttl]   = new_ttl
					['default', share_view].each do |view_name|
						args[:view_name] = view_name
						DNS.goto_zone_page(args)
						r << DNS.check_on_single_domain(args)
					end
					# 清理
					r << Share_zone_er.del_share_zone(args)
					args[:view_name] = share_view
					r << View_er.del_view(args)
					args[:view_name] = 'default'
					r << Zone_er.del_zone(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24710(args)
				# 编辑共享区记录TTL
				@case_ID                = __method__.to_s.split('_')[1]
				r                       = []
				args[:acl_name]         = "acl_#{@case_ID}"
				args[:acl_list]         = Local_Network
				share_view              = "view_#{@case_ID}"
				args[:zone_name]        = "zone.#{@case_ID}"
				args[:owner_list]       = Node_Name_List
				args[:share_zone_name]  = args[:zone_name]
				args[:share_zone_views] = ['default', share_view]
				rdata                   = '192.168.247.10'
				ttl_new                 = '600'
				org_domain              = {'rname'=>@case_ID, 'rtype'=>'A', 'rdata'=>rdata}
				ttl_domain              = {'rname'=>@case_ID, 'rtype'=>'A', 'rdata'=>rdata, 'ttl_new'=>ttl_new}
				begin
					r << ACL_er.create_acl(args)
					args[:view_name] = share_view
					r << View_er.create_view(args)
					['default', share_view].each do |view_name|
						args[:view_name] = view_name
						r << Zone_er.create_zone(args)
					end
					r << Share_zone_er.create_share_zone(args)
					args[:share_zone_domain] = org_domain
					r << Share_zone_er.create_share_zone_rr(args)
					# 编辑TTL
					args[:share_zone_domain] = ttl_domain
					r << Share_zone_er.edit_share_zone_rr(args)
					args[:rname] = @case_ID
					args[:rtype] = 'A'
					args[:rdata] = rdata
					args[:ttl]   = ttl_new
					['default', share_view].each do |view_name|
						args[:view_name] = view_name
						DNS.goto_zone_page(args)
						r << DNS.check_on_single_domain(args)
					end
					# 清理
					r << Share_zone_er.del_share_zone(args)
					args[:view_name] = share_view
					r << View_er.del_view(args)
					args[:view_name] = 'default'
					r << Zone_er.del_zone(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24753(args)
				# 编辑所属视图
				@case_ID               = __method__.to_s.split('_')[1]
				r                      = []
				args[:acl_name]        = "acl_#{@case_ID}"
				args[:acl_list]        = Local_Network
				share_view_1           = "view_#{@case_ID}_1"
				share_view_2           = "view_#{@case_ID}_2"
				args[:zone_name]       = "zone.#{@case_ID}"
				args[:owner_list]      = Node_Name_List
				args[:share_zone_name] = args[:zone_name]
				rdata                  = '192.168.247.53'
				view_0_1               = ['default', share_view_1]
				view_0_2               = ['default', share_view_2]
				view_1_2               = [share_view_1, share_view_2]
				view_0_1_2             = ['default', share_view_1, share_view_2]
				begin
					r << ACL_er.create_acl(args)
					view_1_2 .each do |view|
					 	args[:view_name] = view
						r << View_er.create_view(args)
					end
					view_0_1_2.each do |view_name|
						args[:view_name] = view_name
						r << Zone_er.create_zone(args)
					end
					args[:share_zone_views] = ['default', share_view_1]
					r << Share_zone_er.create_share_zone(args)
					args[:share_zone_domain] = {'rname'=>@case_ID, 'rtype'=>'A', 'rdata'=>rdata}
					r << Share_zone_er.create_share_zone_rr(args)
					# 修改所属视图: 0,1 -> 0, 1, 2
					args[:share_zone_old_views] = view_0_1
					args[:share_zone_new_views] = view_0_1_2
					r << Share_zone_er.edit_share_zone(args)
					args[:rname] = @case_ID
					args[:rtype] = 'A'
					args[:rdata] = rdata
					view_0_1_2.each do |view|
						args[:view_name] = view
						DNS.goto_zone_page(args)
						r << DNS.check_on_single_domain(args)
					end
					# 修改所属视图: 0,1,2 -> 1,2
					args[:share_zone_old_views] = view_0_1_2
					args[:share_zone_new_views] = view_1_2
					r << Share_zone_er.edit_share_zone(args)
					view_1_2.each do |view|
						args[:view_name] = view
						DNS.goto_zone_page(args)
						r << DNS.check_on_single_domain(args)
					end
					# default视图下共享区记录被删除
					args[:view_name] = 'default'
					DNS.goto_zone_page(args)
					r << DNS.check_on_single_domain(args, checkon=true, expected_fail=true)
					# 修改所属视图: 1,2 -> 0,2 保留原区纪录
					args[:share_zone_old_views] = view_1_2
					args[:share_zone_new_views] = view_0_2
					r << Share_zone_er.edit_share_zone(args, keep_rr=true)
					view_0_1_2.each do |view|
						args[:view_name] = view
						DNS.goto_zone_page(args)
						r << DNS.check_on_single_domain(args)
					end
					# 清理
					r << Share_zone_er.del_share_zone(args)
					r << View_er.del_view_list(view_1_2)
					args[:view_name] = 'default'
					r << Zone_er.del_zone(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24707(args)
				# 编辑共享区记录后宕机切换被删除
				@case_ID                      = __method__.to_s.split('_')[1]
				r                             = []
				args[:acl_name]               = "acl_#{@case_ID}"
				args[:acl_list]               = Local_Network
				share_view                    = "view_#{@case_ID}"
				args[:zone_name]              = "zone.#{@case_ID}"
				args[:owner_list]             = Node_Name_List
				args[:share_zone_name]        = args[:zone_name]
				args[:share_zone_views]       = ['default', share_view]
				args[:strategy_name]          = '宕机切换'
				args[:strategy_handle_method] = '告警'
				rdata                         = '192.168.247.7'
				new_rdata                     = '192.168.24.77'
				domain                        = {'rname'=>@case_ID,'rtype'=>'A','rdata'=>rdata}
				new_domain                    = {'rname'=>@case_ID,'rtype'=>'A','rdata_old'=>rdata,'strategy_name'=>args[:strategy_name]}
				new_share_domain              = {'rname'=>@case_ID,'rtype'=>'A','rdata'=>rdata, 'rdata_new'=>new_rdata}
				begin
					r << ACL_er.create_acl(args)
					args[:view_name] = share_view
					r << View_er.create_view(args)
					['default', share_view].each do |view_name|
						args[:view_name] = view_name
						r << Zone_er.create_zone(args)
					end
					r << Share_zone_er.create_share_zone(args)
					args[:share_zone_domain] = domain
					r << Share_zone_er.create_share_zone_rr(args)
					r << ACL_Mng_er.create_monitor_strategy(args)
					# 权威域名添加宕机切换后, 编辑共享区记录
					args[:domain_list] = [new_domain]
					['default', share_view].each do |view_name|
						args[:view_name] = view_name
						r << Domain_er.edit_domain(args)
					end
					args[:share_zone_domain] = new_share_domain
					r << Share_zone_er.edit_share_zone_rr(args)
					# 验证权威域名宕机切换被删除.
					['default', share_view].each do |view_name|
						args[:view_name] = view_name
						DNS.goto_zone_page(args)
						search_string = DNS.get_all_search_string(new_rdata)
						r << 'fail' if search_string.include?(args[:strategy_name])
					end
					# 清理
					r << Share_zone_er.del_share_zone(args)
					args[:view_name] = share_view
					r << View_er.del_view(args)
					args[:view_name] = 'default'
					r << Zone_er.del_zone(args)
					r << ACL_er.del_acl(args)
					r << ACL_Mng_er.del_monitor_strategy(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24731(args)
				# 联动删除共享区
				@case_ID                = __method__.to_s.split('_')[1]
				r                       = []
				share_view_1            = "view_#{@case_ID}_1"
				share_view_2            = "view_#{@case_ID}_2"
				args[:zone_name]        = "zone.#{@case_ID}"
				args[:owner_list]       = Node_Name_List
				args[:share_zone_name]  = args[:zone_name]
				begin
					# 删除视图, 共享区被删除
					args[:view_name] = share_view_1
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					args[:share_zone_views] = [share_view_1]
					r << Share_zone_er.create_share_zone(args)
					r << View_er.del_view(args)
					DNS.open_share_zone_page
					r << DNS.check_on_single_share_zone(args, expected_fail=true)
					# 删除权威区, 共享区被删除
					args[:view_name] = share_view_1
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					args[:share_zone_views] = [share_view_1]
					r << Share_zone_er.create_share_zone(args)
					r << Zone_er.del_zone(args)
					DNS.open_share_zone_page
					r << DNS.check_on_single_share_zone(args, expected_fail=true)
					# 删除一个视图, 所属视图更新
					args[:view_name] = share_view_2
					r << View_er.create_view(args)
					[share_view_1, share_view_2].each do |view|
						args[:view_name] = view
						r << Zone_er.create_zone(args)
					end
					args[:share_zone_views] = [share_view_1,share_view_2]
					r << Share_zone_er.create_share_zone(args)
					args[:view_name] = share_view_2
					r << View_er.del_view(args)
					DNS.open_share_zone_page
					view_owner = DNS.get_cur_elem_string(args[:zone_name])
					r << 'fail' if view_owner.include?(share_view_2)
					# 删除一个权威区, 所属视图更新
					args[:view_name] = share_view_2
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					r << Share_zone_er.del_share_zone(args)
					args[:share_zone_views] = [share_view_1,share_view_2]
					r << Share_zone_er.create_share_zone(args)
					args[:view_name] = share_view_1
					r << Zone_er.del_zone(args)
					DNS.open_share_zone_page
					view_owner = DNS.get_cur_elem_string(args[:zone_name])
					r << 'fail' if view_owner.include?(share_view_1)
					# 清理
					r << Share_zone_er.del_share_zone(args)
					r << View_er.del_view_list([share_view_1, share_view_2])
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24712(args)
				# 删除共享区保留原记录
				@case_ID                = __method__.to_s.split('_')[1]
				r                       = []
				args[:acl_name]         = "acl_#{@case_ID}"
				args[:acl_list]         = Local_Network
				share_view              = "view_#{@case_ID}"
				args[:zone_name]        = "zone.#{@case_ID}"
				args[:owner_list]       = Node_Name_List
				args[:share_zone_name]  = args[:zone_name]
				args[:share_zone_views] = ['default', share_view]
				rdata                   = '192.168.247.12'
				domain                  = {'rname'=>@case_ID,'rtype'=>'A','rdata'=>rdata}
				begin
					r << ACL_er.create_acl(args)
					args[:view_name] = share_view
					r << View_er.create_view(args)
					['default', share_view].each do |view_name|
						args[:view_name] = view_name
						r << Zone_er.create_zone(args)
					end
					r << Share_zone_er.create_share_zone(args)
					args[:share_zone_domain] = domain
					r << Share_zone_er.create_share_zone_rr(args)
					# 删除共享区记录(保留原记录), 再dig
					r << Share_zone_er.del_share_zone(args, keep_rr = true)
					args[:expected_dig_fail] = false
					args[:sleepfirst]        = false
					args[:server_list]       = Node_IP_List
					args[:domain_name]       = "#{@case_ID}.#{args[:zone_name]}"
					args[:rtype]             = 'A'
					args[:actual_rdata]      = rdata
					r << Dig_er.compare_domain(args)
					# 清理
					args[:view_name] = share_view
					r << View_er.del_view(args)
					args[:view_name] = 'default'
					r << Zone_er.del_zone(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24713(args)
				# 删除共享区后新建重复记录
				@case_ID                = __method__.to_s.split('_')[1]
				r                       = []
				args[:acl_name]         = "acl_#{@case_ID}"
				args[:acl_list]         = Local_Network
				share_view              = "view_#{@case_ID}"
				args[:zone_name]        = "zone.#{@case_ID}"
				args[:owner_list]       = Node_Name_List
				args[:share_zone_views] = ['default', share_view]
				rdata                   = '192.168.247.13'
				domain                  = {'rname'=>@case_ID,'rtype'=>'A','rdata'=>rdata}
				begin
					r << ACL_er.create_acl(args)
					args[:view_name] = share_view
					r << View_er.create_view(args)
					['default', share_view].each do |view_name|
						args[:view_name] = view_name
						r << Zone_er.create_zone(args)
					end
					args[:share_zone_name]   = args[:zone_name]
					args[:share_zone_domain] = domain
					r << Share_zone_er.create_share_zone(args)
					r << Share_zone_er.create_share_zone_rr(args)
					# 删除共享区, 再新建同样的权威记录
					r << Share_zone_er.del_share_zone(args)
					args[:domain_list] = [domain]
					r << Domain_er.create_domain(args)
					# 清理
					args[:view_name] = share_view
					r << View_er.del_view(args)
					args[:view_name] = 'default'
					r << Zone_er.del_zone(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24714(args)
				# 删除共享区新建记录
				@case_ID                = __method__.to_s.split('_')[1]
				r                       = []
				args[:acl_name]         = "acl_#{@case_ID}"
				args[:acl_list]         = Local_Network
				share_view              = "view_#{@case_ID}"
				args[:zone_name]        = "zone.#{@case_ID}"
				args[:owner_list]       = Node_Name_List
				args[:share_zone_views] = ['default', share_view]
				rdata                   = '192.168.247.14'
				domain                  = {'rname'=>@case_ID,'rtype'=>'A','rdata'=>rdata}
				new_domain = {'rname'=>@case_ID,'rtype'=>'A','rdata'=>'192.168.247.41'}
				begin
					r << ACL_er.create_acl(args)
					args[:view_name] = share_view
					r << View_er.create_view(args)
					['default', share_view].each do |view_name|
						args[:view_name] = view_name
						r << Zone_er.create_zone(args)
					end
					args[:share_zone_name]   = args[:zone_name]
					args[:share_zone_domain] = domain
					r << Share_zone_er.create_share_zone(args)
					r << Share_zone_er.create_share_zone_rr(args)
					# 删除共享区, 再新建权威记录
					r << Share_zone_er.del_share_zone(args)
					args[:domain_list] = [new_domain]
					r << Domain_er.create_domain(args)
					# 清理
					args[:view_name] = share_view
					r << View_er.del_view(args)
					args[:view_name] = 'default'
					r << Zone_er.del_zone(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_23159(args)
				# 删除多个共享区
				@case_ID                = __method__.to_s.split('_')[1]
				r                       = []
				args[:acl_name]         = "acl_#{@case_ID}"
				args[:acl_list]         = Local_Network
				share_view              = "view_#{@case_ID}"
				share_zones             = ["zone.#{@case_ID}_1", "zone.#{@case_ID}_2"]
				args[:owner_list]       = Node_Name_List
				args[:share_zone_views] = ['default', share_view]
				rdata                   = '192.168.231.59'
				domain                  = {'rname'=>@case_ID,'rtype'=>'A','rdata'=>rdata}
				begin
					r << ACL_er.create_acl(args)
					args[:view_name] = share_view
					r << View_er.create_view(args)
					['default', share_view].each do |view_name|
						args[:view_name] = view_name
						share_zones.each do |zone_name|
							args[:zone_name] = zone_name
							r << Zone_er.create_zone(args)
						end
					end
					args[:share_zone_domain] = domain
					share_zones.each do |zone_name|
						args[:share_zone_name] = zone_name
						r << Share_zone_er.create_share_zone(args)
						r << Share_zone_er.create_share_zone_rr(args)
					end
					# 删除2个共享区记录, 不保留原记录
					share_zones.each do |zone_name|
						args[:share_zone_name] = zone_name
						r << Share_zone_er.del_share_zone(args)
					end
					args[:rtype] = 'A'
					Node_IP_List.each do |node_ip|
						args[:dig_ip] = node_ip
						share_zones.each do |zone_name|
							args[:domain_name] = @case_ID + '.' + zone_name
							r << DNS.dig_as_nxdomain(args)
						end
					end
					# 清理
					args[:view_name] = share_view
					r << View_er.del_view(args)
					args[:view_name] = 'default'
					args[:zone_list] = share_zones
					r << Zone_er.del_zone_list(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_23162(args)
				# 中文共享区记录前台增删改查
				@case_ID                = __method__.to_s.split('_')[1]
				r                       = []
				args[:acl_name]         = "acl_#{@case_ID}"
				args[:acl_list]         = Local_Network
				share_view              = "view_#{@case_ID}"
				args[:zone_name]        = "中文共享区"
				args[:owner_list]       = Node_Name_List
				args[:share_zone_views] = ['default', share_view]
				rdata                   = '192.168.231.62'
				new_rdata               = '192.168.231.63'
				domain                  = {'rname'=>@case_ID,'rtype'=>'A','rdata'=>rdata}
				new_domain              = {'rname'=>@case_ID,'rtype'=>'A','rdata'=>rdata, 'rdata_new'=>new_rdata}
				begin
					r << ACL_er.create_acl(args)
					args[:view_name] = share_view
					r << View_er.create_view(args)
					['default', share_view].each do |view_name|
						args[:view_name] = view_name
						r << Zone_er.create_zone(args)
					end
					# 新建Dig
					args[:share_zone_domain] = domain
					args[:share_zone_name]   = args[:zone_name]
					r << Share_zone_er.create_share_zone(args)
					r << Share_zone_er.create_share_zone_rr(args)
					args[:expected_dig_fail] = false
					args[:sleepfirst]        = false
					args[:server_list]       = Node_IP_List
					args[:domain_name]       = SimpleIDN.to_ascii("#{domain['rname']}.#{args[:zone_name]}")
					args[:rtype]             = 'A'
					args[:actual_rdata]      = rdata
					r << Dig_er.compare_domain(args)
					# 编辑Dig
					args[:share_zone_domain] = new_domain
					r << Share_zone_er.edit_share_zone_rr(args)
					args[:actual_rdata]      = new_rdata
					r << Dig_er.compare_domain(args)
					# 删除Dig
					args[:share_zone_domain] = {'rname'=>@case_ID,'rtype'=>'A','rdata'=>new_rdata}
					r << Share_zone_er.del_share_zone_rr(args)
					args[:rtype] = 'A'
					Node_IP_List.each do |node_ip|
						args[:dig_ip] = node_ip
						r << DNS.dig_as_nxdomain(args)
					end
					# 清理
					args[:view_name] = share_view
					r << View_er.del_view(args)
					args[:view_name] = 'default'
					r << Zone_er.del_zone(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_23145(args)
				# 批量添加中文共享区记录
				@case_ID                = __method__.to_s.split('_')[1]
				r                       = []
				args[:acl_name]         = "acl_#{@case_ID}"
				args[:acl_list]         = Local_Network
				share_view              = "view_#{@case_ID}"
				args[:zone_name]        = "中文共享区导入"
				args[:owner_list]       = Node_Name_List
				args[:share_zone_views] = ['default', share_view]
				begin
					r << ACL_er.create_acl(args)
					args[:view_name] = share_view
					r << View_er.create_view(args)
					['default', share_view].each do |view_name|
						args[:view_name] = view_name
						r << Zone_er.create_zone(args)
					end
					args[:share_zone_name] = args[:zone_name]
					r << Share_zone_er.create_share_zone(args)
					# 导入 + dig
					args[:imported_file] = Upload_Dir + 'zone\23145.txt'
					r << Share_zone_er.import_share_zone_rr(args)
					# # dig 权威区
					args[:expected_dig_fail] = false
					args[:sleepfirst]        = false
					args[:server_list]       = Node_IP_List
					imported_file = File.open(args[:imported_file], 'rb')
					imported_file.each_line do |line|
						domain = line.force_encoding('utf-8').split("\s")
						args[:domain_name]  = SimpleIDN.to_ascii("#{domain[0]}.#{args[:zone_name]}")
						args[:rtype]        = domain[2]
						args[:actual_rdata] = domain[3]
						r << Dig_er.compare_domain(args)
					end
					# 清理
					args[:view_name] = share_view
					r << View_er.del_view(args)
					args[:view_name] = 'default'
					r << Zone_er.del_zone(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_23170(args)
				# 共享区权限验证
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:acl_name]   = "acl_#{@case_ID}"
				args[:acl_list]   = Local_Network
				zone_1            = "zone#{@case_ID}_1"
				zone_2            = "zone#{@case_ID}_2"
				zone_3            = "zone#{@case_ID}_3"
				share_view        = "view_#{@case_ID}"
				args[:zone_name]  = "zone.#{@case_ID}"
				args[:owner_list] = Node_Name_List
				rdata             = '192.168.231.70'
				domain            = {'rname'=>@case_ID,'rtype'=>'A','rdata'=>rdata}
				new_user_rdata    = '192.168.231.71'
				new_user_domain   = {'rname'=>@case_ID,'rtype'=>'A','rdata'=>new_user_rdata}
				begin
					r << ACL_er.create_acl(args)
					args[:view_name] = share_view
					r << View_er.create_view(args)
					[share_view, 'default'].each do |view|
						args[:view_name] = view
						[zone_1, zone_2, zone_3].each do |zone|
							args[:zone_name] = zone
							r << Zone_er.create_zone(args)
						end
					end
					args[:share_zone_views] = ['default',share_view]
					args[:share_zone_domain] = domain
					[zone_1, zone_2, zone_3].each do |zone|
						args[:share_zone_name] = zone
						r << Share_zone_er.create_share_zone(args)
						r << Share_zone_er.create_share_zone_rr(args)
					end
					# 创建用户 + 3个权限
					args[:user_name]   = "user" + @case_ID
					args[:password]    = "1qaz2WSX"
					args[:re_password] = "1qaz2WSX"
					r << User_er.create_user(args)
					args[:view_name] = share_view
					{zone_1=>'修改', zone_2=>'只读', zone_3=>'隐藏'}.each_pair do |zone, authority|
						args[:zone_name] = zone
						args[:authority] = authority
						r << User_er.create_authority(args)
					end
					args[:view_name] = 'default'
					args[:zone_name] = '*'
					args[:authority] = '修改'
					r << User_er.create_authority(args)
					# 验证权限
					new_br = System.start_new_browser_with_new_user(args)
					return "failed case #{@case_ID}" if new_br == "failed"
					old_br = ZDDI.browser
					ZDDI.browser = new_br
					# zone_1 可以新建
					args[:share_zone_name] = zone_1
					args[:share_zone_domain] = new_user_domain
					r << Share_zone_er.create_share_zone_rr(args)
					# zone_2 只读
					args[:zone_name] = zone_2
					args[:share_zone_name] = zone_2
					args[:share_zone_domain] = domain
					DNS.goto_share_zone_page(args)
					r << DNS.check_on_single_share_zone_rr(args, checkon=false, expected_fail=false)
					args[:share_zone_domain] = new_user_domain
	                args[:error_type] = 'after_OK'
	                args[:error_info] = '用户权限不足'
	                DNS.goto_share_zone_page(args)
	                DNS.inputs_share_zone_rr_dialog(args)
	                r << DNS.error_validator_on_popwin(args)
					# zone_3 隐藏
					DNS.open_share_zone_page
					args[:share_zone_name] = zone_3
					r << DNS.check_on_single_share_zone(args, expected_fail=true)
					# 清理
					new_br.close
					ZDDI.browser = old_br
					args[:view_name] = share_view
					r << View_er.del_view(args)
					args[:view_name] = 'default'
					args[:zone_list] = [zone_1, zone_2, zone_3]
					r << Zone_er.del_zone_list(args)
					r << ACL_er.del_acl(args)
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_23322(args)
				# 共享区记录前台查询
				@case_ID                = __method__.to_s.split('_')[1]
				r                       = []
				args[:acl_name]         = "acl_#{@case_ID}"
				args[:acl_list]         = Local_Network
				share_view              = "view_#{@case_ID}"
				args[:zone_name]        = "zone.#{@case_ID}"
				args[:owner_list]       = Node_Name_List
				args[:share_zone_views] = ['default', share_view]
				rdata                   = '192.168.233.22'
				rdata_4a                = '192:168:233::22'
				dm_1                    = {'rname'=>'中文','rtype'=>'A','rdata'=>rdata}
				dm_2                    = {'rname'=>@case_ID,'rtype'=>'A','rdata'=>rdata}
				dm_3                    = {'rname'=>@case_ID,'rtype'=>'AAAA','rdata'=>rdata_4a}
				begin
					r << ACL_er.create_acl(args)
					args[:view_name] = share_view
					r << View_er.create_view(args)
					['default', share_view].each do |view_name|
						args[:view_name] = view_name
						r << Zone_er.create_zone(args)
					end
					# 新建
					args[:share_zone_name] = args[:zone_name]
					r << Share_zone_er.create_share_zone(args)
					[dm_1, dm_2, dm_3].each do |domain|
						args[:share_zone_domain] = domain
						r << Share_zone_er.create_share_zone_rr(args)
					end
					# 当前页面搜索
					DNS.goto_share_zone_page(args)
					['中文', rdata, rdata_4a].each do |search_name|
						ser = DNS.get_all_search_string(search_name)
						r << 'fail' if ser == []
					end
					# 全局搜索
					args[:search_item] = "#{@case_ID}*"
					args[:rdata] = '192.168.23.22'
					ser = Search_er.get_search_result(args)
					r << 'fail' if ser.size != 4
					ser.each do |domain_line|
						r << 'fail' if !domain_line.to_s.include?(args[:zone_name])
					end
					# 清理
					args[:view_name] = share_view
					r << View_er.del_view(args)
					args[:view_name] = 'default'
					r << Zone_er.del_zone(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_23157(args)
				# 选择根区为共享区
				@case_ID                 = __method__.to_s.split('_')[1]
				r                        = []
				args[:acl_name]          = "acl_#{@case_ID}"
				args[:acl_list]          = Local_Network
				share_view               = "view_#{@case_ID}"
				args[:zone_name]         = '@'
				args[:owner_list]        = Node_Name_List
				args[:share_zone_name]   = args[:zone_name]
				args[:share_zone_views]  = ['default', share_view]
				rdata                    = '192.168.231.57'
				args[:share_zone_domain] = {'rname'=>@case_ID, 'rtype'=>'A', 'rdata'=>rdata}
				begin
					r << ACL_er.create_acl(args)
					args[:view_name] = share_view
					r << View_er.create_view(args)
					['default', share_view].each do |view_name|
						args[:view_name] = view_name
						r << Zone_er.create_zone(args)
					end
					r << Share_zone_er.create_share_zone(args)
					r << Share_zone_er.create_share_zone_rr(args)
					# dig 权威区
					args[:expected_dig_fail] = false
					args[:sleepfirst]        = false
					args[:server_list]       = Node_IP_List
					args[:domain_name]       = "#{@case_ID}"
					args[:rtype]             = 'A'
					args[:actual_rdata]      = rdata
					r << Dig_er.compare_domain(args)
					# 清理
					args[:view_name] = share_view
					r << View_er.del_view(args)
					args[:view_name] = 'default'
					r << Zone_er.del_zone(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_23205(args)
				# 在权威区编辑保留后的共享区记录
				@case_ID                = __method__.to_s.split('_')[1]
				r                       = []
				args[:acl_name]         = "acl_#{@case_ID}"
				args[:acl_list]         = Local_Network
				share_view              = "view_#{@case_ID}"
				args[:zone_name]        = "zone.#{@case_ID}"
				args[:owner_list]       = Node_Name_List
				args[:share_zone_name]  = args[:zone_name]
				args[:share_zone_views] = ['default', share_view]
				rdata      = '192.168.232.5'
				rdata_new  = '192.168.23.205'
				domain     = {'rname'=>@case_ID,'rtype'=>'A','rdata'=>rdata}
				domain_new = {'rname'=>@case_ID,'rtype'=>'A','rdata_old'=>rdata, 'rdata_new'=>rdata_new}
				begin
					r << ACL_er.create_acl(args)
					args[:view_name] = share_view
					r << View_er.create_view(args)
					['default', share_view].each do |view_name|
						args[:view_name] = view_name
						r << Zone_er.create_zone(args)
					end
					r << Share_zone_er.create_share_zone(args)
					args[:share_zone_domain] = domain
					r << Share_zone_er.create_share_zone_rr(args)
					# 删除共享区记录(保留原记录) 编辑权威区后再dig
					r << Share_zone_er.del_share_zone(args, keep_rr = true)
					args[:domain_list] = [domain_new]
					r << Domain_er.edit_domain(args)
					args[:expected_dig_fail] = false
					args[:sleepfirst]        = false
					args[:server_list]       = Node_IP_List
					args[:domain_name]       = "#{@case_ID}.#{args[:zone_name]}"
					args[:rtype]             = 'A'
					args[:actual_rdata]      = rdata_new
					r << Dig_er.compare_domain(args)
					# 清理
					args[:view_name] = share_view
					r << View_er.del_view(args)
					args[:view_name] = 'default'
					r << Zone_er.del_zone(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_23303(args)
				# 共享区记录和本地策略重定向等记录重复
				@case_ID                = __method__.to_s.split('_')[1]
				r                       = []
				args[:acl_name]         = "acl_#{@case_ID}"
				args[:acl_list]         = Local_Network
				share_view              = "view_#{@case_ID}"
				args[:zone_name]        = "zone.#{@case_ID}"
				args[:owner_list]       = Node_Name_List
				args[:share_zone_name]  = args[:zone_name]
				args[:share_zone_views] = ['default', share_view]
				rdata_1                 = '192.168.233.1'
				rdata_2                 = '192.168.233.2'
				rdata_3                 = '192.168.233.3'
				domain                  = {'rname'=>@case_ID,'rtype'=>'A','rdata'=>rdata_1}
				begin
					r << ACL_er.create_acl(args)
					args[:view_name] = share_view
					r << View_er.create_view(args)
					['default', share_view].each do |view_name|
						args[:view_name] = view_name
						r << Zone_er.create_zone(args)
					end
					r << Share_zone_er.create_share_zone(args)
					args[:share_zone_domain] = domain
					r << Share_zone_er.create_share_zone_rr(args)
					args[:expected_dig_fail] = false
					args[:sleepfirst]        = false
					args[:server_list]       = Node_IP_List
					args[:domain_name]       = "#{@case_ID}.#{args[:zone_name]}"
					args[:rtype]             = 'A'
					args[:actual_rdata]      = rdata_1
					args[:rname] = args[:domain_name]
					args[:rdata] = rdata_3
					r << Recu_er.create_redirect(args)
					r << Dig_er.compare_domain(args)
					args[:local_type]        = '重定向'
					args[:ip]                = rdata_2
					r << Recu_er.create_local_policies(args)
					args[:actual_rdata]      = rdata_2
					r << Dig_er.compare_domain(args)
					# 清理
					r << Recu_er.del_local_policies(args)
					args[:view_name] = share_view
					r << View_er.del_view(args)
					args[:view_name] = 'default'
					r << Zone_er.del_zone(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_24706(args)
				# 修改视图保留记录
				@case_ID                 = __method__.to_s.split('_')[1]
				r                        = []
				args[:acl_name]          = "acl_#{@case_ID}"
				args[:acl_list]          = Local_Network
				share_view               = "view_#{@case_ID}"
				args[:zone_name]         = "zone.#{@case_ID}"
				args[:owner_list]        = Node_Name_List
				args[:share_zone_name]   = args[:zone_name]
				args[:share_zone_views]  = ['default', share_view]
				rdata                    = '192.168.247.6'
				begin
					r << ACL_er.create_acl(args)
					args[:view_name] = share_view
					r << View_er.create_view(args)
					['default', share_view].each do |view_name|
						args[:view_name] = view_name
						r << Zone_er.create_zone(args)
					end
					args[:share_zone_views]  = [share_view]
					args[:share_zone_domain] = {'rname'=>@case_ID, 'rtype'=>'A', 'rdata'=>rdata}
					r << Share_zone_er.create_share_zone(args)
					r << Share_zone_er.create_share_zone_rr(args)
					# 修改视图, 不保留rr
					args[:share_zone_old_views] = [share_view]
					args[:share_zone_new_views] = ['default']
					r << Share_zone_er.edit_share_zone(args, keep_rr=false)
					args[:domain_name] = @case_ID + '.' + args[:zone_name]
					args[:rtype] = 'A'
					Node_IP_List.each do |node_ip|
						args[:dig_ip] = node_ip
						r << DNS.dig_as_nxdomain(args)
					end
					# 重置视图
					args[:share_zone_old_views] = ['default']
					args[:share_zone_new_views] = [share_view]
					r << Share_zone_er.edit_share_zone(args, keep_rr=false)
					# 修改视图, 保留rr
					args[:share_zone_old_views] = [share_view]
					args[:share_zone_new_views] = ['default']
					r << Share_zone_er.edit_share_zone(args, keep_rr=true)
					Node_IP_List.each do |node_ip|
						args[:dig_ip] = node_ip
						r << DNS.dig_as_noerror(args)
					end
					# 清理
					args[:view_name] = share_view
					r << View_er.del_view(args)
					args[:view_name] = 'default'
					r << Zone_er.del_zone(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_23318(args)
				# 权威区/共享区/全局搜索交叉编辑记录
				@case_ID                 = __method__.to_s.split('_')[1]
				r                        = []
				args[:acl_name]          = "acl_#{@case_ID}"
				args[:acl_list]          = Local_Network
				share_view               = "view_#{@case_ID}"
				args[:zone_name]         = "zone.#{@case_ID}"
				args[:owner_list]        = [Master_Device]
				args[:share_zone_name]   = args[:zone_name]
				args[:share_zone_views]  = ['default', share_view]
				rdata_1                  = '192.168.233.18'
				rdata_2                  = '192.168.23.3'
				rdata_3                  = '192.168.23.18'
				rdata_4                  = '192.168.23.183'
				begin
					r << ACL_er.create_acl(args)
					args[:view_name] = share_view
					r << View_er.create_view(args)
					['default', share_view].each do |view_name|
						args[:view_name] = view_name
						r << Zone_er.create_zone(args)
					end
					r << Share_zone_er.create_share_zone(args)
					args[:share_zone_domain] = {'rname'=>@case_ID, 'rtype'=>'A', 'rdata'=>rdata_1}
					r << Share_zone_er.create_share_zone_rr(args)
					# 新建后dig
					args[:expected_dig_fail] = false
					args[:sleepfirst]        = false
					args[:server_list]       = [Master_IP]
					args[:domain_name]       = "#{@case_ID}.zone.#{@case_ID}"
					args[:rtype]             = 'A'
					args[:actual_rdata]      = rdata_1
					r << Dig_er.compare_domain(args)
					# 共享区内编辑
					args[:share_zone_domain] = {'rname'=>@case_ID, 'rtype'=>'A', 'rdata'=>rdata_1, 'rdata_new'=>rdata_2}
					r << Share_zone_er.edit_share_zone_rr(args)
					args[:actual_rdata] = rdata_2
					r << Dig_er.compare_domain(args)
					# 权威区内编辑
					args[:domain_list] = [{'rname'=>@case_ID, 'rtype'=>'A', 'rdata_old'=>rdata_2, 'rdata_new'=>rdata_3}]
					r << Domain_er.edit_domain(args)
					args[:actual_rdata] = rdata_3
					r << Dig_er.compare_domain(args)
					# 全局搜索编辑
					args[:search_item] = @case_ID + '*'
					args[:ttl]         = '600'
					args[:rdata]       = rdata_4
			  		r << Search_er.search_and_edit(args)
			  		args[:actual_rdata] = rdata_4
					r << Dig_er.compare_domain(args)
					# 清理
					r << Share_zone_er.del_share_zone(args)
					args[:view_name] = share_view
					r << View_er.del_view(args)
					args[:view_name] = 'default'
					r << Zone_er.del_zone(args)
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