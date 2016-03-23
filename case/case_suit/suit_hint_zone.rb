# encoding: utf-8
require File.dirname(__FILE__) + '/../../zddi'
module ZDDI
    module DNS
        class Hint_zone
            def set_ttl_5(args) # set cache ttl to 5 to ensure digging works.
                @case_ID = "set_ttl_to_5s"
                r        = Recu_er.set_ttl_to_5s(args)
                r.include?('succeed') ? "succeed in case #{@case_ID}": "failed case #{@case_ID}"
            end
            def reset_ttl(args) # Reset ttl after hint_zone case done.
                @case_ID = "reset_ttl"
                r        = Recu_er.reset_cache_settings(args)
                r.include?('succeed') ? "succeed in case #{@case_ID}": "failed case #{@case_ID}"
            end
            def case_5820(args)
                # 参数校验, 根配置只允许输入A/AAAA和NS记录
                @case_ID          = __method__.to_s.split('_')[1]
                r                 = []
                args[:view_name]  = "default"
                args[:owner_list] = Node_Name_List
                args[:error_type] = "after_OK"
                args[:error_info] = "根配置只允许存在A/AAAA和NS记录"
                domain            = {}
                domain['ttl']     = '3600'
                rtype_with_rdata  = {
                    "MX"=>"5 ns.",
                    "CNAME"=>"cname.com.",
                    "DNAME"=>"dname.com.",
                    "TXT"=>"text",
                    "SRV"=>"65 5 35 srv.com.",
                    "PTR"=>"ptr.com.",
                    "NAPTR"=>"101 10 \"u\" \"sip+E2U\" \"!^.*$!sip:userA@zdns.cn!\" ."
                }
                begin
                    r << Recu_er.create_hint_zone(args)
                    DNS.open_hint_zone_rr_page(args)
                    # 循环验证A/AAAA和NS记录以外的记录都不能新建
                    rtype_with_rdata.each_pair do |rtype, rdata|
                        domain['rname'] = "rootHint_#{rtype}"
                        domain['rtype'] = rtype
                        domain['rdata'] = rdata
                        DNS.inputs_domain_dialog(domain)
                        r << DNS.error_validator_on_popwin(args)
                    end
                    r << Recu_er.del_hint_zone(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_5818(args)
                @case_ID          = __method__.to_s.split('_')[1]
                r                 = []
                args[:view_name]  = "default"
                args[:owner_list] = Node_Name_List
                commentAdd        = "添加备注"
                commentEdit       = "修改备注"
                begin
                    r << Recu_er.create_hint_zone(args)
                    DNS.open_hint_zone_page
                    r << DNS.input_comments(commentAdd)
                    r << DNS.input_comments(commentEdit)
                    r << Recu_er.del_hint_zone(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_5803(args)
                # 参数校验, 创建根配置时输入空
                @case_ID           = __method__.to_s.split('_')[1]
                r                  = []
                args[:view_name]   = "default"
                args[:owner_list]  = Node_Name_List
                args[:hint_config] = [""]
                args[:error_type]  = "before_OK"
                args[:error_info]  = "必选字段"
                begin
                    DNS.inputs_create_hint_zone_dialog(args)
                    r << DNS.error_validator_on_popwin(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_5804(args)
                # 参数校验, 创建根配置时输入记录格式无效
                @case_ID          = __method__.to_s.split('_')[1]
                r                 = []
                args[:error_type] = "after_OK"
                args[:error_info] = "资源记录格式无效"
                args[:view_name]  = "default"
                args[:owner_list] = Node_Name_List
                hint_config_list  = [
                    [". ns ns.", "sn. A 127.0.0.1"],
                    [". ns ns.", "ns. A ABCD::1234"],
                    [". ns ns.", "ns. AAAA 127.0.0.1"]
                ]
                begin
                    hint_config_list.each do |hint_config|
                        args[:hint_config] = hint_config
                        DNS.inputs_create_hint_zone_dialog(args)
                        r << DNS.error_validator_on_popwin(args)
                    end
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_5814(args)
                # 新建某视图的根配置 >> 再删除
                @case_ID          = __method__.to_s.split('_')[1]
                r                 = []
                args[:ttl]        = "3600"
                args[:view_name]  = "view_#{@case_ID}"
                args[:owner_list] = [Master_Device]
                begin
                    r << View_er.create_view(args)
                    r << Recu_er.create_hint_zone(args)
                    r << Recu_er.del_hint_zone(args)
                    r << View_er.del_view(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_5813(args)
                # 导出根配置
                @case_ID          = __method__.to_s.split('_')[1]
                r                 = []
                args[:view_name]  = "view_#{@case_ID}"
                args[:owner_list] = Node_Name_List
                begin
                    r << View_er.create_view(args)
                    r << Recu_er.create_hint_zone(args)
                    r << Recu_er.export_hint_zone(args)
                    r << View_er.del_view(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_5819(args)
                # 新建NS/A/AAAA记录成功
                @case_ID           = __method__.to_s.split('_')[1]
                r                  = []
                args[:view_name]   = "view_#{@case_ID}"
                args[:owner_list]  = [Master_Device]
                args[:domain_list] = [
                    {"rname"=>"case.5819.ns", "rtype"=>"A", "rdata"=>"192.168.58.19", "ttl"=>"3600"},
                    {"rname"=>"case.5819.ns", "rtype"=>"NS", "rdata"=>"case.5819.ns.", "ttl"=>"3600"},
                    {"rname"=>"case.5819.ns", "rtype"=>"AAAA", "rdata"=>"ABCD::5819", "ttl"=>"3600"}
                ]
                begin
                    r << View_er.create_view(args)
                    r << Recu_er.create_hint_zone(args)
                    r << Recu_er.create_hint_zone_rr(args)
                    r << View_er.del_view(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}" 
            end
            def case_5805(args)
                @case_ID          = __method__.to_s.split('_')[1]
                r                 = []
                args[:view_name]  = "view_5805"
                args[:owner_list] = Node_Name_List
                args[:error_type] = "after_OK"
                args[:error_info] = "资源记录格式无效"
                args[:hint_file]  = Upload_Dir + 'hint_zone\5805.txt'
                begin 
                    r << View_er.create_view(args)
                    DNS.inputs_create_hint_zone_dialog(args)
                    r << DNS.error_validator_on_popwin(args)
                    r << View_er.del_view(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_5807(args)
                @case_ID          = __method__.to_s.split('_')[1]
                r                 = []
                args[:view_name]  = "view_5807"
                args[:owner_list] = Node_Name_List
                args[:error_type] = "before_OK"
                args[:error_info] = "超过最大输入限制(200条)"
                file_201_rr       = Upload_Dir + 'hint_zone\5807_201_rr.txt'
                file_200_rr       = Upload_Dir + 'hint_zone\5807_200_rr.txt'
                begin
                    r << View_er.create_view(args)
                    r << Recu_er.create_hint_zone(args)
                    # 导入201条
                    DNS.open_hint_zone_rr_page(args)
                    args[:hint_rr_file] = file_201_rr
                    DNS.inputs_import_hint_zone_rr_dialog(args)
                    r << DNS.error_validator_on_popwin(args)
                    # 导入200条
                    args[:hint_rr_file] = file_200_rr
                    DNS.inputs_import_hint_zone_rr_dialog(args)
                    r << DNS.waiting_operate_finished
                    # 检查导入成功
                    DNS.open_hint_zone_rr_page(args)
                    if ZDDI.browser.div(:id, "mainTable").span(:class, "total").present?
                        number = ZDDI.browser.div(:id, "mainTable").span(:class, "total").text
                        if number != "202"
                            puts "Not found 202 rdata after importing hint_zone_rr"
                            r << "failed" if number != "202"
                        end
                    end
                    r << View_er.del_view(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_5809(args)
                @case_ID          = __method__.to_s.split('_')[1]
                r                 = []
                args[:view_name]  = "view_5809"
                args[:owner_list] = Node_Name_List
                args[:error_type] = "before_OK"
                args[:error_info] = "请勿输入重复项"
                args[:hint_file]  = Upload_Dir + 'hint_zone\5809.txt'
                begin
                    r << View_er.create_view(args)
                    DNS.inputs_create_hint_zone_dialog(args)
                    r << DNS.waiting_operate_finished
                    r << View_er.del_view(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"   
            end
            def case_5822(args)
                r                 = []
                @case_ID          = __method__.to_s.split('_')[1]
                args[:ttl]        = "3600"
                args[:view_name]  = "view_5822"
                args[:owner_list] = Node_Name_List
                non_A_NS_file     = Upload_Dir + 'hint_zone\5822.txt'
                args[:error_type] = 'after_OK'
                args[:error_info] = "根配置只允许存在A/AAAA和NS记录\n记录序列号:1\n资源记录:www.1.txt. 3600 IN TXT text string"
                begin
                    r << View_er.create_view(args)
                    r << Recu_er.create_hint_zone(args)
                    # 导入 + 校验
                    DNS.open_hint_zone_rr_page(args)
                    DNS.popup_right_menu("batchCreate")
                    DNS.popwin.file_field(:name, "zone_file").click
                    DNS.open_dialog(non_A_NS_file)
                    r << DNS.error_validator_on_popwin(args)
                    r << View_er.del_view(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_5832(args)
                @case_ID          = __method__.to_s.split('_')[1]
                r                 = []
                args[:view_name]  = "view_5832"
                args[:owner_list] = Node_Name_List
                args[:hint_file]  = Upload_Dir + 'hint_zone\5832.txt'
                begin
                    r << View_er.create_view(args)
                    # 用导出文件新建根
                    r << Recu_er.create_hint_zone(args)
                    r << View_er.del_view(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_9502(args)
                # 配置后重启
                @case_ID          = __method__.to_s.split('_')[1]
                r                 = []
                args[:view_name]  = "view_#{@case_ID}"
                args[:owner_list] = Node_Name_List
                args[:keyword]    = "zone \".\" {\ntype hint;"
                begin
                    r << View_er.create_view(args)
                    r << Recu_er.create_hint_zone(args)
                    # grep named
                    r << DNS.grep_keyword_named(args)
                    # 重启
                    Node_Name_List.each do |nodeName|
                        args[:node_name] = nodeName
                        r << Cloud.stop_device_dns_service(args)
                        r << Cloud.start_device_dns_service(args)
                    end
                    # 验证
                    r << DNS.grep_keyword_named(args)
                    # 清理
                    r << View_er.del_view(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_9771(args)
                # 根配置指向真实IP(slave ip)
                @case_ID  = __method__.to_s.split('_')[1]
                r         = []
                @tmp_view = "view_#{@case_ID}"
                @rdata    = "192.168.97.71"
                begin
                    # Slave上建区+记录
                    args[:acl_name]     = "acl_#{@case_ID}"
                    args[:acl_list]     = [Master_IP]
                    args[:owner_list]   = [Slave_Device]
                    args[:view_name]    = @tmp_view
                    args[:zone_name]    = "zone.#{@case_ID}"
                    args[:domain_list]  = [{"rname"=>'a', "rtype"=>"A", "rdata"=>@rdata}]
                    r << ACL_er.create_acl(args)
                    r << View_er.create_view(args)
                    r << Zone_er.create_zone(args)
                    r << Domain_er.create_domain(args)
                    # Master的根指向Slave
                    args[:view_name]    = "default"
                    args[:owner_list]   = [Master_Device]
                    args[:hint_config]  = [". ns ns.", "ns. A #{Slave_IP}"]
                    r << Recu_er.create_hint_zone(args)
                    args[:server_list]  = [Master_IP]
                    args[:domain_name]  = "a.#{args[:zone_name]}"
                    args[:rtype]        = "A"
                    args[:actual_rdata] = @rdata
                    r << Dig_er.compare_domain(args)
                    # 清理
                    r << Recu_er.del_hint_zone(args)
                    args[:view_name] = @tmp_view
                    r << View_er.del_view(args)
                    r << ACL_er.del_acl(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_5811(args)
                # 修改节点 master >> all >> slave
                @case_ID         = __method__.to_s.split('_')[1]
                r                = []
                args[:view_name] = "view_#{@case_ID}"
                args[:keyword]   = "zone \".\" {\ntype hint;"
                begin
                    args[:owner_list] = Node_Name_List
                    r << View_er.create_view(args)
                    args[:owner_list] = [Master_Device]
                    r << Recu_er.create_hint_zone(args)
                    # grep master pass and slave fail
                    r << DNS.grep_keyword_named(args)
                    args[:owner_list] = [Slave_Device]
                    r << DNS.grep_keyword_named(args, keyword_gone=true)
                    # master >> all
                    args[:old_owner_list] = [Master_Device]
                    args[:new_owner_list] = Node_Name_List
                    r << Recu_er.modify_hint_zone_member(args)
                    # grep all pass
                    args[:owner_list] = Node_Name_List
                    r << DNS.grep_keyword_named(args)
                    # all >> slave
                    args[:old_owner_list] = Node_Name_List
                    args[:new_owner_list] = [Slave_Device]
                    r << Recu_er.modify_hint_zone_member(args)
                    # grep master fail and slave pass
                    args[:owner_list] = [Master_Device]
                    r << DNS.grep_keyword_named(args, keyword_gone=true)
                    args[:owner_list] = [Slave_Device]
                    r << DNS.grep_keyword_named(args)
                    # 清理
                    r << View_er.del_view(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_9500(args)
                # 指向真实IP(slave ip) + 下划线域名
                @case_ID  = __method__.to_s.split('_')[1]
                r         = []
                @tmp_view = "view_#{@case_ID}"
                @rname    = "under_line"
                @rdata    = "192.168.95.0"
                begin
                    # SLAVE 建区+记录
                    args[:acl_name]     = "acl_#{@case_ID}"
                    args[:acl_list]     = [Master_IP]
                    args[:owner_list]   = [Slave_Device]
                    args[:view_name]    = @tmp_view
                    args[:zone_name]    = "zone.#{@case_ID}"
                    args[:domain_list]  = [{"rname"=>@rname, "rtype"=>"A", "rdata"=>@rdata}]
                    r << ACL_er.create_acl(args)
                    r << View_er.create_view(args)
                    r << Zone_er.create_zone(args)
                    r << Domain_er.create_domain(args)
                    # default建根配置, 指向SLAVE
                    args[:view_name]    = "default"
                    args[:owner_list]   = [Master_Device]
                    args[:hint_config]  = [". ns ns.", "ns. A #{Slave_IP}"]
                    r << Recu_er.create_hint_zone(args)
                    args[:server_list]  = [Master_IP]
                    args[:domain_name]  = "#{@rname}.#{args[:zone_name]}"
                    args[:rtype]        = "A"
                    args[:actual_rdata] = @rdata
                    r << Dig_er.compare_domain(args)
                    # 清理
                    r << Recu_er.del_hint_zone(args)
                    args[:view_name] = @tmp_view
                    r << View_er.del_view(args)
                    r << ACL_er.del_acl(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_11680(args)
                # 权威区建根后再建根配置
                @case_ID          = __method__.to_s.split('_')[1]
                r                 = []
                @tmp_view_name    = "view_#{@case_ID}"
                @rname            = "multiple_hint"
                @rdata_expected   = "192.168.116.80"
                @rdata_unexpected = "192.168.80.116"
                begin
                    # Slave建区+记录
                    args[:acl_name]    = "acl_#{@case_ID}"
                    args[:acl_list]    = [Master_IP]
                    args[:owner_list]  = [Slave_Device]
                    args[:view_name]   = @tmp_view_name
                    args[:zone_name]   = "zone.#{@case_ID}"
                    args[:domain_list] = [{"rname"=>@rname, "rtype"=>"A", "rdata"=>@rdata_unexpected}]
                    r << ACL_er.create_acl(args)
                    r << View_er.create_view(args)
                    r << Zone_er.create_zone(args)
                    r << Domain_er.create_domain(args)
                    # default下新建权威根区.
                    args[:view_name]   = "default"
                    args[:zone_name]   = "@"
                    args[:owner_list]  = [Master_Device]
                    @domain            = "#{@rname}.zone.#{@case_ID}"
                    args[:domain_list] = [{"rname"=>@domain, "rtype"=>"A", "rdata"=>@rdata_expected}]
                    r << Zone_er.create_zone(args)
                    r << Domain_er.create_domain(args)
                    # default建根配置, 指向SLAVE
                    args[:hint_config]  = [". ns ns.", "ns. A #{Slave_IP}"]
                    args[:server_list]  = [Master_IP]
                    args[:domain_name]  = @domain
                    args[:rtype]        = "A"
                    args[:actual_rdata] = @rdata_expected
                    r << Recu_er.create_hint_zone(args)
                    r << Dig_er.compare_domain(args)
                    # 清理
                    r << Recu_er.del_hint_zone(args)
                    r << Zone_er.del_zone(args)
                    args[:view_name] = @tmp_view_name
                    r << View_er.del_view(args)
                    r << ACL_er.del_acl(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_5826(args)
                # 多条NS记录指向不同的A/AAAA
                @case_ID  = __method__.to_s.split('_')[1]
                r         = []
                @tmp_view = "view_#{@case_ID}"
                @rname    = "multiple_ns"
                @rdata    = "192.168.58.26"
                @aaaa     = "ABCD::5826"
                begin
                    # Slave上建区+记录
                    args[:acl_name]     = "acl_#{@case_ID}"
                    args[:acl_list]     = [Master_IP]
                    args[:owner_list]   = [Slave_Device]
                    args[:view_name]    = @tmp_view
                    args[:zone_name]    = "zone.#{@case_ID}"
                    args[:domain_list]  = [{"rname"=>@rname, "rtype"=>"A", "rdata"=>@rdata}]
                    r << ACL_er.create_acl(args)
                    r << View_er.create_view(args)
                    r << Zone_er.create_zone(args)
                    r << Domain_er.create_domain(args)
                    # default建根配置并添加A和AAAA记录.
                    args[:view_name]    = "default"
                    args[:owner_list]   = [Master_Device]
                    args[:domain_list]  = [
                        {"rname"=>"ns", "rtype"=>"A", "rdata"=>Slave_IP, "ttl"=>"3600"}, 
                        {"rname"=>"ns", "rtype"=>"AAAA", "rdata"=>@aaaa, "ttl"=>"3600"}]
                    r << Recu_er.create_hint_zone(args)
                    r << Recu_er.create_hint_zone_rr(args)
                    # Dig
                    args[:server_list]  = [Master_IP]
                    args[:domain_name]  = "#{@rname}.#{args[:zone_name]}"
                    args[:rtype]        = "A"
                    args[:actual_rdata] = @rdata
                    r << Dig_er.compare_domain(args)
                    # 清理
                    r << Recu_er.del_hint_zone(args)
                    args[:view_name] = @tmp_view
                    r << View_er.del_view(args)
                    r << ACL_er.del_acl(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_5825(args)
                # 编辑根配置中的A/AAAA/NS
                @case_ID           = __method__.to_s.split('_')[1]
                r                  = []
                view_name          = "view_#{@case_ID}"
                args[:view_name]   = view_name
                args[:owner_list]  = Node_Name_List
                args[:domain_list] = [
                    {"rname"=>"a_#{view_name}", "rtype"=>"A", "rdata"=>"192.168.58.25", "ttl"=>"3600"},
                    {"rname"=>"ns_#{view_name}", "rtype"=>"NS", "rdata"=>"a_#{view_name}.", "ttl"=>"3600"},
                    {"rname"=>"aaaa_#{view_name}", "rtype"=>"AAAA", "rdata"=>"5825::ABCD", "ttl"=>"3600"}
                ]
                begin
                    r << View_er.create_view(args)
                    r << Recu_er.create_hint_zone(args)
                    r << Recu_er.create_hint_zone_rr(args)
                    # edit A/AAAA, no NS since there is '.' at the end of domain.
                    args[:domain_list] = [
                        {"rname"=>"a_#{view_name}", "rtype"=>"A", "rdata_old"=>"192.168.58.25", "rdata_new"=>"192.168.25.58", "ttl_old"=>"3600", "ttl_new"=>"600"},
                        {"rname"=>"aaaa_#{view_name}", "rtype"=>"AAAA", "rdata_old"=>"5825::ABCD", "rdata_new"=>"5825::CDEF","ttl_old"=>"3600", "ttl_new"=>"600"}]
                    r << Recu_er.edit_hint_zone_rr(args)
                    r << View_er.del_view(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_5827(args)
                # 删除A记录 提示占用
                @case_ID          = __method__.to_s.split('_')[1]
                r                 = []
                view_name         = "view_#{@case_ID}"
                args[:view_name]  = view_name
                args[:owner_list] = Node_Name_List
                args[:rname]      = 'ns'
                args[:rtype]      = 'A'
                args[:rdata]      = "127.0.0.1"
                args[:error_type] = "after_OK"
                args[:error_info] = "ns. A 127.0.0.1:该glue记录被其他记录使用"
                begin
                    r << View_er.create_view(args)
                    r << Recu_er.create_hint_zone(args)
                    DNS.open_hint_zone_rr_page(args)
                    r << DNS.check_single_hint_zone_rr(args)
                    DNS.popup_right_menu('del')
                    r << DNS.error_validator_on_popwin(args)
                    r << View_er.del_view(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_5828(args)
                # 删除A记录 提示占用
                @case_ID          = __method__.to_s.split('_')[1]
                r                 = []
                view_name         = "view_#{@case_ID}"
                args[:view_name]  = view_name
                args[:owner_list] = Node_Name_List
                args[:rname]      = ''
                args[:rtype]      = 'NS'
                args[:rdata]      = "ns."
                args[:error_type] = "after_OK"
                args[:error_info] = ". NS ns.:不能删除所有的ns记录"
                begin
                    r << View_er.create_view(args)
                    r << Recu_er.create_hint_zone(args)
                    DNS.open_hint_zone_rr_page(args)
                    r << DNS.check_single_hint_zone_rr(args)
                    DNS.popup_right_menu('del')
                    r << DNS.error_validator_on_popwin(args)
                    r << View_er.del_view(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
        end
    end
end