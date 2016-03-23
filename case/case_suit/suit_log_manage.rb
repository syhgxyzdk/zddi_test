# encoding: utf-8
require File.dirname(__FILE__) + '/../../zddi'
module ZDDI
	module System
		class Log_manage
			def case_1418(args)
				@case_ID                   = "1418"
				r                          = []			
				args[:error_type]          = "before_OK"
				args[:error_info]          = "必选字段"
				args[:backup_server]       = ""
				args[:enable_query_backup] = 'yes'
				begin
					System.inputs_query_log_backup_settings_dialog(args)
                	r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1419(args)
				@case_ID             = "1419"
				r                    = []			
				args[:error_type]    = "before_OK"
				args[:error_info]    = "IP地址格式不正确"
				args[:backup_server] = "19@.168.1.10"
                begin
					System.inputs_query_log_backup_settings_dialog(args)
                	r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1420(args)
				@case_ID           = "1420"
				r                  = []			
				args[:error_type]  = "before_OK"
				args[:error_info]  = "必选字段"
				args[:backup_dest] = ""
                begin
					System.inputs_query_log_backup_settings_dialog(args)
                	r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1421(args)
				@case_ID           = "1421"
				r                  = []			
				args[:error_type]  = "before_OK"
				args[:error_info]  = "路径格式不正确"
				args[:backup_dest] = "@!"
                begin
					System.inputs_query_log_backup_settings_dialog(args)
                	r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1422(args)
				@case_ID              = "1422"
				r                     = []			
				args[:error_type]     = "before_OK"
				args[:error_info]     = "必选字段"
				args[:backup_account] = ""
                begin
					System.inputs_query_log_backup_settings_dialog(args)
                	r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1423(args)
				@case_ID              = "1423"
				r                     = []			
				args[:error_type]     = "before_OK"
				args[:error_info]     = "字符串格式不正确，只能为数字，字母，_和-"
				args[:backup_account] = "@!"
                begin
					System.inputs_query_log_backup_settings_dialog(args)
                	r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1424(args)
				@case_ID               = "1424"
				r                      = []			
				args[:error_type]      = "before_OK"
				args[:error_info]      = "必选字段"
				args[:backup_password] = ""
                begin
					System.inputs_query_log_backup_settings_dialog(args)
                	r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_2994(args)
				@case_ID           = "2994"
				r                  = []			
				args[:error_type]  = "before_OK"
				args[:error_info]  = "必选字段"
				args[:backup_size] = ""
                begin
					System.inputs_query_log_backup_settings_dialog(args)
                	r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_2995(args)
				@case_ID           = "2995"
				r                  = []			
				args[:error_type]  = "before_OK"
				args[:error_info]  = "请输入合法的数字"
				args[:backup_size] = "@!"
                begin
					System.inputs_query_log_backup_settings_dialog(args)
                	r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_2996(args)
				@case_ID           = "2996"
				r                  = []			
				args[:error_type]  = "before_OK"
				args[:error_info]  = "请输入最小为 10 的值"
				args[:backup_size] = "1"
                begin
					System.inputs_query_log_backup_settings_dialog(args)
                	r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_2997(args)
				@case_ID           = "2997"
				r                  = []			
				args[:error_type]  = "before_OK"
				args[:error_info]  = "请输入最小为 10 的值"
				args[:backup_size] = "0.1"
                begin
					System.inputs_query_log_backup_settings_dialog(args)
                	r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_21118(args)
				# 页面默认状态检查
				@case_ID           = "21118"
				r = []
				begin
				System.open_query_log_backup_page
				buttons = ["create","edit","modifyByMembers","del","schedule-backup","clean","export_"]
				args[:element_type] = "button"
				buttons.each do |btn|
                  args[:element_value] = btn
                  r << System.element_validator_on_page(args,false)    
                end
				rescue
                	 puts "unknown error on #{@case_ID}"
					 return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_21130(args)
				#同一设备只能创建在一个配置
				case_ID = "21130"
				r = []
				begin
				  args[:backup_server]   = "192.168.1.1"
                  args[:backup_dest]     = "/root/backup"
                  args[:owner_list]      = [Master_Device]
                  args[:backup_account]  = "admin"
                  args[:backup_password] = "password"
                  args[:backup_size]     = "10"
                  args[:error_type]  = "after_OK"
				  args[:error_info]  = "配置已存在"
                  r << Log_er.create_log_backup(args)
                  args[:backup_server]   = "192.168.1.2"
                  r << System.inputs_query_log_backup_settings_dialog(args)
                  r << DNS.error_validator_on_popwin(args)
                  args[:backup_server]   = "192.168.1.1"
                  r << Log_er.del_single_log_backup(args)
                rescue
                	 puts "unknown error on #{@case_ID}"
					 return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_21122(args)
				@case_ID           = "21122"
				r = []
				args[:nodeName]        = nil
				args[:backup_server]     = "203.119.80.70"
                args[:owner_list]      = [Master_Device] if !args[:owner_list]
				args[:backup_dest]     = "/root"
                args[:backup_account]  = "root"
                args[:backup_password] = "zdns@knet.cn"
                args[:backup_size]     = "12"
                args[:backup_method]   = "ftp"
                args[:enable_query_backup] = true
                args[:nodeName] = Master_Device
				#begin
				#r << Log_er.create_log_backup(args)
				args[:old_owner_list] = ["#{Master_Device}"]
                args[:new_owner_list] = ["#{Slave_Device}"]
                args[:element_type] = "button"
                args[:element_value] = "del"
                System.open_query_log_backup_page
                r << System.element_validator_on_page(args,false)    
				#r << Log_er.modify_log_member(args)
			    #r << Log_er.edit_log_backup(args)
                s = ZDDI.browser.div(:class, 'toolsBar').select(:name, 'member')
                s.select("master")
                sleep 5
                s.selected_options.each do |x|
                	puts x.to_s
                end
                    
                #r << Log_er.del_single_log_backup(args)
                #rescue
                	 #puts "unknown error on #{@case_ID}"
					 #return "failed case #{@case_ID}"
                #end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
		end
	end
end