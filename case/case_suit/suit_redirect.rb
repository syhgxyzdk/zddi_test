# encoding: utf-8
require File.dirname(__FILE__) + '/../../zddi'

module ZDDI
	module DNS
		class Redirect
			def case_1906(args)
				#参数校验
				@case_ID      = __method__.to_s.split('_')[1]
				r  			  = []
				@long_zh_name = "ABCDEFghijklmnopqrstuvwsyz0123456789ABCdefghijklmnopqrstuvwsyzMoreThan62leters"
				@long_en_name = "北龙中网北京科技有限责任公司技术部北龙中网北京科技有限"
				@special_char = "@#￥%……&*（）"
				@illegal_TTL  = "2147483648"
				@illegal_IP   = "203.119.80.256"
				@error_info_TTL    = "TTL值的范围为:0-2147483647"
				@error_info_rdata  = "域名格式不正确"
				@error_info_A 	   = "输入合法的IPv4地址，例如：192.168.1.1"
				@error_info_AAAA   = "输入合法的IPv6地址，例如：2401:8d00:3:2:5054:ff:fe5f:7763"
				@error_info_NS 	   = "输入名字服务器的全称域名，例如：ns1.zdns.cn."
				@error_info_MX     = "依次输入 优先级（0-65535） 邮件服务器的全称域名，例如：10 mx30.zdns.cn."
				@error_info_CNAME  = "输入一个全称域名，例如：dns.zdns.cn."
				@error_info_DNAME  = "输入一个全称域名，例如：ip6.tla-1.net."
				@error_info_PTR    = "输入一个全称域名，例如：dns.zdns.cn."
				@error_info_NAPTR  = "依次输入 顺序号（0-65535） 优先级（0-65535） 标志（A-Z，0-9） 正则表达式 服务参数 用于替换的全称域名，例如：101 10 \"u\" \"sip+E2U\" \"!^.*$!sip:userA@zdns.cn!\" ."
				@error_info_SRV    = "依次输入：优先级（0-65535） 权重（0-65535） 端口（1-65535） 全称域名，例如：1 0 9 sysadmins-box.zdns.cn."
				@illegal_name_list = [@long_zh_name, @long_en_name, @special_char]
				args[:error_type]  = "before_OK"
				@error_info_list   = [
					["A", @error_info_A], 
					["AAAA", @error_info_AAAA], 
					["NS", @error_info_NS], 
					["MX", @error_info_MX], 
					["CNAME", @error_info_CNAME], 
					["DNAME", @error_info_DNAME], 
					["PTR", @error_info_PTR], 
					["NAPTR", @error_info_NAPTR], 
					["SRV", @error_info_SRV]
				]
				#循环3次检查"域名格式不正确"
				begin
					@illegal_name_list.each do |name|
						args[:rname] = name
						args[:rdata] = "192.168.1.1"
						DNS.open_redirect_page
						DNS.inputs_redirect_dialog(args)
						args[:error_info] = @error_info_rdata
						r << DNS.error_validator_on_popwin(args)
					end
					#循环检查9项"<记录类型值输入错误>"
					@error_info_list.each do |error|
						DNS.open_redirect_page
						DNS.popup_right_menu
						DNS.popwin.text_field(:name, "name").set("sohu.com")
						DNS.popwin.text_field(:name, "ttl").set("3600")
						DNS.popwin.text_field(:name, "rdata").set("~")
						DNS.popwin.select_list(:name, "type").select(error[0])
						args[:error_info] = error[1]
						r << DNS.error_validator_on_popwin(args)
					end
				rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end

			def case_1917(args)
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				rname             = "rname_edit.xxx."
				@error_info_TTL   = "TTL值的范围为:0-2147483647"
				@error_info_rdata = "域名格式不正确"
				@error_info_A     = "输入合法的IPv4地址，例如：192.168.1.1"
				@error_info_AAAA  = "输入合法的IPv6地址，例如：2401:8d00:3:2:5054:ff:fe5f:7763"
				@error_info_NS    = "输入名字服务器的全称域名，例如：ns1.zdns.cn."
				@error_info_MX    = "依次输入 优先级（0-65535） 邮件服务器的全称域名，例如：10 mx30.zdns.cn."
				@error_info_CNAME = "输入一个全称域名，例如：dns.zdns.cn."
				@error_info_DNAME = "输入一个全称域名，例如：ip6.tla-1.net."
				@error_info_PTR   = "输入一个全称域名，例如：dns.zdns.cn."
				@error_info_NAPTR = "依次输入 顺序号（0-65535） 优先级（0-65535） 标志（A-Z，0-9） 正则表达式 服务参数 用于替换的全称域名，例如：101 10 \"u\" \"sip+E2U\" \"!^.*$!sip:userA@zdns.cn!\" ."
				@error_info_SRV   = "依次输入：优先级（0-65535） 权重（0-65535） 端口（1-65535） 全称域名，例如：1 0 9 sysadmins-box.zdns.cn."
				args[:error_type] = "before_OK"
				args[:ttl]        = "3600"
				rtype_with_rdata  = {
					"A"     =>["192.168.1.1", "@!", @error_info_A],
					"AAAA"  =>["1234::CDEF", "@!", @error_info_AAAA],
					"NS"    =>["a_#{rname}", "@!", @error_info_NS],
					"MX"    =>["5 a_#{rname}", "@!", @error_info_MX],
					"CNAME" =>["cname.com.", "@!", @error_info_CNAME],
					"DNAME" =>["dname.com.", "@!", @error_info_DNAME],
					"TXT"   =>["text", "text_new", @error_info_TTL],
					"SRV"   =>["65 5 35 srv.com.", "@!", @error_info_SRV],
					"PTR"   =>["ptr.com.","@!", @error_info_PTR],
					"NAPTR" =>["101 10 \"u\" \"sip+E2U\" \"!^.*$!sip:userA@zdns.cn!\" .", "@!", @error_info_NAPTR]
				}
				begin
					rtype_with_rdata.each_pair do |rtype, rdata|
						# 重定义rname,避免错误提示
						args[:rname] = "#{rtype.downcase}_#{rname}"
						args[:rtype] = rtype
						args[:rdata] = rdata[0]
						# 用txt记录来产生"ttl"错误提示信息, 因为txt可输入任意字符.
						args[:new_ttl] = "@!" if rtype == 'TXT'
						args[:new_ttl] = "1800" if rtype != 'TXT'
						args[:new_rdata]  = rdata[1]
						args[:error_info] = rdata[2]
						r << Recu_er.create_redirect(args)
						r << DNS.check_single_redirect(args)
						DNS.inputs_redirect_edit_dialog(args)
						r << DNS.error_validator_on_popwin(args)
					end
					# 删除所有已建记录
					r << Recu_er.del_all_redirect
				rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end

			def case_1911(args)
				#新建重复的重定向记录
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:ttl]        = "3600"
				args[:error_info] = "创建重复的资源记录"
				args[:error_type] = "after_OK"
				rname             = "rname_redundance.xxx."
				rtype_with_rdata  = {
					"A"=>"192.168.19.11",
					"AAAA"=>"1234::CDEF",
					"NS"=>"a_#{rname}",
					"MX"=>"5 a_#{rname}",
					"CNAME"=>"cname.com.",
					"DNAME"=>"dname.com.",
					"TXT"=>"text",
					"SRV"=>"65 5 35 srv.com.",
					"PTR"=>"ptr.com.",
					"NAPTR"=>"101 10 \"u\" \"sip+E2U\" \"!^.*$!sip:userA@zdns.cn!\" ."
				}
				begin
					rtype_with_rdata.each_pair do |rtype, rdata|
						#重定义rname.
						args[:rname] = "#{rtype.downcase}_#{rname}"
						args[:rtype] = rtype
						args[:rdata] = rdata
						r << Recu_er.create_redirect(args)
						DNS.open_redirect_page
						DNS.inputs_redirect_dialog(args)
						r << DNS.error_validator_on_popwin(args)
					end
					r << Recu_er.del_all_redirect
				rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end

			def case_1921(args)
				#编辑重定向记录, 再dig新记录
				@case_ID      	  = __method__.to_s.split('_')[1]
				r	  			  = []
				args[:ttl]		  = "3600"
				rname 			  = "rname_edit.xxx."
				rtype_with_rdata  = {
					"A"=>["192.168.19.21", "192.168.21.19"],
					"AAAA"=>["1234::CDEF", "CDEF::1234"],
					"MX"=>["5 a_#{rname}", "8 a_#{rname}"], 
					"CNAME"=>["cname.com.","cname.com.new."],
					"DNAME"=>["dname.com.","dname.com.new."],
					"TXT"=>["text","\"text.new.\"" ],
					"SRV"=>["65 5 35 srv.com.", "65 5 35 srv.com.new."],
					"PTR"=>["ptr.com.", "ptr.com.new."],
					"NAPTR"=>["101 10 \"u\" \"sip+E2U\" \"!^.*$!sip:userA@zdns.cn!\" .", "101 10 \"u\" \"sip+E2U\" \"!^.*$!sip:userA@zdns.cn!\" new."]
				}
				begin
					rtype_with_rdata.each_pair do |rtype, rdata|
						#重定义rname为rtype_rname
						args[:rname]     = "#{rtype.downcase}_#{rname}"
						args[:rtype]     = rtype
						args[:rdata]     = rdata[0]
						args[:rdata_new] = rdata[1]
						r << Recu_er.create_redirect(args)
						r << Recu_er.edit_redirect(args)
						# Dig非NS记录
						args[:server_list] = Node_IP_List 
						args[:domain_name] = args[:rname]
						args[:actual_rdata] = args[:rdata_new]
						if rtype != "NS"
							r << Dig_er.compare_domain(args)
						end
					end
					r << Recu_er.del_all_redirect
				rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			
			def case_9194(args)
				#新建所有记录, dig后, 删除.
				@case_ID         = __method__.to_s.split('_')[1]
				r     			 = []
				args[:ttl]       = "3600"
				rname           = "rname.xxx"
				rtype_with_rdata = {
					"A"=>"192.168.91.94",
					"AAAA"=>"1234::CDEF",
					"NS"=>"a_#{rname}",
					"MX"=>"5 a_#{rname}",
					"CNAME"=>"cname.com.",
					"DNAME"=>"dname.com.",
					"PTR"=>"ptr.com.",
					"TXT"=>"text","SRV"=>"65 5 35 srv.com.",
					"NAPTR"=>"101 10 \"u\" \"sip+E2U\" \"!^.*$!sip:userA@zdns.cn!\" ."
				}
				begin
					# 新建所有类型
					rtype_with_rdata.each_pair do |rtype, rdata|
						args[:rname] = "#{rtype.downcase}_#{rname}"
						args[:rtype] = rtype
						args[:rdata] = rdata
						r << Recu_er.create_redirect(args)
					end
					# Dig
					rtype_with_rdata.each_pair do |rtype, rdata|
						args[:rname] = "#{rtype.downcase}_#{rname}"
						args[:rtype] = rtype
						args[:rdata] = rdata
						if rtype != "NS" #除NS记录外都可dig成功
							r << Dig_er.compare_domain(:server_list=>Node_IP_List, :domain_name=>args[:rname], :rtype=>rtype, :port=>DNS_Port, :actual_rdata=>rdata)
						end
					end
					# 清理
					r << Recu_er.del_all_redirect
				rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end

			def case_9499(args)
				# 新建含下划线的域名
				@case_ID 		 = __method__.to_s.split('_')[1]
				r 	             = []
				args[:ttl] 		 = "3600"
				rname 			 = "rname_underline.xxx"
				rtype_with_rdata = {
					"A"=>"192.168.94.99",
					"AAAA"=>"1234::CDEF",
					"MX"=>"5 a_#{rname}",
					"CNAME"=>"cname.com.",
					"DNAME"=>"dname.com.",
					"TXT"=>"text",
					"SRV"=>"65 5 35 srv.com.",
					"PTR"=>"ptr.com.",
					"NAPTR"=>"101 10 \"u\" \"sip+E2U\" \"!^.*$!sip:userA@zdns.cn!\" ."
				}
				begin
					rtype_with_rdata.each_pair do |rtype, rdata|
						#重定义rname.
						args[:rname] = "#{rtype.downcase}_#{rname}"
						args[:rtype] = rtype
						args[:rdata] = rdata
						r << Recu_er.create_redirect(args)
					end
					# Dig
					rtype_with_rdata.each_pair do |rtype, rdata|
						args[:rname] = "#{rtype.downcase}_#{rname}"
						args[:rtype] = rtype
						args[:rdata] = rdata
						#除NS记录外都可dig成功
						if rtype != "NS"
							r << Dig_er.compare_domain(:server_list=>Node_IP_List, :domain_name=>args[:rname], :rtype=>rtype, :port=>DNS_Port, :actual_rdata=>rdata)
						end
					end
					# 清理
					r << Recu_er.del_all_redirect
				rescue
                    puts "unknown error on #{@case_ID}"
                    return "failed case #{@case_ID}"
                end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end

			def case_9503(args)
				#新建所有记录, 重启服务后dig.
				@case_ID         = __method__.to_s.split('_')[1]
				r     			 = []
				args[:ttl]       = "3600"
				rname           = "rname.xxx"
				rtype_with_rdata = {
					"A"=>"192.168.95.3",
					"AAAA"=>"1234::CDEF",
					"NS"=>"a_#{rname}",
					"MX"=>"5 a_#{rname}",
					"CNAME"=>"cname.com.",
					"DNAME"=>"dname.com.",
					"PTR"=>"ptr.com.",
					"TXT"=>"text","SRV"=>"65 5 35 srv.com.",
					"NAPTR"=>"101 10 \"u\" \"sip+E2U\" \"!^.*$!sip:userA@zdns.cn!\" ."
				}

				begin
					#新建所有类型重定向记录
					rtype_with_rdata.each_pair do |rtype, rdata|
						args[:rname] = "#{rtype.downcase}_#{rname}"
						args[:rtype] = rtype
						args[:rdata] = rdata
						r << Recu_er.create_redirect(args)
					end
					# 重启节点
					Node_Name_List.each do |nodeName|
						args[:node_name] = nodeName
						r << Cloud.stop_device_dns_service(args)
						sleep 3
						r << Cloud.start_device_dns_service(args)
					end
					# Dig
					rtype_with_rdata.each_pair do |rtype, rdata|
						args[:rname] = "#{rtype.downcase}_#{rname}"
						args[:rtype] = rtype
						args[:rdata] = rdata
						if rtype != "NS" #除NS记录外都可dig成功
							r << Dig_er.compare_domain(:server_list=>Node_IP_List, :domain_name=>args[:rname], :rtype=>rtype, :port=>DNS_Port, :actual_rdata=>rdata)
						end
					end
					r << Recu_er.del_all_redirect
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
			    end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end

			def case_5152(args)
				#新建视图+所有记录dig.
				@case_ID         = __method__.to_s.split('_')[1]
				r     		 	 = []
				args[:ttl]       = "3600"
				rname           = "rname.xxx"
				rtype_with_rdata = {
					"A"=>"192.168.51.52",
					"AAAA"=>"1234::CDEF",
					"NS"=>"a_#{rname}",
					"MX"=>"5 a_#{rname}",
					"CNAME"=>"cname.com.",
					"DNAME"=>"dname.com.",
					"PTR"=>"ptr.com.",
					"TXT"=>"text","SRV"=>"65 5 35 srv.com.",
					"NAPTR"=>"101 10 \"u\" \"sip+E2U\" \"!^.*$!sip:userA@zdns.cn!\" ."
				}
				begin
					# 新建ACL+视图
					args[:acl_name]   = "acl_#{@case_ID}"
					args[:acl_list]   = Local_Network
					args[:view_name]  = "view_#{@case_ID}"
					args[:owner_list] = Node_Name_List
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					# 新建所有类型
					rtype_with_rdata.each_pair do |rtype, rdata|
						#重定义rname,避免错误提示
						args[:rname] = "#{rtype.downcase}_#{rname}"
						args[:rtype] = rtype
						args[:rdata] = rdata
						r << Recu_er.create_redirect(args)
					end
					# Dig
					rtype_with_rdata.each_pair do |rtype, rdata|
						#重定义rname,避免错误提示
						args[:rname] = "#{rtype.downcase}_#{rname}"
						args[:rtype] = rtype
						args[:rdata] = rdata
						
						if rtype != "NS" #除NS记录外都可dig成功
							r << Dig_er.compare_domain(:server_list=>Node_IP_List, :domain_name=>args[:rname], :rtype=>rtype, :port=>DNS_Port, :actual_rdata=>rdata)
						end
					end
					# 清理
					r << Recu_er.del_all_redirect
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
			    end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end

			def case_1926(args)
				# 节点断开
				@case_ID         = __method__.to_s.split('_')[1]
				r     			 = []
				args[:ttl]       = "3600"
				rname           = "rname.xxx"
				rtype_with_rdata = {
					"A"=>"192.168.19.26",
					"AAAA"=>"1234::CDEF",
					"NS"=>"a_#{rname}",
					"MX"=>"5 a_#{rname}",
					"CNAME"=>"cname.com.",
					"DNAME"=>"dname.com.",
					"PTR"=>"ptr.com.",
					"TXT"=>"text","SRV"=>"65 5 35 srv.com.",
					"NAPTR"=>"101 10 \"u\" \"sip+E2U\" \"!^.*$!sip:userA@zdns.cn!\" ."
				}
				begin
					args[:node_name] = Slave_Device
					r << Cloud.disconnect_device(args)
					# 新建ACL+视图
					args[:acl_name]   = "acl_#{@case_ID}"
					args[:acl_list]   = Local_Network
					args[:view_name]  = "view_#{@case_ID}"
					args[:owner_list] = [Slave_Device]
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					# 新建所有类型
					rtype_with_rdata.each_pair do |rtype, rdata|
						#重定义rname,避免错误提示
						args[:rname] = "#{rtype.downcase}_#{rname}"
						args[:rtype] = rtype
						args[:rdata] = rdata
						r << Recu_er.create_redirect(args)
					end
					r << Cloud.connect_device(args)
	                # sleep 恢复
	                sleep 15
					# Dig
					rtype_with_rdata.each_pair do |rtype, rdata|
						#重定义rname,避免错误提示
						args[:rname] = "#{rtype.downcase}_#{rname}"
						args[:rtype] = rtype
						args[:rdata] = rdata
						
						if rtype != "NS" #除NS记录外都可dig成功
							r << Dig_er.compare_domain(:server_list=>[Slave_IP], :domain_name=>args[:rname], :rtype=>rtype, :port=>DNS_Port, :actual_rdata=>rdata)
						end
					end
					# 清理
					r << Recu_er.del_all_redirect
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
			    end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end

			def case_12622(args)
				# 节点服务停止
				@case_ID         = "12622"
				r     		     = []
				args[:ttl]       = "3600"
				rname           = "rname.xxx"
				rtype_with_rdata = {
					"A"=>"192.168.126.22",
					"AAAA"=>"1234::CDEF",
					"NS"=>"a_#{rname}",
					"MX"=>"5 a_#{rname}",
					"CNAME"=>"cname.com.",
					"DNAME"=>"dname.com.",
					"PTR"=>"ptr.com.",
					"TXT"=>"text","SRV"=>"65 5 35 srv.com.",
					"NAPTR"=>"101 10 \"u\" \"sip+E2U\" \"!^.*$!sip:userA@zdns.cn!\" ."
				}
				begin
					args[:node_name] = Slave_Device
					r << Cloud.stop_device_dns_service(args)
					# 新建ACL+视图
					args[:acl_name]   = "acl_#{@case_ID}"
					args[:acl_list]   = Local_Network
					args[:view_name]  = "view_#{@case_ID}"
					args[:owner_list] = [Slave_Device]
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					# 新建所有类型
					rtype_with_rdata.each_pair do |rtype, rdata|
						#重定义rname,避免错误提示
						args[:rname] = "#{rtype.downcase}_#{rname}"
						args[:rtype] = rtype
						args[:rdata] = rdata
						r << Recu_er.create_redirect(args)
					end
					r << Cloud.start_device_dns_service(args)
	                # sleep 恢复
	                sleep 15
					# Dig
					rtype_with_rdata.each_pair do |rtype, rdata|
						#重定义rname,避免错误提示
						args[:rname] = "#{rtype.downcase}_#{rname}"
						args[:rtype] = rtype
						args[:rdata] = rdata
						if rtype != "NS" #除NS记录外都可dig成功
							r << Dig_er.compare_domain(:server_list=>[Slave_IP], :domain_name=>args[:rname], :rtype=>rtype, :port=>DNS_Port, :actual_rdata=>rdata)
						end
					end
					# 清理
					r << Recu_er.del_all_redirect
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
			    end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			
			def case_9778(args)
				# ttl 的验证
				@case_ID         = __method__.to_s.split('_')[1]
				r     		     = []
				@ttl_list        = [4, 10]
				@bind_ttl        = 5
				rname           = "rname.xxx"
				rtype_with_rdata = {
					"A"=>"192.168.97.78",
					"AAAA"=>"1234::CDEF",
					"NS"=>"a_#{rname}",
					"MX"=>"5 a_#{rname}",
					"CNAME"=>"cname.com.",
					"DNAME"=>"dname.com.",
					"PTR"=>"ptr.com.",
					"TXT"=>"text","SRV"=>"65 5 35 srv.com.",
					"NAPTR"=>"101 10 \"u\" \"sip+E2U\" \"!^.*$!sip:userA@zdns.cn!\" ."
				}
				begin
					# 新建ACL+视图
					args[:acl_name]   = "acl_#{@case_ID}"
					args[:acl_list]   = Local_Network
					args[:view_name]  = "view_#{@case_ID}"
					args[:owner_list] = [Master_Device]
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					# 新建所有类型
					@ttl_list.each do |ttl|
						args[:ttl] = ttl
						rtype_with_rdata.each_pair do |rtype, rdata|
							args[:rname] = "#{rtype.downcase}_#{rname}"
							args[:rtype] = rtype
							args[:rdata] = rdata
							r << Recu_er.create_redirect(args)
						end
						sleep 5
						# Dig
						rtype_with_rdata.each_pair do |rtype, rdata|
							#重定义rname,避免错误提示
							args[:node_ip]     = Master_IP
							args[:domain_name] = "#{rtype.downcase}_#{rname}"
							args[:rtype]       = rtype
							args[:rdata]       = rdata
							if rtype != "NS" #除NS记录外都可dig成功
								r_ttl = Recu_er.get_ttl_value(args)
								return "failed case #{@case_ID}" if r_ttl != @bind_ttl && r_ttl.to_i != ttl
							end
						end
						r << Recu_er.del_all_redirect
					end
					# 清理
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
			 	end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end

			def case_9757(args)
				# 批量编辑
				@case_ID         = __method__.to_s.split('_')[1]
				r     			 = []
				rname            = "rname.xxx"
				rtype_with_rdata = {
					"A"=>"192.168.97.78",
					"AAAA"=>"1234::CDEF",
					"MX"=>"5 a_#{rname}",
					"CNAME"=>"cname.com.",
					"DNAME"=>"dname.com.",
					"PTR"=>"ptr.com.",
					"TXT"=>"text","SRV"=>"65 5 35 srv.com.",
					"NAPTR"=>"101 10 \"u\" \"sip+E2U\" \"!^.*$!sip:userA@zdns.cn!\" ." }
				begin
					@rdrct_view_name  = "view_#{@case_ID}"
					args[:view_name]  = @rdrct_view_name
					args[:owner_list] = [Master_Device]
					r << View_er.create_view(args)
					# 新建2个视图的重定向记录
					args[:ttl]        = "3600"
					["default", @rdrct_view_name].each do |viewName|
						args[:view_name] = viewName
						rtype_with_rdata.each_pair do |rtype, rdata|
							args[:rname] = "#{rtype.downcase}_#{rname}"
							args[:rtype] = rtype
							args[:rdata] = rdata
							r << Recu_er.create_redirect(args)
						end
					end
					# 选择所有->编辑
					r << Recu_er.check_all_redirect
					args[:ttl_new] = "1800"
					r << Recu_er.edit_selected_redirect(args)
					r << Recu_er.del_all_redirect
					# 清理
					args[:view_name] = @rdrct_view_name
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
			    end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end

			def case_8731(args)
				# 修改视图节点
				@case_ID         = __method__.to_s.split('_')[1]
				r                = []
				rname            = "red.x.y.z"
				rtype_with_rdata = {
					"A"=>"192.168.97.78",
					"AAAA"=>"1234::CDEF",
					"CNAME"=>"cname.com.",
					"DNAME"=>"dname.com.",
					"PTR"=>"ptr.com.",
					"TXT"=>"text",
					"SRV"=>"65 5 35 srv.com.",
					"NAPTR"=>'101 10 "u" "sip+E2U" "!^.*$!sip:userA@zdns.cn!" .'
				}
				begin
					args[:ttl]        = "3600"
					args[:acl_name]   = "acl_#{@case_ID}"
					args[:acl_list]   = Local_Network
					args[:view_name]  = "view_#{@case_ID}"
					args[:owner_list] = [Master_Device]
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					# 新建
					rtype_with_rdata.each_pair do |rtype, rdata|
						args[:rname] = "#{rtype.downcase}.#{rname}"
						args[:rtype] = rtype
						args[:rdata] = rdata
						r << Recu_er.create_redirect(args)
					end
					# Dig Master => Pass
					args[:server_list] = [Master_IP]
					rtype_with_rdata.each_pair do |rtype, rdata|
						# 重定义rname,避免错误提示
						args[:rname] = "#{rtype.downcase}.#{rname}"
						args[:rtype] = rtype
						args[:rdata] = rdata
						args[:domain_name] = args[:rname]
						args[:actual_rdata] = rdata
						if rtype != "NS" # 除NS记录外都可dig成功
							r << Dig_er.compare_domain(args)
						end
					end
					# 修改节点 Master >> ALL
					args[:old_owner_list] = args[:owner_list]
					args[:new_owner_list] = Node_Name_List
					r << View_er.modify_view_member(args)
					# Dig ALL => Pass
					args[:server_list] = Node_IP_List
					rtype_with_rdata.each_pair do |rtype, rdata|
						args[:rname] = "#{rtype.downcase}.#{rname}"
						args[:rtype] = rtype
						args[:rdata] = rdata
						args[:domain_name] = args[:rname]
						args[:actual_rdata] = rdata
						if rtype != "NS" # 除NS记录外都可dig成功
							r << Dig_er.compare_domain(args)
						end
					end
					# 修改节点 ALL >> Slave
					args[:old_owner_list] = Node_Name_List
					args[:new_owner_list] = [Slave_Device]
					r << View_er.modify_view_member(args)
					# Dig Master => Fail
					args[:server_list] = [Master_IP]
					rtype_with_rdata.each_pair do |rtype, rdata|
						args[:rname] = "#{rtype.downcase}.#{rname}"
						args[:rtype] = rtype
						args[:rdata] = rdata
						args[:domain_name] = args[:rname]
						args[:actual_rdata] = rdata
						args[:expected_dig_fail] = 'yes'
						if rtype != "NS" #除NS记录外都可dig成功
							r << Dig_er.compare_domain(args)
						end
					end
					# 清理
					r << Recu_er.del_all_redirect
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end

			def case_1887(args)
				# 重定向新建后检查后台named和记录
				@case_ID = __method__.to_s.split('_')[1]
				r        = []
				rname   = "rname.xxx"
				begin
					@rdrct_view_name  = "view_#{@case_ID}"
					args[:view_name]  = @rdrct_view_name
					args[:owner_list] = Node_Name_List
					r << View_er.create_view(args)
					args[:ttl]       = "3600"
					rtype_with_rdata = {'A'=>'192.168.18.87'}
					# 新建2个视图的重定向记录
					["default", @rdrct_view_name].each do |viewName|
						args[:view_name] = viewName
						rtype_with_rdata.each_pair do |rtype, rdata|
							args[:rname] = "#{rtype.downcase}_#{rname}"
							args[:rtype] = rtype
							args[:rdata] = rdata
							r << Recu_er.create_redirect(args)
							sleep 3
							# grep named and redirect file
							r << DNS.grep_redirect_record(args)
						end
					end
					# 清理
					r << Recu_er.del_all_redirect
					args[:view_name]  = @rdrct_view_name
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
			    end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end

			def case_1927(args)
				# 新建后dig, 删除后dig
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:acl_name]    = "acl_#{@case_ID}"
				args[:acl_list]    = Local_Network
				args[:view_name]   = "view_#{@case_ID}"
				args[:owner_list]  = Node_Name_List
				rname             = "rname.xxx"
				rtype              = 'A'
				args[:rtype]       = rtype
				args[:rname]       = "#{rtype.downcase}_#{rname}"
				args[:rdata]       = "192.168.19.27"
				args[:ttl]         = "3600"
				args[:domain_name] = args[:rname]
				begin
					# create
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Recu_er.create_redirect(args)
					# dig
					Node_IP_List.each do |dig_ip|
						args[:dig_ip] = dig_ip
						r << DNS.dig_as_noerror(args)
					end
					# del redirect
					r << Recu_er.del_all_redirect
					# dig again
					Node_IP_List.each do |dig_ip|
						args[:dig_ip] = dig_ip
						r << DNS.dig_as_nxdomain(args)
					end
					# clean up
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
			    end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end

			def case_2766(args)
				# ACL内Dig
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:acl_name]    = "acl_#{@case_ID}"
				args[:acl_list]    = Local_Network
				args[:view_name]   = "view_#{@case_ID}"
				args[:owner_list]  = Node_Name_List
				rname             = "rname.xxx"
				rtype              = 'A'
				args[:rtype]       = rtype
				args[:rname]       = "#{rtype.downcase}_#{rname}"
				args[:rdata]       = "192.168.27.66"
				args[:ttl]         = "3600"
				args[:domain_name] = args[:rname]
				begin
					# create
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Recu_er.create_redirect(args)
					# dig
					Node_IP_List.each do |dig_ip|
						args[:dig_ip] = dig_ip
						r << DNS.dig_as_noerror(args)
					end
					# del redirect
					r << Recu_er.del_all_redirect
					# clean up
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
			    end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end

			def case_7164(args)
				# ACL外Dig
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:acl_name]    = "acl_#{@case_ID}"
				args[:acl_list]    = ["202.173.10.0/24", "203.119.82.0/24"]
				args[:view_name]   = "view_#{@case_ID}"
				args[:owner_list]  = Node_Name_List
				rname             = "rname.xxx"
				rtype              = 'A'
				args[:rtype]       = rtype
				args[:rname]       = "#{rtype.downcase}_#{rname}"
				args[:rdata]       = "192.168.27.66"
				args[:ttl]         = "3600"
				args[:domain_name] = args[:rname]
				begin
					# create
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					r << Recu_er.create_redirect(args)
					# dig
					Node_IP_List.each do |dig_ip|
						args[:dig_ip] = dig_ip
						r << DNS.dig_as_nxdomain(args)
					end
					# del redirect
					r << Recu_er.del_all_redirect
					# clean up
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
			    end
                r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end

			def case_8365(args)
				# 新建一批重定向, 点击"查询"
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:view_name]  = "view_#{@case_ID}"
				args[:owner_list] = Node_Name_List
				args[:ttl]        = "3600"
				rname            = "rname.xxx"
				rtype_with_rdata  = {
					'A'     =>'192.168.83.65',
					'AAAA'  =>'8365::CDEF',
					'NS'    =>"a_#{rname}",
					'MX'    =>"5 a_#{rname}",
					'CNAME' =>'cname.com.',
					'DNAME' =>'dname.com.',
					'PTR'   =>'ptr.com.',
					'TXT'   =>'text',
					'SRV'   =>"65 5 35 srv.com.",
					'NAPTR' =>'101 10 "u" "sip+E2U" "!^.*$!sip:userA@zdns.cn!" .'
				}
				begin
					r << View_er.create_view(args)
					rtype_with_rdata.each_pair do |rtype, rdata|
						args[:rname] = "#{rtype.downcase}_#{rname}"
						args[:rtype] = rtype
						args[:rdata] = rdata
						r << Recu_er.create_redirect(args)
					end
					# search
					rtype_with_rdata.each_key do |rtype|
						args[:search_keyword] = "#{rtype.downcase}_#{rname}"
						r << Recu_er.search_redirect(args)
					end
					# clean up
					r << View_er.del_view(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def create_50(args)
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:view_name]  = 'test'
				args[:ttl]        = "600"
				begin
					args[:rtype] = 'A'
					50.times do |i|
						args[:rname] = "xxx_#{i.to_s}"
						args[:rdata] = "192.168.1.#{i.to_s}"
						r << Recu_er.create_redirect(args)
					end
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
		end
	end
end