# encoding: utf-8
require File.dirname(__FILE__) + '/../../zddi'
module ZDDI
	module DNS
		class Redirections
			# URL 转发
			def case_19108(args)
				# 新建 -> 查询nginx端口 -> 查询数据库 -> 删除
				@case_ID                 = __method__.to_s.split('_')[1]
				r                        = []
				args[:view_name]         = 'default'
				args[:redirections_name] = "www.case_#{@case_ID}.com"
				args[:redirections_url]  = "https://192.168.19.108/home"
				args[:owner_list]        = Node_Name_List
				args[:log_string]        = '创建URL转发www.case_19108.com'
				begin
					# 新建后nginx端口打开, 数据库查询成功.
					r << Recu_er.create_redirections(args)
					r << Recu_er.grep_nginx_with_redirections(args, nginx_enabled = true)
					r << System.log_validator_on_audit_log_page(args)
					r << Recu_er.query_redirections_db(args, data = true)
					# 新建后nginx端口关闭, 数据库查询无数据.
					r << Recu_er.del_redirections(args)
					r << Recu_er.grep_nginx_with_redirections(args, nginx_enabled = false)
					r << Recu_er.query_redirections_db(args, data = false)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_19111(args)
				# 新建->编辑->删除.
				@case_ID                 = __method__.to_s.split('_')[1]
				r                        = []
				args[:view_name]         = 'default'
				args[:redirections_name] = "www.case_#{@case_ID}.com"
				args[:redirections_url]  = "https://192.168.19.111/home"
				args[:owner_list]        = Node_Name_List
				args[:log_string]        = '创建URL转发www.case_19111.com'
				begin
					# 新建, 查数据库
					r << Recu_er.create_redirections(args)
					r << Recu_er.query_redirections_db(args)
					# 编辑, 查数据库
					args[:redirections_new_url] = "https://192.168.19.111:8080/home"
					r << Recu_er.edit_redirections(args)
					args[:redirections_url] = args[:redirections_new_url]
					r << Recu_er.query_redirections_db(args)
					# 删除
					r << Recu_er.del_redirections(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_19115(args)
				# 导出
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:view_name]  = 'default'
				args[:owner_list] = Node_Name_List
				name_1            = 'domain_19115_1'
				name_2            = 'domain_19115_2'
				name_3            = 'domain_19115_3'
				url_1             = 'ftp://192.168.191.15:55/ftp'
				url_2             = 'http://192.168.191.15:505/http'
				url_3             = 'https://192.168.191.15:5050/https'
				begin
					# 新建 -> 导出 -> 比较
					{name_1=>url_1, name_2=>url_2, name_3=>url_3}.each_pair do |name, url|
						args[:redirections_name] = name
						args[:redirections_url] = url
						r << Recu_er.create_redirections(args)
					end
					r << Recu_er.export_redirections(args)
					nodes = "#{Master_Group}.#{Master_Device},#{Slave_Group}.#{Slave_Device}"
					prefix = "default domain_19115_"
					args[:imported_lines] = []
					args[:imported_lines] << "#{prefix}1 #{url_1} #{nodes} N/A"
					args[:imported_lines] << "#{prefix}2 #{url_2} #{nodes} N/A"
					args[:imported_lines] << "#{prefix}3 #{url_3} #{nodes} N/A"
					args[:imported_file] = Upload_Dir + 'redirections\19115.txt'
					r << DNS.generate_file_for_redirections_importing(args)
					args[:exported_file] = Download_Dir + 'redirections.txt'
					r << Recu_er.compare_exported_redirections_file(args)
					# 删除
					r << Recu_er.del_all_redirections(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_19107(args)
				# 参数检验
				@case_ID         = __method__.to_s.split('_')[1]
				r                = []
				args[:view_name] = 'default'
				begin
					r << DNS.open_redirections_page
					args[:error_type]        = 'before_OK'
					# '必选字段'
					args[:redirections_name] = nil
					args[:redirections_url]  = "https://192.168.12.34/home"
					args[:owner_list]        = Node_Name_List
					args[:error_info]        = '必选字段'
					r << DNS.inputs_redirections_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					# '域名格式不正确'
					args[:redirections_name] = "d@main Is* . !nlleg@l #!"
					args[:redirections_url]  = "https://192.168.12.34/home"
					args[:owner_list]        = Node_Name_List
					args[:error_info]        = '域名格式不正确'
					r << DNS.inputs_redirections_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					# '请输入合法的网址，请以http://,https://或ftp://开头'
					args[:redirections_name] = "www.case_#{@case_ID}.com"
					args[:redirections_url]  = "error_url"
					args[:owner_list]        = Node_Name_List
					args[:error_info]        = '请输入合法的网址，请以http://,https://或ftp://开头'
					r << DNS.inputs_redirections_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					# '至少选择一项'
					args[:redirections_name] = "www.case_#{@case_ID}.com"
					args[:redirections_url]  = "https://192.168.12.34/home"
					args[:owner_list]        = ['']
					args[:error_info]        = '至少选择一项'
					r << DNS.inputs_redirections_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					# 新建重复URL转发
					args[:view_name]         = 'default'
					args[:redirections_name] = "www.case_#{@case_ID}.com"
					args[:redirections_url]  = "https://192.168.12.34:8828/home.info"
					args[:owner_list]        = Node_Name_List
					args[:error_info] = "URL转发配置已存在"
					args[:error_type] = 'after_OK'
					r << Recu_er.create_redirections(args)
					r << DNS.open_redirections_page
					r << DNS.inputs_redirections_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					# 清理
					r << Recu_er.del_redirections(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_19112(args)
				# 修改节点
				@case_ID                 = __method__.to_s.split('_')[1]
				r                        = []
				args[:view_name]         = 'default'
				args[:redirections_name] = "www.case_#{@case_ID}.com"
				args[:redirections_url]  = "https://192.168.12.34/home"
				args[:owner_list]        = Node_Name_List
				args[:log_string]        = "创建URL转发#{args[:redirections_name]}"
				begin
					r << Recu_er.create_redirections(args)
					r << Recu_er.grep_nginx_with_redirections(args, nginx_enabled = true)
					r << System.log_validator_on_audit_log_page(args)
					args[:old_owner_list] = Node_Name_List
            		args[:new_owner_list] = [Master_Device]
					r << Recu_er.modify_redirections_member(args)
					args[:log_string] = "更新URL转发#{args[:redirections_name]}所属设备为#{Master_Group}.#{Master_Device}"
					r << System.log_validator_on_audit_log_page(args)
					# 验证修改节点后台生效
					args[:owner_list] = [Master_Device]
					r << Recu_er.grep_nginx_with_redirections(args, nginx_enabled = true)
					args[:owner_list] = [Slave_Device]
					r << Recu_er.grep_nginx_with_redirections(args, nginx_enabled = false)
					# 清理
					r << Recu_er.del_redirections(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_19190(args)
				# 批量添加参数校验
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:error_type] = 'after_OK'
				inputs_list = [
					'no_this_view wj.com http://popup_error.com local.master N/A', 
					'default wj.com not_a_url local.master N/A',
					'default wj.com http://popup_error.com no_this_node N/A'
				]
				inputs_with_error_info = {
					inputs_list[0] => "操作不存在的视图\n记录序列号:1\n资源记录:#{inputs_list[0]}", 
					inputs_list[1] => "非法的URL转发数据\n记录序列号:1\n资源记录:#{inputs_list[1]}",
					inputs_list[2] => "无法操作不存在的所属设备\n记录序列号:1\n资源记录:#{inputs_list[2]}"
				}
				begin
					DNS.open_redirections_page
					inputs_with_error_info.each_pair do |inputs, error_info|
						args[:batch_inputs] = inputs
                		DNS.inputs_redirections_batch_create_dialog(args)
                		args[:error_info] = error_info
						r << DNS.error_validator_on_popwin(args)
					end
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_19110(args)
				# 批量添加
				@case_ID = __method__.to_s.split('_')[1]
				r        = []
				inputs   = ""
				view     = 'default'
				name_1   = 'redirect.ftp'
				name_2   = 'redirect.http'
				name_3   = 'redirect.https'
				url_1    = 'ftp://192.168.19.110:191/ftp'
				url_2    = 'http://192.168.19.110:1911/http'
				url_3    = 'https://192.168.19.110:19110/https'
				node     = "#{Master_Group}.#{Master_Device},#{Slave_Group}.#{Slave_Device}"
				inputs << "#{view} #{name_1} #{url_1} #{node} N/A\n"
				inputs << "#{view} #{name_2} #{url_2} #{node} N/A\n"
				inputs << "#{view} #{name_3} #{url_3} #{node} N/A"
				args[:view_name] = view
				args[:batch_inputs] = inputs
				name_list = [name_1, name_2, name_3]
				begin
					r << Recu_er.import_redirections(args)
					name_list.each do |name|
						args[:redirections_name] = name
						r << DNS.check_single_redirections(args)
					end
					r << Recu_er.del_all_redirections(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_19255(args)
				# 导入, 含中文
				@case_ID   = __method__.to_s.split('_')[1]
				r          = []
				view_name  = '中文url转发视图'
				name_1     = 'domain_1'
				name_2     = 'domain_2'
				name_3     = 'domain_3'
				url_1      = 'ftp://192.168.192.55:55/ftp'
				url_2      = 'http://192.168.192.55:505/http'
				url_3      = 'https://192.168.192.55:5050/https'
				node       = "#{Master_Group}.#{Master_Device},#{Slave_Group}.#{Slave_Device}"
				view_punny = SimpleIDN.to_ascii(view_name).gsub("\n","")
				lines  = []
				lines << "#{view_punny} #{name_1} #{url_1} #{node} N/A"
				lines << "#{view_punny} #{name_2} #{url_2} #{node} N/A"
				lines << "#{view_punny} #{name_3} #{url_3} #{node} N/A"
				name_list = [name_1, name_2, name_3]
				begin
					# 创建中文视图
					args[:view_name]  = view_name
					args[:owner_list] = Node_Name_List
					r << View_er.create_view(args)
					# 导入
					args[:imported_file]  = Upload_Dir + 'redirections\19255.txt'
					args[:imported_lines] = lines
					r << DNS.generate_file_for_redirections_importing(args)
					r << Recu_er.import_redirections(args)
					# 验证
					name_list.each do |name|
						args[:view_name] = view_punny
						args[:redirections_name] = name
						r << DNS.check_single_redirections(args)
					end
					# 清理
					r << Recu_er.del_all_redirections(args)
					args[:view_name] = view_name
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_19114(args)
				# 搜索
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:view_name]  = 'default'
				args[:owner_list] = Node_Name_List
				name_1            = 'domain_19114_中文'
				name_2            = 'domain_19114_Eng'
				name_3            = 'domain_19114_3'
				url_1             = 'ftp://192.168.191.14:55/ftp'
				url_2             = 'http://192.168.191.14:505/http'
				url_3             = 'https://192.168.191.14:5050/https'
				begin
					# 新建 -> 导出 -> 比较
					{name_1=>url_1, name_2=>url_2, name_3=>url_3}.each_pair do |name, url|
						args[:redirections_name] = name
						args[:redirections_url] = url
						r << Recu_er.create_redirections(args)
					end
					# 搜索
					[name_1, name_2, name_3].each do |name|
						args[:search_keyword] = name
						r << Recu_er.search_redirections(args)
					end
					# 清理
					r << Recu_er.del_all_redirections(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_20233(args)
				# 视图联动删除
				@case_ID                 = __method__.to_s.split('_')[1]
				r                        = []
				args[:view_name]         = "view_#{@case_ID}"
				args[:owner_list]        = Node_Name_List
				args[:redirections_name] = "case.#{@case_ID}"
				args[:redirections_url]  = "http://192.168.202.33:303/http"
				begin
					# 新建视图 -> 新建URL转发 -> 删视图 -> 联动删除URL转发
					r << View_er.create_view(args)
					r << Recu_er.create_redirections(args)
					r << View_er.del_view(args)
					DNS.open_redirections_page
					r << DNS.check_single_redirections(args, expected_fail = true)
					# 数据库查询无数据, nginx端口关闭.
					r << Recu_er.query_redirections_db(args, data = false)
					r << Recu_er.grep_nginx_with_redirections(args, nginx_enabled = false)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_19221(args)
				# 选择节点过滤列表
				@case_ID         = __method__.to_s.split('_')[1]
				r                = []
				args[:view_name] = 'default'
				owner_list = [Node_Name_List, [Master_Device], [Slave_Device]]
				name_list  = ["case.#{@case_ID}.all", "case.#{@case_ID}.master", "case.#{@case_ID}.slave"]
				url_list   = ['ftp://192.168.1.1/all','ftp://192.168.1.1/master','ftp://192.168.1.1/slave']
				begin
					# 新建3个URL转发
					0.upto(2) do |i|
						args[:owner_list]        = owner_list[i]
						args[:redirections_name] = name_list[i]
						args[:redirections_url]  = url_list[i]
						r << Recu_er.create_redirections(args)
					end
					# 选Master节点, 列表自动过滤
					DNS.open_redirections_page
					r << DNS.select_node(Master_Device)
					[0, 1].each do |i|
						args[:redirections_name] = name_list[i]
						args[:redirections_url]  = url_list[i]
						r << DNS.check_single_redirections(args)
					end
					args[:redirections_name] = name_list[2]
					args[:redirections_url]  = url_list[2]
					r << DNS.check_single_redirections(args, expected_fail=true)
					# 选Slave节点, 列表自动过滤
					r << DNS.select_node(Slave_Device)
					[0, 2].each do |i|
						args[:redirections_name] = name_list[i]
						args[:redirections_url]  = url_list[i]
						r << DNS.check_single_redirections(args)
					end
					args[:redirections_name] = name_list[1]
					args[:redirections_url]  = url_list[1]
					r << DNS.check_single_redirections(args, expected_fail=true)
					# 选所有节点
					r << DNS.select_node('所有设备节点')
					[0, 1, 2].each do |i|
						args[:redirections_name] = name_list[i]
						args[:redirections_url]  = url_list[i]
						r << DNS.check_single_redirections(args)
					end
					# 清理
					r << Recu_er.del_all_redirections(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_19220(args)
				# 权限和视图绑定验证
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:view_name]   = 'default'
				args[:owner_list]  = Node_Name_List
				args[:user_name]   = "user" + @case_ID
				args[:password]    = "1qaz2WSX"
				args[:re_password] = "1qaz2WSX"
				authority_list     = [ "修改", "只读", "隐藏"]
				view_list = ['read_only', 'invisible']
				name_list = ["case.#{@case_ID}.edit", "case.#{@case_ID}.read", "case.#{@case_ID}.invisible"]
				url_list  = ['ftp://192.168.1.1/edit','ftp://192.168.1.2/read','ftp://192.168.1.2/invisible']
				begin
					# 新建2个额外视图, 3个URL转发
					view_list.each do |view|
						args[:view_name] = view
						r << View_er.create_view(args)
					end
					view_list = ['default', 'read_only', 'invisible']
					0.upto(2) do |i|
						args[:view_name] = view_list[i]
						args[:redirections_name] = name_list[i]
						args[:redirections_url]  = url_list[i]
						r << Recu_er.create_redirections(args)
					end
					# 新建用户 + 3个权限
					r << User_er.create_user(args)
					0.upto(2).each do |i|
						args[:authority] = authority_list[i]
				        args[:view_name] = view_list[i]
				        args[:zone_name] = "*"
						r << User_er.create_authority(args)
	            	end	
					# 新用户登录, 验证3个URL转发的权限
					new_br = System.start_new_browser_with_new_user(args)
					return "failed case #{@case_ID}" if new_br == "failed"
					old_br = ZDDI.browser
					ZDDI.browser = new_br
					# 修改default视图URL成功
					args[:view_name]         = view_list[0]
					args[:redirections_name] = name_list[0]
					r << Recu_er.edit_redirections(args)
					# 修改readonly视图URL失败.
					args[:view_name]         = view_list[1]
					args[:redirections_name] = name_list[1]
					args[:error_type] = "after_OK"
					args[:error_info] = "用户权限不足"
					DNS.open_redirections_page
					r << DNS.check_single_redirections(args)
					r << DNS.inputs_redirections_edit_dialog(args)
					r << DNS.error_validator_on_popwin(args)
					# invisible视图转发URL不可见.
					args[:view_name]         = view_list[2]
					args[:redirections_name] = name_list[2]
					r << DNS.check_single_redirections(args, expected_fail=true)
					# 清理
					new_br.close
					ZDDI.browser = old_br
					r << User_er.del_user(args)
					[1,2].each do |i|
						args[:view_name] = view_list[i]
						r << View_er.del_view(args)
					end
					r << Recu_er.del_all_redirections(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_22503(args)
				# 删除绝对域名 test.com. -> 成功!
				@case_ID                 = __method__.to_s.split('_')[1]
				r                        = []
				args[:view_name]         = 'default'
				args[:owner_list]        = Node_Name_List
				args[:redirections_name] = "domain.#{@case_ID}."
				args[:redirections_url]  = 'http://192.168.1.1:8088/url'
				begin
					r << Recu_er.create_redirections(args)
					r << Recu_er.del_redirections(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_22505(args)
				# 新建中文URL转发, 查询数据库 -> 正确转码
				@case_ID                 = __method__.to_s.split('_')[1]
				r                        = []
				args[:view_name]         = 'default'
				args[:redirections_name] = "中文.URL转发"
				args[:redirections_url]  = "https://192.168.225.5/home"
				args[:owner_list]        = Node_Name_List
				args[:log_string]        = "创建URL转发#{args[:redirections_name]}"
				begin
					r << Recu_er.create_redirections(args)
					r << Recu_er.grep_nginx_with_redirections(args, nginx_enabled = true)
					r << System.log_validator_on_audit_log_page(args)
					r << Recu_er.query_redirections_db(args, data = true)
					# 新建后nginx端口关闭, 数据库查询无数据.
					r << Recu_er.del_redirections(args)
					r << Recu_er.grep_nginx_with_redirections(args, nginx_enabled = false)
					r << Recu_er.query_redirections_db(args, data = false)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
		end
    end
end