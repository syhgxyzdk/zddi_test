# encoding: utf-8
require File.dirname(__FILE__) + '/dns'
module ZDDI
    module DNS
        ################   Open Access Control Pages   #####################
        def self.open_view_manage_page
            open_page_by_cls_name('views')
        end
        def self.goto_default_view_sortlist_page
            DNS.goto_sortlist_page(:view_name => 'default')
        end
        def self.goto_sortlist_page(args)
            DNS.open_view_manage_page
            DNS.check_on_single_view(args)
            DNS.popup_right_menu('sortlists')
            wait_for_page_present('sortlists')
        end
        def self.open_acl_page
            open_page_by_cls_name('acls')
        end
        def self.open_ip_rrls_page
            open_page_by_cls_name('ip-rrls')
        end
        def self.open_domain_rrls_page
            open_page_by_cls_name('domain-rrls')
        end
        def self.open_monitor_strategies_page
            open_page_by_cls_name('monitor_strategies')
        end
        def self.open_redirections_page
            open_page_by_cls_name('redirections')
        end
        ################   Inputs   #####################
        def self.inputs_ip_rrls_dialog(args)
            DNS.popup_right_menu
            DNS.popwin.text_field(:name, "network").set(args[:limit_ip])
            args[:owner_list].each do |owner|
                DNS.popwin.text_field(:value, "选择设备节点").set("clear")
                DNS.popwin.text_field(:value, "选择设备节点").set(owner)
                DNS.send_enter
            end
            DNS.popwin.text_field(:name, "rate_limit").set(args[:limit_qps])
        end
        def self.inputs_edit_ip_rrls_dialog(args)
            DNS.popup_right_menu('edit')
            DNS.popwin.text_field(:name, "rate_limit").set(args[:limit_qps])
        end
        def self.inputs_domain_rrls_dialog(args)
            DNS.popup_right_menu
            DNS.popwin.text_field(:name, "name").set(args[:limit_domain])
            DNS.popwin.select(:name, "view").select(args[:view_name])
            args[:owner_list].each do |owner|
                DNS.popwin.text_field(:value, "选择设备节点").set("clear")
                DNS.popwin.text_field(:value, "选择设备节点").set(owner)
                DNS.send_enter
            end
            DNS.popwin.text_field(:name, "rate_limit").set(args[:limit_qps])
        end
        def self.inputs_edit_domain_rrls_dialog(args)
            inputs_edit_ip_rrls_dialog(args)
        end
        def self.inputs_monitor_strategies_dialog(args)
            name          = args[:strategy_name]
            timeout       = args[:strategy_timeout]
            handle_method = args[:strategy_handle_method]
            interval      = args[:strategy_interval]
            retry_times   = args[:strategy_retry_times]
            detect_method = args[:strategy_detect_method] # ping/tcp/http/https
            port          = args[:strategy_port] # tcp/http/https 端口
            url           = args[:strategy_url]  # tcp/http/https 发送的URL
            DNS.popup_right_menu
            DNS.popwin.text_field(:name, 'name').set(name) if name
            DNS.popwin.select(:name, 'detect_method').select(detect_method) if detect_method
            DNS.popwin.text_field(:name, 'timeout').set(timeout) if timeout
            DNS.popwin.text_field(:name, 'interval').set(interval) if interval
            DNS.popwin.text_field(:name, 'retry_times').set(retry_times) if retry_times
            if port and DNS.popwin.text_field(:name, 'port').present?
                 DNS.popwin.text_field(:name, 'port').set(port)
            end
            if url and DNS.popwin.text_field(:name, 'url').present?
                 DNS.popwin.text_field(:name, 'url').set(url)
            end
            DNS.popwin.select(:name, 'handle_method').select(handle_method) if handle_method
        end
        def self.inputs_edit_monitor_strategies_dialog(args)
            timeout       = args[:strategy_timeout]
            handle_method = args[:strategy_handle_method]
            interval      = args[:strategy_interval]
            retry_times   = args[:strategy_retry_times]
            detect_method = args[:strategy_detect_method] # ping/tcp/http/https
            port          = args[:strategy_port] # tcp/http/https 端口
            url           = args[:strategy_url]  # tcp/http/https 发送的URL
            DNS.popup_right_menu('edit')
            DNS.popwin.select(:name, 'detect_method').select(detect_method) if detect_method
            DNS.popwin.text_field(:name, 'timeout').set(timeout) if timeout
            DNS.popwin.text_field(:name, 'interval').set(interval) if interval
            DNS.popwin.text_field(:name, 'retry_times').set(retry_times) if retry_times
            if port and DNS.popwin.text_field(:name, 'port').present?
                 DNS.popwin.text_field(:name, 'port').set(port)
            end
            if url and DNS.popwin.text_field(:name, 'url').present?
                 DNS.popwin.text_field(:name, 'url').set(url)
            end
            DNS.popwin.select(:name, 'handle_method').select(handle_method) if handle_method
        end
        def check_all_and_delete
            ZDDI.browser.checkbox(:class, "checkAll").set
            err = DNS.del_checked_item
            return err if err.include?("failed")
            return "succeed"
        end
        ################   Check Single Item   #####################
        def self.check_single_ip_rrls(args)
            box_value = args[:limit_ip].sub(/\//, "$")  # 1.2.3.0/24 => 1.2.3.0$24
            if ZDDI.browser.checkbox(:value, box_value).present?
                ZDDI.browser.checkbox(:value, box_value).set
                return "succeed"
            else
                return "failed"
            end
        end
        def self.check_single_domain_rrls(args)
            box_value = "#{args[:view_name]},#{args[:limit_domain]}"
            if ZDDI.browser.checkbox(:value, box_value).present?
                ZDDI.browser.checkbox(:value, box_value).set
                return "succeed"
            else
                return "failed"
            end
        end
        def self.check_single_monitor_strategies(args)
            box_value = "#{args[:strategy_name]}"
            if ZDDI.browser.checkbox(:value, box_value).present?
                ZDDI.browser.checkbox(:value, box_value).set
                return "succeed"
            else
                return "failed"
            end
        end
        def self.generate_dnsperf_script(args)
            begin
                script_file = args[:dnsperf_script_file]
                domain_list = args[:dnsperf_domain_list]
                to_ip       = args[:dnsperf_to_ip]
                data        = args[:dnsperf_data] ? args[:dnsperf_data] : 'tmp.txt'
                duration    = args[:dnsperf_duration] ? args[:dnsperf_duration] : '30'
                max_q       = args[:dnsperf_max_q] ? args[:dnsperf_max_q] : '100'
                conf        = ""
                conf << "# encoding: utf-8\n"
                conf << "foo = File.open(\"#{Dnsperf_Dir}#{data}\", 'w')\n"
                conf << "#{domain_list}.each do |domain|\n"
                conf << "    foo.puts(\"\#\{domain\} A\")\n"
                conf << "end\n"
                conf << "foo.close\n"
                conf << "qps_result = `cd #{Dnsperf_Dir} && ./dnsperf -s #{to_ip} -d #{data} -l #{duration} -Q #{max_q} -q 999999999 | grep \"Queries per second:\"`\n"
                conf << "qps = qps_result.split(\"\s\")[3]\n"
                conf << "`rm -f #{Dnsperf_Dir}#{data}`\n"
                conf << "puts qps\n"
                file = File.new(script_file, 'w')
                file.puts conf
                file.close
                return 'succeed'
            rescue
                return 'failed'
            end
        end
        def self.get_qps_after_rrls(args)
            from_ip      = args[:dnsperf_from_ip]
            to_ip        = args[:dnsperf_to_ip]
            script_name  = 'run_dnsperf.rb'
            local_file   = Upload_Dir + script_name
            remote_file  = Dnsperf_Dir + script_name
            node_index   = from_ip == Master_IP ? 0 : 1
            node_user    = Node_User_List[node_index]
            node_pwd     = Node_Pwd_List[node_index]
            qps          = '0'
            begin
                # 创建>>上传>>执行>>删除脚本
                args[:dnsperf_script_file] = local_file
                DNS.generate_dnsperf_script(args)
                Net::SSH.start(from_ip, node_user, :password=>node_pwd) do |ssh|
                    ssh.sftp.connect do |sftp|
                        sftp.upload!(local_file, remote_file)
                        ssh.exec!("killall dnsperf")
                        sleep 5  # 停止测试环境中可能的压力, 并暂停5s后执行dnsperf
                        qps = ssh.exec!("ruby #{Dnsperf_Dir}#{script_name}")
                        ssh.exec!("rm -f #{remote_file}")
                    end
                end
                puts "QPS from #{from_ip} to #{to_ip} -> #{qps}"
                return qps
            rescue
                puts "error at Net::SSH => #{from_ip}"
                return nil
            end
        end
        ################   访问控制   #####################
        class ACL_Manage
            ########## IP解析限速 ############
            def create_ip_rrls(args)
                DNS.open_ip_rrls_page
                DNS.inputs_ip_rrls_dialog(args)
                err = DNS.waiting_operate_finished
                puts "succeed to create ip_rrls" if !err
                return err if err
                return "succeed"
            end
            def edit_ip_rrls(args)
                DNS.open_ip_rrls_page
                DNS.check_single_ip_rrls(args)
                DNS.inputs_edit_ip_rrls_dialog(args)
                err = DNS.waiting_operate_finished
                puts "succeed to edit ip_rrls" if !err
                return err if err
                return "succeed"
            end
            def modify_ip_rrls_owner(args)
                DNS.open_ip_rrls_page
                DNS.check_single_ip_rrls(args)
                r = DNS.modify_member(args)                
                return r
            end
            def del_ip_rrls(args)
                DNS.open_ip_rrls_page
                DNS.check_single_ip_rrls(args)
                r = DNS.del_checked_item
                return "failed" if r.include?("failed")
                return "succeed"
            end
            def del_all_ip_rrls
                DNS.open_ip_rrls_page
                DNS.check_on_all
                err = DNS.del_checked_item
                return err if err
            end
            ########## 域名解析限速 ##########
            def create_domain_rrls(args)
                DNS.open_domain_rrls_page
                DNS.inputs_domain_rrls_dialog(args)
                err = DNS.waiting_operate_finished
                puts "succeed to create domain_rrls" if !err
                return err if err
                return "succeed"
            end
            def edit_domain_rrls(args)
                DNS.open_domain_rrls_page
                DNS.check_single_domain_rrls(args)
                DNS.inputs_edit_domain_rrls_dialog(args)
                sleep 10 # 等待编辑生效
                err = DNS.waiting_operate_finished
                puts "succeed to edit domain_rrls" if !err
                return err if err
                return "succeed"
            end
            def modify_domain_rrls_owner(args)
                DNS.open_domain_rrls_page
                DNS.check_single_domain_rrls(args)
                r = DNS.modify_member(args)                
                return r
            end
            def del_domain_rrls(args)
                DNS.open_domain_rrls_page
                DNS.check_single_domain_rrls(args)
                r = DNS.del_checked_item
                return "failed" if r.include?("failed")
                return "succeed"
            end
            def del_all_domain_rrls
                DNS.open_domain_rrls_page
                DNS.check_on_all
                err = DNS.del_checked_item
                return err if err
            end
            ########## 宕机切换 ############
            def create_monitor_strategy(args)
                DNS.open_monitor_strategies_page
                DNS.inputs_monitor_strategies_dialog(args)
                err = DNS.waiting_operate_finished
                return err if err
                r = DNS.check_single_monitor_strategies(args)
                puts "#{r} to create monitor_strategies"
                r.include?('fail') ? 'failed' : 'succeed'
            end
            def edit_monitor_strategy(args)
                dothis = 'to edit monitor_strategies'
                DNS.open_monitor_strategies_page
                DNS.check_single_monitor_strategies(args)
                DNS.inputs_edit_monitor_strategies_dialog(args)
                err = DNS.waiting_operate_finished
                if err
                    puts "fail #{dothis}"
                    return 'fail'
                else
                    puts "succeed #{dothis}"
                    return "succeed"
                end
            end
            def del_monitor_strategy(args)
                dothis = 'to del monitor_strategies'
                DNS.open_monitor_strategies_page
                DNS.check_single_monitor_strategies(args)
                r = DNS.del_checked_item
                if r.include?("fail")
                    puts "fail #{dothis}"
                    return 'fail'
                else
                    puts "succeed #{dothis}"
                    return "succeed"
                end
            end
        end
    end
end
