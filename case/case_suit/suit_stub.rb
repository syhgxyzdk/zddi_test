# encoding: utf-8
require File.dirname(__FILE__) + '/../../zddi'

module ZDDI
	module DNS
		class Stub
			def case_5116(args)
				@case_ID                = __method__.to_s.split('_')[1]
				r                       = []
				args[:error_type]       = "before_OK"
				args[:error_info]       = "区名格式不正确"
				args[:view_name]        = "default"
				args[:zone_name]        = "illeg@lN@me"
				args[:stub_server_list] = ["192.168.51.16"]
				args[:owner_list]       = [Master_Device]
				begin
					DNS.inputs_stub_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end

			def case_5115(args)
				@case_ID                = __method__.to_s.split('_')[1]
				r                       = []
				args[:view_name]        = "default"
				args[:zone_name]        = ""
				args[:stub_server_list] = ["192.168.51.16"]
				args[:owner_list]       = [Master_Device]
				args[:error_type]       = "before_OK"
				args[:error_info]       = "必选字段"
				begin
					DNS.inputs_stub_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end

			def case_5122(args)
				@case_ID                = __method__.to_s.split('_')[1]
				r                       = []
				args[:view_name]        = "view_5122"
				args[:zone_name]        = "zone.5122"
				args[:server_name]      = "192.168.51.22"
				args[:owner_list]       = [Master_Device]
				args[:stub_server_list] = ["192.168.51.22"]
				args[:error_type]       = "after_OK"
				args[:error_info]       = "同名权威区已存在"
				begin
					# 新建视图/区.
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					# 新建重复存根区
					DNS.inputs_stub_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					# 清理
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end

            def case_5133(args)
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:error_type] = "before_OK"
				args[:view_name]  = "default"
				args[:zone_name]  = "zone.5133"
				args[:owner_list] = [Master_Device]
				@server_err1      = "1.2.3.4.5#53"
				@server_err2      = "266.27.18.29#89653214"
				@server_err3      = "202.173.9.100#89653214"
				@server_list      = [@server_err1, @server_err2, @server_err3] 
				@server_err4      = "2.2.2.1\n2.2.2.1"
            	begin
            		args[:error_info] = "非法的服务器列表" 
	            	@server_list.each do |server|
	            		args[:stub_server_list] = [server]
						DNS.inputs_stub_dialog(args)
						r << DNS.error_validator_on_popwin(args)
					end
					args[:error_info] = "请勿输入重复项" 
					args[:stub_server_list] = [@server_err4]
					DNS.inputs_stub_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end

            def case_7144(args)
				@case_ID                = __method__.to_s.split('_')[1]
				r                       = []
				args[:view_name]        = "view_7144"
				args[:zone_name]        = "zone.7144"
				args[:stub_server_list] = ["192.168.71.44"]
				args[:owner_list]       = [Master_Device]
				begin
					#新建视图/存根区.
					r << View_er.create_view(args)
					r << Recu_er.create_stub_zone(args)
					DNS.open_stub_zone_page
					r << DNS.check_single_stub(args)
					# 删除视图, 存根区连带删除
					r << View_er.del_view(args)
					# 验证存根区删除.
					DNS.open_stub_zone_page
					r << DNS.check_single_stub(args, expected_fail=true)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end

			def case_7142(args)
				@case_ID                = __method__.to_s.split('_')[1]
				r                       = []
				args[:view_name]        = "view_7142"
				args[:zone_name]        = "中文存根区.case.7142"
				args[:stub_server_list] = ["192.168.71.42"]
				args[:owner_list]       = [Master_Device]
				begin
					# 新建中文存根区.
					r << View_er.create_view(args)
					r << Recu_er.create_stub_zone(args)
					# 删除
					args[:zone_list] = [args[:zone_name]]
					r << Recu_er.del_stub_zone(args)
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end

			def case_5141(args)
				@case_ID                = __method__.to_s.split('_')[1]
				r                       = []
				args[:view_name]        = "view_5141"
				args[:zone_name]        = "zone.case.5141"
				args[:stub_server_list] = ["192.168.51.42"]
				args[:owner_list]       = [Master_Device]
				begin
					#新建视图/存根区.
					r << View_er.create_view(args)
					r << Recu_er.create_stub_zone(args)
					args[:zone_list] = [args[:zone_name]]
					r << Recu_er.del_stub_zone(args)
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end

			def case_5142(args)
				@case_ID                = __method__.to_s.split('_')[1]
				r                       = []
				args[:view_name]        = "view_5142"
				zone_name_list          = ["zone.case.5142.1", "zone.case.5142.2", "zone.case.5142.3"]
				args[:stub_server_list] = ["192.168.51.42"]
				args[:owner_list]       = [Master_Device]
				begin
					# 新建多个存根区, 批量删除
					r << View_er.create_view(args)
					zone_name_list.each do |zone_name|
						args[:zone_name] = zone_name
						r << Recu_er.create_stub_zone(args)
					end
					# 删除
					args[:zone_list] = zone_name_list
					r << Recu_er.del_stub_zone(args)
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end

			def case_7140(args)
				@case_ID         = __method__.to_s.split('_')[1]
				r                = []
				@stub_view_name  = "view_#{@case_ID}"
				args[:zone_name] = "中文存根区#{@case_ID}"
				begin
					args[:view_name]  = "default"
					args[:owner_list] = [Slave_Device]
					r << Zone_er.create_zone(args)
					args[:domain_list] = [{"rname"=>"ns", "rtype"=>"A", "rdata_old"=>"127.0.0.1", "rdata_new"=>Slave_IP, "ttl"=>"3600"}]
					r << Domain_er.edit_domain(args)   # 编辑ns为SLAVE IP
					args[:domain_list] = [{"rname"=>"a", "rtype"=>"A", "rdata"=>"192.168.71.40", "ttl"=>"3600"}]
					r << Domain_er.create_domain(args) # 创建rdata, 用于dig 
					args[:acl_name]         = "acl_#{@case_ID}"
					args[:acl_list]         = Local_Network
					args[:view_name]        = @stub_view_name
					args[:owner_list]       = [Master_Device]
					args[:stub_server_list] = [Slave_IP]
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Recu_er.create_stub_zone(args)
					# dig "a.中文存根区7140"
					args[:rname] = "a.xn--7140-zf5fp1yukp4gtqrf"
					r << Dig_er.compare_domain(:server_list=>[Master_IP], :domain_name=>args[:rname], :rtype=>"A", :port=>DNS_Port, :actual_rdata=>"192.168.71.40", :sleepfirst=>"yes")
					# 清理数据
					args[:view_name] = "default"
					args[:zone_list] = [args[:zone_name]]
					r << Zone_er.del_zone(args)
					args[:view_name] = @stub_view_name
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end

			def case_9497(args)
				@case_ID         = __method__.to_s.split('_')[1]
				r                = []
				@stub_view_name  = "view_#{@case_ID}"
				args[:zone_name] = "zone.#{@case_ID}"
				begin
					args[:view_name]  = "default"
					args[:owner_list] = [Slave_Device]
					r << Zone_er.create_zone(args)
					args[:domain_list] = [{"rname"=>"ns", "rtype"=>"A", "rdata_old"=>"127.0.0.1", "rdata_new"=>Slave_IP, "ttl"=>"3600"}]
					r << Domain_er.edit_domain(args)   # 编辑ns为SLAVE IP
					args[:domain_list] = [{"rname"=>"under_line", "rtype"=>"A", "rdata"=>"192.168.94.97", "ttl"=>"3600"}]
					r << Domain_er.create_domain(args) # 创建rdata, 用于dig 
					args[:acl_name]         = "acl_#{@case_ID}"
					args[:acl_list]         = Local_Network
					args[:view_name]        = @stub_view_name
					args[:owner_list]       = [Master_Device]
					args[:stub_server_list] = [Slave_IP]
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Recu_er.create_stub_zone(args)
					# dig "a.@zone_name"
					args[:rname] = "#{args[:domain_list][0]["rname"]}.#{args[:zone_name]}"
					r << Dig_er.compare_domain(:server_list=>[Master_IP], :domain_name=>args[:rname], :rtype=>"A", :port=>DNS_Port, :actual_rdata=>"#{args[:domain_list][0]["rdata"]}", :sleepfirst=>"yes")
					# 清理数据
					args[:view_name] = "default"
					args[:zone_list] = [args[:zone_name]]
					r << Zone_er.del_zone(args)
					args[:view_name] = @stub_view_name
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end

			def case_9505(args)
				@case_ID         = __method__.to_s.split('_')[1]
				r                = []
				@stub_view_name  = "view_#{@case_ID}"
				args[:zone_name] = "zone.#{@case_ID}"
				@rdata           = "192.168.95.5"
				@rname           = "restart_dns"
				begin
					# 主节点存根区服务器指向辅节点(其default视图有主区)
					args[:view_name]  = "default"
					args[:owner_list] = [Slave_Device]
					r << Zone_er.create_zone(args)
					# 编辑ns为SLAVE IP
					args[:domain_list] = [{"rname"=>"ns", "rtype"=>"A", "rdata_old"=>"127.0.0.1", "rdata_new"=>Slave_IP, "ttl"=>"3600"}]
					r << Domain_er.edit_domain(args)
					# 创建rdata, 用于dig
					args[:domain_list] = [{"rname"=>@rname, "rtype"=>"A", "rdata"=>@rdata, "ttl"=>"3600"}]
					r << Domain_er.create_domain(args)
					# 建存根区
					args[:acl_name]         = "acl_#{@case_ID}"
					args[:acl_list]         = Local_Network
					args[:view_name]        = @stub_view_name
					args[:owner_list]       = [Master_Device]
					args[:stub_server_list] = [Slave_IP]
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Recu_er.create_stub_zone(args)
					# Dig "retart.@zone_name"
					args[:rname] = "#{@rname}.#{args[:zone_name]}"
					r << Dig_er.compare_domain(:server_list=>[Master_IP], :domain_name=>args[:rname], :rtype=>"A", :port=>DNS_Port, :actual_rdata=>@rdata, :sleepfirst=>"yes")
					# 重启DNS
					args[:node_name] = Master_Device
					r << Cloud.stop_device_dns_service(args)
	                sleep 15
	                r << Cloud.start_device_dns_service(args)
	                sleep 15
					# 重启后Dig
					r << Dig_er.compare_domain(:server_list=>[Master_IP], :domain_name=>args[:rname], :rtype=>"A", :port=>DNS_Port, :actual_rdata=>@rdata, :sleepfirst=>true)
					# 清理
					args[:view_name] = "default"
					r << Zone_er.del_zone(args)
					args[:view_name] = @stub_view_name
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end

			def case_5027(args)
				# 存根区配置为根区是无效的.
				@case_ID         = __method__.to_s.split('_')[1]
				r                = []
				@stub_view_name  = "view_#{@case_ID}"
				args[:zone_name] = "@"
				args[:view_name]  = "default"
				args[:owner_list] = [Slave_Device]
				begin
					r << Zone_er.create_zone(args)
					args[:acl_name]         = "acl_#{@case_ID}"
					args[:acl_list]         = Local_Network
					args[:view_name]        = @stub_view_name
					args[:owner_list]       = [Master_Device]
					args[:stub_server_list] = [Slave_IP]
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Recu_er.create_stub_zone(args)
					# 存根区配置为根区是无效的.
					# bind内置13个根服务器, 当配置某视图根区的存根时,
					# 对应ns的服务器ip被加入根服务器列表, 即变为14个.
					# 然后在从外开始递归, 结果依然返回外部递归结果.
					# 清理
					args[:view_name] = "default"
					args[:zone_list] = [args[:zone_name]]
					r << Zone_er.del_zone(args)
					args[:view_name] = @stub_view_name
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end

			def case_5121(args)
				@case_ID         = __method__.to_s.split('_')[1]
				r                = []
				@stub_view_name  = "view_#{@case_ID}"
				args[:zone_name] = "zone.#{@case_ID}"
				begin
					args[:view_name]  = "default"
					args[:owner_list] = [Slave_Device]
					r << Zone_er.create_zone(args)
					# 编辑ns为SLAVE IP
					args[:domain_list] = [{"rname"=>"ns", "rtype"=>"A", "rdata_old"=>"127.0.0.1", "rdata_new"=>Slave_IP, "ttl"=>"3600"}]
					r << Domain_er.edit_domain(args)
					args[:domain_list] = [{"rname"=>"51.21", "rtype"=>"A", "rdata"=>"192.168.51.21", "ttl"=>"3600"}]
					# 创建rdata, 用于dig
					r << Domain_er.create_domain(args)
					args[:acl_name]         = "acl_#{@case_ID}"
					args[:acl_list]         = Local_Network
					args[:view_name]        = @stub_view_name
					args[:owner_list]       = [Master_Device]
					args[:stub_server_list] = [ "192.168.51.21", "192.168.21.51", Slave_IP]
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Recu_er.create_stub_zone(args)
					# 多IP作为存根服务器时, 轮询检查10分钟.
					10.downto(1){|i| puts "Stub Case: #{@case_ID}, sleeping #{i} mins";	sleep 60}
					args[:rname] = "#{args[:domain_list][0]["rname"]}.#{args[:zone_name]}"
					r << Dig_er.compare_domain(:server_list=>[Master_IP], :domain_name=>args[:rname], :rtype=>"A", :port=>DNS_Port, :actual_rdata=>"#{args[:domain_list][0]["rdata"]}")
					# 清理
					args[:view_name] = "default"
					args[:zone_list] = [args[:zone_name]]
					r << Zone_er.del_zone(args)
					args[:view_name] = @stub_view_name
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end

			def case_7141(args)
				@case_ID         = __method__.to_s.split('_')[1]
				r                = []
				@stub_view_name  = "view_#{@case_ID}"
				args[:zone_name] = "zone.#{@case_ID}"
				# 新建存根后编辑服务器地址: 错误ip=>正确ip.
				begin
					args[:view_name]  = "default"
					args[:owner_list] = [Slave_Device]
					r << Zone_er.create_zone(args)
					args[:domain_list] = [{"rname"=>"ns", "rtype"=>"A", "rdata_old"=>"127.0.0.1", "rdata_new"=>Slave_IP, "ttl"=>"3600"}]
					r << Domain_er.edit_domain(args)   # 编辑ns为SLAVE IP
					args[:domain_list] = [{"rname"=>"71.41", "rtype"=>"A", "rdata"=>"192.168.71.41", "ttl"=>"3600"}]
					r << Domain_er.create_domain(args) # 创建rdata, 用于dig 
					args[:acl_name]         = "acl_#{@case_ID}"
					args[:acl_list]         = Local_Network
					args[:view_name]        = @stub_view_name
					args[:owner_list]       = [Master_Device]
					args[:stub_server_list] = ["192.168.71.41"]
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Recu_er.create_stub_zone(args)
					args[:stub_server_list] = [Slave_IP]
					r << Recu_er.edit_stub_zone(args)
					6.downto(1){|i| puts "Stub Case: #{@case_ID}, sleeping #{i} mins";	sleep 60}
					args[:rname] = "#{args[:domain_list][0]["rname"]}.#{args[:zone_name]}"
					r << Dig_er.compare_domain(:server_list=>[Master_IP], :domain_name=>args[:rname], :rtype=>"A", :port=>DNS_Port, :actual_rdata=>"#{args[:domain_list][0]["rdata"]}")
					# 清理数据
					args[:view_name] = "default"
					args[:zone_list] = [args[:zone_name]]
					r << Zone_er.del_zone(args)
					args[:view_name] = @stub_view_name
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end

			def case_5139(args)
				@case_ID                = __method__.to_s.split('_')[1]
				r                       = []
				args[:view_name]        = "view_#{@case_ID}"
				args[:zone_name]        = "zone.#{@case_ID}"
				args[:owner_list]       = [Master_Device]
				args[:stub_server_list] = ["192.168.51.39"]
				args[:keyword]          = args[:zone_name]
				begin
					r << View_er.create_view(args)
					r << Recu_er.create_stub_zone(args)
					args[:old_owner_list] = args[:owner_list]
					args[:new_owner_list] = Node_Name_List
					r << View_er.modify_view_member(args)
					r << DNS.grep_keyword_named(args)
					args[:owner_list] = [Slave_Device]
					r << DNS.grep_keyword_named(args, keyword_gone = true)
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end

			def case_5138(args)
				@case_ID                = __method__.to_s.split('_')[1]
				r                       = []
				args[:view_name]        = "view_#{@case_ID}"
				args[:zone_name]        = "zone.#{@case_ID}"
				args[:owner_list]       = Node_Name_List
				args[:stub_server_list] = ["192.168.51.38"]
				args[:keyword]          = args[:zone_name]

				begin
					r << View_er.create_view(args)
					r << Recu_er.create_stub_zone(args)
					args[:old_owner_list] = args[:owner_list]
					args[:new_owner_list] = [Slave_Device]
					r << View_er.modify_view_member(args)
					args[:owner_list] = [Slave_Device]
					r << DNS.grep_keyword_named(args)
					args[:owner_list] = [Master_Device]
					r << DNS.grep_keyword_named(args, keyword_gone = true)
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end

			def case_7145(args)
				@case_ID                = __method__.to_s.split('_')[1]
				r                       = []
				args[:view_name]        = "view_#{@case_ID}"
				args[:zone_name]        = "zone.#{@case_ID}"
				args[:owner_list]       = [Master_Device]
				args[:stub_server_list] = ["192.168.71.45"]
				args[:keyword]          = args[:zone_name]
				begin
					r << View_er.create_view(args)
					r << Recu_er.create_stub_zone(args)
					args[:old_owner_list] = args[:owner_list]
					args[:new_owner_list] = [Slave_Device]
					r << View_er.modify_view_member(args)
					args[:owner_list] = [Master_Device]
					r << DNS.grep_keyword_named(args, keyword_gone = true)
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
		end
	end
end