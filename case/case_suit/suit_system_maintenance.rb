# encoding: utf-8
require File.dirname(__FILE__) + '/../../zddi'
module ZDDI
	module System
		class System_maintenance
			def case_1756(args)
				@case_ID             = "1756"
				r                    = []
				args[:error_type]    = "before_OK"
				args[:error_info]    = "必选字段"
				args[:backup_server] = ""
				# 输入后验证
				begin
					System.open_schedule_data_backup_inputs_page
	                System.inputs_data_backup_settings_dialog(args)
	                r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1757(args)
				@case_ID             = "1757"
				r                    = []
				args[:error_type]    = "before_OK"
				args[:error_info]    = "IP地址格式不正确"
				args[:backup_server] = "@!"
				# 输入后验证
				begin
					System.open_schedule_data_backup_inputs_page
	                System.inputs_data_backup_settings_dialog(args)
	                r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1758(args)
				@case_ID           = "1758"
				r                  = []			
				args[:error_type]  = "before_OK"
				args[:error_info]  = "必选字段"
				args[:backup_dest] = ""
				# 输入后验证
				begin
					System.open_schedule_data_backup_inputs_page
	                System.inputs_data_backup_settings_dialog(args)
	                r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1759(args)
				@case_ID           = "1759"
				r                  = []			
				args[:error_type]  = "before_OK"
				args[:error_info]  = "路径格式不正确"
				args[:backup_dest] = "@!"
				# 输入后验证
				begin
					System.open_schedule_data_backup_inputs_page
	                System.inputs_data_backup_settings_dialog(args)
	                r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1760(args)
				@case_ID              = "1760"
				r                     = []			
				args[:error_type]     = "before_OK"
				args[:error_info]     = "必选字段"
				args[:backup_account] = ""
				# 输入后验证
				begin
					System.open_schedule_data_backup_inputs_page
	                System.inputs_data_backup_settings_dialog(args)
	                r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1761(args)
				@case_ID              = "1761"
				r                     = []			
				args[:error_type]     = "before_OK"
				args[:error_info]     = "字符串格式不正确，只能为数字，字母，_和-"
				args[:backup_account] = "@!"
				# 输入后验证
				begin
					System.open_schedule_data_backup_inputs_page
	                System.inputs_data_backup_settings_dialog(args)
	                r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1762(args)
				@case_ID               = "1762"
				r                      = []			
				args[:error_type]      = "before_OK"
				args[:error_info]      = "必选字段"
				args[:backup_password] = ""
				# 输入后验证
				begin
					System.open_schedule_data_backup_inputs_page
	                System.inputs_data_backup_settings_dialog(args)
	                r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1848(args)
				@case_ID               = "1848"
				r                      = []			
				args[:error_type]      = "before_OK"
				args[:error_info]      = "必选字段"
				args[:backup_password] = ""
				# 输入后验证
				begin
					System.open_manual_data_backup_inputs_page
	                System.inputs_data_backup_settings_dialog(args)
	                r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1847(args)
				@case_ID              = "1847"
				r                     = []			
				args[:error_type]     = "before_OK"
				args[:error_info]     = "字符串格式不正确，只能为数字，字母，_和-"
				args[:backup_account] = "@!"
				# 输入后验证
				begin
					System.open_manual_data_backup_inputs_page
	                System.inputs_data_backup_settings_dialog(args)
	                r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1846(args)
				@case_ID              = "1846"
				r                     = []			
				args[:error_type]     = "before_OK"
				args[:error_info]     = "必选字段"
				args[:backup_account] = ""
				# 输入后验证
				begin
					System.open_manual_data_backup_inputs_page
	                System.inputs_data_backup_settings_dialog(args)
	                r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1845(args)
				@case_ID           = "1845"
				r                  = []			
				args[:error_type]  = "before_OK"
				args[:error_info]  = "路径格式不正确"
				args[:backup_dest] = "@!"
				# 输入后验证
				begin
					System.open_manual_data_backup_inputs_page
	                System.inputs_data_backup_settings_dialog(args)
	                r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1844(args)
				@case_ID           = "1844"
				r                  = []			
				args[:error_type]  = "before_OK"
				args[:error_info]  = "必选字段"
				args[:backup_dest] = ""
				# 输入后验证
				begin
					System.open_manual_data_backup_inputs_page
	                System.inputs_data_backup_settings_dialog(args)
	                r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1843(args)
				@case_ID             = "1843"
				r                    = []
				args[:error_type]    = "before_OK"
				args[:error_info]    = "IP地址格式不正确"
				args[:backup_server] = "1(2.!68"
				# 输入后验证
				begin
					System.open_manual_data_backup_inputs_page
	                System.inputs_data_backup_settings_dialog(args)
	                r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1842(args)
				@case_ID             = "1842"
				r                    = []
				args[:error_type]    = "before_OK"
				args[:error_info]    = "必选字段"
				args[:backup_server] = ""
				# 输入后验证
				begin
					System.open_manual_data_backup_inputs_page
	                System.inputs_data_backup_settings_dialog(args)
	                r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1825(args)
				@case_ID             = "1825"
				r                    = []
				args[:error_type]    = "before_OK"
				args[:error_info]    = "必选字段"
				args[:backup_server] = ""
				# 输入后验证
				begin
					System.open_recovery_data_backup_inputs_page
	                System.inputs_data_backup_settings_dialog(args)
	                r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1826(args)
				@case_ID             = "1826"
				r                    = []
				args[:error_type]    = "before_OK"
				args[:error_info]    = "IP地址格式不正确"
				args[:backup_server] = "1o.10.10.1"
				# 输入后验证
				begin
					System.open_recovery_data_backup_inputs_page
	                System.inputs_data_backup_settings_dialog(args)
	                r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1827(args)
				@case_ID          = "1827"
				r                 = []			
				args[:error_type] = "before_OK"
				args[:error_info] = "必选字段"
				args[:backup_src] = ""
				# 输入后验证
				begin
					System.open_recovery_data_backup_inputs_page
	                System.inputs_data_backup_settings_dialog(args)
	                r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1828(args)
				@case_ID          = "1828"
				r                 = []			
				args[:error_type] = "before_OK"
				args[:error_info] = "路径格式不正确"
				args[:backup_src] = "@!"
				# 输入后验证
				begin
					System.open_recovery_data_backup_inputs_page
	                System.inputs_data_backup_settings_dialog(args)
	                r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1829(args)
				@case_ID              = "1829"
				r                     = []			
				args[:error_type]     = "before_OK"
				args[:error_info]     = "必选字段"
				args[:backup_account] = ""
				# 输入后验证
				begin
					System.open_recovery_data_backup_inputs_page
	                System.inputs_data_backup_settings_dialog(args)
	                r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1830(args)
				@case_ID              = "1830"
				r                     = []			
				args[:error_type]     = "before_OK"
				args[:error_info]     = "字符串格式不正确，只能为数字，字母，_和-"
				args[:backup_account] = "@!"
				# 输入后验证
				begin
					System.open_recovery_data_backup_inputs_page
	                System.inputs_data_backup_settings_dialog(args)
	                r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1831(args)
				@case_ID               = "1831"
				r                      = []			
				args[:error_type]      = "before_OK"
				args[:error_info]      = "必选字段"
				args[:backup_password] = ""
				# 输入后验证
				begin
					System.open_recovery_data_backup_inputs_page
	                System.inputs_data_backup_settings_dialog(args)
	                r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
		end
	end
end