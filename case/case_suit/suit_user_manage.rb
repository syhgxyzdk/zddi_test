# encoding: utf-8
require File.dirname(__FILE__) + '/../../zddi'
module ZDDI
	module System
		class User_manage
			def case_2306(args)
				@case_ID           = "2306"
				r                  = []
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				args[:error_type]  = "before_OK"
				error_user         = "输入格式不正确，只能输字母、汉字、数字、下划线"
				error_mobile       = "电话格式不正确"
				test_list          = {
					error_user=>[" space ","成吉思汗","13811223344"],
				 	error_mobile=>["username","成吉思汗"," 13811223344 "]}
				begin
					System.open_user_page
					test_list.each_pair do |error_info, inputs|
						args[:error_info] = error_info
						args[:user_name]  = inputs[0]
						args[:surname]    = inputs[1]
						args[:mobile]     = inputs[2]
						System.inputs_create_user_dialog(args)
						r << DNS.error_validator_on_popwin(args)
					end
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1035(args)
				@case_ID           = "1035"
				r                  = []
				args[:user_name]   = "user1035"
				args[:password]    = "123qweASD"
				args[:re_password] = ""
				args[:error_type]  = "before_OK"
				args[:error_info]  = "请再次输入相同的值"
				begin
					System.open_user_page
					System.inputs_create_user_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1036(args)
				@case_ID           = "1036"
				r                  = []
				args[:user_name]   = "@!"
				args[:password]    = "123qweASD"
				args[:re_password] = "123qweASD"
				args[:error_type]  = "before_OK"
				args[:error_info]  = "输入格式不正确，只能输字母、汉字、数字、下划线"
				begin
					System.open_user_page
					System.inputs_create_user_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1037(args)
				# 姓名长度最小是2, 长度最大是32
				@case_ID           = "1037"
				r                  = []
				args[:user_name]   = "user1037"
				args[:password]    = "123qweASD"
				args[:re_password] = "123qweASD"
				args[:error_type]  = "before_OK"
				args[:error_info]  = "长度最少是 2"
				begin
					System.open_user_page
					args[:surname] = "a"
					System.inputs_create_user_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					args[:surname] = "Name_CanNot_MoreThan_32_Characters"
					System.inputs_create_user_dialog(args)
					get_name = DNS.popwin.text_field(:name, "name").value
					DNS.popwin.button(:class, "cancel").click
					r << (get_name.size == 32) ? "succeed" : "failed"
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1038(args)
				@case_ID           = "1038"
				r                  = []
				args[:user_name]   = "user1038"
				args[:password]    = "123qweASD"
				args[:re_password] = "123qweASD"
				args[:mailbox]     = "123@"
				args[:error_type]  = "before_OK"
				args[:error_info]  = "请输入正确格式的电子邮件"
				begin
					System.open_user_page
					System.inputs_create_user_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1039(args)
				@case_ID           = "1039"
				r                  = []
				args[:user_name]   = "user1039"
				args[:password]    = "123qweASD"
				args[:re_password] = "123qweASD"
				args[:mobile]      = "123@"
				args[:error_type]  = "before_OK"
				args[:error_info]  = "电话格式不正确"
				begin
					System.open_user_page
					System.inputs_create_user_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1040(args)
				@case_ID           = "1040"
				r                  = []
				args[:user_name]   = "user1040"
				args[:password]    = "123qweASD"
				args[:re_password] = "123qweASDD"
				args[:error_type]  = "before_OK"
				args[:error_info]  = "请再次输入相同的值"
				begin
					System.open_user_page
					System.inputs_create_user_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1041(args)
				@case_ID           = "1041"
				r                  = []
				args[:user_name]   = "admin"
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				args[:error_type]  = "after_OK"
				args[:error_info]  = "用户已存在"
				begin
					System.open_user_page
					System.inputs_create_user_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1029(args)
				@case_ID           = "1029"
				r                  = []
				args[:user_name]   = ""
				args[:password]    = "123qweASD"
				args[:re_password] = "123qweASD"
				args[:error_type]  = "before_OK"
				args[:error_info]  = "必选字段"
				begin
					System.open_user_page
					System.inputs_create_user_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1030(args)
				@case_ID           = "1029"
				r                  = []
				args[:user_name]   = "@!#"
				args[:password]    = "123qweASD"
				args[:re_password] = "123qweASD"
				args[:error_type]  = "before_OK"
				args[:error_info]  = "输入格式不正确，只能输字母、汉字、数字、下划线"
				begin
					System.open_user_page
					System.inputs_create_user_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1031(args)
				# 用户名长度最小是2, 长度最大是32
				@case_ID           = "1031"
				r                  = []
				args[:user_name]   = "a"
				args[:password]    = "123qweASD"
				args[:re_password] = "123qweASD"
				args[:error_type]  = "before_OK"
				args[:error_info]  = "长度最少是 2"
				begin
					System.open_user_page
					System.inputs_create_user_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					args[:user_name] = "userCanNot_MoreThan_32_Characters"
					System.inputs_create_user_dialog(args)
					get_user_name = DNS.popwin.text_field(:name, "username").value
					DNS.popwin.button(:class, "cancel").click
					r << (get_user_name.size == 32) ? "succeed" : "failed"
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1032(args)
				@case_ID           = "1032"
				r                  = []
				args[:user_name]   = "user1032"
				args[:password]    = ""
				args[:re_password] = ""
				args[:error_type]  = "before_OK"
				args[:error_info]  = "必选字段"
				begin
					System.open_user_page
					System.inputs_create_user_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1033(args)
				@case_ID           = "1033"
				r                  = []
				args[:user_name]   = "user1033"
				args[:password]    = "@!"
				args[:re_password] = "@!"
				args[:error_type]  = "before_OK"
				args[:error_info]  = "密码必须为数字和大小写字母的组合"
				begin
					System.open_user_page
					System.inputs_create_user_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1034(args)
				@case_ID           = "1034"
				r                  = []
				args[:user_name]   = "user1034"
				args[:password]    = "qazW1"
				args[:re_password] = "qazW1"
				args[:error_type]  = "before_OK"
				args[:error_info]  = "长度最少是 6"
				begin
					System.open_user_page
					System.inputs_create_user_dialog(args)
					# 验证最小长度是6
					r << DNS.error_validator_on_popwin(args)
					# 验证最大长度是32
					long_pwd           = "Password_CanNot_MoreThan_32_Characters"
					args[:password]    = long_pwd
					args[:re_password] = long_pwd
					System.inputs_create_user_dialog(args)
					get_pwd = DNS.popwin.text_field(:name, "password").value
					DNS.popwin.button(:class, "cancel").click
					r << (get_pwd.size == 32) ? "succeed": "failed"
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_2307(args)
				@case_ID           = "2307"
				r                  = []			
				args[:user_name]   = "user2307"
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				args[:error_type]  = "before_OK"
				args[:error_info]  = "输入格式不正确，只能输字母、汉字、数字、下划线"
				begin
					r << User_er.create_user(args)
					args[:surname] = " space "
					r << System.check_on_single_user(args)
					System.inputs_edit_user_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1042(args)
				# 编辑, 参数校验
				@case_ID           = "1042"
				r                  = []
				args[:user_name]   = "user1042"
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				args[:error_type]  = "before_OK"
				args[:error_info]  = "输入格式不正确，只能输字母、汉字、数字、下划线"
				begin
					r << User_er.create_user(args)
					r << System.check_on_single_user(args)
					args[:surname] = "@!"
	                System.inputs_edit_user_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1044(args)
				@case_ID           = "1044"
				r                  = []
				args[:user_name]   = "user1044"
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				surname_1          = "a"
				surname_2          = "Name_CanNot_MoreThan_32_Characters"
				args[:error_info]  = "长度最少是 2"
				args[:error_type]  = "before_OK"
				begin
					r << User_er.create_user(args)
					# 编辑时提示"长度最少是 2"
					args[:surname] = surname_1
					r << System.check_on_single_user(args)
					System.inputs_edit_user_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					# 最多输入32字符
					args[:surname] = surname_2
					System.inputs_edit_user_dialog(args)
					get_name = DNS.popwin.text_field(:name, "name").value
					DNS.popwin.button(:class, "cancel").click
					r << (get_name.size == 32) ? "succeed" : "failed"
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1043(args)
				# 编辑用户名姓名，邮箱，手机为空
				@case_ID           = "1043"
				r                  = []			
				args[:user_name]   = "user1043"
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				args[:surname]     = "admin"
				args[:mailbox]     = "username1023@knet.cn"
				args[:mobile]      = "13911971043"
				begin
					r << User_er.create_user(args)
					args[:surname] = ""
					args[:mailbox] = ""
					args[:mobile]  = ""
					r << User_er.edit_user(args)
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1045(args)
				@case_ID           = "1045"
				r                  = []
				args[:user_name]   = "user1045"
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				args[:error_type]  = "before_OK"
				args[:error_info]  = "请输入正确格式的电子邮件"
				begin
					r << User_er.create_user(args)
					r << System.check_on_single_user(args)
					args[:mailbox] = "1234"
					System.inputs_edit_user_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1046(args)
				# 编辑
				@case_ID           = "1046"
				r                  = []
				args[:user_name]   = "user1046"
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				args[:error_type]  = "before_OK"
				args[:error_info]  = "电话格式不正确"
				begin
					r << User_er.create_user(args)
					args[:mobile] = "1234"
					r << System.check_on_single_user(args)
					System.inputs_edit_user_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1047(args)
				@case_ID           = "1047"
				r                  = []
				args[:user_name]   = "testUser"
				args[:surname]     = "输入姓名"	
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				args[:mobile]      = "1111111111111111111111"
				args[:error_type]  = "before_OK"
				args[:error_info]  = "电话格式不正确"
				begin
					System.open_user_page
					System.inputs_create_user_dialog(args)
					r << DNS.error_validator_on_popwin(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1048(args)
				@case_ID           = "1048"
				r                  = []
				args[:user_name]   = "user1048"
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				args[:error_type]  = "before_OK"
				args[:error_info]  = "电话格式不正确"
				begin
					r << User_er.create_user(args)
					# 编辑手机输入超长数字
					args[:mobile] = "111111111112222222222222222223333333333333333334444444444444"
					r << System.check_on_single_user(args)
					System.inputs_edit_user_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1049(args)
				@case_ID         = "1049"
				r                = []			
				args[:user_name] = "admin"
				begin
					args[:surname] = "管理员"
					args[:mailbox] = "admin@knet.cn"
					args[:mobile]  = "13912348765"
					r << User_er.edit_user(args)
					args[:surname] = ""
					args[:mailbox] = ""
					args[:mobile]  = ""
					r << User_er.edit_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1026(args)
				@case_ID           = "1026"
				r                  = []
				args[:user_name]   = "admin_天津"
				args[:password]    = "123qweASD"
				args[:re_password] = "123qweASD"
				args[:surname]     = "张三" 
				args[:mailbox]     = "123456@qq.com"
				args[:mobile]      = "13811110000"
				begin
					r << User_er.create_user(args)
					r << System.login_with_new_user(args)
					r << User_er.del_user(args)
				rescue
		  			puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1025(args)
				@case_ID           = "1025"
				r                  = []
				args[:user_name]   = "admin_tianjin"
				args[:password]    = "123qweASD"
				args[:re_password] = "123qweASD"
				args[:surname]     = "张三" 
				args[:mailbox]     = "123456@qq.com"
				args[:mobile]      = "13811110000"
				begin
					r << User_er.create_user(args)
					r << System.login_with_new_user(args)
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1024(args)
				@case_ID           = "1024"
				r                  = []
				args[:user_name]   = "天津管理员"
				args[:password]    = "123qweASD"
				args[:re_password] = "123qweASD"
				args[:surname]     = "张三" 
				args[:mailbox]     = "123456@qq.com"
				args[:mobile]      = "13811110000"
				begin
					r << User_er.create_user(args)
					r << System.login_with_new_user(args)
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1054(args)
				# 修改密码后重新登录
				@case_ID           = "1054"
				r                  = []
				args[:user_name]   = "user1054"
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				begin
					r << User_er.create_user(args)
					args[:old_password] = args[:password]
					args[:new_password] = args[:password] + "New"
					args[:rpt_password] = args[:new_password]
					args[:password] = args[:new_password]
					r << User_er.modify_password(args)
					r << System.login_with_new_user(args)
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1055(args)
				# 编辑当前密码错误
				@case_ID           = "1055"
				r                  = []
				args[:user_name]   = "user1055"
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				args[:error_type]  = "after_OK"
				args[:error_info]  = "当前密码错误"
				begin
					r << User_er.create_user(args)
					args[:old_password] = "wrong_pwd"
					args[:new_password] = "1qaz2WSXNew"
					args[:rpt_password] = args[:new_password]
					r << System.check_on_single_user(args)
					r << System.inputs_modify_password_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1056(args)
				# 编辑请再次输入相同的值
				@case_ID           = "1056"
				r                  = []
				args[:user_name]   = "user1056"
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				args[:error_type]  = "before_OK"
				args[:error_info]  = "请再次输入相同的值"
				begin
					r << User_er.create_user(args)
					args[:old_password] = args[:password]
					args[:new_password] = "1New2Password"
					args[:rpt_password] = "1New2Passwords"
					r << System.check_on_single_user(args)
					r << System.inputs_modify_password_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1050(args)
				# 编辑不输入旧密码
				@case_ID           = "1050"
				r                  = []
				args[:user_name]   = "user" + @case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				args[:error_type]  = "before_OK"
				args[:error_info]  = "必选字段"
				begin
					r << User_er.create_user(args)
					args[:old_password] = ""
					args[:new_password] = "1New2Password"
					args[:rpt_password] = "1New2Passwords"
					r << System.check_on_single_user(args)
					r << System.inputs_modify_password_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1051(args)
				# 编辑不输入新密码
				@case_ID           = "1051"
				r                  = []
				args[:user_name]   = "user" + @case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				args[:error_type]  = "before_OK"
				args[:error_info]  = "必选字段"
				begin
					r << User_er.create_user(args)
					args[:old_password] = args[:password]
					args[:new_password] = ""
					args[:rpt_password] = "1New2Passwords"
					r << System.check_on_single_user(args)
					r << System.inputs_modify_password_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1052(args)
				# 编辑输入新密码第二次为空
				@case_ID           = "1052"
				r                  = []
				args[:user_name]   = "user" + @case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				args[:error_type]  = "before_OK"
				args[:error_info]  = "必选字段"
				begin
					r << User_er.create_user(args)
					args[:old_password] = args[:password]
					args[:new_password] = "1New2Password"
					args[:rpt_password] = ""
					r << System.check_on_single_user(args)
					r << System.inputs_modify_password_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1053(args)
				# 编辑新密码输入不合法
				@case_ID           = "1053"
				r                  = []
				args[:user_name]   = "user" + @case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				args[:error_type]  = "before_OK"
				args[:error_info]  = "密码必须为数字和大小写字母的组合"
				begin
					r << User_er.create_user(args)
					args[:old_password] = args[:password]
					args[:new_password] = "@!!"
					args[:rpt_password] = "@!!"
					r << System.check_on_single_user(args)
					r << System.inputs_modify_password_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_7002(args)
				# 新建所有视图所有区修改权限
				@case_ID           = "7002"
				r                  = []
				args[:user_name]   = "user" + @case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				begin
					r << User_er.create_user(args)
					args[:view_name]  = "*"
					args[:zone_name]  = "*"
					args[:owner_list] = Node_Name_List
					args[:authority]  = "修改"
					r << User_er.create_authority(args)
					args[:view_name]  = "default"
					args[:zone_name]  = "default"
					r << Zone_er.create_zone(args)
					r << System.verify_authority_on_new_browser(args)
					r << Zone_er.del_zone(args)
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1334(args)
				# 非admin用户'新建/权限/删除'权限不足
				@case_ID           = "1334"
				r                  = []
				args[:user_name]   = "user" + @case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				args[:error_type]  = "after_OK"
				begin
					r << User_er.create_user(args)
					new_br = System.start_new_browser_with_new_user(args)
					return "failed case #{@case_ID}" if new_br == "failed"
					old_br = ZDDI.browser
					ZDDI.browser = new_br
					# 新建用户 ->　权限不足
					System.open_user_page
					args[:user_name]  = "NewUser" + @case_ID
					args[:error_info] = "用户权限不足"
					System.inputs_create_user_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					# 新建权限 ->　权限不足
					args[:user_name]  = "user" + @case_ID
					args[:owner_list] = Node_Name_List
					args[:view_name]  = '*'
					args[:zone_name]  = '*'
					args[:authority]  = "修改"
					r << System.goto_authority_page(args)
					System.inputs_create_authority_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					# 删除自己 -> 权限不足
					args[:user_name]  = "user" + @case_ID
					args[:error_info] = args[:user_name] + ":用户权限不足"
					System.open_user_page
					r << System.check_on_single_user(args)
					DNS.popup_right_menu('del')
					r << DNS.error_validator_on_popwin(args)
					# 切换浏览器
					new_br.close
					ZDDI.browser = old_br
					r << User_er.del_user(args)
				rescue
					puts "Unknown Error with case #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_2970(args)
				# 非admin创建已存在的区
				@case_ID           = "2970"
				r                  = []
				args[:user_name]   = "user" + @case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				args[:view_name]   = "default" # 非admin只能在default视图建区
				args[:zone_name]   = "zone.#{@case_ID}"
				begin
					args[:owner_list] = Node_Name_List
					r << Zone_er.create_zone(args)
					args[:authority] = "修改"
					r << User_er.create_user(args)
					r << User_er.create_authority(args)
					# 登录后重复建区
					new_br = System.start_new_browser_with_new_user(args)
					return "failed case #{@case_ID}" if new_br == "failed"
					old_br = ZDDI.browser
					ZDDI.browser = new_br
					# 重复建区 -> Error
					args[:error_type] = "after_OK"
					args[:error_info] = "同名权威区已存在"
					r << DNS.goto_view_page(args)
					DNS.inputs_create_zone_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					# 浏览器恢复
					new_br.close
					ZDDI.browser = old_br
					r << User_er.del_user(args)
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1359(args)
				# 非admin修改中文视图中文区
				@case_ID           = "1359"
				r                  = []
				args[:user_name]   = "user" + @case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				args[:view_name]   = @case_ID + "中文视图"
				args[:zone_name]   = @case_ID + "中文区"
				args[:owner_list]  = Node_Name_List
				args[:authority]   = "修改"
				begin
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					r << User_er.create_user(args)
					r << User_er.create_authority(args)
					r << System.verify_authority_on_new_browser(args)
					r << User_er.del_user(args)
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1150(args)
				# 新建重复权限
				@case_ID           = "1150"
				r                  = []
				args[:user_name]   = "user" + @case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				args[:error_info]  = "权限配置规则已存在"
				args[:error_type]  = "after_OK"
				args[:owner_list]  = Node_Name_List
				begin
					args[:authority] = "修改"
					args[:view_name] = "*"
					args[:zone_name] = "*"
					r << User_er.create_user(args)
					r << User_er.create_authority(args)
					# 重新建权限
					r << System.inputs_create_authority_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1151(args)
				# 新建重复权限(不同)
				@case_ID           = "1151"
				r                  = []
				args[:user_name]   = "user" + @case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				args[:error_info]  = "权限配置规则已存在"
				args[:error_type]  = "after_OK"
				args[:owner_list]  = Node_Name_List
				begin
					args[:authority] = "修改"
					args[:view_name] = "*"
					args[:zone_name] = "*"
					r << User_er.create_user(args)
					r << User_er.create_authority(args)
					# 重新建权限
					args[:authority] = "只读"
					args[:view_name] = "*"
					args[:zone_name] = "*"
					r << System.inputs_create_authority_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1120(args)
				 # 多视图多个区的不同权限
				@case_ID           = "1120"
				r                  = []
				args[:user_name]   = "user" + @case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				v1                 = "view_#{@case_ID}_invisible"
				v2                 = "view_#{@case_ID}_readonly"
				v3                 = "view_#{@case_ID}_readwrite"
				view_name_list     = [v1,v2,v3]
				view_author_list   = {v1=>"隐藏", v2=>"只读", v3=>"修改"}
				args[:owner_list]  = [Master_Device]
				args[:zone_name]   = "zone.#{@case_ID}"
				begin
					view_name_list.each do |view_name|
						args[:view_name] = view_name
						r << View_er.create_view(args)
						r << Zone_er.create_zone(args)
					end
					# 新建用户
					r << User_er.create_user(args)
					# 新建三个视图的不同权限
					view_author_list.each_pair do |view_name, authority|
						args[:view_name] = view_name
						args[:authority] = authority
						r << User_er.create_authority(args)
					end
					# 验证权限
					view_author_list.each_pair do |view_name, authority|
						args[:view_name] = view_name
						args[:authority] = authority
						r << System.verify_authority_on_new_browser(args)
					end
					# 删除
					r << User_er.del_user(args)
					r << View_er.del_view_list(view_name_list)
				rescue
					puts "Unknown Error verify authority case #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1115(args)
				# 单视图多个区的不同权限
				@case_ID           = "1115"
				r                  = []
				args[:user_name]   = "user" + @case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				args[:view_name]   = "view_#{@case_ID}"
				z1                 = "zone.#{@case_ID}_invisible"
				z2                 = "zone.#{@case_ID}_readonly"
				z3                 = "zone.#{@case_ID}_readwrite"
				zone_name_list     = [z1,z2,z3]
				zone_author_list   = {z1=>"隐藏", z2=>"只读", z3=>"修改"}
				args[:owner_list]  = [Master_Device]
				begin
					r << View_er.create_view(args)
					zone_name_list.each do |zone_name|
						args[:zone_name] = zone_name
						Zone_er.create_zone(args)
					end
					# 新建三个权限 + 验证
					r << User_er.create_user(args)
					zone_author_list.each_pair do |zone_name, authority|
						args[:zone_name] = zone_name
						args[:authority] = authority
						r << User_er.create_authority(args)
					end
					zone_author_list.each_pair do |zone_name, authority|
						args[:zone_name] = zone_name
						args[:authority] = authority
						r << System.verify_authority_on_new_browser(args)
					end
					r << User_er.del_user(args)
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1109(args)
				# 单视图单个区的不同权限
				@case_ID           = "1109"
				r                  = []
				args[:user_name]   = "user" + @case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				args[:view_name]   = "view_#{@case_ID}"
				args[:zone_name]   = "zone.#{@case_ID}"
				args[:owner_list]  = [Master_Device]
				authority_list     = ["隐藏", "只读", "修改"]
				begin
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					r << User_er.create_user(args)
					authority_list.each do |authority|
						args[:authority] = authority
						r << User_er.create_authority(args)
						r << System.verify_authority_on_new_browser(args)
						r << User_er.del_authority(args)
					end
					r << User_er.del_user(args)
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1075(args)
				# 所有视图和区先建权限后建视图/区
				@case_ID           = "1075"
				r                  = []
				args[:user_name]   = "user" + @case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				author_list        = ["隐藏", "只读", "修改"]
				args[:owner_list]  = Node_Name_List
				begin
					r << User_er.create_user(args)
					# 循环>>建权限>>建视图>>验证权限>>删视图>>删权限
					author_list.each do |authority|
						args[:view_name] = "*"
						args[:zone_name] = "*"
						args[:authority] = authority
						r << User_er.create_authority(args)
						args[:view_name] = "view_#{@case_ID}"
						args[:zone_name] = "zone.#{@case_ID}"
						# 后建区
						r << View_er.create_view(args)
						r << Zone_er.create_zone(args)
						r << System.verify_authority_on_new_browser(args)
						r << View_er.del_view(args)
						args[:view_name] = "*"
						args[:zone_name] = "*"
						r << User_er.del_authority(args)
					end
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1076(args)
				# 所有视图和区先建视图/区后建权限
				@case_ID           = "1076"
				r                  = []
				args[:user_name]   = "user" + @case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				authority_list     = ["隐藏", "只读", "修改"]
				args[:owner_list]  = Node_Name_List
				begin
					r << User_er.create_user(args)
					# 循环>>建视图>>建权限>>验证权限>>删权限>>删视图
					authority_list.each do |authority|
						# 先建区
						args[:view_name] = "view_#{@case_ID}"
						args[:zone_name] = "zone.#{@case_ID}"
						r << View_er.create_view(args)
						r << Zone_er.create_zone(args)
						args[:view_name] = "*"
						args[:zone_name] = "*"
						args[:authority] = authority
						r << User_er.create_authority(args)
						args[:view_name] = "view_#{@case_ID}"
						args[:zone_name] = "zone.#{@case_ID}"
						r << System.verify_authority_on_new_browser(args)
						r << User_er.del_authority(args)
						r << View_er.del_view(args)
					end
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1133(args)
				# 所有视图和区，修改权限；新建对区只读权限
				@case_ID           = "1133"
				r                  = []
				args[:user_name]   = "user" + @case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				args[:owner_list]  = Node_Name_List
				begin
					args[:view_name] = "view_#{@case_ID}"
					args[:zone_name] = "zone.#{@case_ID}"
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					args[:view_name] = "*"
					args[:zone_name] = "*"
					args[:authority] = "修改"
					r << User_er.create_user(args)
					r << User_er.create_authority(args)
					# 新权限
					args[:view_name] = "view_#{@case_ID}"
					args[:zone_name] = "zone.#{@case_ID}"
					args[:authority] = "只读"
					r << User_er.create_authority(args)
					r << System.verify_authority_on_new_browser(args)
					r << View_er.del_view(args)
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1132(args)
				# 所有视图和区修改权限新建对区隐藏权限
				@case_ID           = "1132"
				r                  = []
				args[:user_name]   = "user" + @case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				args[:owner_list]  = Node_Name_List
				begin
					args[:view_name] = "view_#{@case_ID}"
					args[:zone_name] = "zone.#{@case_ID}"
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					args[:view_name] = "*"
					args[:zone_name] = "*"
					args[:authority] = "修改"
					r << User_er.create_user(args)
					r << User_er.create_authority(args)
					# 新权限
					args[:view_name] = "view_#{@case_ID}"
					args[:zone_name] = "zone.#{@case_ID}"
					args[:authority] = "隐藏"
					r << User_er.create_authority(args)
					r << System.verify_authority_on_new_browser(args)
					r << View_er.del_view(args)
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1131(args)
				# 所有视图和区只读权限新建对区修改权限
				@case_ID           = "1131"
				r                  = []
				args[:user_name]   = "user" + @case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				args[:owner_list]  = Node_Name_List
				begin
					args[:view_name] = "view_#{@case_ID}"
					args[:zone_name] = "zone.#{@case_ID}"
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					args[:view_name] = "*"
					args[:zone_name] = "*"
					args[:authority] = "只读"
					r << User_er.create_user(args)
					r << User_er.create_authority(args)
					# 新权限
					args[:view_name] = "view_#{@case_ID}"
					args[:zone_name] = "zone.#{@case_ID}"
					args[:authority] = "修改"
					r << User_er.create_authority(args)
					r << System.verify_authority_on_new_browser(args)
					r << View_er.del_view(args)
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1130(args)
				# 所有视图和区只读权限新建对区隐藏权限
				@case_ID           = "1130"
				r                  = []
				args[:user_name]   = "user" + @case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				args[:owner_list]  = Node_Name_List
				begin
					args[:view_name] = "view_#{@case_ID}"
					args[:zone_name] = "zone.#{@case_ID}"
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					args[:view_name] = "*"
					args[:zone_name] = "*"
					args[:authority] = "只读"
					r << User_er.create_user(args)
					r << User_er.create_authority(args)
					# 新权限
					args[:view_name] = "view_#{@case_ID}"
					args[:zone_name] = "zone.#{@case_ID}"
					args[:authority] = "隐藏"
					r << User_er.create_authority(args)
					r << System.verify_authority_on_new_browser(args)
					r << View_er.del_view(args)
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1129(args)
				# 所有视图和区隐藏权限新建对区修改权限
				@case_ID           = "1129"
				r                  = []
				args[:user_name]   = "user" + @case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				args[:owner_list]  = Node_Name_List
				begin
					args[:view_name] = "view_#{@case_ID}"
					args[:zone_name] = "zone.#{@case_ID}"
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					args[:view_name] = "*"
					args[:zone_name] = "*"
					args[:authority] = "隐藏"
					r << User_er.create_user(args)
					r << User_er.create_authority(args)
					# 新权限
					args[:view_name] = "view_#{@case_ID}"
					args[:zone_name] = "zone.#{@case_ID}"
					args[:authority] = "修改"
					r << User_er.create_authority(args)
					r << System.verify_authority_on_new_browser(args)
					r << View_er.del_view(args)
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1128(args)
				# 所有视图和区隐藏权限新建对区只读权限
				@case_ID           = "1128"
				r                  = []
				args[:user_name]   = "user" + @case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				args[:owner_list]  = Node_Name_List
				begin
					args[:view_name] = "view_#{@case_ID}"
					args[:zone_name] = "zone.#{@case_ID}"
					r << View_er.create_view(args)
					r << Zone_er.create_zone(args)
					args[:view_name] = "*"
					args[:zone_name] = "*"
					args[:authority] = "隐藏"
					r << User_er.create_user(args)
					r << User_er.create_authority(args)
					# 新权限
					args[:view_name] = "view_#{@case_ID}"
					args[:zone_name] = "zone.#{@case_ID}"
					args[:authority] = "只读"
					r << User_er.create_authority(args)
					r << System.verify_authority_on_new_browser(args)
					r << View_er.del_view(args)
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1178(args)
				# 参数校验所管设备选择none
				@case_ID           = "1178"
				r                  = []
				args[:user_name]   = "user" + @case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				begin
					r << User_er.create_user(args)
					args[:view_name]  = "*"
					args[:zone_name]  = "*"
					args[:authority]  = "只读"
					args[:owner_list] = Node_Name_List
					r << User_er.create_authority(args)
					# 编辑权限 -> Error
					r << System.check_on_single_authority(args)
					args[:authority] = "修改"
					# args[:view_name] = "default"
					r << System.inputs_edit_authority_dialog(args)
					begin
						# 删除节点 "ALL是原zlope版本UI"
						sleep 1
	                	if DNS.popwin.span(:text=>'ALL').parent.link(:class=>"search-choice-close").present?
		                	DNS.popwin.span(:text=>'ALL').parent.link(:class=>"search-choice-close").click
	                	end
	                 	# 删除节点 "nodeName是AD版本UI"
	                 	[Master_Device, Slave_Device].each do | nodeName |
		                    if DNS.popwin.span(:text=>nodeName).parent.link(:class=>"search-choice-close").present?
		                    	DNS.popwin.span(:text=>nodeName).parent.link(:class=>"search-choice-close").click
		                    end
		                end
		            rescue
		            	puts 'Moving on after some error of node selecting ... '
		            end
					args[:error_info] = "至少选择一项"
					args[:error_type] = "before_OK"
					r << DNS.error_validator_on_popwin(args)
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1196(args)
				# 编辑权限已存在，权限不同
				@case_ID           = "1196"
				r                  = []
				args[:user_name]   = "user" + @case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				args[:error_info]  = "权限配置规则已存在"
				args[:error_type]  = "after_OK"
				begin
					# 新建权限"default视图+修改"
					r << User_er.create_user(args)
					args[:owner_list] = Node_Name_List
					args[:view_name]  = "default"
					args[:zone_name]  = "*"
					args[:authority]  = "修改"
					r << User_er.create_authority(args)
					# 新建权限"*视图+隐藏"
					args[:view_name] = "*"
					args[:authority] = "隐藏"
					r << User_er.create_authority(args)
					# 编辑 "default视图+修改" -> "ALL视图+隐藏"
					args[:authority] = "修改"
					r << DNS.check_on_elem_by_search(search_name = args[:authority])
					args[:authority] = "只读"
					r << System.inputs_edit_authority_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1195(args)
				# 编辑权限已存在权限相同
				@case_ID           = "1195"
				r                  = []
				args[:user_name]   = "user" + @case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				args[:error_info]  = "权限配置规则已存在"
				args[:error_type]  = "after_OK"
				begin
					# 新建权限"default视图+修改"
					r << User_er.create_user(args)
					args[:owner_list] = Node_Name_List
					args[:view_name]  = "default"
					args[:zone_name]  = "*"
					args[:authority]  = "修改"
					r << User_er.create_authority(args)
					# 新建权限"*视图+隐藏"
					args[:view_name] = "*"
					args[:authority] = "隐藏"
					r << User_er.create_authority(args)
					# 编辑 "default视图+修改" -> "ALL视图+隐藏"
					args[:authority] = "修改"
					r << DNS.check_on_elem_by_search(search_name = args[:authority])
					args[:authority] = "隐藏"
					r << System.inputs_edit_authority_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					r << User_er.del_user(args)
				rescue
					puts "Unknown Error case #{@case_ID}"
					r << "failed"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1206(args)
				# 非admin用户不能编辑权限
				@case_ID           = "1206"
				r                  = []
				args[:user_name]   = "user" + @case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				begin
					args[:view_name]  = "*"
					args[:zone_name]  = "*"
					args[:authority]  = "修改"
					args[:owner_list] = Node_Name_List
					r << User_er.create_user(args)
					r << User_er.create_authority(args)
					new_br = System.start_new_browser_with_new_user(args)
					return "failed case #{@case_ID}" if new_br == "failed"
					old_br = ZDDI.browser
					ZDDI.browser = new_br
					# 非admin编辑权限 -> Error
					args[:authority] = "修改"
					r << System.goto_authority_page(args)
					r << DNS.check_on_elem_by_search(search_name = args[:authority])
					r << System.inputs_edit_authority_dialog(args)
					args[:error_info] = "用户权限不足"
					args[:error_type] = "after_OK"
					r << DNS.error_validator_on_popwin(args)
					# 恢复浏览器
					new_br.close
					ZDDI.browser = old_br
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1182(args)
				@case_ID			 = "1182"
				args[:user_name]	 = "user" + @case_ID
				args[:case_id]       = @case_ID
				args[:authority_old] = "隐藏"
				args[:authority_new] = "只读"
				r = User_er.edit_authority_and_verify_on_browser(args)
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1183(args)
				@case_ID			 = "1183"
				args[:user_name]	 = "user" + @case_ID
				args[:case_id]       = @case_ID
				args[:authority_old] = "隐藏"
				args[:authority_new] = "修改"
				r = User_er.edit_authority_and_verify_on_browser(args)
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1184(args)
				@case_ID			 = "1184"
				args[:user_name]	 = "user" + @case_ID
				args[:case_id]       = @case_ID
				args[:authority_old] = "只读"
				args[:authority_new] = "隐藏"
				r = User_er.edit_authority_and_verify_on_browser(args)
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1186(args)
				@case_ID			 = "1186"
				args[:user_name]	 = "user" + @case_ID
				args[:case_id]       = @case_ID
				args[:authority_old] = "修改"
				args[:authority_new] = "只读"
				r = User_er.edit_authority_and_verify_on_browser(args)
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1187(args)
				@case_ID			 = "1187"
				args[:user_name]	 = "user" + @case_ID
				args[:case_id]       = @case_ID
				args[:authority_old] = "修改"
				args[:authority_new] = "隐藏"
				r = User_er.edit_authority_and_verify_on_browser(args)
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1903(args)
				@case_ID             = "1903"
				args[:user_name]     = "user" + @case_ID
				args[:case_id]       = @case_ID
				args[:authority_old] = "只读"
				args[:authority_new] = "修改"
				r = User_er.edit_authority_and_verify_on_browser(args)
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_23428(args)
				@case_ID           = "23428"
				r                  = []
				args[:user_name]   = "user" + @case_ID
				args[:case_id]     = @case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				args[:view_name]   = "*"
				args[:zone_name]   = "*"
				args[:authority]   = "修改"
				args[:owner_list]  = Node_Name_List
				begin
					r << User_er.create_user(args)
					r << User_er.create_authority(args)
					new_br = System.start_new_browser_with_new_user(args)
					return "failed case #{@case_ID}" if new_br == "failed"
					old_br = ZDDI.browser
					ZDDI.browser = new_br
					# 查看syslog配置是disabled
					r << System.open_audit_log_page
					syslog_disabled = ZDDI.browser.div(:id, "toolsBar").button(:class, 'syslog-config').disabled?
					if syslog_disabled
						puts 'succeed to verify disabled syslog button for user23428'
					else
						puts 'failed to verify disabled syslog button for user23428'
						r << 'fail'
					end
					# 恢复浏览器
					new_br.close
					ZDDI.browser = old_br
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1877(args)
				#删除用户验证
                @case_ID           = "1877"
				r                  = []
				args[:user_name]   = "user" + @case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				begin
					r<<User_er.create_user(args)
             	    b1=ZDDI::System.elem_exists?(args[:user_name])
             	    r<<User_er.del_user(args)
             	    b2=ZDDI::System.elem_exists?(args[:user_name])
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end 
             	if b1 == false || b2 == true
                  r<<"fail"	
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_1878(args)
            	#取消删除用户验证
             	@case_ID           = "1878"
				r                  = []
				args[:user_name]   = "user" + @case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
			    begin
             	  r << User_er.create_user(args)
                  ZDDI::DNS.check_single_check_box(args[:user_name], expected_fail=false)
                  ZDDI.browser.div(:id, "toolsBar").button(:class, "del").click
                  sleep 1
                  ZDDI.browser.div(:id,"popWin").button(:class,"cancel btnCancel").click
                  result=ZDDI::System.elem_exists?("#{args[:user_name]}")
                rescue
                	puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}" 
                end
                if !result
                   r << "fail"  
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_1879(args)
            	#批量删除用户验证
             	@case_ID           = "1879"
				r                  = []
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				begin 
					(1..5).each do |i|
                	args[:user_name]   = "user" +i.to_s
                	r << User_er.create_user(args)
                   end
                #"删除 除admin之外的所有用户"
                r << ZDDI.del_failed_items
                total_result = false
                (1..5).each do |i|
                	  suffix = i.to_s
                	  result = ZDDI::System.elem_exists?("user#{suffix}")
                	 #如果！result=true意味着账户已经不存在
                     total_result = total_result || result
                    end
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
                if  total_result
                     r << "failed"
                end
                 r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}" 
            end
            def case_1880(args)
				#空查询出所有用户
				@case_ID           = "1880"
				r                  = []
				args[:user_name]   = "user" + @case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				new_users = ["user001","user002","admin"]
				begin
					(0..1).each do |i|
						 args[:user_name] = new_users[i]
						 r << User_er.create_user(args)
						end
					ZDDI::DNS.search_elem("xxxxxx")
					ZDDI::DNS.search_elem("")
                    (0..2).each do |i|
                      args[:user_name] == new_users[i]
                      r << ZDDI::System.check_on_single_user(args,expected_fail=false)
					end
					r << ZDDI.del_failed_items
					rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"	
				end
                 r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end  
            def case_1352(args)
				#查询用户存在
				@case_ID           = "1352"
				r                  = []
				args[:user_name]   = "user" + @case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				begin
					r  << User_er.create_user(args)
					b1 = ZDDI::System.elem_exists?(args[:user_name])
                    b2 = ZDDI::System.elem_exists?("admin")
                    if b1 == false || b2 == false
				 	r<< "fail"
				    end
				    r<<User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end 
            def case_1353(args)
            	#查询用户不存在
			    r=[]
				@case_ID           = "1353"
				r                  = []
				args[:user_name]   = "user" + @case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				begin
					r  << User_er.create_user(args)
					b1 = ZDDI::System.elem_exists?("adminx")
					b2 = ZDDI::System.elem_exists?("user 1353")
					if b1 || b2   
                	r << "fail"
                    end
                    r<<User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end 
            def case_1355(args)
            	#查询中文用户且存在
				@case_ID           = "1355"
				r                  = []
				args[:user_name]   = "张鹏飞" + @case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				begin
					r  << User_er.create_user(args)
					result = ZDDI::System.elem_exists?(args[:user_name])
					if result == false
				       r << "fail"
				    end
				    r<<User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_5799(args)
				#用户名为空
				@case_ID           = "5799"
				r                  = []
				args[:user_name]   = ""
				args[:password]    = "xxxxx"
				begin
					new_br = System.inputs_login_parameters(args)
					old_br = ZDDI.browser
					ZDDI.browser = new_br
					expected_error = "用户名或密码不能为空"
					r << System.error_validator_on_page(expected_error)
					sleep 1
					# 恢复浏览器
					new_br.close
					ZDDI.browser = old_br
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_5800(args)
				#密码为空
				@case_ID           = "5800"
				r                  = []
				args[:user_name]   = "username"
				args[:password]    = ""
				begin
					new_br = System.inputs_login_parameters(args)
					old_br = ZDDI.browser
					ZDDI.browser = new_br
					expected_error = "用户名或密码不能为空"
					r << System.error_validator_on_page(expected_error)
					sleep 1
					# 恢复浏览器
					new_br.close
					ZDDI.browser = old_br
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
            def case_5789(args)
				#登录密码错误
				@case_ID           = "5789"
				r                  = []
				args[:user_name]   = "rocky"+@case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				begin
					r  << User_er.create_user(args)
					args[:password] = "wrongpassword"
					new_br = System.inputs_login_parameters(args)
					old_br = ZDDI.browser
					ZDDI.browser = new_br
					expected_error = "用户名或密码输入错误"
					r << System.error_validator_on_page(expected_error)
					sleep 1
					# 恢复浏览器
					new_br.close
					ZDDI.browser = old_br
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end 
			def case_5790(args)
				#用户不存在
				@case_ID           = "5790"
				r                  = []
				args[:user_name]   = "rocky"+@case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				begin
					r  << User_er.create_user(args)
					args[:user_name] = 'non-existent'
					new_br = System.inputs_login_parameters(args)
					old_br = ZDDI.browser
					ZDDI.browser = new_br
					expected_error = "用户名或密码输入错误"
					r << System.error_validator_on_page(expected_error)
					sleep 1
					# 恢复浏览器
					new_br.close
					ZDDI.browser = old_br
					args[:user_name] = "rocky"+@case_ID
				    r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_25942(args)
				# 用户解锁非admin ->admin
				@case_ID           = "25942"
				admin_user         = 'admin'
				new_user           = "user" + @case_ID
				args[:password]    = "123Test"
				args[:re_password] = "123Test"
				args[:case_id]     = @case_ID
				r                  = []
				begin
					args[:user_name] = new_user
					r << User_er.create_user(args)
					args[:user_name] = 'admin'
					r << System.start_new_browser_to_lock_user(args)
					args[:user_name] = new_user
					new_br = System.start_new_browser_with_new_user(args)
					return "failed case #{@case_ID}" if new_br == "failed"
					old_br = ZDDI.browser
					ZDDI.browser = new_br
					args[:user_name] = 'admin'
					args[:password]  = 'zdns'
					r << User_er.unlock_user(args)
					r << System.login_with_new_user(args)
					# 恢复浏览器
					new_br.close
					ZDDI.browser = old_br
					args[:user_name] = new_user
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_25943(args)
				# 用户解锁admin ->非admin
				@case_ID             = "25943"
				args[:user_name]     = "user" + @case_ID
				args[:password]      = "123Test"
				args[:re_password]   = "123Test"
				args[:case_id]       = @case_ID
				r = []
				begin
					r << User_er.create_user(args)
					r << System.start_new_browser_to_lock_user(args)
					r << User_er.unlock_user(args)
					r << System.login_with_new_user(args)
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_25945(args)
				# 用户解锁非admin ->非admin
				@case_ID           = "25945"
				new_user_1         = "user" + @case_ID + '_1'
				new_user_2         = "user" + @case_ID + '_2'
				args[:password]    = "123Test"
				args[:re_password] = "123Test"
				args[:case_id]     = @case_ID
				r                  = []
				begin
					[new_user_1, new_user_2].each do |user_name|
						args[:user_name] = user_name
						r << User_er.create_user(args)
					end
					r << System.start_new_browser_to_lock_user(args)
					args[:user_name] = new_user_1
					new_br = System.start_new_browser_with_new_user(args)
					return "failed case #{@case_ID}" if new_br == "failed"
					old_br = ZDDI.browser
					ZDDI.browser = new_br
					args[:user_name] = new_user_2
					r << User_er.unlock_user(args)
					r << System.login_with_new_user(args)
					# 恢复浏览器
					new_br.close
					ZDDI.browser = old_br
					[new_user_1, new_user_2].each do |user_name|
					    args[:user_name] = user_name
						r << User_er.del_user(args)
					end
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
            def case_5791(args)
				# 非admin用户登陆
				@case_ID             = "5791"
				args[:user_name]     = "user" + @case_ID
				args[:password]      = "123Test"
				args[:re_password]   = "123Test"
				r = []
				begin
					r << User_er.create_user(args)
					#登陆成功验证
					new_br = System.start_new_browser_with_new_user(args)
					return "failed case #{@case_ID}" if new_br == "failed"
					new_br.close
					args[:password]  =  "wrongpassword"
                    new_br = System.inputs_login_parameters(args)
					old_br = ZDDI.browser
					ZDDI.browser = new_br
					expected_error = "用户名或密码输入错误"
					r << System.error_validator_on_page(expected_error)
					sleep 1
					# 恢复浏览器
					new_br.close
					ZDDI.browser = old_br
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_5792(args)
				# 用户连续4次登陆失败，第5次成功
				@case_ID             = "5792"
				args[:user_name]     = "user" + @case_ID
				args[:password]      = "123Test"
				args[:re_password]   = "123Test"
				r = []
				begin
                    r << User_er.create_user(args)
					args[:password]  = "wrongpassword"
					(1..4).each do |i|
                    new_br = System.inputs_login_parameters(args)
                    sleep 1
				 	new_br.close
				   end
				   args[:password]   = "123Test"
                   new_br = System.start_new_browser_with_new_user(args)
                   return "failed case #{@case_ID}" if new_br == "failed"
				   new_br.close
				   sleep 1
					r << User_er.del_user(args)
				rescue 
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_5793(args)
				# 用户连续5次登陆失败，15分钟内禁止再次登陆
				@case_ID             = "5793"
				args[:user_name]     = "user" + @case_ID
				args[:password]      = "123Test"
				args[:re_password]   = "123Test"
				expected_error = "连续5次登录失败，15分钟之内禁止登录."
				r = []
				begin
					r << User_er.create_user(args)
					args[:password]  = "wrongpassword"
					#连续4次输入错误
					(1..4).each do |i|
                    new_br = System.inputs_login_parameters(args)
					new_br.close
				    end
				    #第5次输入错误
				    new_br = System.inputs_login_parameters(args)
				    old_br = ZDDI.browser
				 	ZDDI.browser = new_br
					r << System.error_validator_on_page(expected_error)
					new_br.close
					#10分钟之后再次登陆
					sleep 600
					new_br = System.inputs_login_parameters(args)
					ZDDI.browser = new_br
					r << System.error_validator_on_page(expected_error)
					new_br.close
					#再等待5分钟，加前边时间超出15分钟，再次登陆
					sleep 300
					args[:password]   = "123Test"
                    new_br = System.start_new_browser_with_new_user(args)
                    new_br.close
				    return "failed case #{@case_ID}" if new_br == "failed"
					#恢复浏览器
					ZDDI.browser = old_br
				    r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				puts r
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_5788(args)
				# 密码正确登陆
				@case_ID             = "5788"
				args[:user_name]     = "admin"
				args[:password]      = "zdns"
			    r = []
				begin
					new_br = System.start_new_browser_with_new_user(args)
					return "failed case #{@case_ID}" if new_br == "failed"
					new_br.close
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_6857(args)
				#非admin账户 -> 操作日志、告警日志、区可导出->验证
				@case_ID             = "6857"
				args[:user_name]     = "user" + @case_ID
				args[:password]      = "123Test"
				args[:re_password]   = "123Test"
				r = []
				args[:view_name]     = "default"
				args[:zone_name]     = "zone.#{@case_ID}"
				args[:owner_list]    = ["master"]
				args[:exported_file] = Download_Dir + "#{args[:zone_name]}.txt"
                args[:authority]     = "只读"
				begin
					r << Zone_er.create_zone(args)
					r << User_er.create_user(args)
					r << User_er.create_authority(args)
                    #登陆成功验证
					new_br = System.start_new_browser_with_new_user(args)
					return "failed case #{@case_ID}" if new_br == "failed"
					old_br = ZDDI.browser
					ZDDI.browser = new_br
				    r << Zone_er.export_zone(args)
                    #导出操作日志
                    System.open_system_page
                    r << System.open_audit_log_page
                    r << DNS.export_checked_item
                    args[:exported_file] = Download_Dir + "操作日志.csv"
                    r << DNS.export_validator(args)
                    #导出告警日志
                    r << System.open_warning_records_page
                    r << DNS.export_checked_item
                    args[:exported_file] = Download_Dir + "告警日志.csv"
                    r << DNS.export_validator(args)
					sleep 1
					# 恢复浏览器
					new_br.close
					ZDDI.browser = old_br
					r << User_er.del_user(args)
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_6858(args)
			 #非admin账户修改密码
				@case_ID             = "6858"
				args[:user_name]     = "user" + @case_ID
				args[:password]      = "123Test"
				args[:re_password]   = "123Test"
				args[:old_password]  = "123Test"
                args[:new_password]  = "1qaz2WSX"
                args[:rpt_password]  = "1qaz2WSX" 
				r = []
				begin
					r << User_er.create_user(args)
					new_br = System.start_new_browser_with_new_user(args)
					return "failed case #{@case_ID}" if new_br == "failed"
					old_br = ZDDI.browser
					ZDDI.browser = new_br
					r << User_er. modify_password(args)
					#检查操作日志的正确性
                    args[:log_string] = "更新用户"+" #{args[:user_name]} "+ "的信息"
					r << System.log_validator_on_audit_log_page(args)
					new_br.close
					#使用新密码登陆
					args[:password] = "1qaz2WSX"
					new_br = System.start_new_browser_with_new_user(args)
					return "failed case #{@case_ID}" if new_br == "failed"
					# 恢复浏览器
					new_br.close
					ZDDI.browser = old_br
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_6859(args)
			 #非admin账户 -> 修改密码，参数校验
				@case_ID             = "6859"
				args[:user_name]     = "user" + @case_ID
				args[:password]      = "123Test"
				args[:re_password]   = "123Test"
				args[:old_password]  = ""
                args[:new_password]  = ""
                args[:rpt_password]  = "" 
                required_error = "必选字段"
                invalid_old_password = "当前密码错误"
                invalid_format_error = "密码必须为数字和大小写字母的组合"
                length_error         =  "长度最少是 6"
                not_consistent_error =  "请再次输入相同的值"
				r = []
				begin
					r << User_er.create_user(args)
					new_br = System.start_new_browser_with_new_user(args)
					return "failed case #{@case_ID}" if new_br == "failed"
					old_br = ZDDI.browser
					ZDDI.browser = new_br
					r << System.open_system_page
					r << System.open_user_page
                    r << System.check_on_single_user(args)  
					r << System.inputs_modify_password_dialog(args)
					#3个输入框均为空
                    args[:error_info] = required_error
                    args[:error_type] = "before_OK"
					r << DNS.error_validator_on_popwin(args)
					#其中一个为空
					args[:old_password]  = "123Test"
                    args[:new_password]  = "1qaz2WSX"
                    args[:rpt_password]  = "" 
                    r << System.check_on_single_user(args)  
					r << System.inputs_modify_password_dialog(args)
					r << DNS.error_validator_on_popwin(args)
                    #新密码长度不符合要求
                    args[:old_password]  = "123Test"
                    args[:new_password]  = "123Aa"
                    args[:rpt_password]  = "123Aa" 
                    args[:error_info] = length_error
                    r << System.check_on_single_user(args)  
					r << System.inputs_modify_password_dialog(args)
					r << DNS.error_validator_on_popwin(args)
                    #新密码格式不符合要求
                    args[:old_password]  = "123Test"
                    args[:new_password]  = "123456"
                    args[:rpt_password]  = "123456" 
                    args[:error_info]    =  invalid_format_error
                    r << System.check_on_single_user(args)  
					r << System.inputs_modify_password_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					#两次密码不一致
                    args[:old_password]  = "123Test"
                    args[:new_password]  = "1qaz2WSX"
                    args[:rpt_password]  = "1qaz2WSY" 
                    args[:error_info]    =  not_consistent_error
                    r << System.check_on_single_user(args)  
					r << System.inputs_modify_password_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					#当前密码错误
					args[:old_password]  = "wrongpassword"
					args[:new_password]  = "1qaz2WSX"
                    args[:rpt_password]  = "1qaz2WSX" 
                    args[:error_info] = invalid_old_password
                    args[:error_type] = "after_OK"
                    r << System.check_on_single_user(args)  
					r << System.inputs_modify_password_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					sleep 1
					# 恢复浏览器
					#new_br.close
					ZDDI.browser = old_br
					r << User_er.del_user(args)
				rescue
					 puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_6860(args)
			 #非admin账户编辑自己的用户信息校验
                @case_ID             = "6860"
				args[:user_name]     = "user" + @case_ID
				args[:password]      = "123Test"
				args[:re_password]   = "123Test"
				name_length_error    = "长度最少是 2"
                name_format_error    = "输入格式不正确，只能输字母、汉字、数字、下划线"
				mail_error           = "请输入正确格式的电子邮件"
				phone_error          = "电话格式不正确"
				r = []
				begin
					r << User_er.create_user(args)
					new_br = System.start_new_browser_with_new_user(args)
					return "failed case #{@case_ID}" if new_br == "failed"
					old_br = ZDDI.browser
					ZDDI.browser = new_br
					r << System.open_system_page
					r << System.open_user_page
					args[:surname]    = "a"
                    args[:mailbox]    = "wrong_mail"
                    args[:mobile]     = "1111a"
                    args[:error_info] = name_length_error
                    args[:error_type] = "before_OK"
					r << System.check_on_single_user(args) 
					r << System.inputs_edit_user_dialog(args)
					r << DNS.error_validator_on_popwin(args)
                    args[:surname]    = "12@"
                    args[:mailbox]    = "zpf@knet.cn"
                    args[:mobile]     = "1521011123"
                    args[:error_info] = name_format_error
					r << System.check_on_single_user(args) 
					r << System.inputs_edit_user_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					args[:surname]    = "zhang"
                    args[:mailbox]    = "zpf@knet."
                    args[:mobile]     = "1521011123"
					args[:error_info] = mail_error
					r << System.check_on_single_user(args)
					r << System.inputs_edit_user_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					args[:surname]    = "zhang"
                    args[:mailbox]    = "zpf@knet.com"
                    args[:mobile]     = "15a"
                    args[:error_info] = phone_error 
					r << System.check_on_single_user(args) 
					r << System.inputs_edit_user_dialog(args)
				    r << DNS.error_validator_on_popwin(args)
					# 恢复浏览器
					new_br.close
					ZDDI.browser = old_br
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_10865(args)
				#非admin账户  新建/编辑/删除根配置用户权限不足
				@case_ID             = "10865"
				args[:user_name]     = "user" + @case_ID
				args[:password]      = "123Test"
				args[:re_password]   = "123Test"
				r = []
				args[:view_name]     = "default"
				args[:zone_name]     = "*"
				args[:owner_list]    = ["master"]
                args[:authority]     = "修改"
				begin
					r << User_er.create_user(args)
					r << User_er.create_authority(args)
					r << Recu_er.create_hint_zone(args)
					new_br = System.start_new_browser_with_new_user(args)
					return "failed case #{@case_ID}" if new_br == "failed"
					old_br = ZDDI.browser
					ZDDI.browser = new_br
                    r << DNS.inputs_create_hint_zone_dialog(args)
                    args[:error_info] = "用户权限不足"
                    args[:error_type] = "after_OK"
                    r <<DNS.error_validator_on_popwin(args)
                    #修改设备节点
                    args[:old_owner_list] = "master"
                    args[:new_owner_list] = "master"
                    DNS.check_single_hint_zone(args, expected_fail=false)
                    DNS.popup_right_menu("modifyByMembers")
                    r <<DNS.error_validator_on_popwin(args)
                    DNS.popup_right_menu("del")
                    args[:error_info] = "default:用户权限不足"
                    r << DNS.error_validator_on_popwin(args)
					sleep 1
					# 恢复浏览器
					new_br.close
					ZDDI.browser = old_br
					r << Recu_er.del_hint_zone(args)
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_10866(args)
				#非admin账户 新建/编辑/删除本地策略用户权限不足
				@case_ID             = "10866"
				args[:user_name]     = "user" + @case_ID
				args[:password]      = "123Test"
				args[:re_password]   = "123Test"
				r = []
				args[:view_name]     = "default"
				args[:zone_name]     = "*"
				args[:owner_list]    = ["master"]
                args[:authority]     = "修改"
				begin
					r << User_er.create_user(args)
					r << User_er.create_authority(args)
					args[:domain_name] = "www.google.com"
					args[:ip]          = "192.168.1.1"
					r << Recu_er.create_local_policies(args)
					new_br = System.start_new_browser_with_new_user(args)
					return "failed case #{@case_ID}" if new_br == "failed"
					old_br = ZDDI.browser
					ZDDI.browser = new_br
                    r << DNS.inputs_local_policies_dialog(args)
                    args[:error_info] = "用户权限不足"
                    args[:error_type] = "after_OK"
                    r <<DNS.error_validator_on_popwin(args)
                    DNS.check_single_local_policies(args, expected_fail=false)
                    DNS.popup_right_menu("edit")
                    r <<DNS.error_validator_on_popwin(args)
                    DNS.popup_right_menu("del")
                    args[:error_info] = "#{args[:view_name]}/#{args[:domain_name]}:用户权限不足"
                    r << DNS.error_validator_on_popwin(args)
					sleep 1
					# 恢复浏览器
					new_br.close
					ZDDI.browser = old_br
					r << Recu_er.del_local_policies(args)
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_10867(args)
				#非admin账户 新建/编辑/删除缓存管理用户权限不足
				@case_ID             = "10867"
				args[:user_name]     = "user" + @case_ID
				args[:password]      = "123Test"
				args[:re_password]   = "123Test"
				r = []
				args[:view_name]     = "default"
				args[:zone_name]     = "*"
				args[:owner_list]    = ["master"]
                args[:authority]     = "修改"
				begin
					r << User_er.create_user(args)
					r << User_er.create_authority(args)
					new_br = System.start_new_browser_with_new_user(args)
					return "failed case #{@case_ID}" if new_br == "failed"
					old_br = ZDDI.browser
					ZDDI.browser = new_br
                    DNS.open_cache_manage_page
                    r << DNS.click_on_batch_clear_btn
                    args[:owner_list] = ["master"]
                    args[:error_info] = "用户权限不足"
                    args[:error_type] = "after_OK"
                    DNS.select_owner(args)
                    r <<DNS.error_validator_on_popwin(args)
                    nodeName = "master"
                    DNS.select_node(nodeName)
                    DNS.click_on_cache_set_btn
                    r << DNS.error_validator_on_popwin(args)
                    DNS.click_on_cache_clear_btn
                    r << DNS.error_validator_on_popwin(args)
					sleep 1
					# 恢复浏览器
					new_br.close
					ZDDI.browser = old_br
					r << User_er.del_user(args)        
                 rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1369(args)
			 #非admin账户成功编辑自己的用户信息
                @case_ID             = "1369"
				args[:user_name]     = "user" + @case_ID
				args[:password]      = "123Test"
				args[:re_password]   = "123Test"
				r = []
				begin
					r << User_er.create_user(args)
					new_br = System.start_new_browser_with_new_user(args)
					return "failed case #{@case_ID}" if new_br == "failed"
					old_br = ZDDI.browser
					ZDDI.browser = new_br
					r << System.open_system_page
					args[:surname]    = "rocky"
                    args[:mailbox]    = "zpf@knet.cn"
                    args[:mobile]     = "15211235678"
                    ele_names         = ["name","mailbox","phone"]
                    ele_values        = ["rocky1","zpf@knet.cn","15211235678"]
                    r << User_er.edit_user(args)
					r << System.check_on_single_user(args)
					r << DNS.popup_right_menu("edit")
					(0..2).each do |i| 
					  args[:ele_name]  = ele_names[i]
					  args[:ele_value] = ele_values[i]
					  r<< System.text_value_validator(args)
					end
					# 恢复浏览器
					new_br.close
					ZDDI.browser = old_br
					r << User_er.del_user(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1332(args)
				#非admin账户 新建/编辑/删除重定向权限不足
				@case_ID             = "1332"
				args[:user_name]     = "user" + @case_ID
				args[:password]      = "123Test"
				args[:re_password]   = "123Test"
				r = []
				args[:view_name]     = "default"
				args[:zone_name]     = "*"
				args[:owner_list]    = ["master"]
                args[:authority]     = "修改"
                args[:rname]         =  "www.1.com."
                args[:rtype]         =  "A"
                args[:rdata]         =  "1.1.1.1"
                args[:ttl]           =  "100"
				 begin
    				r << User_er.create_user(args)
					r << User_er.create_authority(args)
					r << Recu_er.create_redirect(args)
					new_br = System.start_new_browser_with_new_user(args)
					return "failed case #{@case_ID}" if new_br == "failed"
					old_br = ZDDI.browser
					ZDDI.browser = new_br
					DNS.open_redirect_page
                    r << DNS.inputs_redirect_dialog(args)
                    args[:error_info] = "用户权限不足"
                    args[:error_type] = "after_OK"
                    r << DNS.error_validator_on_popwin(args)
                    DNS.check_single_redirect(args)
                    DNS.popup_right_menu("edit")
                    r << DNS.error_validator_on_popwin(args)
                    DNS.popup_right_menu("del")
                    args[:error_info] = "#{args[:rname]} #{args[:rtype]} #{args[:rdata]}:用户权限不足"
                    r << DNS.error_validator_on_popwin(args)
					sleep 1
					# 恢复浏览器
					new_br.close
					ZDDI.browser = old_br
					args[:domain_list] = ["www.1.com"]
					r << Recu_er.del_redirect(args)
					r << User_er.del_user(args)        
    			 rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"	
			end
			def case_1331(args)
				#非admin账户 新建/编辑/删除转发区用户权限不足
				@case_ID             = "1331"
				args[:user_name]     = "user" + @case_ID
				args[:password]      = "123Test"
				args[:re_password]   = "123Test"
				r = []
				args[:view_name]     = "default"
				args[:zone_name]     = "*"
				args[:owner_list]    = ["master"]
                args[:authority]     = "只读"
				begin
					r << User_er.create_user(args)
					r << User_er.create_authority(args)
					args[:zone_name]     = "forward.com"
                    args[:forward_style] = "no"
					r << Recu_er.create_forward_zone(args)
					new_br = System.start_new_browser_with_new_user(args)
					return "failed case #{@case_ID}" if new_br == "failed"
					old_br = ZDDI.browser
					ZDDI.browser = new_br
                    r << DNS.inputs_forward_dialog(args)
                    args[:error_info] = "用户权限不足"
                    args[:error_type] = "after_OK"
                    r <<DNS.error_validator_on_popwin(args)
                    DNS.check_single_forward(args, expected_fail=false)
                    DNS.popup_right_menu("edit")
                    r <<DNS.error_validator_on_popwin(args)
                    DNS.popup_right_menu("del")
                    args[:error_info] = "#{args[:zone_name]}:用户权限不足"
                    r << DNS.error_validator_on_popwin(args)
					# 恢复浏览器
					new_br.close
					ZDDI.browser = old_br
					r << Recu_er.del_forward_zone(args)
					r << User_er.del_user(args)        
                 rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1330(args)
				#非admin账户 新建/编辑/删除存根区用户权限不足
				@case_ID             = "1330"
				args[:user_name]     = "user" + @case_ID
				args[:password]      = "123Test"
				args[:re_password]   = "123Test"
				r = []
				args[:view_name]     = "default"
				args[:zone_name]     = "*"
				args[:owner_list]    = ["master"]
                args[:authority]     = "只读"
				begin
					r << User_er.create_user(args)
					r << User_er.create_authority(args)
					args[:zone_name]          = "stub.com"
                    args[:stub_server_list]   = ["203.119.80.70"]
					r << Recu_er.create_stub_zone(args)
					new_br = System.start_new_browser_with_new_user(args)
					return "failed case #{@case_ID}" if new_br == "failed"
					old_br = ZDDI.browser
					ZDDI.browser = new_br
					DNS.open_dns_page
                    r << DNS.inputs_stub_dialog(args)
                    args[:error_info] = "用户权限不足"
                    args[:error_type] = "after_OK"
                    r <<DNS.error_validator_on_popwin(args)
                    DNS.check_single_stub(args, expected_fail=false)
                    DNS.popup_right_menu("edit")
                    r <<DNS.error_validator_on_popwin(args)
                    DNS.popup_right_menu("del")
                    args[:error_info] = "#{args[:zone_name]}:用户权限不足"
                    r << DNS.error_validator_on_popwin(args)
					# 恢复浏览器
					new_br.close
					ZDDI.browser = old_br
					r << Recu_er.del_stub_zone(args)
					r << User_er.del_user(args)        
                 rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1324(args)
				#非admin账户 新建/编辑/删除共享记录权限不足
				@case_ID             = "1324"
				args[:user_name]     = "user" + @case_ID
				args[:password]      = "123Test"
				args[:re_password]   = "123Test"
				r = []
				args[:view_name]     = "default"
				args[:zone_name]     = "*"
				args[:owner_list]    = ["master"]
                args[:authority]     = "只读"
				begin
					r << User_er.create_user(args)
					r << User_er.create_authority(args)
					args[:zone_name]  = "share"
					r << Zone_er.create_zone(args)
					args[:share_rr]   = {'rname'=>'a', 'rtype'=>'A', 'rdata'=>'1.1.1.1'}
					args[:share_rr_owner] = ["default/#{args[:zone_name]}"]
					r << Share_rr_er.create_share_rr(args)
					new_br = System.start_new_browser_with_new_user(args)
					return "failed case #{@case_ID}" if new_br == "failed"
					old_br = ZDDI.browser
					ZDDI.browser = new_br
					DNS.open_share_rr_page
					r << DNS.inputs_share_rr_dialog(args)
                    args[:error_info] = "用户权限不足"
                    args[:error_type] = "after_OK"
                    r <<DNS.error_validator_on_popwin(args)
                    DNS.check_on_single_share_rr(args, expected_fail=false)
                    DNS.popup_right_menu("edit")
                    r <<DNS.error_validator_on_popwin(args)
                    DNS.popup_right_menu("del")
                    args[:error_info] = "a A 1.1.1.1:用户权限不足"
                    r << DNS.error_validator_on_popwin(args)
					# 恢复浏览器
					new_br.close
					ZDDI.browser = old_br
					r << Share_rr_er.del_share_rr(args)
					r << Zone_er.del_zone(args)
					r << User_er.del_user(args)        
                 rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1319(args)
				#非admin账户 新建/编辑/删除访问控制权限不足
				@case_ID             = "1319"
				args[:user_name]     = "user" + @case_ID
				args[:password]      = "123Test"
				args[:re_password]   = "123Test"
				r = []
				args[:view_name]     = "default"
				args[:zone_name]     = "*"
				args[:owner_list]    = ["master"]
                args[:authority]     = "只读"
				begin
					r << User_er.create_user(args)
					r << User_er.create_authority(args)
                    args[:acl_name] = "acl_#{@case_ID}"
				    args[:acl_list] = ["192.168.1.1","192.168.2.1"]		
					r << ACL_er.create_acl(args)
					new_br = System.start_new_browser_with_new_user(args)
					return "failed case #{@case_ID}" if new_br == "failed"
					old_br = ZDDI.browser
					ZDDI.browser = new_br
					DNS.open_acl_page
                    DNS.inputs_create_acl_dialog(args)
                    args[:error_info] = "用户权限不足"
                    args[:error_type] = "after_OK"
                    r <<DNS.error_validator_on_popwin(args)
                    DNS.check_on_single_acl(args, expected_fail = false)
                    DNS.popup_right_menu("edit")
                    r <<DNS.error_validator_on_popwin(args)
                    DNS.popup_right_menu("del")
                    args[:error_info] = "#{args[:acl_name]}:用户权限不足"
                    r << DNS.error_validator_on_popwin(args)
					# 恢复浏览器
					new_br.close
					ZDDI.browser = old_br
				    r << ACL_er.del_acl(args)
					r << User_er.del_user(args)        
                 rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
            def case_1315(args)
				#非admin账户 新建/编辑/删除视图权限不足
				@case_ID             = "1330"
				args[:user_name]     = "user" + @case_ID
				args[:password]      = "123Test"
				args[:re_password]   = "123Test"
				r = []
				args[:view_name]     = "default"
				args[:zone_name]     = "*"
				args[:owner_list]    = ["master"]
                args[:authority]     = "修改"
				begin
					r << User_er.create_user(args)
					r << User_er.create_authority(args)
                    args[:view_name] = "view_#{@case_ID}"
					r << View_er.create_view(args)
					new_br = System.start_new_browser_with_new_user(args)
					return "failed case #{@case_ID}" if new_br == "failed"
					old_br = ZDDI.browser
					ZDDI.browser = new_br
					DNS.open_view_manage_page
                    DNS.inputs_create_view_dialog(args)
                    args[:error_info] = "用户权限不足"
                    args[:error_type] = "after_OK"
                    r <<DNS.error_validator_on_popwin(args)
                    DNS.check_on_single_view(args)
                    DNS.popup_right_menu("edit")
                    r <<DNS.error_validator_on_popwin(args)
                    DNS.popup_right_menu("del")
                    args[:error_info] = "#{args[:view_name]}:用户权限不足"
                    r << DNS.error_validator_on_popwin(args)
					# 恢复浏览器
					new_br.close
					ZDDI.browser = old_br
					r << View_er.del_view(args)
					r << User_er.del_user(args)        
                 rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1350(args)
				#查询权限存在
				@case_ID             = "1350"
				args[:user_name]     = "user" + @case_ID
				args[:password]      = "123Test"
				args[:re_password]   = "123Test"
				r = []
				args[:view_name]     = "default"
				args[:zone_name]     = "*"
				args[:owner_list]    = ["master"]
                args[:authority]     = "修改"
                search_names         =["#{args[:view_name]}","#{args[:zone_name]}","master","#{args[:authority]}"]
				begin
					r << User_er.create_user(args)
					r << User_er.create_authority(args)
					search_names.each do |search_name|
                    args[:search_name] = search_name
					r << DNS.search_name(args, search_ok=true)
				    end
					#r << User_er.del_user(args)        
                 rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1351(args)
				#查询权限不存在
				@case_ID             = "1351"
				args[:user_name]     = "user" + @case_ID
				args[:password]      = "123Test"
				args[:re_password]   = "123Test"
				r = []
				args[:view_name]     = "default"
				args[:zone_name]     = "*"
				args[:owner_list]    = [Master_Device]
                args[:authority]     = "修改"
                search_names         =["vv","slave","只读"]
				begin
					r << User_er.create_user(args)
					r << User_er.create_authority(args)
					sleep 5
					search_names.each do |search_name|
                    args[:search_name] = search_name
					r << DNS.search_name(args, search_ok=false)
				    end
					r << User_er.del_user(args)        
                 rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_6982(args)
				##非admin账户 -> 云中心，设备操作，用户权限不足
				@case_ID             = "6982"
				args[:user_name]     = "user" + @case_ID
				args[:password]      = "123Test"
				args[:re_password]   = "123Test"
				r = []
				args[:view_name]     = "default"
				args[:zone_name]     = "*"
				args[:owner_list]    = ["master"]
                args[:authority]     = "修改"
				begin
					r << User_er.create_user(args)
					r << User_er.create_authority(args)
                    new_br = System.start_new_browser_with_new_user(args)
					return "failed case #{@case_ID}" if new_br == "failed"
					old_br = ZDDI.browser
					ZDDI.browser = new_br
					#非admin尝试断开、编辑、删除节点
					args[:node_name] = Slave_Device
					r << Cloud.select_device(args)
					operations = ["disconnect","edit","del"]
					args[:error_info] = "用户权限不足"
                    args[:error_type] = "after_OK"
                    operations.each do |operation|
                    r << DNS.popup_right_menu("edit")
                    r <<DNS.error_validator_on_popwin(args)
                   end
                    #admin 先将其断开，然后非admin进行链接
                    ZDDI.browser = old_br
                    Cloud.disconnect_device(args)
                    ZDDI.browser = new_br
                    Cloud.select_device(args)
					DNS.popup_right_menu("connect")
                    r <<DNS.error_validator_on_popwin(args)
					# 恢复浏览器
					new_br.close
					ZDDI.browser = old_br
					r << Cloud.connect_device(args)
					r << User_er.del_user(args)        
                 rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end	
		end
	end
end