# encoding: utf-8
require File.dirname(__FILE__) + '/../../zddi'
module ZDDI
	module System
		class Alarm_manage
			def case_1611(args)
				@case_ID          = "1611"
				r                 = []			
				args[:error_type] = "before_OK"
				args[:error_info] = "必选字段"
				args[:min_qps]    = ""
				args[:max_qps]    = ""
				# 输入后验证
				begin
					System.inputs_warning_threshold_settings_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1612(args)
				@case_ID          = "1612"
				r                 = []			
				args[:error_type] = "before_OK"
				args[:error_info] = "请输入合法的整数"
				args[:min_qps]    = "@!"
				args[:max_qps]    = "!@"
				# 输入后验证
				begin
					System.inputs_warning_threshold_settings_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1613(args)
				@case_ID          = "1613"
				r                 = []			
				args[:error_type] = "before_OK"
				args[:error_info] = "请输入合法的整数"
				args[:min_qps]    = "16.13"
				args[:max_qps]    = "13.16"
				# 输入后验证
				begin
					System.inputs_warning_threshold_settings_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1614(args)
				@case_ID          = "1614"
				r                 = []			
				args[:error_type] = "after_OK"
				args[:error_info] = "下限值不应大于上限值"
				args[:min_qps]    = "10000"
				args[:max_qps]    = "1000"
				# 输入后验证
				begin
					System.inputs_warning_threshold_settings_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1615(args)
				@case_ID          = "1615"
				r                 = []			
				args[:error_type] = "before_OK"
				args[:error_info] = "请输入合法的整数"
				args[:min_qps]    = "-10"
				args[:max_qps]    = "-2"
				# 输入后验证
				begin
					System.inputs_warning_threshold_settings_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1616(args)
				@case_ID          = "1616"
				r                 = []			
				args[:error_type] = "before_OK"
				args[:error_info] = "必选字段"
				args[:cpu_usage]  = ""
				# 输入后验证
				begin
					System.inputs_warning_threshold_settings_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1617(args)
				@case_ID          = "1617"
				r                 = []			
				args[:error_type] = "before_OK"
				args[:error_info] = "请输入正整数或小数，且小数点后只能输入一位数字"
				args[:cpu_usage]  = "@!"
				# 输入后验证
				begin
					System.inputs_warning_threshold_settings_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1618(args)
				@case_ID          = "1618"
				r                 = []			
				args[:error_type] = "before_OK"
				args[:error_info] = "请输入 0 和 100 之间的值"
				args[:cpu_usage]  = "1618"
				# 输入后验证
				begin
					System.inputs_warning_threshold_settings_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1619(args)
				@case_ID          = "1619"
				r                 = []			
				args[:error_type] = "before_OK"
				args[:error_info] = "必选字段"
				args[:cpu_temp]   = ""
				# 输入后验证
				begin
					System.inputs_warning_threshold_settings_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1620(args)
				@case_ID          = "1620"
				r                 = []			
				args[:error_type] = "before_OK"
				args[:error_info] = "请输入正整数或小数，且小数点后只能输入一位数字"
				args[:cpu_temp]   = "@!"
				# 输入后验证
				begin
					System.inputs_warning_threshold_settings_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1621(args)
				@case_ID          = "1621"
				r                 = []			
				args[:error_type] = "before_OK"
				args[:error_info] = "请输入 0 和 100 之间的值"
				args[:cpu_temp]   = "1621"
				# 输入后验证
				begin
					System.inputs_warning_threshold_settings_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1622(args)
				@case_ID          = "1622"
				r                 = []			
				args[:error_type] = "before_OK"
				args[:error_info] = "必选字段"
				args[:disk_usage] = ""
				# 输入后验证
				begin
					System.inputs_warning_threshold_settings_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1623(args)
				@case_ID          = "1623"
				r                 = []			
				args[:error_type] = "before_OK"
				args[:error_info] = "请输入正整数或小数，且小数点后只能输入一位数字"
				args[:disk_usage] = "@!"
				# 输入后验证
				begin
					System.inputs_warning_threshold_settings_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1624(args)
				@case_ID          = "1624"
				r                 = []			
				args[:error_type] = "before_OK"
				args[:error_info] = "请输入 0 和 100 之间的值"
				args[:disk_usage] = "1624"
				# 输入后验证
				begin
					System.inputs_warning_threshold_settings_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_2372(args)
				@case_ID          = "2372"
				r                 = []			
				args[:error_type] = "before_OK"
				args[:error_info] = "请输入正整数或小数，且小数点后只能输入一位数字"
				args[:disk_usage] = "@!"
				# 输入后验证
				begin
					System.inputs_warning_threshold_settings_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1625(args)
				@case_ID          = "1625"
				r                 = []			
				args[:error_type] = "before_OK"
				args[:error_info] = "必选字段"
				args[:mem_usage]  = ""
				# 输入后验证
				begin
					System.inputs_warning_threshold_settings_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1626(args)
				@case_ID          = "1626"
				r                 = []			
				args[:error_type] = "before_OK"
				args[:error_info] = "请输入正整数或小数，且小数点后只能输入一位数字"
				args[:mem_usage]  = "@!"
				# 输入后验证
				begin
					System.inputs_warning_threshold_settings_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1627(args)
				@case_ID          = "1627"
				r                 = []			
				args[:error_type] = "before_OK"
				args[:error_info] = "请输入 0 和 100 之间的值"
				args[:mem_usage]  = "1627"
				# 输入后验证
				begin
					System.inputs_warning_threshold_settings_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1604(args)
				@case_ID          = "1604"
				r                 = []			
				args[:error_type] = "before_OK"
				args[:error_info] = "端口号的范围为:1-65534"
				args[:mail_port]  = "16.27"
				# 输入后验证
				begin
					System.inputs_mail_alarm_settings_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1541(args)
				@case_ID          = "1541"
				r                 = []			
				args[:error_type] = "before_OK"
				args[:error_info] = "端口号的范围为:1-65534"
				args[:mail_port]  = "@!"
				# 输入后验证
				begin
					System.inputs_mail_alarm_settings_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1529(args)
				@case_ID          = "1529"
				r                 = []			
				args[:error_type] = "before_OK"
				args[:error_info] = "必选字段"
				args[:mail_port]  = ""
				# 输入后验证
				begin
					System.inputs_mail_alarm_settings_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1527(args)
				@case_ID           = "1527"
				r                  = []			
				args[:error_type]  = "before_OK"
				args[:error_info]  = "必选字段"
				args[:mail_server] = ""
				# 输入后验证
				begin
					System.inputs_mail_alarm_settings_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1528(args)
				@case_ID           = "1528"
				r                  = []			
				args[:error_type]  = "before_OK"
				args[:error_info]  = "域名格式不正确"
				args[:mail_server] = "@!@"
				# 输入后验证
				begin
					System.inputs_mail_alarm_settings_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1531(args)
				@case_ID          = "1531"
				r                 = []			
				args[:error_type] = "before_OK"
				args[:error_info] = "必选字段"
				args[:mail_list]  = ""
				# 输入后验证
				begin
					System.inputs_mail_alarm_settings_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1532(args)
				@case_ID          = "1532"
				r                 = []			
				args[:error_type] = "before_OK"
				args[:error_info] = "请输入正确的邮件列表"
				args[:mail_list]  = "@!"
				# 输入后验证
				begin
					System.inputs_mail_alarm_settings_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1533(args)
				@case_ID            = "1533"
				r                   = []			
				args[:error_type]   = "before_OK"
				args[:error_info]   = "必选字段"
				args[:mail_account] = ""
				# 输入后验证
				begin
					System.inputs_mail_alarm_settings_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1534(args)
				@case_ID           = "1534"
				r                  = []			
				args[:error_type]  = "before_OK"
				args[:error_info]  = "必选字段"
				args[:mail_passwd] = ""
				# 输入后验证
				begin
					System.inputs_mail_alarm_settings_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1556(args)
				@case_ID          = "1556"
				r                 = []			
				args[:error_type] = "before_OK"
				args[:error_info] = "请输入正确的邮件列表"
				args[:mail_list]  = "163@163.com; knet@knet.com"
				# 输入后验证
				begin
					System.inputs_mail_alarm_settings_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					args[:mail_list]  = "163@163.com, knet@knet.com;"
					System.inputs_mail_alarm_settings_dialog(args)
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