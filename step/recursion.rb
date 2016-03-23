# encoding: utf-8
require File.dirname(__FILE__) + '/dns'
module ZDDI
    module DNS
        ################    Open Recursion Pages    #####################
        def self.open_stub_zone_page
            open_page_by_cls_name('stub-zones')
        end
        def self.open_forward_zone_page
            open_page_by_cls_name('forward-zones')
        end
        def self.open_redirect_page
            open_page_by_cls_name('redirect-rrs')
        end
        def self.open_hint_zone_page
            open_page_by_cls_name('hint-zones')
        end
        def self.open_hint_zone_rr_page(args)
            view_name = args[:view_name]
            open_hint_zone_page
            ZDDI.browser.div(:id, "mainTable").div(:title, view_name).link(:class, "refs").click
            wait_for_page_present('hint_zone_rr')
        end
        def self.open_local_policies_page
            open_page_by_cls_name('local-policies')
        end
        def self.open_cache_manage_page
            open_dns_page
            ZDDI.browser.link(:class, 'cache-manage').click
            sleep 1
        end
        def self.open_query_source_page
            open_page_by_cls_name('query-source')
        end
        def self.open_query_source_monitor_page
            open_page_by_cls_name('query-source')
            DNS.popup_right_menu('monitorsetting')
            wait_for_page_present('monitorsetting')
        end
        ################     Inputs on 'New' Dialog   ###########
        def self.inputs_stub_dialog(args)
            zone_name = args[:zone_name]
            view_name = args[:view_name]
            DNS.open_stub_zone_page
            DNS.popup_right_menu
            DNS.popwin.text_field(:name, "name").set(zone_name)
            DNS.popwin.select_list(:name,"view").select(view_name)
            DNS.select_owner(args)
            args[:stub_server_list].each do |server|
                DNS.popwin.textarea(:name, "masters").append(server)
                DNS.send_newline
            end
        end
        def self.inputs_forward_dialog(args)
            zone_name     = args[:zone_name]
            view_name     = args[:view_name]
            forward_style = args[:forward_style]
            DNS.open_forward_zone_page
            DNS.popup_right_menu
            DNS.popwin.text_field(:name, "name").set(zone_name)
            DNS.popwin.select_list(:name,"view").select(view_name)
            DNS.popwin.select_list(:name,"forward_style").select(forward_style)
            DNS.select_owner(args)
            if forward_style != 'no'
                args[:forward_server_list].each do |server|
                    DNS.popwin.textarea(:name, "forwarders").append(server) if server != ''
                    DNS.send_newline if server != ''
                end
            end
        end
        def self.inputs_redirect_dialog(args)
            @view_name = args[:view_name] ? args[:view_name] : "default"
            @ttl       = args[:ttl] ? args[:ttl] : "3600"
            @rtype     = args[:rtype] ? args[:rtype] : "A"
            @rname     = args[:rname]
            @rdata     = args[:rdata]
            DNS.popup_right_menu
            DNS.popwin.select(:name, "view").select(@view_name)
            DNS.popwin.select(:name, "type").select(@rtype)
            DNS.popwin.text_field(:name, "name").set(@rname)
            DNS.popwin.text_field(:name, "ttl").set(@ttl)
            DNS.popwin.text_field(:name, "rdata").set(@rdata)
        end
        def self.inputs_redirect_edit_dialog(args)
            if !ZDDI.browser.button(:class, "edit").disabled?
                ZDDI.browser.button(:class, "edit").click
                DNS.popwin.text_field(:name, "ttl").set(args[:new_ttl])
                DNS.popwin.text_field(:name, "rdata").set(args[:new_rdata])
                return "succeed to input on redirect edit dialog"
            else
                return "failed to input on redirect edit dialog"
            end
        end
        def self.inputs_create_hint_zone_dialog(args)
            @view_name      = args[:view_name]
            @hint_file      = args[:hint_file]
            @owner_list     = args[:owner_list]
            @default_config = [". ns ns.", "ns. A 127.0.0.1"]
            @hint_config    = args[:hint_config] ? args[:hint_config] : @default_config              
            DNS.open_hint_zone_page
            DNS.popup_right_menu
            DNS.popwin.select_list(:name, "view").select(@view_name)
            DNS.select_owner(args)
            if @hint_file
                DNS.popwin.file_field(:name, "hint_file").click
                DNS.open_dialog(@hint_file)
            else
                @hint_config.each do |config|
                    DNS.popwin.textarea(:name, "zone_content").append(config) if config != ''
                    DNS.send_newline if config != ''
                end
            end
        end
        def self.inputs_import_hint_zone_rr_dialog(args)
            @rr_file = args[:hint_rr_file]
            @rr_list = args[:rr_list]
            DNS.popup_right_menu("batchCreate")
            DNS.popwin.file_field(:name, "zone_file").click if @rr_file
            DNS.open_dialog(@rr_file) if @rr_file
            @rr_list.each do |rr|
                DNS.popwin.textarea(:name, "zone_content").append(rr)
                DNS.send_newline
            end if @rr_list
        end
        def self.inputs_local_policies_dialog(args)
            DNS.open_local_policies_page
            DNS.popup_right_menu
            DNS.popwin.text_field(:name, "name").set(args[:domain_name])
            DNS.popwin.select(:name, "view").select(args[:view_name]) if args[:view_name]
            DNS.popwin.select(:name, "type").select(args[:local_type]) if args[:local_type]
            DNS.popwin.text_field(:name, "ttl").set(args[:ttl]) if DNS.popwin.text_field(:name, "ttl").present? and args[:ttl]
            DNS.popwin.text_field(:name, "ip").set(args[:ip]) if DNS.popwin.text_field(:name, "ip").present? and args[:ip]
            DNS.popwin.select(:name, "strategy").select(args[:strategy_name]) if args[:strategy_name] and DNS.popwin.select(:name, "strategy").present? and args[:strategy_name]
        end
        def self.inputs_cache_set_dialog(args)
            DNS.popwin.text_field(:name, "max_cache_ttl").set(args[:max_cache_ttl]) if args[:max_cache_ttl]
            DNS.popwin.text_field(:name, "max_ncache_ttl").set(args[:max_neg_cache_ttl]) if args[:max_neg_cache_ttl]
            DNS.popwin.text_field(:name, "max_cache_size").set(args[:max_cache_size]) if args[:max_cache_size]
        end
        def self.inputs_cache_clear_dialog(args)
            DNS.popwin.select(:name, "view_name").select(args[:view_name]) if args[:view_name]
            DNS.popwin.text_field(:name, "domain_name").set(args[:rname]) if args[:rname]
        end
        def self.inputs_cache_search_box(args)
            view_name = args[:view_name]
            rtype     = args[:rtype]
            domain    = args[:domain_name]
            ZDDI.browser.select(:name, 'view_name').select(view_name) if view_name
            ZDDI.browser.select(:name, 'type').select(rtype) if rtype
            ZDDI.browser.text_field(:name, 'domain_name').set(domain) if domain
        end
        def self.inputs_query_source_dialog(args)
            DNS.popup_right_menu
            view_name           = args[:view_name]
            query_source        = args[:query_source]
            query_source_owner  = args[:query_source_owner]
            query_source_backup = args[:query_source_backup] # this is a arrary as expected
            DNS.popwin.select(:name, "view").select(view_name) if view_name
            DNS.popwin.select(:name, "owner").select(query_source_owner) if query_source_owner
            DNS.popwin.text_field(:name, "query_source").set(query_source) if query_source
            query_source_backup.each do |backup_source|
                DNS.popwin.textarea(:name, "backup_query_sources").append(backup_source) 
                DNS.send_newline
            end if query_source_backup.respond_to?('each')
        end
        def self.inputs_edit_query_source_dialog(args)
            DNS.popup_right_menu('edit')
            query_source        = args[:query_source]
            query_source_backup = args[:query_source_backup] # this is a arrary as expected
            DNS.popwin.text_field(:name, "query_source").set(query_source) if query_source
            query_source_backup.each do |backup_source|
                DNS.popwin.textarea(:name, "backup_query_sources").append(backup_source) 
                DNS.send_newline
            end if query_source_backup.respond_to?('each')
        end
        def self.inputs_query_source_monitor_dialog(args)
            DNS.popup_right_menu
            query_source_owner = args[:query_source_owner]
            query_source       = args[:query_source]
            query_checkers     = args[:query_source_checkers]
            DNS.popwin.select(:name, "owner").select(query_source_owner) if query_source_owner
            DNS.popwin.text_field(:name, "query_source").set(query_source) if query_source
            query_checkers.each do |checker|
                DNS.popwin.textarea(:name, "query_source_checkers").append(checker) 
                DNS.send_newline
            end if query_checkers.respond_to?('each')           
        end
        def self.inputs_redirections_dialog(args)
            DNS.popup_right_menu
            view = args[:view_name]
            name = args[:redirections_name]
            url  = args[:redirections_url]
            DNS.popwin.select(:name, "view").select(view) if view
            DNS.popwin.text_field(:name, "name").set(name) if name
            DNS.popwin.text_field(:name, "redirect_url").set(url) if url
            DNS.select_owner(args)
        end
        def self.inputs_redirections_edit_dialog(args)
            DNS.popup_right_menu('edit')
            new_url = args[:redirections_new_url]
            DNS.popwin.text_field(:name, "redirect_url").set(new_url) if new_url
        end
        def self.inputs_redirections_batch_create_dialog(args)
            DNS.popup_right_menu('batchCreate')
            batch_inputs = args[:batch_inputs]
            batch_file = args[:imported_file]
            if batch_inputs
                DNS.popwin.textarea(:name, "redirect_content").set(batch_inputs)
            elsif batch_file
                DNS.popwin.file_field(:name, 'redirect_file').click
                DNS.open_dialog(batch_file)
            end
        end
        ################   Check on box   ################
        def self.check_single_check_box(box_value, expected_fail=false)
            begin
                ZDDI.browser.checkbox(:value, box_value).set
                expected_fail ? 'failed' : 'succeed'
            rescue
                puts "No checkbox found -> #{box_value}"
                expected_fail ? 'succeed' : 'failed'
            end
        end
        def self.check_single_stub(args, expected_fail=false)
            @view_name = SimpleIDN.to_ascii(args[:view_name]).gsub("\n","")
            if args[:zone_name] == '@' # 根区@会被sinpleIDN错误转码
                @zone_name = '@'
            else
                @zone_name = SimpleIDN.to_ascii(args[:zone_name]).gsub("\n","")
            end
            box_value  = "#{@view_name},#{@zone_name}"
            check_single_check_box(box_value, expected_fail)
        end
        def self.check_single_forward(args, expected_fail=false)
            check_single_stub(args, expected_fail)
        end
        def self.check_single_redirect(args, expected_fail=false)
            box_value = "default$#{args[:rname]}$#{args[:ttl]}$#{args[:rtype]}$#{Base64.encode64(args[:rdata])}".gsub("\n","")
            check_single_check_box(box_value, expected_fail)
        end
        def self.check_single_local_policies(args, expected_fail=false)
            @view_name = SimpleIDN.to_ascii(args[:view_name]).gsub("\n","")
            @rname     = SimpleIDN.to_ascii(args[:domain_name]).gsub("\n","")
            args[:local_type] ||= '重定向'
            if args[:local_type] == '重定向'
                @local_type = 'redirect'
                @ttl        = args[:ttl] ? args[:ttl] : '5'
                @ip         = args[:ip]
                box_value   = "#{@view_name}$#{@rname}$#{@local_type}$#{@ttl}$#{@ip}"
            else
                @local_type = 'nxdomain' if args[:local_type] == '无域名'
                @local_type = 'nodata' if args[:local_type] == '无记录'
                @local_type = 'passthru' if args[:local_type] == '白名单'
                box_value   = "#{@view_name}$#{@rname}$#{@local_type}"
            end
            check_single_check_box(box_value, expected_fail)
        end
        def self.check_single_hint_zone(args, expected_fail=false)
            box_value = SimpleIDN.to_ascii(args[:view_name]).gsub("\n","")
            check_single_check_box(box_value, expected_fail)
        end
        def self.check_single_hint_zone_rr(args, expected_fail=false)
            box_value = "#{args[:rname]}.$3600$#{args[:rtype]}$#{Base64.encode64(args[:rdata])}".gsub("\n","")
            check_single_check_box(box_value, expected_fail) 
        end
        def self.check_single_query_source(args, expected_fail=false)
            @group    = args[:query_source_owner] == "master" ? "local" : "slave"
            @box_name = "#{@group}.#{args[:query_source_owner]}$#{args[:view_name]}"
            box_value = "#{Base64.encode64(@box_name)}".gsub("\n","")
            check_single_check_box(box_value, expected_fail)
        end
        def self.check_single_query_source_monitor(args, expected_fail=false)
            @group    = args[:query_source_owner] == "master" ? "local" : "slave"
            @box_name = "#{@group}.#{args[:query_source_owner]}$#{args[:query_source]}"
            box_value = "#{Base64.encode64(@box_name)}".gsub("\n","")
            check_single_check_box(box_value, expected_fail)
        end
        def self.check_single_redirections(args, expected_fail=false)
            view = args[:view_name]
            name = args[:redirections_name]
            box_value = "#{view},#{name}"
            check_single_check_box(box_value, expected_fail) 
        end
        ###################   缓存管理   ###################
        def self.dig_all_node_to_make_cache(args)
            domain = args[:domain_name]
            rtype  = args[:rtype]
            r = []
            Node_IP_List.each do |ip|
                dig = `dig @#{ip} #{domain} #{rtype} +short`
                r << 'fail' if dig.to_s.include?("SERVFAIL")
                puts "dig @#{ip} #{domain} #{rtype} +short --> #{dig}"
            end
            r.empty? ? 'succeed' : 'failed'
        end
        def self.select_node_on_cache_manage(args)
            DNS.open_cache_manage_page
            nodeName = args[:nodeName]
            DNS.select_node(nodeName)
        end
        def self.click_on_cache_set_btn
            ZDDI.browser.div(:id, "toolsBar").button(:class, "cache-set").click
            sleep 0.5
        end
        def self.click_on_cache_clear_btn
            ZDDI.browser.div(:id, "toolsBar").button(:class, "cache-clear").click
            sleep 0.5
        end 
        def self.click_on_batch_clear_btn
            ZDDI.browser.div(:id, "toolsBar").button(:class, "batchClear").click
            sleep 0.5
        end
        def self.click_on_search_btn
            ZDDI.browser.div(:id, "search").button(:class, "searchBut").click
            sleep 3
        end
        def self.get_search_result_in_cache(args, result = true)
            # result means search result is null or not.
            node = args[:nodeName]
            view = args[:view_name]
            domain = args[:domain_name]
            cache_result = "Search cache #{node}/#{view}/#{domain} -->"
            begin
                r = ZDDI.browser.table(:class, "baseTable data").strings
            rescue
                r = []
            end
            puts "#{cache_result} no cache result" if r == []
            puts "#{cache_result} #{r}" if r != []
            if result
                r != [] ? 'succeed' : 'failed'
            else
                r == [] ? 'succeed' : 'failed'
            end
        end
        ###################   重定向后台检查   ###################
        def self.grep_redirect_record(args)
            @view_name         = args[:view_name]
            @keyword           = args[:rdata]
            @timeout           = 30
            failed_rlist       = []
            grep_zone_file_cmd = "grep \"#{@view_name}/redirect\" #{Named_Conf}"
            grep_pass          = ''
            grep_fail          = ''
            node_index_list    = get_node_index_list(args)
            node_index_list.each do |i|
                node_ip   = Node_IP_List[i]
                node_user = Node_User_List[i]
                node_pwd  = Node_Pwd_List[i]
                grep_rslt = "to grep redirect record #{@keyword} in named.conf of #{node_ip}"
                grep_pass = "succeed #{grep_rslt}"
                grep_fail = "failed #{grep_rslt}"
                begin
                    Net::SSH.start(node_ip, node_user, :password=>node_pwd) do |ssh|
                        grep_1st_time = ssh.exec!(grep_zone_file_cmd)
                        Timeout::timeout(@timeout) {
                            # 第一次grep就找到zone_file.
                            while grep_1st_time
                                @zone_file = grep_1st_time.split(' ')[1].delete('"').delete(';')
                                break
                            end
                            # 第一次grep未找到zone_file, try again.
                            while !grep_1st_time
                                sleep 5; grep_seq_time = ssh.exec!(grep_zone_file_cmd)
                                @zone_file = grep_seq_time.split(' ')[1].delete('"').delete(';')
                                break if grep_seq_time
                            end
                            # 在zone_file中grep record
                            grep_record_cmd  = "grep \"#{@keyword}\" #{@zone_file}"
                            @grep_record = ssh.exec!(grep_record_cmd) if @zone_file
                            puts grep_pass if @grep_record
                            failed_rlist << "failed" if !@grep_record
                        }
                    end
                rescue Timeout::Error
                    puts grep_fail
                    failed_rlist << "failed"
                rescue
                    puts "error at Net::SSH => #{node_ip}"
                    failed_rlist << "failed"
                end
            end
            failed_rlist.empty? ? grep_pass : grep_fail
        end
        ###################   URL转发后台数据库查询   ###################
        def self.generate_redirections_query_script(args)
            begin
                script_file = args[:redirections_query_script_file]
                conf        = ""
                conf << "require 'sqlite3'\n"
                conf << "redirect_db = '/usr/local/zddi/redirect.db'\n"
                conf << "r = \"\"\n"
                conf << "db = SQLite3::Database.new(redirect_db)\n"
                conf << "query_redirections_url = \"Select * From 'redirection'\"\n"
                conf << "db.execute(query_redirections_url) do |row|\n"
                conf << "    r << row.to_s\n"
                conf << "end\n"
                conf << "db.close\n"
                conf << "puts r\n"
                file = File.new(script_file, 'w')
                file.puts conf
                file.close
                return 'succeed'
            rescue
                return 'failed'
            end
        end
        def self.generate_file_for_redirections_importing(args)
            file = File.new(args[:imported_file], 'w')
            leng = args[:imported_lines].size
            args[:imported_lines].each_with_index do |line, index|
                file.write(line)
                file.write("\n") if index < leng - 1 # 最后一行无回车
            end
            file.close
            sleep 1
            file = IO.readlines(args[:imported_file])
            args[:imported_lines].any?{|line| file.to_s.include?(line)} ? 'succeed' : 'failed'
        end
        ###################   递归管理的方法   ###################
        class Recursion
            #################   基础操作   ######################
            def _create_zone(args, type)
                DNS.inputs_stub_dialog(args) if type == 'stub'
                DNS.inputs_forward_dialog(args) if type == 'forward'
                err = DNS.waiting_operate_finished
                return err if err
            end
            def _edit_zone(args, type)
                @stub_server_list    = args[:stub_server_list]
                @forward_server_list = args[:forward_server_list]
                @forward_style       = args[:forward_style]
                if type == 'stub'
                    DNS.open_stub_zone_page
                    DNS.check_single_stub(args)
                    DNS.popup_right_menu('edit')
                    DNS.popwin.textarea(:name, 'masters').clear
                    @stub_server_list.each do |server|
                        DNS.popwin.textarea(:name, 'masters').append(server)
                        DNS.send_newline
                    end
                elsif type == 'forward'
                    DNS.open_forward_zone_page
                    DNS.check_single_forward(args)
                    DNS.popup_right_menu('edit')
                    DNS.popwin.select_list(:name,'forward_style').select(@forward_style) if @forward_style
                    if @forward_style != 'no'
                        DNS.popwin.textarea(:name, "forwarders").clear
                        @forward_server_list.each do |server|
                            DNS.popwin.textarea(:name, "forwarders").append(server) if server != ''
                            DNS.send_newline if server != ''
                        end
                    end
                end
                err = DNS.waiting_operate_finished
                return err if err
            end
            def _check_zone(args, type)
                failed_rlist         = []
                @view_name           = args[:view_name]
                @zone_name           = args[:zone_name]
                @owner_list          = args[:owner_list]
                @stub_server_list    = args[:stub_server_list]
                @forward_server_list = args[:forward_server_list]
                @forward_style       = args[:forward_style]
                @all_owner           = @owner_list[0] if @owner_list.size == 1
                @all_owner           = @owner_list.join(', slave.') if @owner_list.size == 2
                check_result         = "to check #{type} zone \'#{@zone_name}\'"
                pass                 = "succeed #{check_result}"
                fail                 = "failed #{check_result}"
                DNS.context = DNS.get_cur_elem_string(@zone_name)
                failed_rlist << 'FAIL' if !DNS.context[0][1].include?(@view_name)
                failed_rlist << 'FAIL' if !DNS.context[0][2].include?(@zone_name)
                failed_rlist << 'FAIL' if !DNS.context[0][3].include?(@all_owner)
                if type == 'stub'
                    failed_rlist << 'FAIL' if !DNS.context[0][4].include?(@stub_server_list.join("#53, "))
                elsif type == 'forward'
                    failed_rlist << 'FAIL' if !DNS.context[0][5].include?(@forward_style)
                    if @forward_style != 'no'
                        failed_rlist << 'FAIL' if !DNS.context[0][4].include?(@forward_server_list.join("#53, "))
                    else
                        failed_rlist << 'FAIL' if DNS.context[0][4] != ''
                    end
                end
                puts pass if failed_rlist.empty?
                puts fail if !failed_rlist.empty?
                failed_rlist.empty? ? 'succeed' : 'failed'
            end
            def _del_zone(args, type)
                if type == "stub"
                    DNS.open_stub_zone_page
                    DNS.check_single_stub(args)
                elsif type == "forward"
                    DNS.open_forward_zone_page
                    DNS.check_single_forward(args)
                end
                del_result = DNS.del_checked_item
                if del_result == 'succeed'
                    puts "succeed to del #{type} #{args[:zone_name]}"
                    return 'succeed'
                else
                    puts "failed to del #{type} #{args[:zone_name]}"
                    return 'fail'
                end
            end
            def _del_all(type)
                DNS.open_stub_zone_page if type == 'stub'
                DNS.open_forward_zone_page if type == 'forward'
                DNS.open_redirect_page if type == 'redirect'
                DNS.open_hint_zone_page if type == 'hint_zone'
                DNS.open_local_policies_page if type == 'local_policies'
                DNS.open_query_source_page if type == 'query_source'
                DNS.open_redirections_page if type == 'redirections'
                DNS.check_on_all # 全选
                err = DNS.del_checked_item
                return err if err
            end
            def _compare_files(args)
                # expt_file = IO.readlines(args[:exported_file])
                # impt_file = IO.readlines(args[:imported_file])
                # 导出文件在windows默认为ASNI编码, 用IO.readlines读取出错
                # 需要二进制读取后再转码
                expt_lines = []
                impt_lines = []
                expt_rb = File.open(args[:exported_file], 'rb')
                impt_rb = File.open(args[:imported_file], 'rb')
                expt_rb.each_line { |line| expt_lines << line.force_encoding('utf-8') }
                impt_rb.each_line { |line| impt_lines << line.force_encoding('utf-8') }
                expt_rb.close
                impt_rb.close
                if (expt_lines - impt_lines).empty? and (impt_lines - expt_lines).empty? 
                    puts 'succeed to compare file ---> no diff'
                    return 'succeed'
                else
                    p '----------'
                    p expt_lines
                    p '----------'
                    p impt_lines
                    p '----------'
                    puts 'fail to compare file, diff string--->' + (expt_lines - impt_lines).to_s
                    return 'failed'
                end
            end
            #################   存根区常用操作   ######################
            def create_stub_zone(args)
                _create_zone(args, "stub")
                return _check_zone(args, "stub")
            end
            def edit_stub_zone(args)
                _edit_zone(args, "stub")
                return _check_zone(args, "stub")
            end
            def modify_stub_zone_member(args)
                DNS.open_stub_zone_page
                DNS.check_single_stub(args)
                r = DNS.modify_member(args)                
                return r
            end
            def del_stub_zone(args)
                return _del_zone(args, "stub")
            end
            def del_all_stub_zone
                _del_all('stub')
            end
            #################   转发区常用操作   ######################
            def create_forward_zone(args)
                _create_zone(args, "forward")
                return _check_zone(args, "forward")
            end
            def generate_forward_zone_file_for_importing(args)
                # args[:imported_file]
                # args[:imported_lines]
                r = DNS.generate_file_for_importing(args)
                puts "#{r} to generate_forward_zone_file_for_importing"
                return r
            end
            def import_forward_zone(args)
                DNS.open_forward_zone_page
                DNS.import_file(args)
            end
            def export_forward_zone(args)
                DNS.open_forward_zone_page
                DNS.popup_right_menu('export_')
                err = DNS.waiting_operate_finished
                sleep 3
                err ? err : 'succeed'
            end
            def compare_exported_forward_zone_file(args)
                _compare_files(args)
            end
            def edit_forward_zone(args)
                _edit_zone(args, "forward")
                return _check_zone(args, "forward")
            end
            def modify_forward_zone_member(args)
                DNS.open_forward_zone_page
                DNS.check_single_forward(args)
                r = DNS.modify_member(args)                
                return r
            end
            def del_forward_zone(args)
                return _del_zone(args, 'forward')
            end
            def del_all_forward_zone
                _del_all('forward')
            end
            #################   重定向常用操作   ######################
            def create_redirect(args)
                view_name = args[:view_name]
                rname     = args[:rname]
                rtype     = args[:rtype]
                ttl       = args[:ttl] ? args[:ttl] : '600'
                rdata     = args[:rdata]
                DNS.open_redirect_page
                DNS.popup_right_menu
                DNS.popwin.select_list(:name, "view").select(view_name) if view_name
                DNS.popwin.text_field(:name, "name").set(rname)
                DNS.popwin.select_list(:name, "type").select(rtype)
                DNS.popwin.text_field(:name, "ttl").set(ttl)
                DNS.popwin.text_field(:name, "rdata").set(rdata)
                err = DNS.waiting_operate_finished
                return err if err
                puts "succeed to create redirect #{view_name} #{rname} #{rtype} #{ttl} #{rdata}"
                return "succeed"
            end
            def edit_redirect(args)
                new_ttl   = args[:ttl_new]
                new_rdata = args[:rdata_new]
                begin
                    DNS.open_redirect_page
                    DNS.check_single_redirect(args)
                    DNS.popup_right_menu('edit')
                    DNS.popwin.text_field(:name, "ttl").set(new_ttl) if new_ttl
                    if new_rdata && DNS.popwin.text_field(:name, "rdata").present?
                       DNS.popwin.text_field(:name, "rdata").set(new_rdata)
                    end
                    err = DNS.waiting_operate_finished
                    return err if err
                    puts 'succeed to edit redirect...'
                    return 'succeed'
                rescue
                    puts 'failed to edit redirect...'
                    return 'failed'
                end
            end
            def edit_selected_redirect(args)
                new_ttl = args[:ttl_new]
                begin
                    DNS.popup_right_menu('edit')
                    DNS.popwin.text_field(:name, "ttl").set(new_ttl) if new_ttl
                    return 'failed' if DNS.popwin.text_field(:name, "rdata").present?
                    err = DNS.waiting_operate_finished
                    return err if err
                    puts 'succeed to batch edit redirect...'
                    return 'succeed'
                rescue
                    puts 'failed to batch edit redirect...'
                    return 'failed'
                end
            end
            def del_redirect(args)
                DNS.open_redirect_page
                domain_list = args[:domain_list]
                domain_list.each { |domain|
                    if DNS.domain_exists?(domain)
                        DNS.del_searched_elem
                    end
                }
                r = ""
                domain_list.each { |domain|
                    if !DNS.domain_exists?(domain)
                        r += "succeed to del redirect domain: #{domain}\n"
                    else
                        r += "failed to del redirect domain: #{domain}\n"
                    end
                }
                puts r
                return r
            end
            def check_all_redirect
                DNS.open_redirect_page
                DNS.check_on_all # a little redundance
            end
            def del_all_redirect
                _del_all('redirect')
            end
            def search_redirect(args)
                @keyword = args[:search_keyword]
                DNS.open_redirect_page
                DNS.search_elem(@keyword)
                r = DNS.get_cur_elem_string.to_s
                r.include?(@keyword) ? 'succeed' : 'failed'
            end
            #################   根配置常用操作   ######################
            def create_hint_zone(args)
                DNS.inputs_create_hint_zone_dialog(args)
                r = DNS.waiting_operate_finished ? 'fail' : 'succeed'
                puts "#{r} to create hint_zone for #{args[:view_name]}"
                r
            end
            def create_hint_zone_rr(args)
                r                = []
                create_rr        = "to create hint zone rr"
                @view_name       = args[:view_name]
                @domain_list     = args[:domain_list]
                @tmp_zone_name   = args[:zone_name]
                args[:zone_name] = '' # set zone_name to empty temporarily
                DNS.open_hint_zone_rr_page(args)
                @domain_list.each do |domain|
                    r << DNS.inputs_domain_dialog(domain)
                    r << DNS.waiting_operate_finished
                    args[:rname] = domain['rname']
                    args[:rtype] = domain['rtype']
                    args[:rdata] = domain['rdata']
                    args[:tll]   = domain['ttl']
                    r << DNS.check_on_single_domain(args, checkon=false)
                end
                args[:zone_name] = @tmp_zone_name # recovery zone_name
                puts r.to_s.include?('fail') ? "failed #{create_rr}" : "succeed #{create_rr}"
                r.to_s.include?('fail') ? "fail": "succeed"
            end
            def import_hint_zone_rr(args)
                DNS.open_hint_zone_rr_page(args)
                DNS.inputs_import_hint_zone_rr_dialog(args)
                r = DNS.waiting_operate_finished ? 'fail' : 'succeed'
                puts "#{r} to import rr for hint_zone of #{args[:view_name]}"
                r
            end
            def edit_hint_zone_rr(args)
                r = []
                DNS.open_hint_zone_rr_page(args)
                args[:domain_list].each do |domain|
                    args[:rname] = domain["rname"]
                    args[:rtype] = domain["rtype"]
                    args[:ttl]   = domain["ttl_old"] ? domain["ttl_old"] : domain["ttl"] 
                    args[:rdata] = domain["rdata_old"]
                    DNS.check_single_hint_zone_rr(args)
                    DNS.inputs_edit_domain_dialog(domain)
                    DNS.waiting_operate_finished
                    org_zone_name    = args[:zone_name]
                    args[:zone_name] = ''
                    args[:rdata]     = domain["rdata_new"]
                    args[:ttl]       = domain["ttl_new"] ? domain["ttl_new"] : domain["ttl"]
                    uchk_rr = DNS.uncheck_on_single_domain(args) # uncheck domain to verify edit
                    args[:zone_name] = org_zone_name
                    r << uchk_rr
                    puts "#{uchk_rr} to edit hint_zone_rr: #{domain}"
                end
                r.to_s.include?('fail') ? 'fail' : 'succeed'
            end
            def modify_hint_zone_member(args)
                @view_name = args[:view_name]
                @modify_hint_zone_member = "to modify_hint_zone_member #{args[:old_owner_list]} => #{args[:new_owner_list]}"
                DNS.open_hint_zone_page
                DNS.check_single_hint_zone(args)
                r = DNS.modify_member(args)
                puts "succeed #{@modify_hint_zone_member}" if r.include?("succeed")
                puts "failed #{@modify_hint_zone_member}" if r.include?("failed")
                r
            end
            def export_hint_zone(args)
                @view_name = args[:view_name]
                @export_hint_zone = "to export hint_zone:#{@view_name}"
                begin 
                    DNS.open_hint_zone_page
                    DNS.check_single_hint_zone(args)
                    DNS.export_checked_item
                    file_name = "#{@view_name}.txt"
                    args[:exported_file] = File.join(Download_Dir + file_name)
                    r = DNS.export_validator(args, delete=true)
                    puts "succeed #{@export_hint_zone}" if r.include?("succeed")
                    puts "failed #{@export_hint_zone}" if r.include?("failed")
                rescue
                    puts "FAIL => Error #{@view_name} to del hint_zone\n"
                end
                r
            end
            def del_hint_zone(args)
                view_name = args[:view_name]
                DNS.open_hint_zone_page                
                DNS.del_searched_elem if DNS.view_exists?(view_name)
                r = DNS.view_exists?(view_name) ? 'fail' : 'succeed'
                puts "#{r} to del hint_zone for #{view_name}"
                r
            end
            def del_all_hint_zone
                _del_all('hint_zone')
            end
            def del_hint_zone_rr(args)
                view_name   = args[:view_name]
                domain_list = args[:domain_list]
                DNS.open_hint_zone_rr_page
                begin
                    domain_list.each do |domain|
                        args[:rname] = domain["rname"]
                        args[:rtype] = domain["rtype"]
                        args[:rdata] = domain["rdata_old"]
                        args[:ttl]   = domain["ttl_old"] ? domain["ttl_old"] : domain["ttl"] 
                        DNS.check_single_hint_zone_rr(args)
                    end
                    r = DNS.del_checked_item
                    puts "succeed del_hint_zone_rr" if r.include?("succeed")
                    puts "failed del_hint_zone_rr" if r.include?("failed")
                rescue
                    puts "FAIL => del hint_zone_rr error!"
                    return "failed"
                end
            end
            #################   本地策略常用操作   ######################
            def create_local_policies(args)
                DNS.inputs_local_policies_dialog(args)
                err = DNS.waiting_operate_finished
                return err if err
                DNS.open_local_policies_page
                r = DNS.check_single_local_policies(args)
                puts "#{r} to create local_policies"
                r.include?('fail') ? 'fail' : 'succeed'
            end
            def edit_local_policies(args)
                @new_local_type = args[:new_local_type]
                @new_ttl        = args[:new_ttl]
                @new_ip         = args[:new_ip]
                domain          = args[:domain_name]
                DNS.open_local_policies_page
                DNS.check_on_elem_by_search(search_name = domain, checkon = true)
                DNS.popup_right_menu('edit')
                DNS.popwin.select(:name, "type").select(@new_local_type) if @new_local_type
                DNS.popwin.text_field(:name, "ttl").set(@new_ttl) if DNS.popwin.text_field(:name, "ttl").present? && @new_ttl
                DNS.popwin.text_field(:name, "ip").set(@new_ip) if DNS.popwin.text_field(:name, "ip").present? && @new_ip
                DNS.popwin.select(:name, "strategy").select(args[:strategy_name]) if args[:strategy_name] and DNS.popwin.select(:name, "strategy").present?
                return 'fail' if DNS.waiting_operate_finished
                return 'succeed'
            end
            def import_local_policies(args)
                DNS.open_local_policies_page
                DNS.import_file(args)
            end
            def export_local_policies(args)
                DNS.open_local_policies_page
                DNS.popup_right_menu('export_')
                err = DNS.waiting_operate_finished
                sleep 5
                err ? err : 'succeed'
            end
            def compare_exported_local_policies_file(args)
                _compare_files(args)
            end
            def generate_local_policies_file_for_importing(args)
                # args[:imported_file]
                # args[:imported_lines]
                r = DNS.generate_file_for_importing(args)
                puts "#{r} to generate_local_policies_file_for_importing"
                return r
            end
            def del_local_policies(args)
                domain = args[:domain_name]
                DNS.open_local_policies_page
                DNS.check_on_elem_by_search(search_name = domain, checkon = true)
                err = DNS.del_checked_item           
                return err if err
                return "succeed"
            end
            def del_all_local_policies
                _del_all('local_policies')
            end
            def search_local_policies(args)
                @search_keyword = args[:search_keyword]
                @match_keyword = args[:match_keyword]
                DNS.open_local_policies_page
                DNS.search_elem(@search_keyword)
                r = DNS.get_cur_elem_string
                r.to_s.include?(@match_keyword) ? 'succeed' : 'failed'
            end
            #################   缓存管理常用操作   ######################
            def del_all_cache_all_device(args)
                # 为避免此函数篡改原'args[:owner_list]'参数, 需要暂时保存为"@save_tmp_owner_list"
                @save_tmp_owner_list = args[:owner_list]
                args[:owner_list] = Node_Name_List
                DNS.open_cache_manage_page
                DNS.click_on_batch_clear_btn
                DNS.select_owner(args)
                err = DNS.waiting_operate_finished
                sleep 5
                args[:owner_list] = @save_tmp_owner_list
                return err if err
                return "succeed"
            end
            def del_cache_of_device(args)
                if DNS.select_node_on_cache_manage(args)
                    DNS.click_on_cache_clear_btn
                    err = DNS.waiting_operate_finished
                    sleep 5
                    return err if err
                    return "succeed"
                end
            end
            def del_cache_of_view(args)
                view_name = args[:view_name]
                if DNS.select_node_on_cache_manage(args)
                    DNS.click_on_cache_clear_btn
                    DNS.popwin.select(:name=>"view_name").select(view_name)
                    err = DNS.waiting_operate_finished
                    sleep 5
                    return err if err
                    return "succeed"
                end
            end
            def del_cache_of_domain(args)
                domain_name = args[:domain_name]
                view_name   = args[:view_name]
                if DNS.select_node_on_cache_manage(args)
                    DNS.click_on_cache_clear_btn
                    DNS.popwin.select(:name=>"view_name").select(view_name)
                    DNS.popwin.text_field(:name=>"domain_name").set(domain_name)
                    err = DNS.waiting_operate_finished
                    return err if err
                    return "succeed"
                end
            end
            def get_ttl_value(args)     # TTL
                ttl_list    = []
                server      = args[:node_ip]
                domain_name = args[:domain_name]
                rtype       = args[:rtype] ? args[:rtype] : "A"
                dig_rs      = `dig @#{server} #{domain_name} #{rtype} +noauthority +noadditional +noquestion`
                dig_rs_list = dig_rs.split("\n")
                dig_rs_list.each do |line|
                    if line =~ /^#{domain_name}/
                        # puts line
                        ttl = line.split("\s")[1]
                        ttl_list << ttl if ttl =~ /\d{1,5}/
                    end
                end
                if !ttl_list.empty?
                    puts "dig @#{server} #{domain_name} #{rtype} TTL => #{ttl_list[0]}" 
                    return ttl_list[0]
                else
                    puts "dig @#{server} #{domain_name} #{rtype} TTL failed!"
                    return "failed"
                end
            end
            def get_neg_ttl_value(args) # 否定TTL
                server      = args[:node_ip]
                domain_name = args[:domain_name]
                neg_line    = ";; AUTHORITY SECTION:"
                neg_ttl     = nil
                dig_rs      = `dig @#{server} #{domain_name} A +noadditional +noquestion`
                dig_rs_list = dig_rs.split("\n")
                dig_rs_list.each_with_index do |line, index|
                    if line =~ /^#{neg_line}/
                        neg_ttl = dig_rs_list[index + 1].split("\s")[1]
                    end
                end
                return neg_ttl if neg_ttl =~ /\d{1,5}/
                return "failed"
            end
            def change_cache_settings(args)
                # args[:max_cache_ttl]
                # args[:max_neg_cache_ttl]
                # args[:max_cache_size]
                DNS.select_node_on_cache_manage(args)
                DNS.click_on_cache_set_btn
                DNS.inputs_cache_set_dialog(args)
                err = DNS.waiting_operate_finished
                sleep 5
                return err if err
                return "succeed"
            end
            def set_ttl_to_5s(args)
                args[:max_cache_ttl]     = "5"
                args[:max_neg_cache_ttl] = "5"
                args[:max_cache_size]    = "0"
                failed_rlist = []
                Node_Name_List.each{|nodeName|
                    args[:nodeName] = nodeName
                    DNS.select_node_on_cache_manage(args)
                    DNS.click_on_cache_set_btn
                    DNS.inputs_cache_set_dialog(args)
                    err = DNS.waiting_operate_finished
                    failed_rlist << "failed" if err and err.include?("failed")
                }
                return "succeed" if failed_rlist.empty?
                return "failed"
            end
            def reset_cache_settings(args)
                args[:max_cache_ttl]     = "151200"
                args[:max_neg_cache_ttl] = "10800"
                args[:max_cache_size]    = "0"
                failed_rlist = []
                Node_Name_List.each{|nodeName|
                    args[:nodeName] = nodeName
                    DNS.select_node_on_cache_manage(args)
                    DNS.click_on_cache_set_btn
                    DNS.inputs_cache_set_dialog(args)
                    err = DNS.waiting_operate_finished
                    failed_rlist << "failed" if err and err.include?("failed")
                }
                return "succeed" if failed_rlist.empty?
                return "failed"
            end
            def search_domain_in_cache(args, result = true)
                view_name   = args[:view_name]
                rtype       = args[:rtype]
                domain_name = args[:domain_name]
                r = []
                r << DNS.select_node_on_cache_manage(args)
                r << DNS.inputs_cache_search_box(args)
                r << DNS.click_on_search_btn
                r << DNS.get_search_result_in_cache(args, result)
                r.to_s.include?('fail') ? 'failed' : 'succeed'
            end
            def del_searched_domain_from_cache
                begin
                    ZDDI.browser.div(:id=>'toolsBar').button(:class=>'del').click
                    DNS.waiting_operate_finished
                    puts 'succeed to delete domain in cache'
                    return 'succeed'
                rescue
                    puts 'Del buttion is disabled when deleting cache'
                    return 'failed'
                end
            end
            #################   请求源地址常用操作   ####################
            def create_query_source(args)
                DNS.open_query_source_page
                DNS.inputs_query_source_dialog(args)
                err = DNS.waiting_operate_finished
                if err
                    puts 'failed to create query source ...'
                    return err
                else
                    puts 'succeed to create query source ...'
                    return "succeed"
                end
            end
            def create_query_source_monitor(args)
                DNS.open_query_source_monitor_page
                DNS.inputs_query_source_monitor_dialog(args)
                err = DNS.waiting_operate_finished
                if err
                    puts 'failed to create query source monitor ...'
                    return err
                else
                    puts 'succeed to create query source monitor ...'
                    return "succeed"
                end
            end
            def edit_query_source(args)
                DNS.open_query_source_page
                DNS.check_single_query_source(args)
                DNS.inputs_edit_query_source_dialog(args)
                err = DNS.waiting_operate_finished
                if err
                    puts 'failed to edit query source ...'
                    return err
                else
                    puts 'succeed to edit query source ...'
                    return "succeed"
                end
            end
            def del_query_source(args)
                DNS.open_query_source_page
                DNS.check_single_query_source(args)
                r = DNS.del_checked_item
                puts "#{r} to del query source ..."
                return r
            end
            def del_all_query_source
                _del_all('query_source')
            end
            def del_query_source_monitor(args)
                DNS.open_query_source_monitor_page
                DNS.check_single_query_source_monitor(args)
                r = DNS.del_checked_item
                puts "#{r} to del query source monitor ..."
                return r
            end
            #################   URL转发常用操作   ####################
            def create_redirections(args)
                r = []
                name = args[:redirections_name]
                url = args[:redirections_url]
                DNS.open_redirections_page
                DNS.inputs_redirections_dialog(args)
                r << DNS.waiting_operate_finished
                DNS.open_redirections_page
                # 去除域名结尾的'.', 如果有的话.
                if name =~ /.*\.$/
                    puts 'remove the end -> . <- of redirections_name'
                    args[:redirections_name] = name.split('')[0..-2].join('')
                end
                r << DNS.check_single_redirections(args)
                result = r.to_s.include?('fail') ? 'fail' : 'succeed'
                puts "#{result} to create redirection #{name} -> #{url}"
                result
            end
            def generate_redirections_file_for_importing(args)
                # args[:imported_file]
                # args[:imported_lines]
                # 最后一行不能输入换行
                r = DNS.generate_file_for_importing(args)
                puts "#{r} to generate_forward_zone_file_for_importing"
                return r
            end
            def import_redirections(args)
                DNS.open_redirections_page
                DNS.inputs_redirections_batch_create_dialog(args)
                r = DNS.waiting_operate_finished
                return r
            end
            def export_redirections(args)
                DNS.open_redirections_page
                DNS.popup_right_menu('export_')
                err = DNS.waiting_operate_finished
                sleep 3
                err ? err : 'succeed'
            end
            def compare_exported_redirections_file(args)
                _compare_files(args)
            end
            def edit_redirections(args)
                r = []
                DNS.open_redirections_page
                r << DNS.check_single_redirections(args)
                DNS.popup_right_menu('edit')
                r << DNS.inputs_redirections_edit_dialog(args)
                r << DNS.waiting_operate_finished
                sleep 5
                r.to_s.include?('fail') ? 'failed' : 'succeed'
            end
            def modify_redirections_member(args)
                DNS.open_redirections_page
                DNS.check_single_redirections(args)
                r = DNS.modify_member(args)                
                return r
            end
            def del_redirections(args)
                r = []
                DNS.open_redirections_page
                r << DNS.check_single_redirections(args)
                r << DNS.del_checked_item
                r.to_s.include?('fail') ? 'failed' : 'succeed'
            end
            def del_all_redirections(args)
                _del_all('redirections')
            end
            def grep_nginx_with_redirections(args, nginx_enabled = true)
                r               = []
                @timeout        = 30
                grep_nginx      = 'netstat -nltp | grep 80 | grep nginx'
                node_index_list = DNS.get_node_index_list(args)
                node_index_list.each do |i|
                    node_ip   = Node_IP_List[i]
                    node_user = Node_User_List[i]
                    node_pwd  = Node_Pwd_List[i]
                    grep_rslt = "to grep nginx on #{node_ip}"
                    grep_pass = "succeed #{grep_rslt}"
                    grep_fail = "failed #{grep_rslt}"
                    begin
                        Net::SSH.start(node_ip, node_user, :password=>node_pwd) do |ssh|
                            grep_1st_time = ssh.exec!(grep_nginx)
                            Timeout::timeout(@timeout) {
                                # 期望nginx在80端口打开, 第一次grep已打开 => Pass
                                puts grep_pass if grep_1st_time and nginx_enabled
                                # 期望nginx在80端口关闭, 第一次grep为关闭 => Pass
                                puts grep_pass if !grep_1st_time and !nginx_enabled 
                                # 期望nginx在80端口打开, 第一次grep为关闭 => Retry
                                while nginx_enabled && !grep_1st_time
                                    sleep 5
                                    grep_seq_time = ssh.exec!(grep_nginx)
                                    puts grep_pass if grep_seq_time
                                    break if grep_seq_time
                                end
                                # 期望nginx在80端口关闭, 第一次grep为打开 => Retry
                                while !nginx_enabled && grep_1st_time 
                                    sleep 5
                                    grep_seq_time = ssh.exec!(grep_nginx)
                                    puts grep_pass if !grep_seq_time
                                    break if !grep_seq_time
                                end
                            }
                        end
                    rescue Timeout::Error
                        puts grep_fail
                        r << "failed"
                    rescue
                        puts "error at Net::SSH => #{node_ip}"
                        r << "failed"
                    end
                end
                r.to_s.include?('fail') ? 'failed' : 'succeed'
            end
            def query_redirections_db(args, data = true)
                r            = []
                name         = args[:redirections_name]
                url          = args[:redirections_url]
                script_name  = 'query_db_redirections.rb'
                query_script = "ruby /usr/local/zddi/#{script_name}"
                local_file   = Upload_Dir + script_name
                remote_file  = Node_DB_dir + script_name
                args[:redirections_query_script_file] = local_file
                node_index_list = DNS.get_node_index_list(args)
                r << DNS.generate_redirections_query_script(args)
                node_index_list.each do |i|
                    node_ip   = Node_IP_List[i]
                    node_user = Node_User_List[i]
                    node_pwd  = Node_Pwd_List[i]
                    # Upload and execute query script
                    Net::SSH.start(node_ip, node_user, :password=>node_pwd) do |ssh|
                        ssh.sftp.connect do |sftp|
                            begin
                                sftp.upload!(local_file, remote_file)
                                # 若查询结果含中文字符, 需要转码: ASCII-8BIT -> UTF-8
                                query_result = ssh.exec!("ruby #{remote_file}").force_encoding('utf-8')
                                if query_result.include?(name) && query_result.include?(url) && data
                                    r << 'succeed'
                                    puts "succeed to query redirections.db #{node_ip} --> #{query_result}"
                                elsif !query_result.include?(name) && !query_result.include?(url) && !data
                                    r << 'succeed'
                                    puts "succeed to query redirections.db #{node_ip} --> no query data"
                                else
                                    r << 'failed'
                                    puts "failed to query redirections.db #{node_ip} --> #{query_result}"
                                end
                                # Del script file after query done.
                                ssh.exec!("rm -f #{remote_file}")
                            rescue
                                puts "failed to query redirections.db on #{node_ip}"
                                r << 'failed'
                            end
                        end
                    end
                end
                r.to_s.include?('fail') ? 'fail' : 'succeed'
            end
            def search_redirections(args)
                @keyword = args[:search_keyword]
                DNS.open_redirections_page
                DNS.search_elem(@keyword)
                r = DNS.get_cur_elem_string.to_s
                r.include?(@keyword) ? 'succeed' : 'failed'
            end
        end
    end
end
