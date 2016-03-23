# encoding: utf-8
require File.dirname(__FILE__) + '/../../zddi'
module ZDDI
	module Cloud
		class Node_manage
			def case_781(args)
				@case_ID             = "781"
				r                    = []
				args[:error_type]    = "before_OK"
				args[:error_info]    = "必选字段"
				args[:node_name]     = @case_ID
				args[:node_username] = ""
				begin
					# 输入后验证
					Cloud.inputs_add_node_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_782(args)
				@case_ID             = "782"
				r                    = []
				args[:error_type]    = "before_OK"
				args[:error_info]    = "输入格式不正确，只能输字母、汉字、数字、下划线"
				args[:node_name]     = @case_ID
				args[:node_username] = "@!"
				begin
					# 输入后验证
					Cloud.inputs_add_node_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_696(args)
				@case_ID              = "696"
				r                     = []
				args[:error_type]     = "before_OK"
				args[:error_info]     = "必选字段"
				args[:node_name]      = @case_ID
				args[:new_group_name] = ""
				begin
					# 输入后验证
					Cloud.inputs_add_node_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_772(args)
				@case_ID              = "772"
				r                     = []
				args[:error_type]     = "before_OK"
				args[:error_info]     = "输入格式不正确，只能输字母、汉字、数字、下划线"
				args[:node_name]      = @case_ID
				args[:new_group_name] = "@!"
				begin
					# 输入后验证
					Cloud.inputs_add_node_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_786(args)
				@case_ID             = "786"
				r                    = []
				args[:error_type]    = "before_OK"
				args[:error_info]    = "必选字段"
				args[:node_name]     = @case_ID
				args[:node_password] = ""
				begin
					# 输入后验证
					Cloud.inputs_add_node_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_774(args)
				@case_ID          = "774"
				r                 = []
				args[:error_type] = "before_OK"
				args[:error_info] = "必选字段"
				args[:node_name]  = ""
				begin
					# 输入后验证
					Cloud.inputs_add_node_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_775(args)
				@case_ID          = "775"
				r                 = []
				args[:error_type] = "before_OK"
				args[:error_info] = "输入格式不正确，只能输字母、汉字、数字、下划线"
				args[:node_name]  = "@!"
				begin
					# 输入后验证
					Cloud.inputs_add_node_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_778(args)
				@case_ID          = "775"
				r                 = []
				args[:error_type] = "before_OK"
				args[:error_info] = "必选字段"
				args[:node_name]  = @case_ID
				args[:node_ip]    = ""
				begin
					# 输入后验证
					Cloud.inputs_add_node_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_779(args)
				@case_ID             = "779"
				r                    = []
				args[:error_type]    = "before_OK"
				args[:error_info]    = "IP地址格式不正确"
				args[:node_name]     = @case_ID
				args[:node_ip]       = "192.256.12.1o"
				begin
					# 输入后验证
					Cloud.inputs_add_node_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_780(args)
				@case_ID             = "780"
				r                    = []
				args[:error_type]    = "before_OK"
				args[:error_info]    = "IP地址格式不正确"
				args[:node_name]     = @case_ID
				args[:node_ip]       = "2002:d22f:1::1@0"
				begin
					# 输入后验证
					Cloud.inputs_add_node_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_773(args)
				@case_ID              = "773"
				r                     = []
				args[:node_name]      = @case_ID
				args[:new_group_name] = "GroupName_CanNot_MoreThan_32_Characters"
				begin
					# 输入后验证
					Cloud.inputs_add_node_dialog(args)
					get_name = DNS.popwin.text_field(:name, "groupname").value
					DNS.popwin.button(:class, "cancel").click
					r << (get_name.size == 32) ? "succeed" : "failed"
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_776(args)
				@case_ID              = "776"
				r                     = []
				args[:node_name]      = "NodeName_CanNot_MoreThan_32_Characters"
				begin
					# 输入后验证
					Cloud.inputs_add_node_dialog(args)
					get_name = DNS.popwin.text_field(:name, "name").value
					DNS.popwin.button(:class, "cancel").click
					r << (get_name.size == 32) ? "succeed" : "failed"
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_783(args)
				@case_ID             = "783"
				r                    = []
				args[:error_type]    = "before_OK"
				args[:error_info]    = "长度最少是 4"
				args[:node_name]     = @case_ID
				args[:node_username] = "abc"
				begin
					# 最少字符4位
					Cloud.inputs_add_node_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					# 最大字符32位
					args[:node_username]  = "UserName_CanNot_MoreThan_32_Characters"
					Cloud.inputs_add_node_dialog(args)
					get_name = DNS.popwin.text_field(:name, "username").value
					DNS.popwin.button(:class, "cancel").click
					r << (get_name.size == 32) ? "succeed" : "failed"
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_769(args)
				@case_ID          = "769"
				r                 = []
				args[:error_type] = "after_OK"
				args[:error_info] = "成员设备无法访问"
				args[:node_name]  = @case_ID
				args[:node_ip]    = "1.1.1.1"
				begin
					# 输入后验证
					Cloud.inputs_add_node_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_770(args)
				@case_ID          = "770"
				r                 = []
				args[:error_type] = "after_OK"
				args[:error_info] = "无法识别的ZDNS设备"
				args[:node_name]  = @case_ID
				args[:node_ip]    = "8.8.8.8"
				begin
					# 输入后验证
					Cloud.inputs_add_node_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end			
			def case_767(args)
				@case_ID          = "767"
				r                 = []
				args[:error_type] = "after_OK"
				args[:error_info] = "拥有相同IP的成员已存在"
				args[:node_name]  = @case_ID
				args[:node_ip]    = "#{Master_IP}"
				begin
					# 输入后验证
					Cloud.inputs_add_node_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_766(args)
				@case_ID          = "766"
				r                 = []
				args[:error_type] = "after_OK"
				args[:error_info] = "拥有相同名字的成员已存在"
				args[:node_name]  = "master"
				args[:node_ip]    = "8.8.8.8"
				begin
					# 输入后验证
					Cloud.inputs_add_node_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_798(args)
				@case_ID          = "798"
				r                 = []
				args[:error_type] = "before_OK"
				args[:error_info] = "输入格式不正确，只能输字母、汉字、数字、下划线"
				args[:node_name]  = "@!!@"
				begin
					# 输入后验证
					Cloud.inputs_edit_node_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_797(args)
				@case_ID          = "797"
				r                 = []
				args[:error_type] = "before_OK"
				args[:error_info] = "必选字段"
				args[:node_name]  = ""
				begin
					# 输入后验证
					Cloud.inputs_edit_node_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_8343(args)	#覆盖了 case 819
				@case_ID              = "8343"
				r                     = []
				args[:node_ip]        = "#{Slave_IP}"
				args[:node_username]  = "zdns"
				args[:node_password]  = "knetzdns"
				args[:node_name]      = Slave_Device
				args[:new_group_name] = Slave_Group
				begin
					Cloud.del_device(args)
					Cloud.add_device(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_784(args)
				@case_ID              = "784"
				r                     = []
				args[:node_ip]        = "#{Slave_IP}"
				args[:node_username]  = "zdns123"
				args[:node_password]  = "knetzdns"
				args[:node_name]      = Slave_Device
				args[:new_group_name] = Slave_Group
				args[:error_type]     = "after_OK"
				args[:error_info]     = "用户名/密码验证失败"
				begin
					Cloud.del_device(args)
					Cloud.inputs_add_node_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					args[:node_username] = "zdns"
					Cloud.add_device(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end		
			def case_785(args)
				@case_ID              = "785"
				r                     = []
				args[:node_ip]        = "#{Slave_IP}"
				args[:node_username]  = "zdns"
				args[:node_password]  = "111111"
				args[:node_name]      = Slave_Device
				args[:new_group_name] = Slave_Group
				args[:error_type]     = "after_OK"
				args[:error_info]     = "用户名/密码验证失败"
				begin
					Cloud.del_device(args)
					Cloud.inputs_add_node_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					args[:node_password] = "knetzdns"
					Cloud.add_device(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
		end
	end
end