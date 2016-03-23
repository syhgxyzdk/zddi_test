# encoding: utf-8
require File.dirname(__FILE__) + '/dns'

module ZDDI
    module Cloud
        def self.open_cloud_page
            ZDDI.browser.link(:class, "cloud").click
            sleep 1
        end
        def self.show_node_as_map
            ZDDI.browser.div(:id, "toolsBar").button(:class, "showMap").click
            sleep 1
        end
        def self.show_node_as_list
            ZDDI.browser.div(:id, "toolsBar").button(:class, "showList").click
            sleep 1
        end
        def self.open_device_group(args)
            group_name = (args[:node_name] == Master_Device) ? Master_Group : Slave_Group
            Cloud.open_cloud_page
            ZDDI.browser.div(:id, "left").link(:title, group_name).click
            sleep 1
        end
        def self.open_device(args)
            open_device_group(args)
            ZDDI.browser.div(:id, "left").link(:title, args[:node_name]).double_click
            sleep 3
            return "succeed" if ZDDI.browser.div(:class, "nodeStatus").present?
            return "failed"
        end
        def self.select_device(args)
            open_device_group(args)
            ZDDI.browser.div(:id, "left").link(:title, args[:node_name]).click
            sleep 1
            return "succeed" if !ZDDI.browser.div(:class, "rightPart shortcut").button(:class, "edit").disabled?
            return "failed"
        end
        def self.add_device(args)
            Cloud.inputs_add_node_dialog(args)
            r = DNS.waiting_operate_finished ? 'fail' : 'succeed'
            puts "#{r} to add device #{args[:node_ip]}"
            sleep 30 # waiting for all services getting started normally.
            return r
        end
        def self.edit_device(args)
            select_device(args)
            # inputs of edit_device
        end
        def self.del_device(args)
            select_device(args)
            if !ZDDI.browser.div(:class, "rightPart shortcut").button(:class, "del").disabled?
                ZDDI.browser.div(:class, "rightPart shortcut").button(:class, "del").click
                r = DNS.waiting_operate_finished ? 'fail' : 'succeed'
                puts "#{r} to del device #{args[:node_name]}"
                sleep 30 # waiting for node deletion completed in background.
                return r
            else
                puts "fail to del device #{args[:node_name]} with disabled delete button"
                return "failed"
            end
        end
        def self.disconnect_device(args)
            select_device(args)
            if !ZDDI.browser.div(:class, "rightPart shortcut").button(:class, "disconnect").disabled?
                ZDDI.browser.div(:class, "rightPart shortcut").button(:class, "disconnect").click
                err = DNS.waiting_operate_finished
                return err if err
                sleep 3
                return "succeed"
            else
                return "failed"
            end
        end
        def self.connect_device(args)
            select_device(args)
            if !ZDDI.browser.div(:class, "rightPart shortcut").button(:class, "connect").disabled?
                ZDDI.browser.div(:class, "rightPart shortcut").button(:class, "connect").click
                err = DNS.waiting_operate_finished
                return err if err
                sleep 3
                return "succeed"
            else
                return "failed"
            end
        end
        def self.recovery_device(args)
            select_device(args)
            begin
                ZDDI.browser.div(:class, "rightPart shortcut").button(:class, "recovery").click
                err = DNS.waiting_operate_finished
                return err if err
                sleep 3
                return "succeed"
            rescue
                return "failed"
            end
        end
        def self.start_device_service(args, service_name = 'dns')
            open_device(args)
            server_id = 'dns_service_manage' if service_name == 'dns'
            server_id = 'ntp_service_manage' if service_name == 'ntp'
            begin
                ZDDI.browser.div(:class, "nodeStatus").tr(:id, server_id).i(:class, "btnRunning").click
                DNS.waiting_operate_finished
                return 'succeed'
            rescue
                if ZDDI.browser.div(:class, "nodeStatus").tr(:id, server_id).i(:class, "btnStop").present?
                    puts "#{service_name.upcase} server is running, no need to restart it"
                    return 'succeed'
                else
                    puts 'Not found either Stop_Button or Start_Button on ServiceManage Page...'
                    return 'fail'
                end
            end
        end
        def self.stop_device_service(args, service_name = 'dns')
            open_device(args)
            server_id = 'dns_service_manage' if service_name == 'dns'
            server_id = 'ntp_service_manage' if service_name == 'ntp'
            begin
                ZDDI.browser.div(:class, "nodeStatus").tr(:id, server_id).i(:class, "btnStop").click
                sleep 1
                r = DNS.waiting_operate_finished
                r ? 'failed' : 'succeed'
            rescue
                if ZDDI.browser.div(:class, "nodeStatus").tr(:id, server_id).i(:class, "btnRunning").present?
                    puts "#{service_name.upcase} server is stopped, no need to stop again"
                    return 'succeed'
                else
                    puts 'Not found either Stop_Button or Start_Button on ServiceManage Page...'
                    return 'fail'
                end
            end
        end
        def self.start_device_dns_service(args)
            start_device_service(args, 'dns')
        end
        def self.stop_device_dns_service(args)
            stop_device_service(args, 'dns')
        end
        def self.restart_device_dns_service(args)
            r = stop_device_dns_service(args)
            sleep 5
            r += start_device_dns_service(args)
            r.include?('failed') ? 'failed' : 'succeed'
        end
        def self.start_device_ntp_service(args)
            start_device_service(args, 'ntp')
        end
        def self.stop_device_ntp_service(args)
            stop_device_service(args, 'ntp')
        end
        def self.restart_device_ntp_service(args)
            r = stop_device_ntp_service(args)
            sleep 5
            r += start_device_ntp_service(args)
            r.include?('failed') ? 'failed' : 'succeed'
        end
        def self.open_device_dns_config_page(args)
            if open_device(args) == "succeed"
                ZDDI.browser.div(:class, "nodeStatus").link(:class, "dnsConfig").click
                sleep 1
                return "succeed" if ZDDI.browser.div(:id, "popWin").present?
                return "failed"
            else
                puts "open_device failed"
                return "failed"
            end
        end
        def self.inputs_dns_config_page(args)
            recur_enable   = args[:recursion_enable] # "yes" or "no"
            log_enable     = args[:log_enable]       # "yes" or "no"
            listen_port    = args[:listen_port]
            listen_ip      = args[:listen_ip]
            query_source   = args[:query_source]
            notify_source  = args[:notify_source]
            fail_forwarder = args[:fail_forwarder]
            if open_device_dns_config_page(args) == "succeed"
                DNS.popwin.radio(:name=>"recursion_enable", :value=>recur_enable).set if recur_enable
                DNS.popwin.radio(:name=>"log_enable", :value=>log_enable).set if log_enable
                DNS.popwin.text_field(:name=>"listen_port").set(listen_port) if listen_port
                DNS.popwin.text_area(:name=>"listen_ip").set(listen_ip) if listen_ip
                DNS.popwin.text_field(:name=>"query_source").set(query_source) if query_source
                DNS.popwin.text_field(:name=>"notify_source").set(notify_source) if notify_source
                DNS.popwin.text_field(:name=>"fail_forwarder").set(fail_forwarder) if fail_forwarder
                return "succeed"
            else
                return "failed"
            end
        end
        def self.inputs_add_node_dialog(args)
            node_name     = args[:node_name]
            node_ip       = args[:node_ip] ? args[:node_ip] : "192.168.1.1"
            node_username = args[:node_username] ? args[:node_username] : "zdns" 
            node_password = args[:node_password] ? args[:node_password] : "knetzdns" 
            Cloud.open_cloud_page
            DNS.popup_right_menu
            DNS.popwin.select(:name, "group").set(args[:select_group]) if args[:select_group]
            if args[:new_group_name]
                DNS.popwin.button(:class,"btnGray btnSelectGroup").click
                sleep 0.5
                DNS.popwin.text_field(:name, "groupname").set(args[:new_group_name])
            end
            DNS.popwin.text_field(:name, "name").set(node_name)
            DNS.popwin.text_field(:name, "ip").set(node_ip)
            DNS.popwin.text_field(:name, "username").set(node_username)
            DNS.popwin.text_field(:name, "password").set(node_password)
            DNS.popwin.checkbox(:name, "enable_auto").set if args[:node_is_backup]
        end
        def self.inputs_edit_node_dialog(args)
            node_name = args[:node_name]
            Cloud.open_cloud_page
            Cloud.show_node_as_list
            ZDDI.browser.div(:class, "baseTableDataWrap").div(:title, "#{Master_IP}").click
            DNS.popup_right_menu('edit')
            sleep 0.5
            DNS.popwin.text_field(:name, "name").set(node_name)
        end         
        def self.enable_dns_recursion(args)
            inputs_dns_config_page(args)
            err = DNS.waiting_operate_finished
            sleep 3 # waiting
            return err if err
            puts "succeed to enable_dns_recursion on #{args[:node_name]}"
            return "succeed" if !err
        end
        def self.disable_dns_recursion(args)
            inputs_dns_config_page(args)
            err = DNS.waiting_operate_finished
            sleep 3 # waiting
            return err if err
            puts "succeed to disable_dns_recursion on #{args[:node_name]}"
            return "succeed" if !err
        end
        def self.enable_dns_log(args)
            inputs_dns_config_page(args)
            err = DNS.waiting_operate_finished
            sleep 3 # waiting
            return err if err
            puts "succeed to enable_dns_log on #{args[:node_name]}"
            return "succeed" if !err
        end
        def self.disable_dns_log(args)
            inputs_dns_config_page(args)
            err = DNS.waiting_operate_finished
            sleep 3 # waiting
            return err if err
            puts "succeed to disable_dns_log on #{args[:node_name]}"
            return "succeed" if !err
        end
        def self.change_dns_listen_port(args)
            inputs_dns_config_page(args)
            err = DNS.waiting_operate_finished
            sleep 3 # waiting
            return err if err
            puts "succeed to change listen_port to \"#{args[:listen_port]}\" on #{args[:node_name]}"
            return "succeed" if !err
        end
        def self.change_dns_listen_ip(args)
            inputs_dns_config_page(args)
            err = DNS.waiting_operate_finished
            sleep 3 # waiting
            return err if err
            puts "succeed to change dns_listen_ip to \"#{args[:listen_ip]}\" on #{args[:node_name]}"
            return "succeed" if !err
        end
        def self.change_dns_query_source(args)
            inputs_dns_config_page(args)
            err = DNS.waiting_operate_finished
            sleep 3 # waiting
            return err if err
            puts "succeed to change dns_query_source to \"#{args[:query_source]}\" on #{args[:node_name]}"
            return "succeed" if !err
        end
        def self.change_dns_notify_source(args)
            inputs_dns_config_page(args)
            err = DNS.waiting_operate_finished
            sleep 3 # waiting
            return err if err
            puts "succeed to change dns_notify_source to \"#{args[:notify_source]}\" on #{args[:node_name]}"
            return "succeed" if !err
        end
        def self.change_dns_fail_forwarder(args)
            inputs_dns_config_page(args)
            err = DNS.waiting_operate_finished
            sleep 3 # waiting
            return err if err
            puts "succeed to change dns_fail_forwarder to \"#{args[:fail_forwarder]}\" on #{args[:node_name]}"
            return "succeed" if !err
        end
    end
end