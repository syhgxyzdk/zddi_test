# encoding: utf-8
require File.dirname(__FILE__) + '/../../zddi'

module ZDDI
	module DNS
		class Local_policies
            def case_9496(args)
                @case_ID           = __method__.to_s.split('_')[1]
                r                  = []
                args[:view_name]   = "default"
                args[:domain_name] = "case_9496_dig.underline"
                args[:local_type]  = "重定向"
                args[:ttl]         = "3600"
                args[:ip]          = "192.168.94.96"
                begin
                    r << Recu_er.create_local_policies(args)
                    args[:rtype]        = "A"
                    args[:server_list]  = Node_IP_List
                    args[:actual_rdata] = args[:ip]
                    args[:sleepfirst]   = 'yes'
                    r << Dig_er.compare_domain(args)
                    r << Recu_er.del_local_policies(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_9501(args)
                # 配置后重启
                @case_ID           = __method__.to_s.split('_')[1]
                r                  = []
                args[:view_name]   = "default"
                args[:domain_name] = "case.#{@case_ID}"
                args[:local_type]  = "重定向"
                args[:ttl]         = "3600"
                args[:ip]          = "192.168.95.1"
                begin
                    r << Recu_er.create_local_policies(args)
                    args[:rtype]        = "A"
                    args[:server_list]  = Node_IP_List
                    args[:actual_rdata] = args[:ip]
                    args[:sleepfirst]   = 'yes'
                    r << Dig_er.compare_domain(args)
                    # 重启DNS
                    Node_Name_List.each do |nodeName|
                        args[:node_name] = nodeName
                        r << Cloud.restart_device_dns_service(args)
                    end
                    args[:rtype]        = "A"
                    args[:server_list]  = Node_IP_List
                    args[:actual_rdata] = args[:ip]
                    args[:sleepfirst]   = 'yes'
                    r << Dig_er.compare_domain(args)
                    r << Recu_er.del_local_policies(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_7956(args)
                @case_ID          = __method__.to_s.split('_')[1]
                r                 = []
                ip                = "192.168.79.56"
                err               = "@!"
                ttl               = "3600"
                rname             = "case.7956"
                error_info1       = "必选字段"
                error_info2       = "域名格式不正确"
                error_info3       = "TTL值的范围为:0-2147483647"
                error_info4       = "IP地址格式不正确"
                args[:error_type] = "before_OK"
                invalid_rrs       = {
                    error_info1=>["", "", ""], 
                    error_info2=>[err, ttl, ip], 
                    error_info3=>[rname, err, ip], 
                    error_info4=>[rname,ttl,err]
                }

                begin
                    invalid_rrs.each_pair do |error_info, rr|
                        args[:error_info]  = error_info
                        args[:domain_name] = rr[0]
                        args[:ttl]         = rr[1]
                        args[:ip]          = rr[2]
                        DNS.inputs_local_policies_dialog(args)
                        r << DNS.error_validator_on_popwin(args)
                    end
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_8010(args)
                @case_ID           = __method__.to_s.split('_')[1]
                r                  = []
                args[:view_name]   = "view_8010"
                args[:acl_list]    = ["test_acl"]
                args[:owner_list]  = [Master_Device]
                args[:ttl]         = "3600"
                args[:domain_name] = "case.8010"
                args[:ip]          = "192.168.80.10"
                args[:error_type]  = "after_OK"
                args[:error_info]  = "本地域名策略重复"
                begin
                    r << View_er.create_view(args)
                    DNS.inputs_local_policies_dialog(args)
                    r << DNS.waiting_operate_finished
                    DNS.inputs_local_policies_dialog(args)
                    r << DNS.error_validator_on_popwin(args)
                    View_er.del_view(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_8008(args)
                @case_ID           = __method__.to_s.split('_')[1]
                r                  = []
                args[:view_name]   = "view_#{@case_ID}"
                args[:owner_list]  = [Master_Device]
                args[:local_type]  = '重定向'
                args[:domain_name] = "case.#{@case_ID}"
                args[:ttl]         = "3600"
                args[:ip]          = "192.168.80.8"
                begin
                    r << View_er.create_view(args)
                    r << Recu_er.create_local_policies(args)
                    r << View_er.del_view(args)
                    # 删除视图后本地策略被联动删除验证
                    DNS.open_local_policies_page
                    r << DNS.check_single_local_policies(args, expected_fail=true)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_8382(args)
                #新建3种重定向 + 删除
                @case_ID               = __method__.to_s.split('_')[1]
                r                      = []
                args[:view_name]       = "view_8382"
                args[:owner_list]      = [Master_Device]
                args[:ttl]             = "3600"
                rname                  = "case.8382"
                args[:ip]              = "192.168.83.82"
                rname_with_policy_type = {
                    ".redirect"=>"重定向",
                    ".nxdomain"=>"无域名", 
                    ".noerror"=>"无记录"
                }
                begin
                    r << View_er.create_view(args)
                    rname_with_policy_type.each_pair do |ext, type|
                        args[:domain_name] = rname + ext
                        args[:local_type]  = type
                        r << Recu_er.create_local_policies(args)
                        r << Recu_er.del_local_policies(args) #返回是否删除成功
                    end
                    r << View_er.del_view(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_8002(args)
                #新建"北龙.软件园"重定向, dig正常
                @case_ID           = __method__.to_s.split('_')[1]
                r                  = []
                args[:view_name]   = "default"
                args[:ttl]         = "3600"
                args[:domain_name] = "北龙.软件园"
                args[:ip]          = "192.168.80.2"
                args[:local_type]  = '重定向'
                begin
                    r << Recu_er.create_local_policies(args)
                    args[:rtype]        = "A"
                    args[:server_list]  = Node_IP_List
                    args[:domain_name]  = "xn--djr839o.xn--5nqz7q5o3c"
                    args[:actual_rdata] = args[:ip]
                    args[:sleepfirst]   = 'yes'
                    r << Dig_er.compare_domain(args)
                    args[:domain_name] = "北龙.软件园"
                    r << Recu_er.del_local_policies(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_7972(args)
                @case_ID           = __method__.to_s.split('_')[1]
                r                  = []
                args[:view_name]   = "default"
                args[:ttl]         = "3600"
                args[:domain_name] = "case.7972"
                args[:ip]          = "192.168.79.72"
                args[:local_type]  = '重定向'
                begin
                    r << Recu_er.create_local_policies(args)
                    args[:rtype]        = "A"
                    args[:server_list]  = Node_IP_List
                    args[:actual_rdata] = args[:ip]
                    args[:sleepfirst]   = 'yes'
                    r << Dig_er.compare_domain(args)
                    r << Recu_er.del_local_policies(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_8378(args)
                # 编辑重定向, dig正常
                @case_ID           = __method__.to_s.split('_')[1]
                r                  = []
                args[:view_name]   = "default"
                args[:domain_name] = "case.8378"
                args[:local_type]  = '重定向'
                args[:ttl]         = "3600"
                args[:ip]          = "192.168.83.78"
                begin
                    r << Recu_er.create_local_policies(args)
                    args[:rtype]        = "A"
                    args[:server_list]  = Node_IP_List
                    args[:actual_rdata] = args[:ip]
                    args[:sleepfirst]   = 'yes'
                    r << Dig_er.compare_domain(args)
                    # 编辑
                    args[:new_ttl] = "1800"
                    args[:new_ip]  = "192.168.78.83"
                    r << Recu_er.edit_local_policies(args)
                    args[:rtype]        = "A"
                    args[:server_list]  = Node_IP_List
                    args[:actual_rdata] = args[:new_ip]
                    args[:sleepfirst]   = 'yes'
                    r << Dig_er.compare_domain(args)
                    # 删除
                    r << Recu_er.del_local_policies(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_7987(args)
                # 本地策略配置无域名
                @case_ID           = __method__.to_s.split('_')[1]
                r                  = []
                args[:view_name]   = "default"
                args[:domain_name] = "case.#{@case_ID}"
                args[:local_type]  = "无域名"
                args[:rtype]       = 'A'
                begin
                    r << Recu_er.create_local_policies(args)
                    # Dig
                    Node_IP_List.each do |node_ip|
                        args[:dig_ip] = node_ip
                        r << DNS.dig_as_nxdomain(args)
                    end
                    # 删除
                    r << Recu_er.del_local_policies(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_7986(args)
                # 本地策略配置无记录
                @case_ID           = __method__.to_s.split('_')[1]
                r                  = []
                args[:view_name]   = "default"
                args[:domain_name] = "case.#{@case_ID}"
                args[:local_type]  = "无记录"
                args[:rtype]       = 'A'
                begin
                    r << Recu_er.create_local_policies(args)
                    # Dig
                    Node_IP_List.each do |node_ip|
                        args[:dig_ip] = node_ip
                        r << DNS.dig_as_nodata(args)
                    end
                    # 删除
                    r << Recu_er.del_local_policies(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_8003(args)
                # 本地策略配置无域名-中文
                @case_ID           = __method__.to_s.split('_')[1]
                r                  = []
                args[:view_name]   = "default"
                args[:domain_name] = "用例.#{@case_ID}"
                args[:local_type]  = "无域名"
                args[:rtype]       = 'A'
                begin
                    r << Recu_er.create_local_policies(args)
                    # Dig
                    Node_IP_List.each do |node_ip|
                        args[:dig_ip] = node_ip
                        r << DNS.dig_as_nxdomain(args)
                    end
                    # 删除
                    r << Recu_er.del_local_policies(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_8004(args)
                # 本地策略配置无记录-中文
                @case_ID           = __method__.to_s.split('_')[1]
                r                  = []
                args[:view_name]   = "default"
                args[:domain_name] = "用例.#{@case_ID}"
                args[:local_type]  = "无记录"
                args[:rtype]       = 'A'
                begin
                    r << Recu_er.create_local_policies(args)
                    # Dig
                    Node_IP_List.each do |node_ip|
                        args[:dig_ip] = node_ip
                        r << DNS.dig_as_nodata(args)
                    end
                    # 删除
                    r << Recu_er.del_local_policies(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_8379(args)
                # 编辑本地策略  重定向->无域名->无记录
                @case_ID           = __method__.to_s.split('_')[1]
                r                  = []
                args[:view_name]   = "default"
                args[:domain_name] = "case.#{@case_ID}"
                args[:local_type]  = "重定向"
                args[:rtype]       = 'A'
                args[:ip]          = '192.168.83.79'
                args[:ttl]         = '5'
                begin
                    r << Recu_er.create_local_policies(args)
                    Node_IP_List.each do |node_ip|
                        args[:dig_ip] = node_ip
                        r << DNS.dig_as_noerror(args)
                    end
                    # 编辑
                    args[:new_local_type] = "无域名"
                    r << Recu_er.edit_local_policies(args)
                    # Dig
                    Node_IP_List.each do |node_ip|
                        args[:dig_ip] = node_ip
                        r << DNS.dig_as_nxdomain(args)
                    end
                    # 编辑
                    args[:new_local_type] = "无记录"
                    r << Recu_er.edit_local_policies(args)
                    # Dig
                    Node_IP_List.each do |node_ip|
                        args[:dig_ip] = node_ip
                        r << DNS.dig_as_nodata(args)
                    end
                    # 删除
                    r << Recu_er.del_local_policies(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_8380(args)
                # 编辑本地策略  无记录->重定向->无域名
                @case_ID           = __method__.to_s.split('_')[1]
                r                  = []
                args[:view_name]   = "default"
                args[:domain_name] = "case.#{@case_ID}"
                args[:local_type]  = "无记录"
                args[:rtype]       = 'A'
                begin
                    r << Recu_er.create_local_policies(args)
                    Node_IP_List.each do |node_ip|
                        args[:dig_ip] = node_ip
                        r << DNS.dig_as_nodata(args)
                    end
                    # 编辑
                    args[:new_local_type] = '重定向'
                    args[:new_ip]         = '192.168.83.80'
                    args[:new_ttl]        = '5'
                    r << Recu_er.edit_local_policies(args)
                    # Dig
                    Node_IP_List.each do |node_ip|
                        args[:dig_ip] = node_ip
                        r << DNS.dig_as_noerror(args)
                    end
                    # 编辑
                    args[:new_local_type]  = "无域名"
                    r << Recu_er.edit_local_policies(args)
                    # Dig
                    Node_IP_List.each do |node_ip|
                        args[:dig_ip] = node_ip
                        r << DNS.dig_as_nxdomain(args)
                    end
                    # 删除
                    r << Recu_er.del_local_policies(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_8381(args)
                # 编辑本地策略  无域名->无记录->重定向
                @case_ID           = __method__.to_s.split('_')[1]
                r                  = []
                args[:view_name]   = "default"
                args[:domain_name] = "case.#{@case_ID}"
                args[:local_type]  = "无域名"
                args[:rtype]       = 'A'
                begin
                    r << Recu_er.create_local_policies(args)
                    Node_IP_List.each do |node_ip|
                        args[:dig_ip] = node_ip
                        r << DNS.dig_as_nxdomain(args)
                    end
                    # 编辑
                    args[:new_local_type]  = "无记录"
                    r << Recu_er.edit_local_policies(args)
                    # Dig
                    Node_IP_List.each do |node_ip|
                        args[:dig_ip] = node_ip
                        r << DNS.dig_as_nodata(args)
                    end
                    # 编辑
                    args[:new_local_type] = "重定向"
                    args[:new_ip]         = '192.168.83.81'
                    args[:new_ttl]        = '5'
                    r << Recu_er.edit_local_policies(args)
                    # Dig
                    Node_IP_List.each do |node_ip|
                        args[:dig_ip] = node_ip
                        r << DNS.dig_as_noerror(args)
                    end
                    # 删除
                    r << Recu_er.del_local_policies(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_8005(args)
                # 非default视图
                @case_ID           = __method__.to_s.split('_')[1]
                r                  = []
                args[:view_name]   = "view_#{@case_ID}"
                args[:owner_list]  = Node_Name_List
                args[:acl_name]    = "acl_#{@case_ID}"
                args[:acl_list]    = Local_Network
                args[:domain_name] = "case.#{@case_ID}"
                args[:local_type]  = "重定向"
                args[:ip]          = '192.168.80.5'
                args[:ttl]         = '10'
                args[:rtype]       = 'A'
                begin
                    r << ACL_er.create_acl(args)
                    r << View_er.create_view(args)
                    r << Recu_er.create_local_policies(args)
                    # Dig
                    Node_IP_List.each do |node_ip|
                        args[:dig_ip] = node_ip
                        r << DNS.dig_as_noerror(args)
                    end
                    # 删除
                    r << Recu_er.del_local_policies(args)
                    r << View_er.del_view(args)
                    r << ACL_er.del_acl(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_8385(args)
                # 查询功能, 支持所有字段
                @case_ID = __method__.to_s.split('_')[1]
                r        = []
                begin
                    # 创建三个本地策略 '重定向' '无域名' '无记录', 其中一个添加备注.
                    args[:view_name]  = "view_#{@case_ID}"
                    args[:owner_list] = Node_Name_List
                    r << View_er.create_view(args)
                    args[:strategy_name] = "宕机切换_#{@case_ID}"
                    r << ACL_Mng_er.create_monitor_strategy(args)
                    args[:domain_name] = "case.#{@case_ID}_1" # <------ 记录1
                    args[:local_type]  = '重定向'
                    args[:ttl]         = '1200'
                    args[:ip]          = '192.168.83.85'
                    r << Recu_er.create_local_policies(args)
                    args[:view_name]   = 'default'
                    args[:domain_name] = "case.#{@case_ID}_2" # <------ 记录2
                    args[:local_type]  = "无域名"
                    r << Recu_er.create_local_policies(args)
                    args[:domain_name] = "case.#{@case_ID}_3" # <------ 记录3
                    args[:local_type]  = "无记录"
                    r << Recu_er.create_local_policies(args)
                    # 添加备注
                    @comment = "用来查询本地策略的备注, 用例#{@case_ID}"
                    DNS.open_local_policies_page
                    r << DNS.input_comments(@comment)
                    # 查询7字段
                    {'重定向' =>"case.#{@case_ID}_1",
                     '无域名' =>"case.#{@case_ID}_2",
                     '无记录' =>"case.#{@case_ID}_3",
                     '本地策' =>"case.#{@case_ID}_1",
                     '宕机切' =>"case.#{@case_ID}_1",
                     '192.16' =>"case.#{@case_ID}_1",
                     'view'   =>"case.#{@case_ID}_1", 
                     '1200'   =>"case.#{@case_ID}_1"               
                    }.each_pair do |search_keyword, match_keyword|
                        args[:search_keyword] = search_keyword
                        args[:match_keyword] = match_keyword
                        r << Recu_er.search_local_policies(args)
                    end
                    # 删除
                    args[:view_name] = "view_#{@case_ID}"
                    r << View_er.del_view(args)
                    r << Recu_er.del_all_local_policies
                    r << ACL_Mng_er.del_monitor_strategy(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_14517(args)
                @case_ID               = __method__.to_s.split('_')[1]
                r                      = []
                args[:error_type]      = 'after_OK'
                inputs_list = [
                    'v_14517 case.14517 redirect 5 192.168.145.17 N/A N/A',
                    'default case.14517 invalid 5 192.168.145.17 N/A N/A',
                    'default case.14517 redirect 5 192.168.145.17 nxd N/A'
                ]
                inputs_with_error_info = {
                    inputs_list[0] => "操作不存在的视图\n记录序列号:1\n#{inputs_list[0]}",
                    inputs_list[1] => "资源记录格式无效\n记录序列号:1\n#{inputs_list[1]}",
                    inputs_list[2] => "操作不存在的宕机切换策略\n记录序列号:1\n#{inputs_list[2]}"
                }
                begin
                    DNS.open_local_policies_page
                    inputs_with_error_info.each_pair do |inputs, error_info|
                        args[:imported_lines] = [inputs]
                        args[:error_info]     = error_info
                        DNS.popup_right_menu('batchCreate')
                        r << DNS.inputs_import_dialog(args)
                        r << DNS.error_validator_on_popwin(args)
                    end
                    # '本地域名策略重复'
                    dup_line = 'default case.14517 redirect 5 192.168.145.17 N/A N/A'
                    args[:imported_lines] = [dup_line, dup_line]
                    args[:error_info]     = "本地域名策略重复\n记录序列号:2\n#{dup_line}"
                    DNS.popup_right_menu('batchCreate')
                    r << DNS.inputs_import_dialog(args)
                    r << DNS.error_validator_on_popwin(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_14519(args)
                @case_ID           = __method__.to_s.split('_')[1]
                r                  = []
                args[:view_name]   = 'default'
                args[:domain_name] = "case.#{@case_ID}"
                args[:local_type]  = '重定向'
                args[:ttl]         = '1200'
                args[:ip]          = '192.168.83.85'
                args[:error_type]  = 'after_OK'
                begin
                    r << Recu_er.create_local_policies(args)
                    # '本地域名策略重复',
                    dup_line = 'default case.14519 redirect 5 192.168.145.19 N/A N/A'
                    args[:imported_lines] = [dup_line, dup_line]
                    args[:error_info]     = '本地域名策略重复'
                    DNS.open_local_policies_page
                    DNS.popup_right_menu('batchCreate')
                    r << DNS.inputs_import_dialog(args)
                    r << DNS.error_validator_on_popwin(args)
                    r << Recu_er.del_local_policies(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_14520(args)
                # 导入导出中文域名, 对比文件
                @case_ID             = __method__.to_s.split('_')[1]
                r                    = []
                args[:view_name]     = "中文视图_#{@case_ID}"
                args[:owner_list]    = [Master_Device]
                args[:imported_file] = Upload_Dir + 'zone\14520.txt'
                args[:exported_file] = Download_Dir + 'local-policies.txt'
                args[:local_type]    = '重定向'
                args[:ttl]           = '1200'
                args[:ip]            = '192.168.145.20'
                @domain_name         = "中文域名.#{@case_ID}"
                begin
                    r << View_er.create_view(args)
                    1.upto(3) do |id|
                        args[:domain_name] = "#{@domain_name}_#{id}"
                        r << Recu_er.create_local_policies(args)
                    end
                    # 导出, 验证, 删除文件
                    r << Recu_er.export_local_policies(args)
                    r << Recu_er.compare_exported_local_policies_file(args)
                    r << DNS.delete_exported_file(args)
                    # 删除, 再导入
                    r << Recu_er.del_all_local_policies
                    r << Recu_er.import_local_policies(args)
                    # 导入验证
                    1.upto(3) do |id|
                        args[:domain_name] = "#{@domain_name}_#{id}"
                        r << DNS.check_single_local_policies(args)
                    end
                    # 清理
                    1.upto(3) do |id|
                        args[:domain_name] = "#{@domain_name}_#{id}"
                        r << Recu_er.del_local_policies(args)
                    end
                    r << View_er.del_view(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_14521(args)
                # 导入 + dig
                @case_ID              = __method__.to_s.split('_')[1]
                r                     = []
                args[:acl_name]       = "acl_#{@case_ID}"
                args[:acl_list]       = Local_Network
                args[:view_name]      = "view_#{@case_ID}"
                args[:owner_list]     = [Master_Device]
                args[:imported_file]  = Upload_Dir + 'zone\14521.txt'
                args[:imported_lines] = []
                @domain_name          = "case.#{@case_ID}"
                begin
                    r << ACL_er.create_acl(args)
                    r << View_er.create_view(args)
                    # 生成要导入的文件
                    1.upto(3) do |id|
                        line = "#{args[:view_name]} #{@domain_name}_#{id} redirect 5 192.168.145.21 N/A N/A"
                        args[:imported_lines] << line
                    end
                    r << Recu_er.generate_local_policies_file_for_importing(args)
                    r << Recu_er.import_local_policies(args)
                    # Dig
                    args[:dig_ip] = Master_IP
                    args[:rtype]  = 'A'
                    1.upto(3) do |id|
                        args[:domain_name] = "#{@domain_name}_#{id}"
                        r << DNS.dig_as_noerror(args)
                    end
                    # 删除
                    r << View_er.del_view(args)
                    r << ACL_er.del_acl(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_20144(args)
                @case_ID           = __method__.to_s.split('_')[1]
                r                  = []
                args[:view_name]   = 'default'
                args[:domain_name] = "case.#{@case_ID}"
                begin
                    args[:local_type]   = '白名单'
                    r << Recu_er.create_local_policies(args)
                    Node_IP_List.each do |ip|
                        args[:dig_ip] = ip
                        r << DNS.dig_as_nxdomain(args)
                    end
                    r << Recu_er.del_local_policies(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_20145(args)
                @case_ID           = __method__.to_s.split('_')[1]
                r                  = []
                args[:view_name]   = 'default'
                args[:domain_name] = "case.#{@case_ID}"
                args[:ttl]         = '1200'
                args[:ip]          = '192.168.20.145'
                begin
                    args[:local_type]   = '重定向'
                    r << Recu_er.create_local_policies(args)
                    args[:server_list]  = Node_IP_List
                    args[:rtype]        = "A"
                    args[:actual_rdata] = args[:ip]
                    r << Dig_er.compare_domain(args)
                    # 编辑成白名单后自动出去递归
                    args[:new_local_type] = '白名单'
                    r << Recu_er.edit_local_policies(args)
                    Node_IP_List.each do |ip|
                        args[:dig_ip] = ip
                        r << DNS.dig_as_nxdomain(args)
                    end
                    r << Recu_er.del_local_policies(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_20146(args)
                @case_ID           = __method__.to_s.split('_')[1]
                r                  = []
                args[:view_name]   = 'default'
                args[:domain_name] = "case.#{@case_ID}"
                begin
                    args[:local_type] = '白名单'
                    r << Recu_er.create_local_policies(args)
                    r << Recu_er.del_local_policies(args)
                    Node_IP_List.each do |ip|
                        args[:dig_ip] = ip
                        r << DNS.dig_as_nxdomain(args)
                    end
                    # 检查日志
                    args[:log_string] = "删除本地策略: #{args[:view_name]}/#{args[:domain_name]} #{args[:local_type]}"
                    r << System.log_validator_on_audit_log_page(args)
                rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
		end
	end
end