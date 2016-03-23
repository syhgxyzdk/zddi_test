# encoding: utf-8
require File.dirname(__FILE__) + '/../zddi'

module ZDDI
    module DNS
        extend self
        attr_accessor :context
        ################    Wait for specified page loads completed   ##########
        def wait_for_page_present(cls_name)
            case cls_name
            when 'data-manage'
                page_title = '视图管理列表'
            when 'shared-zones'
                page_title = '共享区列表'
            when 'share_zone_rr' # customized class_name
                page_title = '共享区记录列表'
            when 'zone_list' # customized class_name
                page_title = '区列表'
            when 'rr_list'   # customized class_name
                page_title = '记录列表'
            when 'shared-rrs'
                page_title = '共享记录列表'
            when 'search'
                page_title = '全局搜索列表'
            when 'stub-zones'
                page_title = '存根区列表'
            when 'forward-zones'
                page_title = '转发区列表'
            when 'redirect-rrs'
                page_title = '重定向列表'
            when 'hint-zones'
                page_title = '根配置列表'
            when 'hint_zone_rr'
                page_title = '记录列表'
            when 'local-policies'
                page_title = '本地策略列表'
            when 'query-source'
                page_title = '请求源地址列表'
            when 'monitorsetting'
                page_title = '监测设置列表'
            when 'views'
                page_title = '视图管理列表'
            when 'sortlists' # customized class_name
                page_title = '记录排序列表'
            when 'acls'
                page_title = '访问控制列表'
            when 'ip-rrls'
                page_title = 'IP解析限速列表'
            when 'domain-rrls'
                page_title = '域名解析限速列表'
            when 'monitor_strategies'
                page_title = '策略列表'
            when 'redirections'
                page_title = 'URL转发列表'
            when 'users'
                page_title = '用户管理列表'
            when 'audit-logs'
                page_title = '操作日志列表'
            when 'warning_records'
                page_title = '告警记录'
            when 'data_backup_logs'
                page_title = '备份/恢复列表'
            end
            sleep 1
            begin
                page_open = Watir::Wait.until {ZDDI.browser.div(:id=>"tableTitle").span.text == page_title}
                return 'succeed' if page_open
            rescue
                # Watir::Wait.until 默认等待30s, 超时后报错.
                return 'fail'
            end
        end
        ################    Define Popwin and Toolbar Buttons   ################
        def self.popwin
            ZDDI.browser.div(:id, 'popWin')
        end
        def self.popup_right_menu(operation='create', select_first=false)
            ZDDI.browser.table(:index, 1).checkbox(:index, 0).set if select_first
            begin 
                ZDDI.browser.div(:id, "toolsBar").button(:class, operation).click
                sleep 1
                return 'succeed'
            rescue
                return 'failed'
            end
        end
        ################    Open DNS Authority Pages   ################
        def self.open_dns_page
            sleep 0.5
            ZDDI.browser.div(:id, "topMenus").link(:class=>"dns").click
            sleep 1
        end
        def self.open_default_view_page
            open_data_manage_page                
            ZDDI.browser.div(:id, "mainTable").div(:title, 'default').link(:class, "refs").click
            sleep 1
        end
        def self.open_page_by_cls_name(cls_name)
            open_dns_page
            ZDDI.browser.link(:class, cls_name).click
            wait_for_page_present(cls_name)
        end
        def self.open_data_manage_page
            open_page_by_cls_name('data-manage')
        end
        def self.open_share_zone_page
            open_page_by_cls_name('shared-zones')
        end
        def self.open_share_rr_page
            open_page_by_cls_name('shared-rrs')
        end
        def self.open_search_page
            open_page_by_cls_name('search')
        end
        ################     Goto Pages   ################
        def self.goto_view_page(args)
            view_name = args[:view_name]
            begin
                open_data_manage_page
                ZDDI.browser.div(:id, "mainTable").div(:title, view_name).link(:class, "refs").click
                wait_for_page_present('zone_list')
            rescue
                return "failed goto #{view_name}"
            end
        end
        def self.goto_zone_page(args)
            zone_name = args[:zone_name].downcase # 区名小写
            begin
                goto_view_page(args)
                ZDDI.browser.div(:id, "mainTable").div(:title, zone_name).link(:class, "refs").click
                wait_for_page_present('rr_list')
            rescue
                puts "failed goto #{zone_name}"
                return 'fail'
            end
        end
        def self.goto_share_zone_page(args)
            zone_name = args[:share_zone_name].downcase # 区名小写
            begin
                open_share_zone_page
                ZDDI.browser.div(:id, "mainTable").div(:title, zone_name).link(:class, "refs").click
                wait_for_page_present('share_zone_rr')
            rescue
                puts "failed goto share_zone: #{zone_name}"
                return 'fail'
            end
        end
        ################    Check on box   ################
        def self.check_on_all
            begin
                ZDDI.browser.div(:id, "mainTable").checkbox(:class, 'checkAll').set
                return 'succeed'
            rescue
                return 'failed'
            end
        end
        def self.check_on_single_acl(args, expected_fail = false)
            box_value = args[:acl_name]
            return check_single_check_box(box_value, expected_fail)
        end
        def self.check_on_single_view(args)
            # simpleide:中文名转punycode
            name_value = SimpleIDN.to_ascii(args[:view_name]).gsub("\n","")
            if ZDDI.browser.div(:id, "mainTable").checkbox(:value, name_value).present?
                ZDDI.browser.div(:id, "mainTable").checkbox(:value, name_value).set
                sleep 0.5
                return "succeed"
            else
                puts "Not found view: #{args[:view_name]}..."
                return "failed"
            end
        end
        def self.check_on_multiple_view(args)
            view_list    = args[:view_list] 
            failed_rlist = []
            DNS.open_view_manage_page
            view_list.each{|view_name|
                args[:view_name] = view_name
                r = check_on_single_view(args)
                failed_rlist << r if r and r.include?("failed")
            }
            return "succeed" if failed_rlist.empty?
            return "failed"
        end
        def self.check_on_single_sortlist(args)
            name_value = args[:sortlists_source_ip].sub('/','$')
            begin
                ZDDI.browser.div(:id, "mainTable").checkbox(:value, name_value).set
                return 'succeed'
            rescue
                puts "check_on sortlist failed, box_value: #{name_value}"
                return 'failed'
            end
        end
        def self.check_on_single_zone(args)
            # SimpleIDN:中文名转punycode
            name_value = SimpleIDN.to_ascii(args[:zone_name]).gsub("\n","")
            begin
                ZDDI.browser.div(:id, "mainTable").checkbox(:value, name_value).set
                return "succeed"
            rescue
                puts "Not found zone: #{args[:zone_name]}..."
                return "failed"
            end
        end
        def self.check_on_multiple_zone(args)
            zone_list = args[:zone_list]
            failed_rlist = []
            DNS.goto_zone_page(args)
            zone_list.each{|zone_name|
                args[:zone_name] = zone_name
                r = check_on_single_zone(args)
                failed_rlist << r if r and r.include?("failed")
            }
            return "succeed" if failed_rlist.empty?
            return "failed"
        end
        def self.check_on_single_domain(args, checkon=true, expected_fail=false)
            zone_name = args[:zone_name] == '@' ? '.' : args[:zone_name]
            dname     = (args[:rname] + '.' + zone_name).downcase
            rtype     = args[:rtype]
            ttl       = args[:ttl] ? args[:ttl] : "3600"
            # 分类处理rdata的特殊情况
            rdata     = args[:rdata]
            rdata     = rdata.upcase if rtype == 'AAAA'
            # rdata = "\"#{rdata}\"" if rtype == 'TXT' # txt记录的引号在AD版本已经去掉
            if (rtype == 'CNAME' || rtype == 'DNAME') &&  rdata.split('')[-1] != '.'
                rdata = "#{rdata}.#{zone_name}."
            end
            dname_code   = SimpleIDN.to_ascii(dname).gsub("\n","")
            rdata_code   = Base64.encode64(rdata).gsub("\n","")
            name_value   = dname_code + ".$" + ttl + "$" + rtype + "$" + rdata_code
            if ZDDI.browser.div(:id, "mainTable").checkbox(:value, name_value).present?
                ZDDI.browser.div(:id, "mainTable").checkbox(:value, name_value).set if checkon
                ZDDI.browser.div(:id, "mainTable").checkbox(:value, name_value).clear if !checkon
                expected_fail ? 'failed' : 'succeed'
            else
                puts "No domain found, checkbox -> #{name_value}"
                expected_fail ? 'succeed' : 'failed'
            end
        end
        def self.check_on_multiple_domain(args)
            domain_list  = args[:domain_list]
            zone_name    = args[:zone_name]
            failed_rlist = []
            domain_list.each do |domain|
                args[:rname] = domain[0]
                args[:rtype] = domain[1]
                args[:ttl]   = domain[2]
                args[:rdata] = domain[3]
                r = check_on_single_domain(args)
                failed_rlist << 'fail' if r and r.include?("fail")
            end
            return "succeed" if failed_rlist.empty?
            return "failed"
        end
        def self.uncheck_on_single_domain(args)
            dname      = args[:rname] + '.' + args[:zone_name]
            rtype      = args[:rtype]
            ttl        = args[:ttl] ? args[:ttl] : "3600"
            rdata      = args[:rdata]
            dname_code = SimpleIDN.to_ascii(dname).gsub("\n","")
            rdata_code = Base64.encode64(rdata).gsub("\n","")
            name_value = dname_code + ".$" + ttl + "$" + rtype + "$" + rdata_code
            if ZDDI.browser.div(:id, "mainTable").checkbox(:value, name_value).present?
                ZDDI.browser.div(:id, "mainTable").checkbox(:value, name_value).clear
                sleep 0.5
                return "succeed"
            else
                puts "No domain named: #{dname}"
                return "failed"
            end
        end
        def self.check_del_ptr_box
            begin
                DNS.popwin.checkbox(:name, 'link_ptr').set
                return 'succeed'
            rescue
                puts 'link ptr checked Failed'
                return 'failed'
            end
        end
        def self.check_on_single_share_zone(args, expected_fail=false)
            box_value  = SimpleIDN.to_ascii(args[:share_zone_name])
            check_single_check_box(box_value, expected_fail)
        end
        def self.check_on_single_share_zone_rr(args, checkon=true, expected_fail=false)
            args[:rname] = args[:share_zone_domain]['rname']
            args[:rtype] = args[:share_zone_domain]['rtype']
            args[:rdata] = args[:share_zone_domain]['rdata'] ? args[:share_zone_domain]['rdata'] : args[:share_zone_domain]['rdata_old']
            args[:ttl]   = args[:share_zone_domain]['ttl'] ? args[:share_zone_domain]['ttl'] : '3600'
            check_on_single_domain(args, checkon, expected_fail)
        end
        def self.check_on_single_share_rr(args, expected_fail=false)
            rr = args[:share_rr]
            rt = rr['rtype']
            tl = rr['ttl'] ? rr['ttl'] : '3600'
            rn = SimpleIDN.to_ascii(rr['rname'])
            rd = Base64.encode64(rr['rdata'])
            box_value = "#{rn}$#{tl}$#{rt}$#{rd}".gsub("\n","")
            check_single_check_box(box_value, expected_fail)
        end
        ################    反向区地址<->区名转换   ################
        def zone_name_to_arpa(args)
            @ip_name = args[:zone_name]
            if @ip_name =~ /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\/\d{1,2}\z/
                subnet = @ip_name.split('.') 
                mask = subnet[-1].split("/")[-1].to_i / 8
                prefix = subnet[0..mask-1].reverse.join(".")
                @arpa_name =  prefix + ".in-addr.arpa"
                puts "succeed to convert: #{@ip_name} to arpa: #{@arpa_name}"
                return @arpa_name
            elsif @ip_name =~ /^\w{1,4}:{1,2}\w{1,4}:{0,2}\w{0,10}\/{1}\d{1,3}\z/
                ipv6 = IPAddress::IPv6.expand(@ip_name.split('/')[0]).to_s
                mask = @ip_name.split('/')[1].to_i / 4 # 取掩码位, 4个增1个IPv6的16进制数
                prefix = ipv6.split(':').join('').split('')[0..mask-1].reverse.join('.')
                @arpa_name =  prefix + '.ip6.arpa'
                puts "succeed to convert: #{@ip_name} to arpa: #{@arpa_name}"
                return @arpa_name
            else
                puts "failed to convert: #{@ip_name} to arpa."
                return false
            end
        end
        ################    窗口输入   ################
        def self.inputs_create_acl_dialog(args)
            @acl_name = args[:acl_name]
            @acl_list = args[:acl_list]
            @acl_file = args[:acl_file]
            DNS.popup_right_menu
            DNS.popwin.text_field(:name, "name").set(@acl_name)
            if @acl_list
                @acl_list.each_with_index do |acl|
                    DNS.popwin.textarea(:name, "networks").append(acl)
                    DNS.send_newline
                end
            elsif @acl_file
                DNS.popwin.file_field(:id, "networksFile").click
                DNS.open_dialog(@acl_file)
            end
        end
        def self.inputs_edit_acl_dialog(args)
            @acl_list = args[:acl_list]
            @acl_file = args[:acl_file]
            DNS.popup_right_menu('edit')
            if @acl_list
                DNS.popwin.textarea(:name, "networks").clear
                @acl_list.each_with_index do |acl|
                    DNS.popwin.textarea(:name, "networks").append(acl)
                    DNS.send_newline
                end
            elsif @acl_file
                DNS.popwin.file_field(:id, "networksFile").click
                DNS.open_dialog(@acl_file)
            end
        end
        def self.inputs_create_view_dialog(args)
            @acl_name_list = args[:acl_name] ? [args[:acl_name]] : nil
            @view_name     = args[:view_name]
            @owner_list    = args[:owner_list]
            @ffwdr         = args[:fail_forwarder]
            @dns64_list    = args[:dns64_list]
            DNS.popup_right_menu
            # 先ACL, 后viewName, 最后选节点; 其他顺序有一定概率的互相干扰.
            if @acl_name_list
                DNS.popwin.select(:index, 1).select('选择访问控制')
                @acl_name_list.each do |acl|
                    DNS.popwin.text_field(:value, '选择访问控制以启用视图').set('clear')
                    DNS.popwin.text_field(:value, '选择访问控制以启用视图').set(acl)
                    DNS.send_enter
                end
            end 
            DNS.popwin.text_field(:name, 'name').set(@view_name) # 视图名,必选项
            DNS.select_owner(args)                               # 节点名,必选项
            # 失败转发
            DNS.popwin.text_field(:name, 'fail_forwarder').set(@ffwdr) if @ffwdr
            # DNS64
            if @dns64_list
                @dns64_list.each do |dns64|
                    DNS.popwin.textarea(:name, 'dns64s').append(dns64)
                    DNS.send_newline
                end
            end
        end
        def self.inputs_create_sortlist(args)
            DNS.popup_right_menu
            @source_ip    = args[:sortlists_source_ip]
            @prefered_ips = args[:sortlists_prefered_ips]
            DNS.popwin.text_field(:name, 'source_ip').set(@source_ip)
            @prefered_ips.each do |ip|
                DNS.popwin.textarea(:name, 'prefered_ips').append(ip)
                DNS.send_newline
            end
        end
        def self.inputs_create_zone_dialog(args)
            @zone_name       = args[:zone_name]
            @zone_type       = args[:zone_type]            # 正向区/反向区
            @server_type     = args[:server_type]          # 主区/辅区
            @renewal         = args[:renewal]              # 辅区续期
            @master_server   = args[:master_server]        # 主服务器地址
            @slave_server    = args[:slave_server]         # 辅服务器地址
            @owner_list      = args[:owner_list]           # 所属节点
            @ttl             = args[:ttl]
            @source_type     = args[:source_type]          # 数据来源:file/copy/transfer
            @zone_file_name  = args[:zone_file_name]       # 区文件之文件名
            @zone_copy_name  = args[:zone_copy_name]       # 区拷贝之区名字
            @transfer_server = args[:zone_transfer_server] # 区传送之服务器
            @enable_ad       = args[:enable_ad]            # 是否启用AD控制器
            @ad_list         = args[:acl_name] ? [args[:acl_name]] : nil    # AD控制器
            DNS.popup_right_menu
            # 正/反向区选择
            if @zone_type == 'in-addr'
                DNS.popwin.select(:name, 'type').select('反向区')
                DNS.popwin.text_field(:name, 'network').set(@zone_name)
            else
                DNS.popwin.text_field(:name, 'name').set(@zone_name)
            end
            # 主辅区选择和输入
            if @server_type == 'slave'
                DNS.popwin.select(:name, 'server_type').select('辅区')
                DNS.popwin.textarea(:name, 'masters').set(@master_server) if @master_server
            else
                DNS.popwin.textarea(:name, 'slaves').set(@slave_server) if @slave_server
            end
            # 节点选择
            DNS.select_owner(args)
            # TTL
            DNS.popwin.text_field(:name, 'default_ttl').set(@ttl) if @ttl
            # AD控制器 (default视图专属)
            if DNS.popwin.text_field(:value, '选择访问控制').present? and @enable_ad
                @ad_list.each do |acl|
                    DNS.popwin.text_field(:value, '选择访问控制').set('clear')
                    DNS.popwin.text_field(:value, '选择访问控制').set(acl)
                    DNS.send_enter
                end
            end
            # 区数据来源
            DNS.popwin.radio(:value, @source_type).set if @source_type
            # 区文件
            if @source_type == 'zone_file'
                DNS.popwin.file_field(:name, 'zone_file').click
                r = DNS.open_dialog(@zone_file_name)
                failed_rlist << r if r and r.include?('failed')
            end
            # 区拷贝
            DNS.popwin.select(:name, 'view_and_zone').select(@zone_copy_name) if @source_type == 'zone_copy'
            # 区传送
            DNS.popwin.text_field(:name, 'zone_owner_server').set(@transfer_server) if @source_type == 'zone_transfer'
            # 辅区续期
            DNS.popwin.checkbox(:name, 'renewal').set if @server_type == 'slave' && @renewal
        end
        def self.inputs_edit_soa_dialog(args)
            DNS.popup_right_menu('edit-SOA')
            soa_ttl       = args[:soa_ttl]
            soa_mname     = args[:soa_mname]
            soa_rname     = args[:soa_rname]
            soa_serial    = args[:soa_serial]
            soa_refresh   = args[:soa_refresh]
            soa_retry     = args[:soa_retry]
            soa_expire    = args[:soa_expire]
            soa_minimum   = args[:soa_minimum]
            origin_serial = DNS.popwin.text_field(:name, 'serial').value
            soa_serial    = soa_serial ? (origin_serial.to_i + 1).to_s : soa_serial
            DNS.popwin.text_field(:name, 'ttl').set(soa_ttl) if soa_ttl
            DNS.popwin.text_field(:name, 'mname').set(soa_mname) if soa_mname
            DNS.popwin.text_field(:name, 'rname').set(soa_rname) if soa_rname
            DNS.popwin.text_field(:name, 'serial').set(soa_serial) if soa_serial
            DNS.popwin.text_field(:name, 'refresh').set(soa_refresh) if soa_refresh
            DNS.popwin.text_field(:name, 'retry').set(soa_retry) if soa_retry
            DNS.popwin.text_field(:name, 'expire').set(soa_expire) if soa_expire
            DNS.popwin.text_field(:name, 'minimum').set(soa_minimum) if soa_minimum
        end
        def self.check_soa(args)
            r = []
            DNS.popup_right_menu('edit-SOA')
            r << 'failed' if args[:soa_ttl] && args[:soa_ttl] != DNS.popwin.text_field(:name, 'ttl').value
            r << 'failed' if args[:soa_mname] && args[:soa_mname] != DNS.popwin.text_field(:name, 'mname').value
            r << 'failed' if args[:soa_rname] && args[:soa_rname] != DNS.popwin.text_field(:name, 'rname').value
            r << 'failed' if args[:soa_serial] && args[:soa_serial] != DNS.popwin.text_field(:name, 'serial').value
            r << 'failed' if args[:soa_refresh] && args[:soa_refresh] != DNS.popwin.text_field(:name, 'refresh').value
            r << 'failed' if args[:soa_retry] && args[:soa_retry] != DNS.popwin.text_field(:name, 'retry').value
            r << 'failed' if args[:soa_expire] && args[:soa_expire] != DNS.popwin.text_field(:name, 'expire').value
            r << 'failed' if args[:soa_minimum] && args[:soa_minimum] != DNS.popwin.text_field(:name, 'minimum').value
            DNS.popwin.button(:class, 'cancel').click
            r.to_s.include?('failed') ? 'failed' : 'succeed'
        end
        def self.get_soa_values(args)
            DNS.popup_right_menu('edit-SOA')
            r = []
            soa_ttl     = args[:soa_ttl]
            soa_mname   = args[:soa_mname]
            soa_rname   = args[:soa_rname]
            soa_serial  = args[:soa_serial]
            soa_refresh = args[:soa_refresh]
            soa_retry   = args[:soa_retry]
            soa_expire  = args[:soa_expire]
            soa_minimum = args[:soa_minimum]
            r << 'failed' if soa_ttl != DNS.popwin.text_field(:name, 'ttl').value.to_s
            r << 'failed' if soa_mname != DNS.popwin.text_field(:name, 'mname').value.to_s
            r << 'failed' if soa_rname != DNS.popwin.text_field(:name, 'rname').value.to_s
            r << 'failed' if soa_serial != DNS.popwin.text_field(:name, 'serial').value.to_s
            r << 'failed' if soa_refresh != DNS.popwin.text_field(:name, 'refresh').value.to_s
            r << 'failed' if soa_retry != DNS.popwin.text_field(:name, 'retry').value.to_s
            r << 'failed' if soa_expire != DNS.popwin.text_field(:name, 'expire').value.to_s
            r << 'failed' if soa_minimu != DNS.popwin.text_field(:name, 'minimum').value.to_s
            r.empty? ? 'succeed' : 'failed'
        end
        def self.inputs_domain_dialog(domain,set_name=true)
            rname    = domain['rname']
            rtype    = domain['rtype']
            rdata    = domain['rdata']
            ttl      = domain['ttl']
            strategy = domain['strategy_name']
            DNS.popup_right_menu
            DNS.popwin.text_field(:name=>'name').set(rname) if rname && set_name
            DNS.popwin.select(:name=>'type').select(rtype) if rtype
            DNS.popwin.text_field(:name=>'ttl').set(ttl) if ttl
            DNS.popwin.text_field(:name=>'rdata').set(rdata) if rdata
            DNS.popwin.select(:name=>'strategy').select(strategy) if strategy and DNS.popwin.select(:name=>'strategy').present?
            DNS.popwin.checkbox(:name=>'link_ptr').set if domain['auto_ptr']
        end
        def self.inputs_batch_domain_dialog(args)
            file_name   = args[:file_name]
            domain_list = args[:domain_list]
            DNS.popup_right_menu('batchCreate')
            if file_name
                DNS.popwin.file_field(:name, 'zone_file').click
                DNS.open_dialog(file_name)
            end
            if domain_list
                domain_list.each do |domain|
                    rr = "#{domain['rname']} #{domain['ttl']} #{domain['rtype']} #{domain['rdata']}"
                    DNS.popwin.textarea(:name, "zone_content").append(rr)
                    DNS.send_newline
                end
            end
        end
        def self.inputs_edit_domain_dialog(domain)
            DNS.popup_right_menu('edit')
            DNS.popwin.text_field(:name, 'ttl').set(domain['ttl_new']) if domain['ttl_new']
            DNS.popwin.text_field(:name, 'rdata').set(domain['rdata_new']) if domain['rdata_new']
            DNS.popwin.checkbox(:name, 'link_ptr').set if domain['auto_ptr']
            if DNS.popwin.select(:name, 'strategy').present? && domain['strategy_name']
                DNS.popwin.select(:name, 'strategy').select(domain['strategy_name'])
            end
        end
        def self.input_comments(comments)
            cmt_gray = '../img/comment.png'    # 没有备注的图片
            cmt_blue = '../img/commenthas.png' # 有备注的图片
            r = ''
            if ZDDI.browser.div(:id, 'mainTable').image(:src, cmt_blue).present?
                ZDDI.browser.div(:id, 'mainTable').image(:src, cmt_blue).click
                sleep 1
                DNS.popwin.textarea(:name, 'comment').set(comments)
                r = DNS.waiting_operate_finished
            end
            if ZDDI.browser.div(:id, 'mainTable').image(:src,cmt_gray).present?
                ZDDI.browser.div(:id, 'mainTable').image(:src, cmt_gray).click
                sleep 1
                DNS.popwin.textarea(:name, 'comment').set(comments)
                r = DNS.waiting_operate_finished
            end
            puts 'succeed to input comments' if !r
            return r if r
            return 'succeed'
        end
        def self.inputs_import_dialog(args)
            lines = args[:imported_lines]
            lines.each do |line|
                DNS.popwin.textarea(:name, 'zone_content').append(line)
                DNS.send_newline
            end
        end
        def self.inputs_view_of_share_zone(views)
            views.each do |view|
                DNS.popwin.text_field(:value, "选择视图").set("clear")
                DNS.popwin.text_field(:value, "选择视图").set(view)
                DNS.send_enter if view != ''
            end
        end
        def self.remove_view_of_share_zone(views)
            views.each do |view|
                DNS.popwin.span(:text=>view).parent.link(:class=>"search-choice-close").click
            end
        end
        def self.inputs_share_zone_dialog(args)
            name  = args[:share_zone_name]
            views = args[:share_zone_views]
            ttl   = args[:share_zone_ttl]
            DNS.popup_right_menu
            DNS.popwin.select(:name=>'name').select(name)
            DNS.inputs_view_of_share_zone(views)
            DNS.popwin.text_field(:name=>'default_ttl').set(ttl) if ttl
        end
        def self.inputs_edit_share_zone_dialog(args, keep_rr = false)
            old_views = args[:share_zone_old_views]
            new_views = args[:share_zone_new_views]
            ttl       = args[:share_zone_ttl]
            DNS.popup_right_menu('edit')
            DNS.remove_view_of_share_zone(old_views) if old_views
            DNS.inputs_view_of_share_zone(new_views) if new_views
            DNS.popwin.text_field(:name=>'default_ttl').set(ttl) if ttl
            DNS.popwin.checkbox(:name=>'keep_shared_rrs').set if keep_rr
        end
        def self.inputs_share_zone_rr_dialog(args)
            domain = args[:share_zone_domain]
            DNS.inputs_domain_dialog(domain)
        end
        def self.inputs_edit_share_zone_rr_dialog(args)
            domain = args[:share_zone_domain]
            DNS.inputs_edit_domain_dialog(domain)
        end
        def self.inputs_share_rr_dialog(args)
            rr = args[:share_rr]
            rr_owner = args[:share_rr_owner]
            rname = rr['rname']
            rtype = rr['rtype']
            ttl   = rr['ttl'] ? rr['ttl'] : '3600'
            rdata = rr['rdata']
            DNS.popup_right_menu
            rr_owner.each do |owner|
                DNS.popwin.text_field(:value, "选择共享区").set("clear")
                DNS.popwin.text_field(:value, "选择共享区").set(owner)
                DNS.send_enter
            end
            DNS.popwin.text_field(:name, "name").set(rname)
            DNS.popwin.select(:name, "type").select(rtype)
            DNS.popwin.text_field(:name, "ttl").set(ttl)
            DNS.popwin.text_field(:name, "rdata").set(rdata)
        end
        def self.inputs_edit_share_rr_dialog(args)
            rr    = args[:share_rr]
            ttl   = rr['ttl'] ? rr['ttl'] : '3600'
            rdata = rr['rdata_new']
            DNS.popup_right_menu('edit')
            DNS.popwin.text_field(:name, "ttl").set(ttl) if ttl
            DNS.popwin.text_field(:name, "rdata").set(rdata) if rdata
        end
        ################   选择右上角节点   ################
        def self.select_node(nodeName)
            begin 
                ZDDI.browser.div(:class, 'toolsBar').select(:name, 'member').select(nodeName)
                sleep 1
                return 'succeed'
            rescue
                puts "failed to select #{nodeName}"
                return 'failed'
            end
        end
        ################   修改节点   ################
        def self.select_owner(args)
            @owner_list = args[:owner_list]
            @owner_list.each do |owner|
                DNS.popwin.text_field(:value, "选择设备节点").set("clear")
                DNS.popwin.text_field(:value, "选择设备节点").set(owner)
                DNS.send_enter if owner != ""
            end
        end
        def self.modify_member(args)
            @old_owner_list = args[:old_owner_list]
            @new_owner_list = args[:new_owner_list]
            begin
                DNS.popup_right_menu("modifyByMembers")
                @old_owner_list.each do |old_node|
                    DNS.popwin.span(:text=>old_node).parent.link(:class=>"search-choice-close").click
                end
                @new_owner_list.each do |new_node|
                    DNS.popwin.text_field(:value, "选择设备节点").set("clear")
                    DNS.popwin.text_field(:value, "选择设备节点").set(new_node)
                    DNS.send_enter
                end
                err = DNS.waiting_operate_finished
                sleep 3
                r = err ? 'failed' : 'succeed'
                puts "#{r} to modify member from #{@old_owner_list} to #{@new_owner_list}"
                r
            rescue
                puts "Error => modify member from #{@old_owner_list} to #{@new_owner_list}"
                DNS.popwin.button(:class, "cancel").click if DNS.popwin.present?
                return "failed"
            end
        end
        ################   删除操作   ################
        def self.del_checked_item
            if !ZDDI.browser.div(:id, "toolsBar").button(:class, "del").disabled?
                ZDDI.browser.div(:id, "toolsBar").button(:class, "del").click
                err = DNS.waiting_operate_finished
                return err if err
                return "succeed"
            else
                puts "DEL button is disabled, deleting blocked"
                return "failed"
            end
        end
        def self.del_searched_elem
            ZDDI.browser.table(:index, 1).checkbox(:index, 0).set
            ZDDI.browser.div(:id, "toolsBar").button(:class, "del").click
            err = DNS.waiting_operate_finished
            return err if err
            return "succeed"
        end
        ################   显示更多   ################
        def self.click_show_more_btn
            if ZDDI.browser.button(:class, "showMore").present?
                ZDDI.browser.button(:class, "showMore").click
                sleep 1
            end
        end
        def self.show_all_records
            while ZDDI.browser.button(:class, "showMore").present?
                ZDDI.browser.button(:class, "showMore").click
                sleep 1
            end
        end
        ################   添加记录   ################
        def self.add_rr(domain, set_name = true)
            DNS.inputs_domain_dialog(domain, set_name)
            err = DNS.waiting_operate_finished
            return err if err
            return nil
        end
        ################   参数校验   ################
        def self.waiting_operate_finished
            begin
                # "确定"button的两个属性
                DNS.popwin.button(:class,"save").click if DNS.popwin.button(:class,"save").present? and !DNS.popwin.button(:class,"save").disabled?
                DNS.popwin.button(:class,"ok").click if DNS.popwin.button(:class,"ok").present? and !DNS.popwin.button(:class,"ok").disabled?
                # 循环20s等待popwin的"确定"点击生效.
                Timeout::timeout(20) {
                    while DNS.popwin.present? do
                        sleep 1
                    end
                }
                return nil if !DNS.popwin.present? # 正常, 返回nil
            rescue Timeout::Error                  # 异常, 返回'fail'
                if DNS.popwin.label(:class, "error").present?
                    error_up = DNS.popwin.label(:class, "error").text
                end
                if DNS.popwin.div(:class, "flashError").present?
                    error_up = DNS.popwin.div(:class, "flashError").span.text                    
                end 
                # 点击'取消', return 'fail'
                DNS.popwin.button(:class, "cancel").click if DNS.popwin.present?
                puts "fail at Popwin => found \"#{error_up}\", cancelled!"
                return 'fail'
            end
        end
        def self.error_validator_on_popwin(args)
            # "before_OK: 输入框下方的提示. "after_OK": 窗口顶部的错误提示, 必须点【确定】后才显示"
            if args[:error_info] and args[:error_type]
                    error_info = args[:error_info]
                    error_type = args[:error_type] 
                    r_pass     = "succeed to validate: \"#{error_info}\"\n"
                    r_fail     = "failed to validate: \"#{error_info}\", found: "
                    r_error    = "failed to validate: \"#{error_info}\", not found\n"
                    error_up   = nil
                while DNS.popwin.present? do
                    # "确定"button的两个属性
                    DNS.popwin.button(:class, "save").click if DNS.popwin.button(:class, "save").present?
                    DNS.popwin.button(:class, "ok").click if DNS.popwin.button(:class, "ok").present?
                    sleep 1
                    # 验证error_info
                    case error_type
                    when "before_OK"
                        if DNS.popwin.label(:class, "error").present?
                            error_up = DNS.popwin.label(:class, "error").text
                        end
                    # 有些flashError后台处理稍长, 如'区传送失败'的提示.
                    when "after_OK"
                        begin
                            Timeout::timeout(20) {
                                while !DNS.popwin.div(:class, "flashError").present? do
                                    sleep 1
                                end
                                error_up = DNS.popwin.div(:class, "flashError").span.text
                            }
                        rescue Timeout::Error
                            puts "No flashError found in 20s."                    
                        end
                    end
                    r = r_error if !error_up
                    r = r_pass if error_up == error_info
                    r = r_fail + "#{error_up}\"\n" if error_up != error_info
                    DNS.popwin.button(:class, "cancel").click if DNS.popwin.button(:class, "cancel").present?
                    puts r
                end
                return r
            else
                puts "FAIL => error_validator found NONE error."
                return "failed"
            end
        end
        def self.grep_keyword_named(args, keyword_gone = false)
            r               = []
            @timeout        = 30
            keyword         = args[:keyword]
            grep_cmd        = "grep \"#{keyword}\" #{Named_Conf}"
            node_index_list = get_node_index_list(args)
            node_index_list.each do |i|
                node_ip   = Node_IP_List[i]
                node_user = Node_User_List[i]
                node_pwd  = Node_Pwd_List[i]
                grep_rslt = "to grep \"#{keyword}\" in named.conf of #{node_ip}"
                grep_pass = "succeed #{grep_rslt}"
                grep_fail = "failed #{grep_rslt}"
                begin
                    Net::SSH.start(node_ip, node_user, :password=>node_pwd) do |ssh|
                        grep_1st_time = ssh.exec!(grep_cmd)
                        Timeout::timeout(@timeout) {
                            # 期望关键字存在, 第一次grep也存在.
                            puts grep_pass if grep_1st_time and !keyword_gone
                            # 期望关键字消失,第一次grep消失!
                            puts grep_pass if !grep_1st_time and keyword_gone
                            # 期望关键字存在, 但第一次grep不存在.
                            while !grep_1st_time and !keyword_gone 
                                sleep 5
                                grep_seq_time = ssh.exec!(grep_cmd)
                                puts grep_pass if grep_seq_time
                                break if grep_seq_time
                            end
                            # 期望关键字消失,但第一次grep未消失!
                            while grep_1st_time and keyword_gone 
                                sleep 5
                                grep_seq_time = ssh.exec!(grep_cmd)
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
            r.to_s.include?('fail') ? 'fail' : 'succeed'
        end
        def self.get_node_index_list(args)
            node_index_list = [0] if args[:owner_list] == [Master_Device]
            node_index_list = [1] if args[:owner_list] == [Slave_Device]
            node_index_list = [0,1] if args[:owner_list] == Node_Name_List
            return node_index_list
        end
        def self.grep_process_node(args, process_gone = false)
            r               = []
            @timeout        = 60
            process         = args[:process_name]
            grep_cmd        = "ps aux | grep -v grep | grep \"#{process}\""
            node_index_list = get_node_index_list(args)
            node_index_list.each do |i|
                node_ip   = Node_IP_List[i]
                node_user = Node_User_List[i]
                node_pwd  = Node_Pwd_List[i]
                grep_rslt = "to grep process \"#{process}\" on #{node_ip}"
                grep_pass = "succeed #{grep_rslt}"
                grep_fail = "failed #{grep_rslt}"
                begin
                    Net::SSH.start(node_ip, node_user, :password=>node_pwd) do |ssh|
                        grep_1st_time = ssh.exec!(grep_cmd)
                        Timeout::timeout(@timeout) {
                            # 期望Process存在, 第一次grep也存在.
                            puts grep_pass if grep_1st_time and !process_gone
                            # 期望Process存在,第一次grep消失!
                            puts grep_pass if !grep_1st_time and process_gone
                            # 期望Process存在, 但第一次grep不存在.
                            while !grep_1st_time and !process_gone 
                                sleep 5
                                grep_seq_time = ssh.exec!(grep_cmd)
                                puts grep_pass if grep_seq_time
                                break if grep_seq_time
                            end
                            # 期望Process存在,但第一次grep未消失!
                            while grep_1st_time and process_gone 
                                sleep 5
                                grep_seq_time = ssh.exec!(grep_cmd)
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
            r.to_s.include?('fail') ? 'fail' : 'succeed'
        end
        def self.kill_process_node(args)
            r         = []
            process   = args[:process_name]
            kill_pid  = "ps aux | grep -v grep | grep \"#{process}\" | awk '{print $2}' | xargs kill -9"
            # 因为有些进程只在master才有, 所以此方法需要指定args[:owner_list]为Master或Slave
            index     = args[:kill_device] == Master_Device ? 0 : 1
            node_ip   = Node_IP_List[index]
            node_user = Node_User_List[index]
            node_pwd  = Node_Pwd_List[index]
            kill_pro  = "to kill process \"#{process}\" on #{node_ip}"
            begin
                Net::SSH.start(node_ip, node_user, :password=>node_pwd) do |ssh|
                    kill = ssh.exec!(kill_pid)
                    if kill == nil
                        puts "succeed #{kill_pro}"
                    else
                        r << 'fail' 
                    end
                end
            rescue
                puts "error at Net::SSH => #{node_ip}"
                r << "fail"
            end
            r.to_s.include?('fail') ? 'fail' : 'succeed'
        end
        ################   搜索关键字   ################
        def self.search_elem(elem_name)
            ZDDI.browser.div(:id, "search").text_field(:class, "search").set(elem_name)
            ZDDI.browser.div(:id, "search").button(:class, "searchBut").click
            sleep 1
        end
        ################   获取搜索结果的一项和所有项   ################
        def self.get_cur_elem_string(name = nil)
            if name
                ZDDI.browser.table(:class, "baseTable data").strings.each do |row|
                    row.each do |field|
                        return [row] if field.include?(name)
                    end
                end
            else
                return ZDDI.browser.table(:class, "baseTable data").strings[0]
            end
        end
        def self.get_all_search_string(search_name = nil)
            if search_name
                ZDDI.browser.text_field(:class=>'search').set(search_name)
                ZDDI.browser.button(:class=>'searchBut').click
                sleep 1
            end
            p '<search result line>'
            p ZDDI.browser.table(:class, "baseTable data").strings.to_s
            p '</search result line>'
            return ZDDI.browser.table(:class, "baseTable data").strings
        end
        ################   get first checkbox by search   ################
        def self.check_on_elem_by_search(search_name = nil, checkon = true)
            if search_name
                ZDDI.browser.text_field(:class=>'search').set(search_name)
                ZDDI.browser.button(:class=>'searchBut').click
                sleep 1
            end
            begin
                ZDDI.browser.table(:class, "baseTable data").checkbox(:index, 0).set
                ZDDI.browser.table(:class, "baseTable data").checkbox(:index, 0).clear if !checkon
                puts 'succeed to check_element on first checbox'
                return 'succeed'
            rescue
                puts 'failed to check_element on first checbox'
                return 'fail'
            end
        end
        ################   搜索 & 验证   ################
        def self.search_name(args, search_ok=true)
            @search_name = args[:search_name]
            ZDDI.browser.text_field(:class, 'search').set(@search_name)
            ZDDI.browser.button(:class, 'searchBut').click
            sleep 1
            # search 结果验证
            if ZDDI.browser.table(:index, 1).checkbox(:index, 0).present?
                if search_ok
                    puts "Search #{@search_name} OK"
                    return 'succeed'
                end
                return 'failed' if !search_ok
            else
                if !search_ok
                    puts "Search #{@search_name} NOT OK"
                    return 'succeed'
                end
                return 'failed' if search_ok
            end
        end
        ################   查询是否存在对应项  ################
        def self.elem_exists?(elem_name)
            search_elem(elem_name)
            return get_cur_elem_string(elem_name).to_s.include?(elem_name)
        end
        def self.view_exists?(view_name)
            return elem_exists?(view_name)
        end
        def self.zone_exists?(zone_name)
            return elem_exists?(zone_name)
        end
        def self.domain_exists?(domain_name)
            return elem_exists?(domain_name)
        end
        def self.acl_exists?(acl_name)
            return elem_exists?(acl_name)
        end
        def self.share_rr_exists?(share_rr_name)
            return elem_exists?(share_rr_name)
        end
        ################   获取查询的各字段值   ################
        def self.get_elem_num
            return get_cur_elem_string.length
        end
        def self.get_acl_network
            return context[0][3]
        end
        def self.get_view_ffwdr
            return context[0][3]
        end
        def self.get_view_priorty
            return context[0][4]
        end
        def self.get_view_acl
            return context[0][5]
        end
        def self.get_view_dns64
            return context[0][6]
        end
        def self.get_zone_device
            return context[0][2]
        end
        def self.get_zone_ttl
            return context[0][5]
        end
        ################   Send key   ################
        def self.send_enter
            ZDDI.browser.send_keys("\r\n")
        end
        def self.send_newline
            ZDDI.browser.send_keys("\n")
        end
        def self.send_tab
            ZDDI.browser.send_keys(:tab)
        end
        def self.send_shift_tab
            ZDDI.browser.send_keys(:shift, :tab)
        end
        def self.send_space
            ZDDI.browser.send_keys(:space)
        end
        ################   导入 & 导出   ################
        def self.choose_file(args)
            file = args[:imported_file]
            begin
                DNS.popwin.file_field(:name, 'zone_file').click
            rescue
                DNS.popwin.file_field(:name, 'file').click
            end
            DNS.open_dialog(file)
        end
        def self.import_file(args)
            DNS.popup_right_menu('batchCreate')
            DNS.choose_file(args)
            err = DNS.waiting_operate_finished
            puts 'succeed to import file' if !err
            puts 'failed to import file' if err
            err ? err : 'succeed'
        end
        def self.export_checked_item
            DNS.popup_right_menu("export_")
            err = DNS.waiting_operate_finished
            return err if err
            return 'succeed'
        end
        def self.delete_exported_file(args)
            begin
                File.delete(args[:exported_file]) # 正常删除返回'1'
                return 'succeed'
            rescue
                return 'failed'
            end
        end
        def self.export_validator(args, delete=true)
            file = args[:exported_file]
            1.upto(10) do
                sleep 1
                break if File::exists?(file)
            end
            return 'failed' if !File::exists?(file)
            delete ? delete_exported_file(args) : 'succeed'
        end
        def self.generate_file_for_importing(args)
            file = File.new(args[:imported_file], 'w')
            args[:imported_lines].each do |line|
                file.write(line)
                file.write("\n") if args[:imported_lines].size > 1
            end
            file.close
            sleep 1
            file = IO.readlines(args[:imported_file])
            args[:imported_lines].any?{|line| file.to_s.include?(line)} ? 'succeed' : 'failed'
        end
        ################   AutoIt打开本地文件   ################
        def self.open_dialog(file_path)
            sleep 1 # wait window opened
            win_title = %w[打开 文件上传 选择要加载的文件] # chrome/ff/ie 3个'打开文件'窗口
            i = 0   #counter
            win_title.each do |title|
                if AUTOIT.WinExists(title) == 1
                    AUTOIT.WinActivate(title)
                    sleep 1
                    AUTOIT.ControlSetText(title, "", "Edit1", file_path) #输入路径
                    AUTOIT.ControlClick(title, "", "Button1")            #点击"打开"
                    sleep 1
                    if AUTOIT.WinExists(title) == 0 # 打开文件成功
                        puts "Open file: #{file_path}"
                        return 'succeed'
                    else                           # "找不到文件", 打开失败
                        AUTOIT.Send("{SPACE}")                     # 处理"找不到"窗口
                        sleep 0.5
                        AUTOIT.ControlClick(title, "", "Button2")  # 点击"取消"
                        puts "Not found file: #{file_path}, cancelled the window"
                        return 'failed'
                    end
                else
                    i += 1 #所有窗口都没找到 => Fail.
                    puts 'Not found Open_File window' if i == 3
                    return 'failed'
                end
            end
        end
        ################   右上角选择正向区   ################
        def self.select_zone_type_as_normal(args)
            return true if ZDDI.browser.div(:class, "toolsBar").select(:name, "type").select('正向区')
            return false
        end
        ################   右上角选择反向区   ################
        def self.select_zone_type_as_addr(args)
            return true if ZDDI.browser.div(:class, "toolsBar").select(:name, "type").select('反向区')
            return false
        end
        ################   dig 返回状态  ################
        def self.get_dig_result(args)
            server = args[:dig_ip]
            domain = args[:domain_name]
            rtype  = args[:rtype]
            dig    = `dig @#{server} #{domain} #{rtype}`
        end
        def self.dig_as_noerror(args, sleepfirst=true)
            sleep 10 if sleepfirst
            res = get_dig_result(args)
            rr  = !res.include?('ANSWER: 0') and res.include?('status: NOERROR')
            rs  = "dig @#{args[:dig_ip]} #{args[:domain_name]} #{args[:rtype]} --> NoError"
            if rr
                puts "succeed to #{rs}"
                return 'succeed'
            else
                puts "fail to #{rs}"
                return 'failed'
            end
        end
        def self.dig_as_nodata(args, sleepfirst=true)
            sleep 10 if sleepfirst
            res = get_dig_result(args)
            rr  = res.include?('ANSWER: 0') and res.include?('status: NOERROR')
            rs  = "dig @#{args[:dig_ip]} #{args[:domain_name]} #{args[:rtype]} --> NoData"
            if rr
                puts "succeed to #{rs}"
                return 'succeed'
            else
                puts "fail to #{rs}"
                return 'failed'
            end
        end
        def self.dig_as_nxdomain(args, sleepfirst=true)
            sleep 10 if sleepfirst
            res = get_dig_result(args)
            rr  = res.include?('status: NXDOMAIN')
            rs  = "dig @#{args[:dig_ip]} #{args[:domain_name]} #{args[:rtype]} --> NxDomain"
            if rr
                puts "succeed to #{rs}"
                return 'succeed'
            else
                puts "fail to #{rs}"
                return 'failed'
            end
        end
        def self.dig_as_serverfail(args, sleepfirst=true)
            sleep 10 if sleepfirst
            res = get_dig_result(args)
            rr  = res.include?('status: SERVFAIL')
            rs  = "dig @#{args[:dig_ip]} #{args[:domain_name]} #{args[:rtype]} --> ServFail"
            if rr
                puts "succeed to #{rs}"
                return 'succeed'
            else
                puts "fail to #{rs}"
                return 'failed'
            end
        end
        def self.dig_soa(args, sleepfirst = true)
            r = []
            server         = args[:dig_ip]
            zone_name      = args[:zone_name]
            soa_value_list = args[:soa_value_list]
            sleep 10 if sleepfirst
            actual_soa     = `dig @#{server} #{zone_name} soa +short`
            soa_value_list.each do |soa_value|
                r << 'failed' if !actual_soa.include?(soa_value)
            end
            puts "succeed to dig soa #{zone_name} at #{server}" if r.empty?
            r.empty? ? 'succeed' : 'failed'
        end
        def self.dig_to_validate_rr_weight(args)
            # |||||||||||||     权重验证方法说明     ||||||||||||||||||
            # 根据domain_list中同名记录权重+IP生成一个Hash, 如{'1.2.3.4'=>10, '1,2,3,5'=>20}.
            # 至少dig500次 : 如果权重之和 > 500, 则dig次数 = 权重之和
            # 根据dig次数计算每个IP期望返回次数:如'1.2.3.4'从10变为　(10.to_f / (10 + 20).to_f) * 500.to_f = 167
            # 从dig结果中整理出每个IP实际返回次数的新Hash, 如{'1.2.3.4'=>155, '1,2,3,5'=>345}.
            # 注意: 所有相同权重的rr会一起返回, 所以每次计数时只取dig得到的第一个IP, 这样符合用户使用场景.
            # 最后用 (期望次数 - 返回次数) / 期望次数, 作为误差, 如 (167 - 155).abs.to_f / 167.to_f = 0.07
            # 误差大于20%时, 记为Fail.
            r = []
            # args[:domain_list]
            rw         = {'1.1.1.1'=>10, '1.1.1.2'=>20, '1.1.1.3'=>30, '1.1.1.4'=>30}
            server     = args[:dig_ip]
            domain     = '1.cn'
            rtype      = 'A'
            dig        = "dig @#{server} #{domain} #{rtype} +short"
            sum_w      = 0
            dig_result = []
            rw_result  = {}
            rw.values.each {|i| sum_w += i}
            dig_times  = sum_w < 500 ? 500 : sum_w
            # 根据dig次数重置rw
            rw.each_pair { |ip, w| rw[ip] = ((w.to_f / sum_w.to_f) * dig_times.to_f ).to_i }
            dig_times.times { dig_result << `#{dig}`.split("\n")[0] }
            rw.each_key { |ip| rw_result[ip] = dig_result.count(ip) }
            rw_list = rw.values
            rw_result_list = rw_result.values
            puts '--------- rr weight result ------------'
            puts rw
            puts rw_result
            rw.size.times do |index|
                if rw_list[index] != 0
                    er = ( rw_list[index] - rw_result_list[index] ).abs.to_f / rw_list[index].to_f
                    puts "#{rw_list[index]} <-> #{rw_result_list[index]} => #{er}"
                    r << 'fail' if er > 0.2
                else
                    r << 'fail' if rw_result_list[index] != 0
                end
            end
            r.empty? ? 'succeed' : 'fail'
        end
        ################   权威管理   ################
        class ACL
            def create_acl(args)
                DNS.open_acl_page
                DNS.inputs_create_acl_dialog(args)
                r = DNS.waiting_operate_finished ? 'fail' : 'succeed'
                puts "#{r} to edit acl #{args[:acl_name]}"
                r
            end
            def edit_acl(args)
                DNS.open_acl_page
                DNS.check_on_single_acl(args)
                DNS.inputs_edit_acl_dialog(args)
                r = DNS.waiting_operate_finished ? 'fail' : 'succeed'
                puts "#{r} to edit acl #{args[:acl_name]}"
                r
            end
            def del_acl(args)
                DNS.open_acl_page
                DNS.check_on_single_acl(args)
                r = DNS.del_checked_item
                puts "#{r} to del acl #{args[:acl_name]}"
                r
            end
            def del_all_acl
                DNS.open_acl_page
                DNS.check_on_all
                DNS.del_checked_item
            end
            def search_acl(args)
                @keyword = args[:search_keyword]
                DNS.open_acl_page
                DNS.search_elem(@keyword)
                r = DNS.get_cur_elem_string.to_s
                r.include?(@keyword) ? 'succeed' : 'failed'
            end
        end
        class View
            def create_view(args)
                @acl_name_list = args[:acl_name] ? [args[:acl_name]] : nil
                @view_name     = args[:view_name]
                @owner_list    = args[:owner_list]
                @ffwdr         = args[:fail_forwarder]
                @dns64_list    = args[:dns64_list]
                DNS.open_view_manage_page
                DNS.inputs_create_view_dialog(args)
                err = DNS.waiting_operate_finished
                return err if err
                return check_view
            end
            def order_view(args)
                @view_name    = args[:view_name]
                @pio          = args[:priority]
                @reorder_view = "to reorder view: #{@view_name} priority: #{@pio}\n"
                DNS.open_view_manage_page
                if DNS.view_exists?(@view_name)
                    DNS.popup_right_menu("reorder", true)
                    DNS.popwin.text_field(:name, "priority").set(@pio)
                    err = DNS.waiting_operate_finished
                    return err if err
                else
                    r = "failed to reorder view #{@view_name} due to not found it.\n"
                end
                DNS.context = DNS.get_cur_elem_string(@view_name)
                if DNS.get_view_priorty == @pio
                    r = "succeed #{@reorder_view}"
                else
                    r = "failed #{@reorder_view}"
                end
                puts r
                return r
            end
            def create_sortlist_on_view(args)
                DNS.goto_sortlist_page(args)
                DNS.inputs_create_sortlist(args)
                err = DNS.waiting_operate_finished
                return err if err
                return check_sortlist(args)
            end
            def dig_sortlist_order(args, expected_fail=false)
                failed_rlist        = []
                domain              = args[:domain_name]
                expected_order_list = args[:sortlists_prefered_ips]
                size_exp            = expected_order_list.size
                sleep 5
                args[:owner_list].each do |owner|
                    node_ip = Master_IP if owner == Master_Device
                    node_ip = Slave_IP if owner == Slave_Device
                    res     = `dig @#{node_ip} #{domain} +short`
                    if res
                        actual_order_list = res.split("\n")
                        size_act = actual_order_list.size
                        compares = (size_exp < size_act) ? size_exp : size_act # 取两个IP列表的最小size再比较
                        compares.times do |i|
                            ip1 = IPAddress(expected_order_list[i])
                            ip2 = IPAddress(actual_order_list[i])
                            puts '------------------------'
                            puts "    sortlist: #{expected_order_list[i]}"
                            puts "dig on local: #{actual_order_list[i]}"
                            failed_rlist << 'failed' if !ip1.include?(ip2)
                        end
                    else
                        failed_rlist << 'failed'
                    end
                end
                return (failed_rlist.empty? ? 'failed' : 'succeed') if expected_fail
                failed_rlist.empty? ? 'succeed' : 'failed'
            end
            def dig_sortlist_order_on_master(args)
                failed_rlist        = []
                domain              = args[:domain_name]
                expected_order_list = args[:sortlists_prefered_ips]
                size_exp            = expected_order_list.size
                sleep 5
                i                   = 0
                res                 = ''
                node_ip             = Node_IP_List[i]
                node_user           = Node_User_List[i]
                node_pwd            = Node_Pwd_List[i]
                dig_cmd             = "dig @#{node_ip} #{domain} +short"
                Net::SSH.start(node_ip, node_user, :password => node_pwd) do |ssh|
                    res = ssh.exec!(dig_cmd)
                end
                if res
                    actual_order_list = res.split("\n")
                    size_act = actual_order_list.size
                    compares = (size_exp < size_act) ? size_exp : size_act # 取两个IP列表的最小size再比较
                    compares.times do |i|
                        ip1 = IPAddress(expected_order_list[i])
                        ip2 = IPAddress(actual_order_list[i])
                        puts '------------------------'
                        puts "   sortlist: #{expected_order_list[i]}"
                        puts "dig on node: #{actual_order_list[i]}"
                        failed_rlist << 'failed' if !ip1.include?(ip2)
                    end
                else
                    return 'failed'
                end
                failed_rlist.empty? ? 'succeed' : 'failed'
            end
            def edit_sortlist_on_view(args)
                @prefered_ips = args[:new_sortlists_prefered_ips]
                DNS.goto_sortlist_page(args)
                DNS.check_on_single_sortlist(args)
                DNS.popup_right_menu('edit')
                DNS.popwin.textarea(:name, "prefered_ips").set(@prefered_ips.join("\n"))
                err = DNS.waiting_operate_finished
                sleep 5 # waiting for new sortlist works
                return err if err
                return check_sortlist(args, operation='edit')
            end
            def del_sortlist_on_view(args)
                @source_ip = args[:sortlists_source_ip]
                DNS.goto_sortlist_page(args)
                DNS.check_on_single_sortlist(args)
                if DNS.del_checked_item == 'succeed'
                    puts "succeed to del sortlist: #{@source_ip}"
                    sleep 5 # waiting for new sortlist works
                    return 'succeed'
                else
                    puts "failed to del sortlist: #{@source_ip}"
                    return 'failed'
                end
            end
            def edit_view(args)
                @view_name    = args[:view_name]
                @del_acl_list = args[:del_acl_list]
                @add_acl_list = args[:add_acl_list]
                @dns64_list   = args[:dns64_list]
                @ffwdr        = args[:fail_forwarder]
                DNS.open_view_manage_page
                if DNS.view_exists?(@view_name)
                    DNS.popup_right_menu("edit", true)
                    # 编辑失败转发
                    DNS.popwin.text_field(:name, "fail_forwarder").set(@ffwdr) if @ffwdr
                    # 编辑ACL, 先全删再加新地址
                    if @del_acl_list
                        @del_acl_list.each do |acl|
                            DNS.popwin.span(:text=>acl).parent.link(:class=>"search-choice-close").click
                            # 点"x"删acl_name
                        end
                    end
                    if @add_acl_list
                        @add_acl_list.each do |acl|
                            DNS.popwin.text_field(:value, "选择访问控制以启用视图").set("clear")
                            DNS.popwin.text_field(:value, "选择访问控制以启用视图").set(acl)
                            DNS.send_enter
                        end
                    end
                    # 编辑DNS64
                    if @dns64_list
                        DNS.popwin.textarea(:name, "dns64s").clear
                        @dns64_list.each do |dns64|
                            DNS.popwin.textarea(:name, "dns64s").append(dns64)
                            DNS.send_newline
                        end
                    end
                    err = DNS.waiting_operate_finished
                    return err if err
                    # 验证编辑结果
                    return check_view("edit")
                end
            end
            def check_view(operation="create")
                check_view   = "to #{operation} view: #{@view_name}"
                check_result = []
                view_strings = DNS.get_cur_elem_string(@view_name).to_s
                if operation == "create"
                    # verify owner_list
                    @owner_list.each do |owner|
                        check_result << "failed" if !view_strings.include?(owner)
                    end
                    # verify acl_name_list
                    if @acl_name_list
                        @acl_name_list.each do |acl_name|
                            check_result << "failed" if !view_strings.include?(acl_name)
                        end
                    end
                end
                # verify acl del and add
                if operation == "edit"
                    check_result << "failed" if @add_acl_list and !view_strings.include?(@add_acl_list.join(', '))
                    check_result << "failed" if @del_acl_list and view_strings.include?(@del_acl_list.join(', '))
                end
                # verify fail forward
                check_result << "failed" if @ffwdr and !view_strings.include?(@ffwdr)
                puts "failed to check fail forward: #{@ffwdr}" if @ffwdr and !view_strings.include?(@ffwdr)
                # verify dns64
                check_result << "failed" if @dns64_list and !view_strings.include?(@dns64_list.join(', ').downcase)
                puts "failed to check dns64: #{@dns64_list}" if @dns64_list and !view_strings.include?(@dns64_list.join(', ').downcase)
                r = check_result.empty? ? "succeed" : "failed"
                puts "#{r} #{check_view}"
                return r
            end
            def check_sortlist(args, operation='create')
                check_result  = []
                @source_ip    = args[:sortlists_source_ip]
                @prefered_ips = args[:sortlists_prefered_ips] if operation == 'create'
                @prefered_ips = args[:new_sortlists_prefered_ips] if operation == 'edit'
                DNS.context   = DNS.get_cur_elem_string(@source_ip)
                @prefered_ips.each {|ip| check_result << 'failed' if !DNS.context[0][2].include?(ip)}
                if check_result.empty?
                    puts "succeed to #{operation} sortlist for #{@source_ip}"
                    return 'succeed'
                else
                    puts "failed to #{operation} sortlist for #{@source_ip}"
                    return 'failed'
                end
            end
            def modify_view_member(args)
                DNS.open_view_manage_page
                DNS.check_on_single_view(args)
                r = DNS.modify_member(args)
                return r
            end
            def del_view(args)
                DNS.open_view_manage_page
                DNS.check_on_single_view(args)
                r = DNS.del_checked_item
                puts "succeed to del view: #{args[:view_name]}" if r.include?('succeed')
                return r
            end
            def del_view_list(view_list)
                r = ""
                DNS.open_view_manage_page
                view_list.each do |view_name|
                    if DNS.view_exists?(view_name)
                        DNS.del_searched_elem
                    end
                end
                view_list.each do |view_name|
                    if !DNS.view_exists?(view_name)
                        r += "succeed to del view: #{view_name}\n"
                    else
                        r += "failed to del view: #{view_name}\n"
                    end
                end
                puts r
                return r
            end
        end
        class Zone
            def create_zone(args)
                r = []
                @view_name  = args[:view_name]
                @owner_list = args[:owner_list]
                if args[:zone_type] == 'in-addr'
                    @zone_name = DNS.zone_name_to_arpa(args)
                else
                    @zone_name = args[:zone_name]
                end
                DNS.goto_view_page(args)
                DNS.inputs_create_zone_dialog(args)
                r << DNS.waiting_operate_finished
                sleep 5 # 等待 named reconfig
                r << check_zone("create")
                r.to_s.include?('fail') ? 'fail' : 'succeed'
            end
            def edit_zone(args)
                @new_ttl       = args[:new_ttl]
                @m_server      = args[:master_server]
                @s_server      = args[:slave_server]
                @modify_master = args[:modify_master]
                @modify_slave  = args[:modify_slave]
                @renewal       = args[:renewal]   # 辅区续期
                @modify_ad     = args[:modify_ad]
                @ad_list       = args[:acl_name] ? [args[:acl_name]] : nil
                begin
                    DNS.goto_view_page(args)
                    DNS.check_on_single_zone(args)
                    DNS.popup_right_menu("edit")
                    DNS.popwin.text_field(:name, "default_ttl").set(@new_ttl) if @new_ttl
                    DNS.popwin.textarea(:name, "slaves").set(@s_server) if @s_server && @modify_slave
                    DNS.popwin.textarea(:name, "masters").set(@m_server) if @m_server && @modify_master
                    # AD控制器 (只有default视图才有此选项)
                    if DNS.popwin.text_field(:value, "选择访问控制").present? && @modify_ad && @ad_list
                        @ad_list.each do |acl|
                            DNS.popwin.text_field(:value, "选择访问控制").set("clear")
                            DNS.popwin.text_field(:value, "选择访问控制").set(acl)
                            DNS.send_enter
                        end
                    end
                    # 辅区续期
                    if DNS.popwin.checkbox(:name, "renewal").present?
                        DNS.popwin.checkbox(:name, "renewal").set if @renewal
                        DNS.popwin.checkbox(:name, "renewal").clear if !@renewal
                    end
                    err = DNS.waiting_operate_finished
                    puts "succeed to edit zone #{args[:zone_name]}" if !err
                    sleep 5 # 等待写入named.conf
                    return err if err
                    return "succeed"
                rescue
                    puts "Error => edit zone #{args[:zone_name]} failed"
                    return "failed"
                end
            end
            def edit_soa(args)
                r         = []
                view_name = args[:view_name]
                zone_name = args[:zone_name]
                r << DNS.goto_zone_page(args)
                r << DNS.inputs_edit_soa_dialog(args)
                r << DNS.waiting_operate_finished
                r << DNS.check_soa(args)
                if r.to_s.include?('failed')
                    puts "failed to edit soa of #{zone_name} of #{view_name}"
                    return 'failed'
                else
                    puts "succeed to edit soa of #{zone_name} of #{view_name}"
                    return 'succeed'
                end
            end
            def create_slave_zone_on_master(args)
                r        = []
                new_view = args[:view_name]
                begin
                    # default视图, slave节点建主区
                    args[:view_name]    = 'default'
                    args[:slave_server] = Master_IP
                    args[:owner_list]   = [Slave_Device]
                    r << Zone_er.create_zone(args)
                    # view视图, master节点建辅区
                    args[:owner_list]  = [Master_Device]
                    args[:view_name]   = new_view
                    r << View_er.create_view(args)
                    args[:server_type]   = "slave"
                    args[:master_server] = Slave_IP
                    r << Zone_er.create_zone(args)
                rescue
                    puts "unknown error while creating slave zone on master..."
                    return "failed"
                end
                r.to_s.include?('failed') ? 'failed' : 'succeed'
            end
            def check_zone(operation="create")
                r = ""
                DNS.context = DNS.get_cur_elem_string(@zone_name)
                @zone_name = '.' if @zone_name == '@'
                @all_owner = @owner_list[0] if @owner_list.size == 1
                @all_owner = @owner_list.join(', slave.') if @owner_list.size == 2
                if DNS.get_zone_device.include?(@all_owner) && DNS.get_zone_ttl.to_i != 0
                    r += "succeed to #{operation} zone: #{@zone_name} in view: #{@view_name} owner_list: #{@owner_list}\n"
                else
                    failed = false
                    @owner_list.each_index do |i|
                        if !DNS.get_zone_device.include?(@owner_list[i])
                           r += "failed to #{operation} zone: #{@zone_name} in view: #{@view_name} in device: #{@owner_list[i]}\n"
                           failed = true 
                        end
                    end
                    if !failed
                        r += "succeed to #{operation} zone: #{@zone_name} in view: #{@view_name} owner_list: #{@owner_list}\n"
                    end
                end
                puts r
                return r
            end
            def modify_zone_member(args)
                DNS.goto_view_page(args)
                DNS.check_on_single_zone(args)
                r = DNS.modify_member(args)                
                return r
            end
            def export_zone(args)
                @view_name           = args[:view_name]
                @zone_name           = args[:zone_name]
                args[:exported_file] = Download_Dir + "#{args[:zone_name]}.txt" if !args[:exported_file]
                export_zone          = "to export zone: #{@zone_name} of view: #{@view_name}"
                DNS.goto_view_page(args)
                DNS.check_on_single_zone(args)
                DNS.export_checked_item
                r = DNS.export_validator(args, delete=true)
                puts "#{r} #{export_zone}"
                return r
            end
            def del_zone(args)
                view_name = args[:view_name]
                zone_name = args[:zone_name]
                del_zone  = "to del zone: #{zone_name} of view: #{view_name}"
                DNS.goto_view_page(args)
                if DNS.zone_exists?(zone_name)
                    r = DNS.del_searched_elem
                else
                    r = 'failed'
                end
                puts "#{r} #{del_zone}"
                return r
            end
            def del_zone_list(args)
                view_name = args[:view_name] 
                zone_list = args[:zone_list] 
                if DNS.goto_view_page(args)
                    zone_list.each do |zone_name|
                        if DNS.zone_exists?(zone_name)
                            DNS.del_searched_elem
                        end
                    end
                end
                r = ""
                zone_list.each do |zone_name|
                    if !DNS.zone_exists?(zone_name)
                        r += "succeed to del zone: #{zone_name} in view: #{view_name}\n"
                    else
                        r += "failed to del zone: #{zone_name}\n"
                    end
                end
                puts r
                return r
            end
        end
        class Domain
            def create_domain(args)
                view_name    = args[:view_name]
                zone_name    = args[:zone_name]
                domain_list  = args[:domain_list]
                failed_rlist = []
                DNS.goto_zone_page(args)
                domain_list.each do |domain|
                    r = DNS.add_rr(domain)
                    failed_rlist << r if r and r.include?("failed")
                    args[:rname] = domain["rname"]
                    args[:rtype] = domain["rtype"]
                    args[:rdata] = domain["rdata"]
                    args[:ttl]   = domain["ttl"]
                    r = DNS.check_on_single_domain(args, checkon=false)
                    failed_rlist << r if r and r.include?("failed")
                    puts "#{r} to create domain: #{domain} "
                end
                return "succeed" if failed_rlist.empty?
                return "failed"
            end
            def batch_add_domain(args)
                r         = []
                view_name = args[:view_name]
                zone_name = args[:zone_name]
                # file_name         = args[:file_name]
                # batch_domain_list = args[:domain_list]
                r << DNS.goto_zone_page(args)
                r << DNS.inputs_batch_domain_dialog(args)
                r << DNS.waiting_operate_finished
                if r.to_s.include?('fail')
                    puts 'failed to batch add domain...'
                    return 'failed'
                else
                    puts 'succeed to batch add domain...'
                    return 'succeed'
                end
            end
            def edit_domain(args)
                r = []
                view_name   = args[:view_name]
                zone_name   = args[:zone_name]
                domain_list = args[:domain_list]
                r << DNS.goto_zone_page(args)
                domain_list.each do |domain|
                    args[:rname] = domain["rname"]
                    args[:rtype] = domain["rtype"]
                    args[:ttl]   = domain["ttl_old"] ? domain["ttl_old"] : domain["ttl"] 
                    args[:rdata] = domain["rdata_old"]
                    r << DNS.check_on_elem_by_search(args[:rdata])
                    r << DNS.inputs_edit_domain_dialog(domain)
                    r << DNS.waiting_operate_finished
                    puts "succeed to edit domain: #{domain}" if !r.to_s.include?('failed')
                end
                r.to_s.include?('failed') ? 'failed' : 'succeed'
            end
            def edit_batch_domain(args)
                view_name   = args[:view_name]
                zone_name   = args[:zone_name]
                domain_list = args[:domain_list]
                if DNS.goto_zone_page(args).include?("succeed")
                    domain_list.each do |domain|
                        args[:rname] = domain["rname"]
                        args[:rtype] = domain["rtype"]
                        args[:ttl]   = domain["ttl"]
                        args[:rdata] = domain["rdata"]
                        next if DNS.check_on_single_domain(args).include?("succeed")
                    end
                    DNS.popup_right_menu("edit")
                    DNS.popwin.text_field(:name, "ttl").set("600") # 批量修改ttl为600
                    DNS.popwin.button(:class, "save").click
                    r = DNS.waiting_operate_finished
                    return "succeed" if !r
                    return "failed" if r
                end
            end
            def del_domain(args)
                r           = []
                view_name   = args[:view_name]
                zone_name   = args[:zone_name]
                domain_list = args[:domain_list]
                del_ptr     = args[:del_ptr]
                del_domain  = "to del domain in #{zone_name}"
                r << DNS.goto_zone_page(args)
                domain_list.each do |domain|
                    args[:rname] = domain["rname"]
                    args[:rtype] = domain["rtype"]
                    args[:ttl]   = domain["ttl"] ? domain["ttl"] : "3600"
                    args[:rdata] = domain["rdata"]
                    r << DNS.check_on_single_domain(args)
                    if del_ptr 
                        r << DNS.popup_right_menu('del')
                        r << DNS.check_del_ptr_box
                        r << DNS.waiting_operate_finished
                    else
                        r << DNS.del_checked_item
                    end
                end
                # puts and returns
                if r.to_s.include?('failed')
                    puts "failed #{del_domain}"
                    return 'failed'
                else
                    puts "succeed #{del_domain}"
                    return 'succeed'
                end
            end
        end
        class Share_zone
            def create_share_zone(args)
                DNS.open_share_zone_page
                DNS.inputs_share_zone_dialog(args)
                r = DNS.waiting_operate_finished ? 'fail' : 'succeed'
                puts "#{r} to create share zone -> #{args[:share_zone_name]}"
                return r
            end
            def edit_share_zone(args, keep_rr=false)
                DNS.open_share_zone_page
                DNS.check_on_single_share_zone(args)
                DNS.inputs_edit_share_zone_dialog(args, keep_rr)
                r = DNS.waiting_operate_finished ? 'fail' : 'succeed'
                puts "#{r} to edit share zone -> #{args[:share_zone_name]}"
                return r
            end
            def _del_share_zone(keep_rr)
                if !ZDDI.browser.div(:id, "toolsBar").button(:class, "del").disabled?
                    ZDDI.browser.div(:id, "toolsBar").button(:class, "del").click
                    DNS.popwin.checkbox(:name=>'keep_shared_rrs').set if keep_rr
                    err = DNS.waiting_operate_finished
                    return err if err
                    return "succeed"
                else
                    puts "error on Deleting -> Del button is disalbed !"
                    return "failed"
                end
            end
            def del_share_zone(args, keep_rr = false)
                DNS.open_share_zone_page
                DNS.check_on_single_share_zone(args)
                r = _del_share_zone(keep_rr)
                puts "#{r} to del share zone -> #{args[:share_zone_name]}"
                return r
            end
            def del_all_share_zone(args, keep_rr = false)
                DNS.open_share_zone_page
                DNS.check_on_all
                r = _del_share_zone(args, keep_rr)
                puts "#{r} to del all share zone..."
                return r
            end
            def create_share_zone_rr(args)
                DNS.goto_share_zone_page(args)
                DNS.inputs_share_zone_rr_dialog(args)
                r = DNS.waiting_operate_finished ? 'fail' : 'succeed'
                puts "#{r} to create share zone rr -> #{args[:share_zone_domain]}"
                return r
            end
            def edit_share_zone_rr(args)
                DNS.goto_share_zone_page(args)
                DNS.check_on_single_share_zone_rr(args)
                DNS.inputs_edit_share_zone_rr_dialog(args)
                r = DNS.waiting_operate_finished ? 'fail' : 'succeed'
                puts "#{r} to edit share zone rr -> #{args[:share_zone_domain]}"
                return r
            end
            def import_share_zone_rr(args)
                DNS.goto_share_zone_page(args)
                r = DNS.import_file(args)
                puts "#{r} to import share zone rr -> #{args[:imported_file]}"
                return r
            end
            def del_share_zone_rr(args)
                DNS.goto_share_zone_page(args)
                DNS.check_on_single_share_zone_rr(args)
                r = DNS.del_checked_item
                puts "#{r} to del share zone rr -> #{args[:share_zone_domain]}"
                return r
            end
            def del_all_share_zone_rr(args)
                DNS.goto_share_zone_page(args)
                DNS.check_on_all
                r = DNS.del_checked_item
                puts "#{r} to del all share zone rr..."
                return r
            end
        end
        class ShareRR
            def create_share_rr(args)
                r = []
                DNS.open_share_rr_page
                DNS.inputs_share_rr_dialog(args)
                rs = DNS.waiting_operate_finished ? 'fail' : 'succeed'
                puts "#{rs} to create share_rr: #{args[:share_rr]}"
                r << rs
                r.to_s.include?('fail') ? 'fail' : 'succeed'
            end
            def edit_share_rr(args)
                r = []
                DNS.open_share_rr_page
                r << DNS.check_on_single_share_rr(args)
                DNS.inputs_edit_share_rr_dialog(args)
                rs = DNS.waiting_operate_finished ? 'fail' : 'succeed'
                puts "#{rs} to edit share_rr: #{args[:share_rr]}"
                r << rs
                r.to_s.include?('fail') ? 'fail' : 'succeed'
            end
            def modify_share_rr_owner(args)
                r = []
                @old_owner_list = args[:old_share_rr_owner]
                @new_owner_list = args[:new_share_rr_owner]
                begin
                    DNS.open_share_rr_page
                    DNS.check_on_single_share_rr(args)
                    DNS.popup_right_menu("modifyByOwner")
                    @old_owner_list.each do |old_owner|
                       r << DNS.popwin.span(:text=>old_owner).parent.link(:class=>"search-choice-close").click
                    end
                    @new_owner_list.each do |new_owner|
                        DNS.popwin.text_field(:value, "选择区").set("clear")
                        DNS.popwin.text_field(:value, "选择区").set(new_owner)
                        DNS.send_enter
                    end
                rescue
                    puts "Error of modify share_rr_owner from #{@old_owner_list} to #{@new_owner_list}"
                    DNS.popwin.button(:class, "cancel").click if DNS.popwin.present?
                    return "fail"
                end
                rs = DNS.waiting_operate_finished ? 'fail' : 'succeed'
                r << rs
                puts "#{rs} to modify share_rr_owner to #{@new_owner_list}"
                r.to_s.include?('fail') ? 'fail' : 'succeed'
            end
            def del_share_rr(args)
                r = []
                DNS.open_share_rr_page
                r << DNS.check_on_single_share_rr(args)
                r << DNS.del_checked_item
                rs = DNS.waiting_operate_finished ? 'fail' : 'succeed'
                puts "#{rs} to del share_rr #{args[:share_rr]}"
                r.to_s.include?('fail') ? 'fail' : 'succeed'
            end
            def del_all_share_rr(args)
                r = []
                DNS.open_share_rr_page
                DNS.check_on_all
                DNS.del_checked_item
            end
        end
        class Search
            def _match_search_result?(search_item)
                DNS.open_search_page
                DNS.search_elem(search_item)
                search_result = DNS.get_cur_elem_string.to_s
                search_item = search_item.gsub('*', '') if search_item.include?('*')
                search_result.include?(search_item) ? true : false
            end
            def search_and_operate(keyword, operation, ttl=nil, rdata=nil)
                if _match_search_result?(keyword)
                    DNS.popup_right_menu(operation, true)
                    if operation == 'edit'
                        DNS.popwin.text_field(:name, "ttl").set(ttl) if ttl
                        DNS.popwin.text_field(:name, "rdata").set(rdata) if rdata
                    end
                    r = DNS.waiting_operate_finished ? 'fail' : 'succeed'
                    puts "#{r} to #{operation} from global search result"
                    return r
                else
                    return 'fail'
                end
            end
            def search_and_edit(args)
                search_item = args[:search_item]
                ttl         = args[:ttl]
                rdata       = args[:rdata]
                return search_and_operate(search_item, 'edit', ttl, rdata)
            end
            def search_and_del(args)
                search_item = args[:search_item]
                return search_and_operate(search_item,'del')
            end
            def get_search_result(args)
                search_item = args[:search_item]
                DNS.open_search_page
                DNS.search_elem(search_item)
                return ZDDI.browser.table(:class, "baseTable data").strings
            end
            def get_search_result_number(args)
                r = get_search_result(args)
                return r.size
            end
        end
        class SyncData
            # old method, sometimes is not working....
            def compare_domain_dnsruby(args)
                server_list       = args[:server_list]
                domain_name       = args[:domain_name]
                rtype             = args[:rtype]
                port              = args[:port]
                actual_rdata      = args[:actual_rdata]
                message           = Dnsruby::Message.new(domain_name, rtype)
                message.header.rd = 1
                r = ""
                server_list.each do |server|
                    res        = Dnsruby::Resolver.new({:nameserver => server})
                    res.port   = port
                    ret, error = res.send_plain_message(message)
                    puts "---> from: #{server} get: #{ret.answer} with error: #{error.inspect}"
                    bfind      = ret.answer.find {|rrs| rrs.to_s.include?(actual_rdata)} 
                    if bfind
                        r += "succeed to verify domain #{domain_name} in server #{server} answer: #{ret.answer.to_s}\n"
                    else
                        r += "failed to verify domain #{domain_name} in server #{server} answer: #{ret.answer.to_s}\n"
                    end
                end
                puts r
                return r
            end
            # using 'dig' to replace dnsruby library method
            def compare_domain(args)
                server_list  = args[:server_list]
                domain       = args[:domain_name]
                rtype        = args[:rtype]
                rdata        = args[:actual_rdata]
                rdata        = (rtype == "NAPTR") ? rdata : rdata.downcase
                r            = ""
                failed_rlist = []
                @timeout     = 30
                sleep 15 if args[:sleepfirst]
                server_list.each do |server|
                    dig_pass = "succeed to dig @#{server} #{domain} #{rtype} => #{rdata}"
                    dig = `dig @#{server} #{domain} #{rtype}`
                    if dig.include?(rdata)
                        puts dig_pass
                    else
                        puts "dig @#{server} #{domain} #{rtype} failed as expected!" if args[:expected_dig_fail]
                        return "succeed" if args[:expected_dig_fail]
                        begin
                            Timeout::timeout(@timeout){
                                while !dig.include?(rdata)
                                    sleep 5
                                    dig_retry = `dig @#{server} #{domain} #{rtype}`
                                    puts dig_pass if dig_retry.include?(rdata)
                                    break if dig_retry.include?(rdata)
                                end
                            }
                        rescue Timeout::Error
                            puts "Error => dig @#{server} #{domain} #{rtype} timed out!"
                            failed_rlist << "failed"
                        end
                    end
                end
                failed_rlist.empty? ? 'succeed' : 'failed'
            end
        end
    end
end
