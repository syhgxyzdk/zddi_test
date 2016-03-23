# encoding: utf-8
require File.dirname(__FILE__) + '/../../zddi'
module ZDDI
	module DNS
		class Query_source
            def case_12283(args)
				@case_ID                  = "12283"
				r                         = []
				args[:view_name]          = "default"
				args[:query_source]       = Master_IP
				args[:query_source_owner] = Master_Device
				begin
					r << Recu_er.create_query_source(args)
					args[:owner_list] = [Master_Device]
					args[:keyword]    = args[:query_source]
					r << DNS.grep_keyword_named(args)
					# 编辑为错误IP
					args[:query_source] = "192.168.122.83"
					r << Recu_er.edit_query_source(args)
					args[:keyword] = args[:query_source]
					r << DNS.grep_keyword_named(args, keyword_gone=true)
					r << Recu_er.del_query_source(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_10902(args)
				@case_ID         = "10902"
				r                = []
				args[:view_name] = "view_#{@case_ID}"
				begin
					# 1. 视图节点 all -> master  => 请求源地址不变.
					args[:owner_list] = Node_Name_List
					r << View_er.create_view(args)
					args[:query_source]       = Master_IP
					args[:query_source_owner] = Master_Device
					r << Recu_er.create_query_source(args)
					args[:old_owner_list] = args[:owner_list]
					args[:new_owner_list] = [Master_Device]
					r << View_er.modify_view_member(args)
					args[:owner_list]     = [Master_Device]
					args[:keyword]        = args[:query_source]
					r << DNS.grep_keyword_named(args)
					# 删除视图
					r << View_er.del_view(args)
                	# 2. 视图节点 slave -> all  => 请求源地址不变.
                	args[:owner_list] = [Slave_Device]
					r << View_er.create_view(args)
					args[:query_source]       = Slave_IP
					args[:query_source_owner] = Slave_Device
					r << Recu_er.create_query_source(args)
					args[:old_owner_list] = args[:owner_list]
					args[:new_owner_list] = Node_Name_List
					r << View_er.modify_view_member(args)
					args[:keyword]        = args[:query_source]
					r << DNS.grep_keyword_named(args)
					# 删除视图
					r << View_er.del_view(args)
					# 3. 视图节点 master -> slave => 请求源地址设置被删除.
					args[:owner_list] = [Master_Device]
					r << View_er.create_view(args)
					args[:query_source]       = Master_IP
					args[:query_source_owner] = Master_Device
					r << Recu_er.create_query_source(args)
					args[:old_owner_list] = args[:owner_list]
					args[:new_owner_list] = [Slave_Device]
					r << View_er.modify_view_member(args)
					args[:keyword]        = args[:query_source]
					r << DNS.grep_keyword_named(args, keyword_gone=true)
					# 删除视图
					r << View_er.del_view(args)
					# 4. 视图节点 slave -> master <<> 请求源地址设置被删除.
					args[:owner_list] = [Slave_Device]
					r << View_er.create_view(args)
					args[:query_source]       = Slave_IP
					args[:query_source_owner] = Slave_Device
					r << Recu_er.create_query_source(args)
					args[:old_owner_list] = args[:owner_list]
					args[:new_owner_list] = [Master_Device]
					r << View_er.modify_view_member(args)
					args[:keyword]        = args[:query_source]
					r << DNS.grep_keyword_named(args, keyword_gone=true)
					# 删除视图
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_21085(args)
				@case_ID                   = "21085"
				r                          = []
				args[:view_name]           = "default"
				args[:query_source]        = Master_IP
				args[:query_source_owner]  = Master_Device
				err_1    = 'IP地址格式不正确'
				err_2    = '请勿输入重复项'
				err_3    = '超过最大输入限制(5条)'
				ip_1     = ["192.168.210.85", "2014:ABCE::36DZ"]
				ip_2     = ["192.168.210.85", "192.168.210.85"]
				ip_3     = ['10.10.10.1', '10.10.10.2', '10.10.10.3', '10.10.10.4', '10.10.10.5', '10.10.10.6']
				err_list = {ip_1=>err_1, ip_2=>err_2, ip_3=>err_3}
				begin
					args[:error_type] = 'before_OK'
					DNS.open_query_source_page
					err_list.each_pair do |ip, err|
						args[:query_source_backup] = ip
						args[:error_info] = err
						DNS.inputs_query_source_dialog(args)
						r << DNS.error_validator_on_popwin(args)
					end
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_21841(args)
            	# 告警
				@case_ID                   = "21841"
				r                          = []
				args[:view_name]           = "default"
				args[:query_source]        = Master_IP
				args[:query_source_owner]  = Master_Device
				warning = "请求源地址异常:告警 #{Master_Group}.#{Master_Device}/#{args[:view_name]}/#{Master_IP}"
				begin
					r << Recu_er.create_query_source(args)
					args[:query_source_checkers] = ['1.2.3.1','1.2.3.2','1.2.3.3','1.2.3.4', '1.2.3.5']
					r << Recu_er.create_query_source_monitor(args)
					sleep 240
					args[:warning_string] = warning
					r << System.warning_validator_on_warning_records_page(args)
					# 清理
					r << Recu_er.del_query_source(args)
					r << Recu_er.del_query_source_monitor(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_23363(args)
            	# 切换
				@case_ID                   = "21841"
				r                          = []
				args[:view_name]           = "default"
				args[:query_source]        = Master_IP
				args[:query_source_backup] = [Slave_IP]
				args[:query_source_owner]  = Master_Device
				warning = "请求源地址异常:切换 #{Master_Group}.#{Master_Device}/#{args[:view_name]}/#{Master_IP}->#{args[:query_source_backup][0]}"
				begin
					r << Recu_er.create_query_source(args)
					args[:query_source_checkers] = ['1.2.3.1','1.2.3.2','1.2.3.3','1.2.3.4', '1.2.3.5']
					r << Recu_er.create_query_source_monitor(args)
					sleep 240
					args[:warning_string] = warning
					r << System.warning_validator_on_warning_records_page(args)
					# 清理
					r << Recu_er.del_query_source(args)
					r << Recu_er.del_query_source_monitor(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
        end
    end
end