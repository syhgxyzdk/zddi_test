# encoding: utf-8
require File.dirname(__FILE__) + '/dns'
module ZDDI
    module System
        extend self
        ###############   open pages   ###############
        def self.open_system_page
            ZDDI.browser.link(:class, 'system').click
            sleep 1
        end
        def self.open_page_by_cls_name(cls_name)
            open_system_page
            ZDDI.browser.link(:class, cls_name).click
            sleep 1
        end
        def self.open_user_page
            open_page_by_cls_name('users')
            DNS.wait_for_page_present('users')
        end
        def self.open_audit_log_page
            open_page_by_cls_name('audit-logs')
            DNS.wait_for_page_present('audit-logs')
        end
        def self.open_mail_alarm
            open_page_by_cls_name('warning_configs')
        end
        def self.open_warning_threshold_settings_page
            open_page_by_cls_name('warning_threshold')
        end
        def self.open_warning_records_page
            open_page_by_cls_name('warning_records')
            DNS.wait_for_page_present('warning_records')
        end
        def self.open_query_log_page
            open_page_by_cls_name('query_logs')
        end
        def self.open_query_log_backup_page
            open_page_by_cls_name('query_backup_logs')
        end
        def self.open_data_backup_page
            open_page_by_cls_name('data_backup_logs')
            DNS.wait_for_page_present('data_backup_logs')
        end
        ###############   Search Something   ###############
        def self.elem_exists?(name)
            return DNS.elem_exists?(name)
        end
        ###############   Log validator   ###############
        def self.log_validator_on_audit_log_page(args)
            log = args[:log_string]
            open_audit_log_page
            begin # 记录太多时页面需要等待
                Timeout::timeout(30){
                    while !ZDDI.browser.div(:id=>"mainTable").div(:title=>log).present?
                        sleep 2
                    end
                    puts "succeed to validate --> #{log}"
                    return "succeed"
                }
            rescue Timeout::Error
                puts "failed to find --> #{log}"
                return "failed"
            end
        end
        ###############   Warning validator   ###############
        def self.warning_validator_on_warning_records_page(args)
            warning = args[:warning_string]
            open_warning_records_page
            begin 
                # 记录太多时页面需要等待
                Timeout::timeout(30){
                    while !ZDDI.browser.div(:id=>"mainTable").div(:title=>warning).present?
                        sleep 2
                    end
                    puts "succeed to get warning #{warning}"
                    return "succeed"
                }
            rescue Timeout::Error
                puts "failed to get warning #{warning}"
                return "failed"
            end
        end
        ###############   open backup dialog   ###############
        def self.open_schedule_data_backup_inputs_page
            open_data_backup_page
            DNS.popup_right_menu("schedule-backup")
            if DNS.popwin.select(:name, "enable_auto").value == "no"
               DNS.popwin.select(:name, "enable_auto").select("启用")
                sleep 0.5
            end
        end
        def self.open_manual_data_backup_inputs_page
            open_data_backup_page
            DNS.popup_right_menu("manual-backup")
        end
        def self.open_recovery_data_backup_inputs_page
            open_data_backup_page
            DNS.popup_right_menu("recovery-backup")
        end
        ###############   inputs on dialogs  ###############
        def self.inputs_create_user_dialog(args)
            DNS.popup_right_menu
            DNS.popwin.text_field(:name, "username").set(args[:user_name]) if args[:user_name]
            DNS.popwin.text_field(:name, "password").set(args[:password]) if args[:password]
            DNS.popwin.text_field(:name, "change_passwd").set(args[:re_password]) if args[:re_password]
            DNS.popwin.text_field(:name, "name").set(args[:surname]) if args[:surname]
            DNS.popwin.text_field(:name, "mailbox").set(args[:mailbox]) if args[:mailbox]
            DNS.popwin.text_field(:name, "phone").set(args[:mobile]) if args[:mobile]
        end
        def self.inputs_edit_user_dialog(args)
            DNS.popup_right_menu('edit')
            DNS.popwin.text_field(:name, "name").set(args[:surname]) if args[:surname]
            DNS.popwin.text_field(:name, "mailbox").set(args[:mailbox]) if args[:mailbox]
            DNS.popwin.text_field(:name, "phone").set(args[:mobile]) if args[:mobile]
        end
        def self.inputs_modify_password_dialog(args)
            DNS.popup_right_menu('pwd')
            DNS.popwin.text_field(:name, "old_password").set(args[:old_password]) if args[:old_password]
            DNS.popwin.text_field(:name, "password").set(args[:new_password]) if args[:new_password]
            DNS.popwin.text_field(:name, "change_password").set(args[:rpt_password]) if args[:rpt_password]
        end
        def self.inputs_create_authority_dialog(args)
            view_name = args[:view_name] if args[:view_name]
            zone_name = args[:zone_name] if args[:zone_name]
            authority = args[:authority] if args[:authority]
            DNS.popup_right_menu
            DNS.popwin.select(:name=>'view_name').select(view_name)
            DNS.popwin.select(:name=>'zone_name').select(zone_name)
            DNS.popwin.select(:name=>'priority').select(authority)
            # 选择所有节点 => '*'
            if args[:owner_list] == Node_Name_List
                # DNS.popwin.text_field(:value, "选择设备节点").set("clear")
                DNS.popwin.text_field(:value, "选择设备节点").set("ALL")
                DNS.send_enter
            else
                DNS.select_owner(args)
            end
        end
        def self.inputs_edit_authority_dialog(args)
            view_name = args[:view_name] if args[:view_name]
            zone_name = args[:zone_name] if args[:zone_name]
            authority = args[:authority] if args[:authority]
            DNS.popup_right_menu('edit')
            DNS.popwin.select(:name=>'view_name').select(view_name)
            DNS.popwin.select(:name=>'zone_name').select(zone_name)
            DNS.popwin.select(:name=>'priority').select(authority)
            # 选择所有节点 => '*'
            if args[:owner_list] == Node_Name_List
                # DNS.popwin.text_field(:value, "选择设备节点").set("clear")
                DNS.popwin.text_field(:value, "选择设备节点").set("ALL")
                DNS.send_enter
            else
                DNS.select_owner(args)
            end
        end
        def self.inputs_query_log_backup_settings_dialog(args)
            args[:backup_server]   = "192.168.1.1" if !args[:backup_server]
            args[:backup_dest]     = "/root/backup" if !args[:backup_dest]
            args[:owner_list]      = [Master_Device] if !args[:owner_list]
            args[:backup_account]  = "admin" if !args[:backup_account]
            args[:backup_password] = "password" if !args[:backup_password]
            args[:backup_size]     = "10" if !args[:backup_size]
            # System.open_query_log_backup_page
            # nodeName = args[:nodeName] ? args[:nodeName] : Master_Device
            # DNS.select_node(nodeName)
            # DNS.popup_right_menu('schedule-backup')
            goto_log_backup_configuration_page(args) #替代前边4行，需要验证
            DNS.popup_right_menu
            DNS.popwin.text_field(:name, "server").set(args[:backup_server])
            DNS.popwin.text_field(:name, "dest").set(args[:backup_dest])
            DNS.select_owner(args)
            DNS.popwin.select_list(:name, "method").select(args[:backup_method]) if args[:backup_method]
            DNS.popwin.text_field(:name, "account").set(args[:backup_account])
            DNS.popwin.text_field(:name, "password").set(args[:backup_password])
            DNS.popwin.text_field(:name, "size").set(args[:backup_size])
            DNS.popwin.checkbox(:name, "enable_auto").set if args[:enable_query_backup]
        end
        def self.inputs_edit_log_backup_settings_dialog(args)
            DNS.popup_right_menu("edit")
            DNS.popwin.select_list(:name, "method").select(args[:backup_method]) if args[:backup_method]
            DNS.popwin.text_field(:name, "account").set(args[:backup_account]) if args[:backup_account]
            DNS.popwin.text_field(:name, "password").set(args[:backup_password]) if args[:backup_password]
            DNS.popwin.text_field(:name, "size").set(args[:backup_size]) if args[:backup_size]
            if args[:enable_query_backup]
            DNS.popwin.checkbox(:name, "enable_auto").set
            else
               DNS.popwin.checkbox(:name, "enable_auto").clear 
            end 
        end

        def self.inputs_warning_threshold_settings_dialog(args)
            open_warning_threshold_settings_page
            DNS.popup_right_menu('warning-threshold-set')
            DNS.popwin.text_field(:name, "min_qps").set(args[:min_qps]) if args[:min_qps]
            DNS.popwin.text_field(:name, "max_qps").set(args[:max_qps]) if args[:max_qps]
            DNS.popwin.text_field(:name, "min_rate").set(args[:min_rate]) if args[:min_rate]
            DNS.popwin.text_field(:name, "max_rate").set(args[:max_rate]) if args[:max_rate]
            DNS.popwin.text_field(:name, "cpu_usage").set(args[:cpu_usage]) if args[:cpu_usage]
            DNS.popwin.text_field(:name, "cpu_temp").set(args[:cpu_temp]) if args[:cpu_temp]
            DNS.popwin.text_field(:name, "disk_usage").set(args[:disk_usage]) if args[:disk_usage]
            DNS.popwin.text_field(:name, "mem_usage").set(args[:mem_usage]) if args[:mem_usage]
            DNS.popwin.text_field(:name, "success_rate").set(args[:success_rate]) if args[:success_rate]
        end
        def self.inputs_mail_alarm_settings_dialog(args)
            # 预设字段, 防止出现多个"必须字段"字样
            args[:mail_server]  = "mail.smtp.com" if !args[:mail_server]
            args[:mail_account] = "admin" if !args[:mail_account]
            args[:mail_passwd]  = "password" if !args[:mail_passwd]
            args[:mail_list]    = "test@knet.com" if !args[:mail_list]
            open_mail_alarm
            DNS.popup_right_menu('email-warning-set')
            DNS.popwin.checkbox(:name,"enable_email").set
            DNS.popwin.checkbox(:name,"enable_verify").set
            DNS.popwin.text_field(:name,"server").set(args[:mail_server])
            DNS.popwin.text_field(:name,"port").set(args[:mail_port]) if args[:mail_port]
            DNS.popwin.text_field(:name,"account").set(args[:mail_account])
            DNS.popwin.text_field(:name,"passwd").set(args[:mail_passwd])
            DNS.popwin.textarea(:name,"emails").set(args[:mail_list])
        end
        def self.inputs_data_backup_settings_dialog(args)
            # 数据备份 -> 备份设置 / 手动备份 / 备份恢复的三个页面共享此方法
            args[:backup_server]   = "192.168.1.1" if !args[:backup_server]
            args[:backup_dest]     = "/root/backup" if !args[:backup_dest]
            args[:backup_src]      = "/root/backup" if !args[:backup_src]
            args[:backup_account]  = "admin" if !args[:backup_account]
            args[:backup_password] = "password" if !args[:backup_password]
            # 备份设置 -> 启用
            if DNS.popwin.select_list(:name, "enable_auto").present?
                DNS.popwin.select_list(:name, "enable_auto").select("启用")
            end
            # 备份设置 -> 备份方式
            if DNS.popwin.select_list(:name, "method").present?
                DNS.popwin.select_list(:name, "method").select(args[:backup_method]) if args[:backup_method]
            end
            # 服务器, 用户名, 密码
            DNS.popwin.text_field(:name, "server").set(args[:backup_server])
            DNS.popwin.text_field(:name, "account").set(args[:backup_account])
            DNS.popwin.text_field(:name, "password").set(args[:backup_password])
            # 路径 -> 备份 / 恢复
            if DNS.popwin.text_field(:name, "dest").present?
                DNS.popwin.text_field(:name, "dest").set(args[:backup_dest])
            end
            if DNS.popwin.text_field(:name, "src").present?
                DNS.popwin.text_field(:name, "src").set(args[:backup_src])
            end
            # 备份设置 -> 备份周期
            if DNS.popwin.select_list(:name, "reccurence").present?
                DNS.popwin.select_list(:name, "reccurence").select(args[:backup_reccurence]) if args[:backup_reccurence]
                DNS.popwin.select_list(:name, "week").select(args[:backup_week]) if args[:backup_week]
                DNS.popwin.select_list(:name, "time").select(args[:backup_time]) if args[:backup_time]
            end
        end
        ###############   check_on user / authority   ###############
        def self.check_on_single_log_backup(args, expected_fail=false)
            box_source = "#{args[:backup_server]}$xn--#{args[:backup_dest]}-"
            box_value  = Base64.encode64(box_source).gsub("\n","")
            return DNS.check_single_check_box(box_value, expected_fail)
        end
        ###############   check_on log backup         ###############
        def self.check_on_single_user(args, expected_fail=false)
            box_value = args[:user_name]
            return DNS.check_single_check_box(box_value, expected_fail)
        end
        ###############   check_on user's authority   ###############
        def self.check_on_single_authority(args, expected_fail=false)
            # box_value is 'view$zone$local.master$0'
            view        = args[:view_name]
            zone        = args[:zone_name]
            owner_list  = args[:owner_list]
            node        = "#{Master_Group}.#{Master_Device}" if owner_list == [Master_Device]
            node        = "#{Slave_Group}.#{Slave_Device}" if owner_list == [Slave_Device]
            node        = '*' if owner_list == Node_Name_List
            auth_head   = view + "$" + zone + "$" + node +"$"
            auth_select = auth_head + "0" if args[:authority] == "隐藏"
            auth_select = auth_head + "1" if args[:authority] == "只读"
            auth_select = auth_head + "2" if args[:authority] == "修改"
            box_value   = Base64.encode64(auth_select).gsub("\n","")
            return DNS.check_single_check_box(box_value, expected_fail)
        end
        ###############   goto user's authority page   ###############
        def self.goto_authority_page(args)
            System.open_user_page
            System.check_on_single_user(args)
            DNS.popup_right_menu('authorities')
            sleep 1
        end
        ###############   goto log backup configuration list page   ###############
        def self.goto_log_backup_configuration_page(args)
                System.open_query_log_backup_page
                nodeName = args[:nodeName] ? args[:nodeName] : Master_Device
                DNS.select_node(nodeName)
                DNS.popup_right_menu('schedule-backup')
            sleep 1
        end
        ###############   new users sign-up in new browser   ###############
        def self.login_with_new_user(args)
            begin
                login_new_user = start_new_browser_with_new_user(args)
                login_new_user.close
                return 'succeed'
            rescue
                return 'failed'
            end
        end
        def self.start_new_browser_with_new_user(args)
            site    = "https://#{Master_IP}/index"
            user    = args[:user_name]
            pwd     = args[:password]
            browser = Watir::Browser.new:chrome, :switches => %w[--start-maximized]
            browser.goto(site)
            browser.text_field(:name, "login").wait_until_present # 等待登录页面
            browser.text_field(:name, "login").set(user)
            browser.text_field(:name, "password").set(pwd)
            browser.send_keys("\r\n") # '回车'登录
            sleep 1
            browser.div(:class, "userInfo").link(:class, "logout").wait_until_present
            browser.window.maximize # 登录后最大化
            if browser.div(:class, "userInfo").link(:class, "logout").present?
                puts "succeed to login with #{user}/#{pwd}"
                return browser
            else
                puts "failed to login with #{user}/#{pwd}"
                return "failed"
            end
        end
        def self.start_new_browser_to_lock_user(args)
            site     = "https://#{Master_IP}/index"
            user     = args[:user_name]
            rand_num = rand(92553046)
            browser  = Watir::Browser.new:chrome, :switches => %w[--start-maximized]
            browser.goto(site)
            browser.text_field(:name, "login").wait_until_present # 等待登录页面
            6.times do |i|
                pwd = (rand_num + i).to_s
                browser.text_field(:name, "login").set(user)
                browser.text_field(:name, "password").set(pwd)
                browser.send_keys("\r\n")
            end
            r = (browser.div(:id=>'error').text == Lock_User_Msg) ? 'succeed' : 'fail'
            puts "#{r} to lock #{user}"
            browser.close
            r
        end
        def self.inputs_login_parameters(args)
            site    = "https://#{Master_IP}/index"
            user    = args[:user_name]
            pwd     = args[:password]
            browser = Watir::Browser.new:chrome, :switches => %w[--start-maximized]
            browser.goto(site)
            browser.text_field(:name, "login").wait_until_present # 等待登录页面
            browser.text_field(:name, "login").set(user)
            browser.text_field(:name, "password").set(pwd)
            browser.send_keys("\r\n") # '回车'登录
            sleep 1
            return browser 
        end
        def self.error_validator_on_page(expeted_error)
            #在单击确定之后，页面出现错误信息
            b1 = ZDDI.browser.label(:class=>"error").exists?
            b2 = ZDDI.browser.div(:class=>"error").exists?
             error_element=nil
             if b1
                error_element = ZDDI.browser.label(:class=>"error")
             elsif b2
                error_element = ZDDI.browser.div(:class=>"error")
             else
                 return "failed, error elemnt does not exists"
             end
             if error_element.text != expeted_error
                return "fail,the actual error is not same as expected"
            else
                return "succeed, the actual error is same as expected"
                
            end
        end
        def self.element_validator_on_page(args,expected=true)
             #验证页面中元素是否应该存在
             element_type  = args[:element_type] ? args[:element_type] : "text"
             element_value = args[:element_value] if args[:element_value]
             actual = nil
             case element_type
             when "text"
              actual = ZDDI.browser.text_field(:class=>"#{element_value}").exists?
             when "button"
              actual = ZDDI.browser.button(:class=>"#{element_value}").present?
             end
             if actual == expected
                puts   "element #{args[:element_type]}->#{args[:element_value]} validation is succeed"
                return "Succeed, actual result is equal to expected result"
             else
                puts   "element #{args[:element_type]}->#{args[:element_value]} validation is failed" 
                return "failed, actual result is not equal to expected result"
             end
        end
        def self.text_value_validator(args)
           #验证文本框中的数据
           text_ele      = DNS.popwin.text_field(:name, args[:ele_name]) if args[:ele_name]
           text_value    = text_ele.value
           if text_value == args[:ele_value]
             puts "succeed to validate #{args[:ele_name]}, actual value is #{args[:ele_value]}"
             return "succeed"
           else
             puts "failed to validate #{args[:ele_name]},actual value is #{text_value}"
             return "failed"
           end
        end
        ###############   用户权限验证   ###############
        def self.verify_authority_on_new_browser(args)
            r = []
            new_br = System.start_new_browser_with_new_user(args)
            return "fail" if new_br == "failed"
            old_br = ZDDI.browser
            ZDDI.browser = new_br
            begin
                case args[:authority]
                when "隐藏"
                    try_goto = DNS.goto_zone_page(args)
                    r << 'fail' if try_goto.include?("succeed")
                when "只读"
                    args[:error_info] = "用户权限不足"
                    args[:error_type] = "after_OK"
                    args[:rname]      = "readonly"
                    args[:rdata]      = "192.168.1.1" 
                    r << DNS.goto_zone_page(args)
                    DNS.popup_right_menu
                    DNS.popwin.text_field(:name, "name").set(args[:rname]) if args[:rname]
                    DNS.popwin.text_field(:name, "rdata").set(args[:rdata]) if args[:rdata]
                    r << DNS.error_validator_on_popwin(args)
                when "修改"
                    args[:rname] = "readwrite"
                    args[:rdata] = "192.168.1.1"
                    r << DNS.goto_zone_page(args)
                    DNS.popup_right_menu
                    DNS.popwin.text_field(:name, "name").set(args[:rname]) if args[:rname]
                    DNS.popwin.text_field(:name, "rdata").set(args[:rdata]) if args[:rdata]
                    r << DNS.waiting_operate_finished
                end
                puts "succeed to verify_authority_on_new_browser --> #{args[:authority]}"
            rescue
                puts "unknown error while verify_authority_on_new_browser"
                r << 'fail'
            ensure
                new_br.close
                ZDDI.browser = old_br
            end
            r.to_s.include?('fail') ? 'fail' : 'succeed'
        end
        ###############   用户管理组合操作   ###############
        class User
            def create_user(args)
                r = []
                r << System.open_user_page
                System.inputs_create_user_dialog(args)
                r << DNS.waiting_operate_finished
                r << System.check_on_single_user(args)
                puts "succeed to create user #{args[:user_name]}" if !r.to_s.include?('fail')
                r.to_s.include?('fail') ? 'fail' : 'succeed'
            end
            def edit_user(args)
                r = []
                System.open_user_page
                r << System.check_on_single_user(args)
                System.inputs_edit_user_dialog(args)
                r << DNS.waiting_operate_finished
                r << System.check_on_single_user(args)
                puts "succeed to edit user #{args[:user_name]}" if !r.to_s.include?('fail')
                r.to_s.include?('fail') ? 'fail' : 'succeed'
            end
            def modify_password(args)
                r = []
                System.open_user_page
                r << System.check_on_single_user(args)
                System.inputs_modify_password_dialog(args)
                r << DNS.waiting_operate_finished
                r << System.check_on_single_user(args)
                puts "succeed to modify password for #{args[:user_name]}" if !r.to_s.include?('fail')
                r.to_s.include?('fail') ? 'fail' : 'succeed'
            end
            def create_authority(args)
                r = []
                view = args[:view_name]
                zone = args[:zone_name]
                authority = args[:authority]
                System.goto_authority_page(args)
                System.inputs_create_authority_dialog(args)
                r = DNS.waiting_operate_finished ? 'fail' : 'succeed'
                puts "#{r} to create #{authority} for user #{args[:user_name]}"
                return r
            end
            def edit_authority(args)
                r = []
                r << System.goto_authority_page(args)
                args[:authority] = args[:authority_old]
                r << System.check_on_single_authority(args)
                args[:authority] = args[:authority_new]
                System.inputs_edit_authority_dialog(args)
                r << DNS.waiting_operate_finished
                #r << System.check_on_single_authority(args)
                puts "succeed to edit authority for user #{args[:user_name]}" if !r.to_s.include?('fail')
                r.to_s.include?('fail') ? 'fail' : 'succeed'
            end
            def edit_authority_and_verify_on_browser(args)
                r                  = []
                args[:password]    = "1qaz2WSX"
                args[:re_password] = "1qaz2WSX"
                args[:view_name]   = "authority#{args[:case_id]}"
                args[:zone_name]   = "authority#{args[:case_id]}"
                args[:owner_list]  = Node_Name_List
                begin
                    # 新建视图 + 区
                    r << View_er.create_view(args)
                    r << Zone_er.create_zone(args)
                    # 新建用户, 验证权限
                    r << create_user(args)
                    args[:authority] = args[:authority_old]
                    r << create_authority(args)
                    r << System.verify_authority_on_new_browser(args)
                    # 编辑 + 验证 authority_old => authority_new
                    r << edit_authority(args)
                    r << System.verify_authority_on_new_browser(args)
                    # 清理
                    r << View_er.del_view(args)
                    r << del_user(args)
                rescue
                    r << 'fail'
                end
                r.to_s.include?('fail') ? 'fail' : 'succeed'
            end
            def unlock_user(args)
                r = []
                r << System.open_user_page
                r << System.check_on_single_user(args)
                DNS.popup_right_menu('unlock')
                rs = DNS.waiting_operate_finished ? 'fail' : 'succeed'
                puts "#{rs} to unlock #{args[:user_name]}"
                r << rs
                r.to_s.include?('fail') ? 'fail' : 'succeed'
            end
            def del_authority(args)
                r = []
                r << System.goto_authority_page(args)
                r << DNS.check_on_elem_by_search(search_name = args[:authority])
                r << DNS.del_checked_item
                r.to_s.include?('fail') ? 'fail' : 'succeed'
            end
            def del_user(args)
                r = []
                r << System.open_user_page
                r << System.check_on_single_user(args)
                r << DNS.del_checked_item
                r.to_s.include?('fail') ? 'fail' : 'succeed'
            end
        end
        ###############   日志管理操作   ###############
        class Log
              def create_log_backup(args)
                r = []
                r << System.inputs_query_log_backup_settings_dialog(args)
                r << DNS.waiting_operate_finished
                r << System.check_on_single_log_backup(args)
                puts "succeed to create log backup #{args[:backup_server]}" if !r.to_s.include?('fail')
                r.to_s.include?('fail') ? 'fail' : 'succeed'
              end
              def edit_log_backup(args)
                  r = []
                  r << System.check_on_single_log_backup(args)
                  r << System.inputs_edit_log_backup_settings_dialog(args)
                  r << DNS.waiting_operate_finished
                  puts "succeed to edit log backup #{args[:backup_server]}" if !r.to_s.include?('fail')
                  r.to_s.include?('fail') ? 'fail' : 'succeed'
              end
              def del_single_log_backup(args)
                 r = []
                 r << System.check_on_single_log_backup(args)
                 r << DNS.del_checked_item
                 puts "succeed to delete log backup #{args[:backup_server]}" if !r.to_s.include?('fail')
                 r.to_s.include?('fail') ? 'fail' : 'succeed'
             end
             def modify_log_member(args)
                 r = []
                 System.check_on_single_log_backup(args)
                 r = DNS.modify_member(args)
                 return r
             end
        end
     end
end
