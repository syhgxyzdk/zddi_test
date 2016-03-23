# encoding: utf-8
require File.dirname(__FILE__) + '/../../zddi'

module ZDDI
	module DNS
		class Forward
			def case_5002(args)
				# 同名权威区已存在
				@case_ID                   = __method__.to_s.split('_')[1]
				r                          = []
				args[:error_type]          = "after_OK"
				args[:error_info]          = "同名权威区已存在"
				args[:view_name]           = "view_5002"
				args[:zone_name]           = "zone.5002"
				args[:forward_server_list] = ['192.168.50.2']
				args[:forward_style]       = 'only'
				args[:owner_list]          = [Master_Device]
				begin 
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					DNS.inputs_forward_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_7146(args)
				# 删除视图连带删除转发区
				@case_ID                   = __method__.to_s.split('_')[1]
				r                          = []
				args[:view_name]           = "view_7146"
				args[:zone_name]           = "zone.7146"
				args[:forward_server_list] = ['192.168.71.46']
				args[:forward_style]       = 'only'
				args[:owner_list]          = [Master_Device]
				begin
					r << View_er.create_view(args)
					r << Recu_er.create_forward_zone(args)
					r << View_er.del_view(args)
					# 若可以选中,则表示删除失败
					DNS.open_forward_zone_page
					r << DNS.check_single_forward(args, expected_fail=true)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_5010(args)
				# 一次删除多个转发区
				@case_ID                   = __method__.to_s.split('_')[1]
				r                          = []
				args[:view_name]           = "view_5010"
				zone_name_list             = ['zone_5010_1', 'zone_5010_2', 'zone_5010_3']
				args[:owner_list]          = [Master_Device]
				args[:forward_server_list] = ["192.168.50.10"]
				args[:forward_style]       = 'only'
				begin
					r << View_er.create_view(args)
					zone_name_list.each do |zone_name|
						args[:zone_name] = zone_name
						r << Recu_er.create_forward_zone(args)
					end
					# 依次选择, 一起删除
					DNS.open_forward_zone_page
					zone_name_list.each do |zone_name|
						args[:zone_name] = zone_name
			        	r << DNS.check_single_forward(args)
			        end
			        r << DNS.del_checked_item
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_5009(args)
				# 删除单个转发区
				@case_ID                   = __method__.to_s.split('_')[1]
				r                          = []
				args[:view_name]           = "view_5009"
				args[:zone_name]           = "zone.5009"
				args[:owner_list]          = [Master_Device]
				args[:forward_server_list] = ["192.168.50.9"]
				args[:forward_style]       = 'first'
				begin
					r << View_er.create_view(args)
					r << Recu_er.create_forward_zone(args)
					# 删除
					r << Recu_er.del_forward_zone(args)
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_4961(args)
				# 同名转发区已经存在
				@case_ID                   = __method__.to_s.split('_')[1]
				r                          = []
				args[:error_type]          = "after_OK"
				args[:error_info]          = "同名转发区已经存在"
				args[:view_name]           = "view_4961"
				args[:zone_name]           = "zone.4961"
				args[:owner_list]          = [Master_Device]
				args[:forward_server_list] = ['192.168.49.61']
				args[:forward_style]       = 'only'
				begin
					r << View_er.create_view(args)
					r << Recu_er.create_forward_zone(args)
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

			def case_4959(args)
				# 输入重复的转发服务器
				@case_ID                   = __method__.to_s.split('_')[1]
				r                          = []
				args[:error_type]          = "before_OK"
				args[:error_info]          = "请勿输入重复项"
				args[:view_name]           = "view_4959"
				args[:zone_name]           = "zone.4959"
				args[:forward_server_list] = ['192.168.49.59', '192.168.49.59']
				args[:owner_list]          = [Master_Device]
				args[:forward_style]       = 'only'
				begin
					r << View_er.create_view(args)
					DNS.inputs_forward_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_4958(args)
				@case_ID                   = __method__.to_s.split('_')[1]
				r                          = []
				args[:view_name]           = "view_4958"
				args[:zone_name]           = "zone.4958"
				args[:forward_server_list] = ['192.168.49.58']
				args[:owner_list]          = [Master_Device]
				args[:forward_style]       = 'only'
				args[:error_type]          = "after_OK"
				args[:error_info]          = "同名转发区已经存在"
				begin
					r << View_er.create_view(args)
					r << Recu_er.create_forward_zone(args)
					DNS.inputs_forward_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_4946(args)
				# 参数校验输入空
				@case_ID             = __method__.to_s.split('_')[1]
				r                    = []
				args[:view_name]     = 'default'
				args[:zone_name]     = 'zone.4946'
				args[:error_type]    = "before_OK"
				args[:forward_style] = 'first'
				begin
					# 服务器输入空
					args[:error_info]          = '必选字段'
					args[:forward_server_list] = ['']
					args[:owner_list]          = [Master_Device]
					DNS.inputs_forward_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					# 节点输入为空
					args[:error_info]          = '至少选择一项'
					args[:forward_server_list] = ['192.168.49.46']
					args[:owner_list]          = ['']
					DNS.inputs_forward_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_4944(args)
				@case_ID             = __method__.to_s.split('_')[1]
				r                    = []
				args[:view_name]     = "default"
				args[:owner_list]    = [Master_Device]
				args[:forward_style] = 'only'
				args[:error_type]    = "before_OK"
				begin
	 				# 输入区名称错误
					args[:error_info]          = "区名格式不正确"
					args[:zone_name]           = "_Err_Zone_Name_^&%"
					args[:forward_server_list] = ["192.168.49.44"]
					DNS.inputs_forward_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					# 输入服务器错误
					args[:error_info]          = "非法的服务器列表"
					args[:zone_name]           = "zone.4944"
					args[:forward_server_list] = ["IP.Err.49.44"]
					DNS.inputs_forward_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_9498(args)
				# 域名含下划线
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				@forward_view_name = "view_#{@case_ID}"
				args[:acl_name]    = "acl_#{@case_ID}"
				args[:acl_list]    = Local_Network
				args[:zone_name]   = "zone.#{@case_ID}"
				args[:domain_list] = [{"rname"=>"a_under_line", "rtype"=>"A", "rdata"=>"192.168.94.98", "ttl"=>"3600"}]
	 			begin
	 				# Slave建主区
	 				args[:view_name]   = "default"
	 				args[:owner_list]  = [Slave_Device]
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					# Master建转发
					args[:view_name]  = @forward_view_name
					args[:owner_list] = [Master_Device]
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					args[:forward_server_list] = [Slave_IP]
					args[:forward_style]       = 'only'
					r << Recu_er.create_forward_zone(args)
					# dig
					args[:rname] = "#{args[:domain_list][0]["rname"]}.#{args[:zone_name]}"
					r << Dig_er.compare_domain(:server_list=>[Master_IP], :domain_name=>args[:rname], :rtype=>"A", :port=>DNS_Port, :actual_rdata=>"#{args[:domain_list][0]["rdata"]}", :sleepfirst=>"yes")
					# 清理
					args[:view_name] = "default"
					r << Zone_er.del_zone(args)
					args[:view_name] = @forward_view_name
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end

			def case_9504(args)
				# 配置后重启
				@case_ID                   = __method__.to_s.split('_')[1]
				r                          = []
				args[:view_name]           = "view_#{@case_ID}"
				args[:zone_name]           = "zone.#{@case_ID}"
				args[:owner_list]          = Node_Name_List
				args[:keyword]             = args[:zone_name]
				args[:forward_server_list] = ['192.168.95.4']
				args[:forward_style]       = 'first'
	 			begin
					r << View_er.create_view(args)
					r << Recu_er.create_forward_zone(args)
					r << DNS.grep_keyword_named(args)
					# 重启DNS
					Node_Name_List.each do |memberName|
						args[:node_name] = memberName
						r << Cloud.restart_device_dns_service(args)
					end
				    r << DNS.grep_keyword_named(args)
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_4954(args)
				# 同一服务器配置多个转发区
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				@forward_view_name = "view_#{@case_ID}"
				args[:zone_list]   = ["zone.#{@case_ID}.1", "zone.#{@case_ID}.2"]
	 			begin
	 				# Slave创建两个主区
					args[:view_name]   = "default"
					args[:owner_list]  = [Slave_Device]
					args[:domain_list] = [{"rname"=>"a_under_line", "rtype"=>"A", "rdata"=>"192.168.94.98", "ttl"=>"3600"}]
					args[:zone_list].each do |zone_name|
						args[:zone_name] = zone_name
						r << Zone_er.create_zone(args)
						r << Domain_er.create_domain(args)
					end
					# Master新建视图 + ACL
					args[:acl_name]   = "acl_#{@case_ID}"
					args[:acl_list]   = Local_Network
					args[:view_name]  = @forward_view_name
					args[:owner_list] = [Master_Device]
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					# Master创建两个转发区
					args[:forward_server_list] = [Slave_IP]
					args[:forward_style]       = 'only'
					args[:zone_list].each do |zone_name|
						args[:zone_name] = zone_name
						r << Recu_er.create_forward_zone(args)
					end
					# Dig
					args[:zone_list].each do |zone_name|
						@domain = "#{args[:domain_list][0]["rname"]}.#{zone_name}"
						@actual_rdata = "#{args[:domain_list][0]["rdata"]}"
						r << Dig_er.compare_domain(:server_list=>[Master_IP], :domain_name=>@domain, :rtype=>"A", :port=>DNS_Port, :actual_rdata=>@actual_rdata, :sleepfirst=>"yes")
					end
					# 清理
					args[:view_name] = "default"
					r << Zone_er.del_zone_list(args)
					args[:view_name] = @forward_view_name
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_9229(args)
				# 相同区的不同服务器, 返回响应速度快的服务器
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				@forward_view_name = "view_#{@case_ID}"
	 			begin
	 				# Slave建记录, 用于Dig
					args[:view_name]   = "default"
					args[:zone_name]   = "zone.#{@case_ID}"
					args[:owner_list]  = [Slave_Device]
					args[:domain_list] = [{"rname"=>"a_under_line", "rtype"=>"A", "rdata"=>"192.168.92.29", "ttl"=>"3600"}]
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					# 同一个区的两个转发服务器
					args[:acl_name]			= "acl_#{@case_ID}"
					args[:acl_list]			= Local_Network
					args[:view_name]           = @forward_view_name
					args[:owner_list]          = [Master_Device]
					args[:forward_server_list] = [Slave_IP, "8.8.8.8"]
					args[:forward_style]       = 'only'
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Recu_er.create_forward_zone(args)
					# Dig
					@domain = "#{args[:domain_list][0]["rname"]}.#{args[:zone_name]}"
					@actual_rdata = "#{args[:domain_list][0]["rdata"]}"
					r << Dig_er.compare_domain(:server_list=>[Master_IP], :domain_name=>@domain, :rtype=>"A", :port=>DNS_Port, :actual_rdata=>@actual_rdata, :sleepfirst=>"yes")
					# 清理
					args[:view_name] = "default"
					r << Zone_er.del_zone(args)
					args[:view_name] = @forward_view_name
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_11679(args)
				# 新建根配置后再新建根的转发, 不冲突
				@case_ID                   = __method__.to_s.split('_')[1]
				r                          = []
				args[:view_name]           = "view_#{@case_ID}"
				args[:zone_name]           = "@"
				args[:owner_list]          = Node_Name_List
				args[:forward_server_list] = [Slave_IP]
				args[:forward_style]       = 'only'
				begin
	 				r << View_er.create_view(args)
					r << Recu_er.create_hint_zone(args)
					r << Recu_er.create_forward_zone(args)
					# 清理
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_8399(args)
				# 修改默认端口, 转发正常
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				@forward_view_name = "view_#{@case_ID}"
				args[:zone_name]   = "zone.#{@case_ID}"
				args[:group_name]  = Slave_Group
				args[:node_name] = Slave_Device
				args[:listen_port] = "5053"
				begin
					args[:view_name]  = "default"
					args[:owner_list] = [Slave_Device]
					r << Zone_er.create_zone(args)
					args[:domain_list] = [{"rname"=>"a", "rtype"=>"A", "rdata"=>"192.168.83.99", "ttl"=>"3600"}]
					r << Domain_er.create_domain(args) # 创建rdata, 用于dig 
					# 修改辅节点DNS的端口号
					r << Cloud.change_dns_listen_port(args)
					# 创建ACL, VIEW, Forwarder, and dig it!
					args[:acl_name]   = "acl_#{@case_ID}"
					args[:acl_list]   = Local_Network
					args[:view_name]  = @forward_view_name
					args[:owner_list] = [Master_Device]
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					args[:forward_server_list] = ["#{Slave_IP}##{args[:listen_port]}"]
					args[:forward_style]       = 'only'
					r << Recu_er.create_forward_zone(args)
					@domain = "#{args[:domain_list][0]["rname"]}.#{args[:zone_name]}"
					@actual_rdata = "#{args[:domain_list][0]["rdata"]}"
					r << Dig_er.compare_domain(:server_list=>[Master_IP], :domain_name=>@domain, :rtype=>"A", :port=>DNS_Port, :actual_rdata=>@actual_rdata, :sleepfirst=>"yes")

					# 恢复辅节点DNS的端口号为53
					args[:listen_port] = "53"
					r << Cloud.change_dns_listen_port(args)
					# 清理
					args[:view_name] = "default"
					r << Zone_er.del_zone(args)
					args[:view_name] = @forward_view_name
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end

			def case_4991(args)
				# 转发区配置为根区
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				@forward_view_name = "view_#{@case_ID}"
				@rname             = "#{@case_ID}.com"
				@rdata             = "192.168.49.91"
				args[:zone_name]   = "@"
	 			begin
					args[:view_name]   = "default"
					args[:owner_list]  = [Slave_Device]
					r << Zone_er.create_zone(args)
					args[:domain_list] = [{"rname"=>@rname, "rtype"=>"A", "rdata"=>@rdata, "ttl"=>"3600"}]
					r << Domain_er.create_domain(args) # 创建rdata, 用于dig 
					args[:acl_name]    = "acl_#{@case_ID}"
					args[:acl_list]    = Local_Network
					args[:view_name]   = @forward_view_name
					args[:owner_list]  = [Master_Device]
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					args[:forward_server_list] = [Slave_IP]
					args[:forward_style]       = 'only'
					r << Recu_er.create_forward_zone(args)
					r << Dig_er.compare_domain(:server_list=>[Master_IP], :domain_name=>@rname, :rtype=>"A", :port=>DNS_Port, :actual_rdata=>@rdata, :sleepfirst=>"yes")
					# 清理
					args[:view_name] = "default"
					r << Zone_er.del_zone(args)
					args[:view_name] = @forward_view_name
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_5000(args)
				# 验证Only和First
				@case_ID                   = __method__.to_s.split('_')[1]
				r                          = []
				args[:zone_name]           = 'com'
				args[:forward_server_list] = [Slave_IP]
				args[:domain_name]         = "baidu.com"
				args[:dig_ip]              = Master_IP
				args[:rtype]               = 'A'
	 			begin
					# 所有节点缓存清零, Default视图验证First, 返回NoError(外网递归结果)
					r << Recu_er.del_all_cache_all_device(args)
					args[:view_name]     = 'default'
					args[:owner_list]    = [Master_Device]
					args[:forward_style] = 'first'
					r << Recu_er.create_forward_zone(args)
					r << DNS.dig_as_noerror(args)
					r << Recu_er.del_forward_zone(args)
					# 所有节点缓存清零, 新建视图验证Only, 返回Slave节点结果(NXDOMAIN)
					r << Recu_er.del_all_cache_all_device(args)
					args[:owner_list] = [Slave_Device]
					r << Zone_er.create_zone(args) # default视图建com区
					args[:view_name]  = "view_#{@case_ID}"
					args[:owner_list] = [Master_Device]
					args[:acl_name]   = "acl_#{@case_ID}"
					args[:acl_list]   = Local_Network
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					args[:forward_style] = 'only'
					r << Recu_er.create_forward_zone(args)
					r << DNS.dig_as_nxdomain(args)
					# 清理
					r << Recu_er.del_forward_zone(args)
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
					args[:view_name]     = 'default'
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_4996(args)
				# 编辑default视图的转发区 only->first, dig返回结果一致.
				@case_ID                   = __method__.to_s.split('_')[1]
				r                          = []
				args[:view_name]           = "default"
				args[:zone_name]           = "com"
				args[:forward_server_list] = [Slave_IP]
				args[:domain_name]         = "sohu.com"
				args[:dig_ip]              = Master_IP
				args[:rtype]               = 'A'
	 			begin
					# 所有节点缓存清零, Default视图验证First, 返回Slave的外网递归结果.
					r << Recu_er.del_all_cache_all_device(args)
					args[:owner_list]    = [Master_Device]
					args[:forward_style] = 'only'
					r << Recu_er.create_forward_zone(args)
					r << DNS.dig_as_noerror(args)
					# 所有节点缓存清零, 编辑转发区为first, 依然返回Slave的外网递归结果.
					r << Recu_er.del_all_cache_all_device(args)
					args[:forward_style] = 'first'
					r << Recu_er.edit_forward_zone(args)
					r << DNS.dig_as_noerror(args)
					# 清理
					r << Recu_er.del_forward_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_4997(args)
				# 非Default视图, 编辑转发配置 only -> first
				@case_ID           = "4997"
				r                  = []
				@forward_view_name = "view_#{@case_ID}"
				args[:view_name]   = "default"
				args[:zone_name]   = "zone.#{@case_ID}"
				args[:domain_list] = [{"rname"=>"a", "rtype"=>"A", "rdata"=>"192.168.49.97", "ttl"=>"600"}]
				args[:domain_name] = "a.zone.#{@case_ID}"
				args[:dig_ip]      = Master_IP
				args[:rtype]       = 'A'
	 			begin
	 				# Slave上创建rdata, 用于转发dig 
	 				args[:owner_list]  = [Slave_Device]
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					# Master上建转发区, 使用only
					args[:acl_name]            = "acl_#{@case_ID}"
					args[:acl_list]            = Local_Network
					args[:view_name]           = @forward_view_name
					args[:owner_list]          = [Master_Device]
					args[:forward_server_list] = [Slave_IP]
					args[:forward_style]       = 'only'
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Recu_er.create_forward_zone(args)
					# dig
					r << DNS.dig_as_noerror(args)
					# 编辑为first
					args[:forward_style] = 'first'
					r << Recu_er.edit_forward_zone(args)
					# 清理缓存, dig结果应该不变.
					r << Recu_er.del_all_cache_all_device(args)
					r << DNS.dig_as_noerror(args)
					# 清理数据
					args[:view_name] = "default"
					r << Zone_er.del_zone(args)
					args[:view_name] = @forward_view_name
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_9506(args)
				# 配置转发节为根区, 检查named中是.而不是@
				@case_ID                   = __method__.to_s.split('_')[1]
				r                          = []
				args[:view_name]           = "default"
				args[:zone_name]           = "@"
				args[:owner_list]          = Node_Name_List
				args[:forward_server_list] = ["192.168.55.30"]
				args[:forward_style]       = 'only'
	 			begin
					r << Recu_er.create_forward_zone(args)
					args[:keyword] = "zone \".\" {\ntype forward;\nforward only;\nforwarders { #{args[:forward_server_list][0]} port 53 ; };\n};"
					r << DNS.grep_keyword_named(args)
					r << Recu_er.del_forward_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			# 修改节点
			def case_5007(args)
				# 修改设备节点从All->SLAVE
				@case_ID                   = __method__.to_s.split('_')[1]
				r                          = []
				args[:view_name]           = "default"
				args[:zone_name]           = "zone.#{@case_ID}"
				args[:owner_list]          = Node_Name_List
				args[:forward_server_list] = ["192.168.50.7"]
				args[:forward_style]       = 'first'
	 			begin
					r << Recu_er.create_forward_zone(args)
					args[:keyword] = args[:zone_name]
					r << DNS.grep_keyword_named(args)
					args[:old_owner_list] = args[:owner_list]
			        args[:new_owner_list] = [Slave_Device]
					r << Recu_er.modify_forward_zone_member(args)
					args[:owner_list] = [Master_Device]
					r << DNS.grep_keyword_named(args, keyword_gone = true)
					args[:owner_list] = [Slave_Device]
					r << DNS.grep_keyword_named(args)
					r << Recu_er.del_forward_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_5008(args)
				# 修改设备节点从 MASTER -> ALL
				@case_ID                   = __method__.to_s.split('_')[1]
				r                          = []
				args[:view_name]           = "default"
				args[:zone_name]           = "zone.#{@case_ID}"
				args[:owner_list]          = [Master_Device]
				args[:forward_server_list] = ["192.168.50.8"]
				args[:forward_style]       = 'only'
	 			begin
					r << Recu_er.create_forward_zone(args)
					args[:keyword] = args[:zone_name]
					r << DNS.grep_keyword_named(args)
					args[:old_owner_list] = args[:owner_list]
			        args[:new_owner_list] = Node_Name_List
					r << Recu_er.modify_forward_zone_member(args)
					args[:owner_list] = Node_Name_List
					r << DNS.grep_keyword_named(args)
					r << Recu_er.del_forward_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_7147(args)
				# 修改视图设备节点 MASTER -> SLAVE, 转发区被删除.
				@case_ID                   = __method__.to_s.split('_')[1]
				r                          = []
				args[:view_name]           = "view_#{@case_ID}"
				args[:zone_name]           = "zone.#{@case_ID}"
				args[:owner_list]          = [Master_Device]
				args[:forward_server_list] = ['192.168.71.47']
				args[:forward_style]       = 'only'
				begin
					r << View_er.create_view(args)
					r << Recu_er.create_forward_zone(args)
					args[:keyword] = args[:zone_name]
					r << DNS.grep_keyword_named(args)
					args[:old_owner_list] = args[:owner_list]
					args[:new_owner_list] = [Slave_Device]
					r << View_er.modify_view_member(args)
					DNS.open_forward_zone_page
					r << DNS.check_single_forward(args, expected_fail=true)
					args[:owner_list] = Node_Name_List
					r << DNS.grep_keyword_named(args, keyword_gone=true)
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_14511(args)
				# 导入/导出中文转发区, 对比文件
				@case_ID             = __method__.to_s.split('_')[1]
				r                    = []
				args[:view_name]     = "中文视图_#{@case_ID}"
				@zone_name           = "中文区.#{@case_ID}"
				args[:owner_list]    = [Master_Device]
				args[:forward_style] = 'only'
				args[:exported_file] = Download_Dir + 'forward-zones.txt'
				args[:imported_file] = Upload_Dir + 'zone\14511.txt'
				begin
					r << View_er.create_view(args)
					1.upto(3) do |id|
						args[:zone_name]           = "#{@zone_name}_#{id}"
						args[:forward_server_list] = ["192.145.11.#{id}"]
						r << Recu_er.create_forward_zone(args)
					end
					# 导出
					r << Recu_er.export_forward_zone(args)
					# 验证 & 删除
					r << Recu_er.compare_exported_forward_zone_file(args)
					r << DNS.delete_exported_file(args)
					# 删除 & 导入
					r << Recu_er.del_all_forward_zone
					r << Recu_er.import_forward_zone(args)
					# 导入 & 验证
					1.upto(3) do |id|
						args[:zone_name] = "#{@zone_name}_#{id}"
						r << DNS.check_single_forward(args)
					end
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_14512(args)
				# 导入字段非法
				@case_ID               = __method__.to_s.split('_')[1]
				r                      = []
				args[:error_type]      = 'after_OK'
				suffix = "\n记录序列号:1\n区信息:"
				inputs_list = [
					'v_14542 zone.14512 local.master 192.168.145.12#53 only N/A',
					'default zone.14512 local.slaver 192.168.145.12#53 only N/A',
					'default zone.14512 local.master 192.168.14.512#53 only N/A',
					'default zone.14512 local.master 192.168.145.12#53 _err N/A',
					'default zone.14512 local.master 192.168.145.12#53 first'
				]
				inputs_with_error_info = {
					inputs_list[0] =>"操作不存在的视图#{suffix}#{inputs_list[0]}",
					inputs_list[1] =>"无法操作不存在的所属设备#{suffix}#{inputs_list[1]}",
					inputs_list[2] =>"非法的IP地址#{suffix}#{inputs_list[2]}",
					inputs_list[3] =>"未知的转发区方式#{suffix}#{inputs_list[3]}",
					inputs_list[4] =>"非法的区数据内容#{suffix}#{inputs_list[4]}"
				}
				begin
					DNS.open_forward_zone_page
					inputs_with_error_info.each_pair do |inputs, error_info|
						args[:imported_lines] = [inputs]
						args[:error_info]     = error_info
						DNS.popup_right_menu('batchCreate')
						r << DNS.inputs_import_dialog(args)
						r << DNS.error_validator_on_popwin(args)
					end
					# 请勿输入重复项
					dup_line = 'default zone.14512 local.master 192.168.145.12#53 only N/A'
					args[:imported_lines] = [dup_line, dup_line]
					args[:error_info]     = '请勿输入重复项'
					args[:error_type]     = 'before_OK'
					DNS.popup_right_menu('batchCreate')
					r << DNS.inputs_import_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_14513(args)
				# 导入 + dig
				@case_ID              = __method__.to_s.split('_')[1]
				r                     = []
				@forward_view_name    = "view_#{@case_ID}"
				args[:view_name]      = 'default'
				@zone_name            = "zone.#{@case_ID}"
				args[:owner_list]     = [Master_Device]
				args[:forward_style]  = 'only'
				args[:imported_file]  = Upload_Dir + 'zone\14513.txt'
				args[:imported_lines] = []
				args[:domain_list]    = [{"rname"=>"www", "rtype"=>"A", "rdata"=>"192.168.145.13", "ttl"=>"600"}]
				begin
					# 在slave上建两个区+记录, to dig...
					args[:owner_list] = [Slave_Device]
					1.upto(2) do |id|
						args[:zone_name] = "#{@zone_name}_#{id}"
						r << Zone_er.create_zone(args)
						r << Domain_er.create_domain(args)
					end
					# 生成要导入的文件
					1.upto(2) do |id|
						args[:zone_name] = "#{@zone_name}_#{id}"
						line = "#{@forward_view_name} #{args[:zone_name]} local.master #{Slave_IP}#53 only N/A"
						args[:imported_lines] << line
					end
					r << Recu_er.generate_forward_zone_file_for_importing(args)
					# 为Master新建ACL +　视图, 再导入转发区
					args[:acl_name] = "acl_#{@case_ID}"
					args[:acl_list] = Local_Network
					r << ACL_er.create_acl(args)
					args[:view_name]  = @forward_view_name
					args[:owner_list] = [Master_Device]
					r << View_er.create_view(args)
					r << Recu_er.import_forward_zone(args)
					# Dig
					args[:dig_ip] = Master_IP
					args[:rtype]  = 'A'
					1.upto(2) do |id|
						args[:domain_name] = "www.#{@zone_name}_#{id}"
						r << DNS.dig_as_noerror(args)
					end
					# 删除
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
					args[:view_name] = 'default'
					1.upto(2) do |id|
						args[:zone_name] = "#{@zone_name}_#{id}"
						r << Zone_er.del_zone(args)
					end
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_14516(args)
				# 导入已经存在的转发区
				@case_ID                   = __method__.to_s.split('_')[1]
				r                          = []
				args[:error_type]          = 'after_OK'
				args[:view_name]           = 'default'
				args[:zone_name]           = "zone.#{@case_ID}"
				args[:owner_list]          = [Master_Device]
				args[:forward_style]       = 'only'
				args[:forward_server_list] = ['192.168.145.16']
				begin
					r << Recu_er.create_forward_zone(args)
					DNS.open_forward_zone_page
					args[:imported_lines] = ['default zone.14516 local.master 192.168.145.16#53 only N/A']
					args[:error_info]     = "同名转发区已经存在\n记录序列号:1\n区信息:default zone.14516 local.master 192.168.145.16#53 only N/A"
					DNS.popup_right_menu('batchCreate')
					r << DNS.inputs_import_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					r << Recu_er.del_forward_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_15891(args)
				# 转发配置从only变为no, 不转发!
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:acl_name]    = "acl_#{@case_ID}"
				args[:acl_list]    = [Master_IP]
				@view_name         = "view_#{@case_ID}"
				@rdata             = '192.168.158.91'
				args[:view_name]   = @view_name
				args[:zone_name]   = "zone.#{@case_ID}"
				args[:owner_list]  = [Slave_Device]
				args[:domain_list] = [{'rname'=>"#{@case_ID}", 'rtype'=>'A', 'rdata'=>@rdata, 'ttl'=>'3600'}]
				begin
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					r << Domain_er.create_domain(args)
					args[:view_name]           = 'default'
					args[:owner_list]          = [Master_Device]
					args[:forward_style]       = 'only'
					args[:forward_server_list] = [Slave_IP]
					r << Recu_er.create_forward_zone(args)
					# Dig
					@domain_name = "#{@case_ID}.#{args[:zone_name]}"
					r << Dig_er.compare_domain(:server_list=>[Master_IP], :domain_name=>@domain_name, :rtype=>"A", :port=>DNS_Port, :actual_rdata=>@rdata, :sleepfirst=>"yes")
					# edit forward zone
					args[:forward_style] = 'no'
					r << Recu_er.edit_forward_zone(args)
					# flush cache
					args[:nodeName] = Master_Device
					r << Recu_er.del_cache_of_device(args)
					args[:dig_ip]      = Master_IP
					args[:domain_name] = @domain_name
					args[:rtype]       = 'A'
					r << DNS.dig_as_nxdomain(args)
					args[:view_name] = @view_name
					# clean up
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
					args[:view_name] = 'default'
					r << Recu_er.del_forward_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_15892(args)
				# 导入/导出转发区为 'no'
				@case_ID              = __method__.to_s.split('_')[1]
				r                     = []
				args[:view_name]      = "view_#{@case_ID}"
				args[:zone_name]      = "zone.#{@case_ID}"
				args[:forward_style]  = 'no'
				args[:owner_list]     = Node_Name_List
				args[:exported_file]  = Download_Dir + 'forward-zones.txt'
				args[:imported_file]  = Upload_Dir + 'zone\15892.txt'
				args[:imported_lines] = []
				args[:imported_lines] << "#{args[:view_name]} #{args[:zone_name]} local.master,slave.#{Slave_Device} N/A no N/A"
				begin
					# 根据节点名生成要文件
					r << Recu_er.generate_forward_zone_file_for_importing(args)
					# 新建, 导出
					r << View_er.create_view(args)
					r << Recu_er.create_forward_zone(args)
					r << Recu_er.export_forward_zone(args)
					# 验证, 删除导出文件
					r << Recu_er.compare_exported_forward_zone_file(args)
					r << DNS.delete_exported_file(args)
					# 删除后导入
					r << Recu_er.del_forward_zone(args)
					r << Recu_er.import_forward_zone(args)
					# 导入验证
					r << DNS.check_single_forward(args)
					# 清理
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_20759(args)
				# 导入/@/验证后删除
				@case_ID              = __method__.to_s.split('_')[1]
				r                     = []
				args[:view_name]      = "view_#{@case_ID}"
				args[:zone_name]      = "@"
				args[:forward_style]  = 'first'
				forward_server        = '192.168.207.59#53'
				nodes = "#{Master_Group}.#{Master_Device},#{Slave_Group}.#{Slave_Device} #{forward_server}"
				args[:owner_list]     = Node_Name_List
				args[:imported_file]  = Upload_Dir + 'zone\20759.txt'
				args[:imported_lines] = []
				args[:imported_lines] << "#{args[:view_name]} #{args[:zone_name]} #{nodes} #{args[:forward_style]} N/A"
				begin
					# 导入 + 验证named.conf中的@为, 删除@成功
					r << View_er.create_view(args)
					r << Recu_er.generate_forward_zone_file_for_importing(args)
					r << Recu_er.import_forward_zone(args)
					args[:keyword] = "zone \"\.\" {\ntype forward;\nforward first;\nforwarders { #{forward_server} port 53 ; };\n};"
					r << DNS.grep_keyword_named(args)
					r << Recu_er.del_forward_zone(args)
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_20042(args)
				# 转发黑名单
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:view_name]  = 'default'
				args[:owner_list] = Node_Name_List
				begin
					args[:zone_name]           = 'baidu.com'
					args[:forward_style]       = 'only'
					args[:forward_server_list] = ['1.2.3.4']
					r << Recu_er.create_forward_zone(args)
					args[:zone_name]           = 'mp3.baidu.com'
					args[:forward_style]       = 'no'
					r << Recu_er.create_forward_zone(args)
					args[:domain_name] = 'mp3.baidu.com'
					args[:rtype]       = 'A'
					Node_IP_List.each do |ip|
						args[:dig_ip] = ip
						r << DNS.dig_as_noerror(args)
					end
					r << Recu_er.del_forward_zone(args)
					args[:zone_name] = 'baidu.com'
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