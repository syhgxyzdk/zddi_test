# encoding: utf-8
require File.dirname(__FILE__) + '/../../zddi'
module ZDDI
	module DNS
		class Cache_manage
			def case_8001(args)
				@case_ID               = __method__.to_s.split('_')[1]
				r                      = []
				args[:nodeName]        = Master_Device
				error_1                = "必选字段"
				error_2                = "请输入合法的整数"
				error_3                = "TTL值的范围为:0-2147483647"
				error_4                = "请输入最大为 9999999999 的值"
				args[:error_type]      = "before_OK"
				error_info_with_inputs = {
					error_1=>["","",""], 
					error_2=>["600","600","@!"], 
					error_3=>["!","@","0"], 
					error_4=>["1","1","99999999991"]}
				begin
					DNS.open_cache_manage_page
					if DNS.select_node_on_cache_manage(args)
						error_info_with_inputs.each_pair do |error_info, inputs|
							args[:error_info]		 = error_info
							args[:max_cache_ttl]     = inputs[0]
							args[:max_neg_cache_ttl] = inputs[1]
							args[:max_cache_size]	 = inputs[2]
							DNS.click_on_cache_set_btn
							DNS.inputs_cache_set_dialog(args)
							r << DNS.error_validator_on_popwin(args)
						end
					end
				rescue
					puts "unknown error on #{@case_ID}"
					r << 'failed'
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
				
			def case_8020(args)
				@case_ID              = __method__.to_s.split('_')[1]
				r                     = []
				args[:nodeName]       = Master_Device
				error_1               = "必选字段"
				error_2               = "域名格式不正确"
				rname_1               = ""
				rname_2               = " space.in "
				rname_3               = "@*&^"
				args[:error_type]     = "before_OK"
				rname_with_error_info = {
								rname_1=>error_1, 
								rname_2=>error_2, 
								rname_3=>error_2 
						        }
				begin
					DNS.open_cache_manage_page
					if DNS.select_node_on_cache_manage(args)
						rname_with_error_info.each_pair do |rname, error_info|
							args[:rname]	  = rname
							args[:error_info] = error_info
							DNS.click_on_cache_clear_btn
							DNS.inputs_cache_clear_dialog(args)
							r << DNS.error_validator_on_popwin(args)
						end
					end
				rescue
					puts "unknown error on #{@case_ID}"
					r << 'failed'
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
            end
            def case_8016(args)
            	# 清除所有设备缓存, 验证ttl被重置
				@case_ID = __method__.to_s.split('_')[1]
				r        = []
				begin
					args[:domain_name] = "baidu.com"
					# 生成缓存
					Node_IP_List.each{ |ip|
						args[:node_ip] = ip
						ttl = Recu_er.get_ttl_value(args)
					}
					# TTL递减
					sleep 5
					# 清理缓存
					r << Recu_er.del_all_cache_all_device(args)
					# 缓存重置
					Node_IP_List.each do |ip|
						args[:node_ip] = ip
						ttl = Recu_er.get_ttl_value(args)
						r << 'failed' if ttl != "600"
					end
				rescue
					puts "unknown error on #{@case_ID}"
					r << 'failed'
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_8017(args)
				# 清除所有视图缓存, 验证ttl被重置
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:acl_name]    = "acl_#{@case_ID}"
				args[:acl_list]    = Local_Network
				args[:view_name]   = "view_#{@case_ID}"
				args[:owner_list]  = Node_Name_List
				args[:domain_name] = "baidu.com"
				begin
					# 生成default视图缓存
					Node_IP_List.each do |ip|
						args[:node_ip] = ip
						ttl = Recu_er.get_ttl_value(args)
					end
					# 新建ACL+View
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					# 生成view视图缓存
					Node_IP_List.each do |ip|
						args[:node_ip] = ip
						ttl = Recu_er.get_ttl_value(args)
					end					
					# TTL递减
					sleep 5
					# 清理所有视图缓存
					Node_Name_List.each do |nodeName|
						args[:nodeName] = nodeName
						r << Recu_er.del_cache_of_device(args)
					end
					# view视图缓存重置
					Node_IP_List.each do |ip|
						args[:node_ip] = ip
						ttl = Recu_er.get_ttl_value(args)
						r << 'failed' if ttl != "600"
					end
					# default视图缓存重置
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
					Node_IP_List.each do |ip|
						args[:node_ip] = ip
						ttl = Recu_er.get_ttl_value(args)
						r << 'failed' if ttl != "600"
					end
				rescue
					puts "unknown error on #{@case_ID}"
					r << 'failed'
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_8023(args)
				# 清除视图下所有域名的缓存, 验证ttl被重置
				@case_ID          = "8023"
				r                 = []
				args[:acl_name]   = "acl_#{@case_ID}"
				args[:acl_list]   = Local_Network
				args[:view_name]  = "view_#{@case_ID}"
				args[:owner_list] = Node_Name_List
				@baidu            = 'baidu.com'
				@sohu             = 'sohu.com'
				@domain_name_list = [@baidu, @sohu]
				@origin_ttl_baidu = ''
				@origin_ttl_sohu  = ''
				begin
					# 先清除所有缓存, 保证不受其他case影响
					Recu_er.del_all_cache_all_device(args)
					# 获取baidu/sohu的最大ttl
					args[:node_ip]     = Master_IP
					args[:domain_name] = @baidu
					@origin_ttl_baidu  = Recu_er.get_ttl_value(args)
					args[:domain_name] = @sohu
					@origin_ttl_sohu   = Recu_er.get_ttl_value(args)
					# 新建ACL+View
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					# 生成view视图缓存
					Node_IP_List.each{ |ip|
						args[:node_ip] = ip
						@domain_name_list.each{ |domainName|
							args[:domain_name] = domainName
							ttl = Recu_er.get_ttl_value(args)
						}
					}					
					# TTL递减
					sleep 5
					# 清理缓存
					Node_Name_List.each{ |nodeName|
						args[:nodeName] = nodeName
						r << Recu_er.del_cache_of_view(args)
					}
					# view缓存重置
					Node_IP_List.each{ |ip|
						args[:node_ip] = ip
						args[:domain_name] = @domain_name_list[0]
						ttl = Recu_er.get_ttl_value(args)
						r << "failed" if ttl != @origin_ttl_baidu
						args[:domain_name] = @domain_name_list[1]
						ttl = Recu_er.get_ttl_value(args)
						r << "failed" if ttl != @origin_ttl_sohu
					}
					# 清理数据
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_8019(args)
				# 清除中文域名的缓存, 验证ttl被重置
				@case_ID             = "8019"
				r					 = []
				args[:acl_name]      = "acl_#{@case_ID}"
				args[:acl_list]      = Local_Network
				args[:view_name]     = "view_#{@case_ID}"
				args[:owner_list]    = Node_Name_List
				ip_list              = [Master_IP, Slave_IP]
				nodeName_list        = [Master_Device, Slave_Device]
				@chs_domain_name     = "清华大学.中国"
				@punycode_domainName = "xn--xkry9kk1bz66a.xn--fiqs8s"
				@ttl_after_reset     = ''
				begin
					# 先清除所有缓存, 保证不受其他case影响
					Recu_er.del_all_cache_all_device(args)
					# 获取该域名ttl最大值
					args[:node_ip]     = Master_IP
					args[:domain_name] = @punycode_domainName
					@ttl_after_reset   = Recu_er.get_ttl_value(args)
					# 再次清除所有缓存, 保证不受其他case影响
					Recu_er.del_all_cache_all_device(args)
					# 新建ACL+View
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					# 生成view视图缓存
					ip_list.each{ |ip|
						args[:node_ip] = ip
						args[:domain_name] = @punycode_domainName
						ttl = Recu_er.get_ttl_value(args)
					}	
					# TTL递减
					sleep 5
					# 清理缓存
					nodeName_list.each{ |nodeName|
						args[:nodeName] = nodeName
						args[:domain_name] = @chs_domain_name
						r << Recu_er.del_cache_of_domain(args)
					}
					# 验证缓存重置
					ip_list.each{ |ip|
						args[:node_ip] = ip
						args[:domain_name] = @punycode_domainName
						ttl = Recu_er.get_ttl_value(args)
						r << "failed" if ttl != @ttl_after_reset
					}
					# 清理数据
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_8022(args)
				# 清除单个域名不影响其他域名
				@case_ID          = "8022"
				r                 = []
				args[:view_name]  = "default"
				@baidu            = 'baidu.com'
				@sohu             = 'sohu.com'
				@domain_name_list = [@baidu, @sohu]
				@origin_ttl_baidu = ''
				@origin_ttl_sohu  = ''
				begin
					# 先清除所有缓存, 保证不受其他case影响
					Recu_er.del_all_cache_all_device(args)
					# 获取baidu/sohu的最大ttl
					args[:node_ip]     = Master_IP
					args[:domain_name] = @baidu
					@origin_ttl_baidu  = Recu_er.get_ttl_value(args)
					args[:domain_name] = @sohu
					@origin_ttl_sohu   = Recu_er.get_ttl_value(args)
					# 先清除所有缓存, 保证不受其他case影响
					Recu_er.del_all_cache_all_device(args)
					# 生成default视图缓存
					Node_IP_List.each { |ip|
						args[:node_ip] = ip
						@domain_name_list.each { |domain_name|
							args[:domain_name] = domain_name
							ttl = Recu_er.get_ttl_value(args)
						}
					}
					# TTL递减
					sleep 5
					# 清理第一个域名
					Node_Name_List.each { |nodeName|
						args[:nodeName] = nodeName
						args[:domain_name] = @domain_name_list[0]
						r << Recu_er.del_cache_of_domain(args)
					}
					# baidu被重置, sohu继续递减
					Node_IP_List.each { |ip|
						args[:node_ip] = ip
						args[:domain_name] = @domain_name_list[0]
						ttl = Recu_er.get_ttl_value(args)
						r << "failed" if ttl != @origin_ttl_baidu
						args[:domain_name] = @domain_name_list[1]
						ttl = Recu_er.get_ttl_value(args)
						r << "failed" if ttl == @origin_ttl_sohu
					}
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_8018(args)
				# 清除单个设备不影响其他设备
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:view_name]   = "default"
				args[:domain_name] = "baidu.com"
				begin
					# 先清除所有缓存, 保证不受其他case影响
					Recu_er.del_all_cache_all_device(args)
					# 生成default视图缓存
					Node_IP_List.each do |ip|
						args[:node_ip] = ip
						ttl = Recu_er.get_ttl_value(args)
					end
					# TTL递减
					sleep 5
					# 清理第Slave设备
					args[:nodeName] = Slave_Device
					r << Recu_er.del_cache_of_device(args)
					# Slave设备被重置,  Master递减
					args[:node_ip] = Master_IP
					ttl = Recu_er.get_ttl_value(args)
					r << 'failed' if ttl == "600"
					args[:node_ip] = Slave_IP
					ttl = Recu_er.get_ttl_value(args)
					r << 'failed' if ttl != "600"
				rescue
					puts "unknown error on #{@case_ID}"
					r << 'failed'
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_8014(args)
				# 清除单个视图不影响其他视图
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:acl_name]    = "acl_#{@case_ID}"
				args[:acl_list]    = Local_Network
				args[:owner_list]  = Node_Name_List
				args[:view_name]   = "default"
				args[:domain_name] = "baidu.com"
				begin
					# 先清除所有缓存, 保证不受其他case影响
					Recu_er.del_all_cache_all_device(args)
					# 生成default视图缓存
					Node_IP_List.each do |ip|
						args[:node_ip] = ip
						ttl = Recu_er.get_ttl_value(args)
					end
					# 新建ACL+View
					args[:view_name] = "view_#{@case_ID}"
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					# 生成View视图缓存
					Node_IP_List.each do |ip|
						args[:node_ip] = ip
						ttl = Recu_er.get_ttl_value(args)
					end
					# TTL递减
					sleep 5
					# 清理View视图
					Node_Name_List.each do |nodeName|
						args[:nodeName] = nodeName
						r << Recu_er.del_cache_of_view(args)
					end
					sleep 3
					# View视图的TTL被重置
					Node_IP_List.each do |ip|
						args[:node_ip] = ip
						ttl = Recu_er.get_ttl_value(args)
						r << 'failed' if ttl != "600"
					end
					# 清理数据
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
					Node_IP_List.each do |ip|
						args[:node_ip] = ip
						ttl = Recu_er.get_ttl_value(args)
						r << 'failed' if ttl == "600"
					end
				rescue
					puts "unknown error on #{@case_ID}"
					r << 'failed'
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_8006(args)
				# 更改记录缓存默认时间生效
				@case_ID             = __method__.to_s.split('_')[1]
				r                    = []
				args[:view_name]     = "default"
				args[:owner_list]    = Node_Name_List
				args[:domain_name]   = "baidu.com"
				args[:max_cache_ttl] = "300"
				begin
					# 先清除所有缓存, 保证不受其他case影响
					Recu_er.del_all_cache_all_device(args)
					# 更改记录缓存默认时间
					Node_Name_List.each do |nodeName|
						args[:nodeName] = nodeName
						r << Recu_er.change_cache_settings(args)
					end
					# 验证
					Node_IP_List.each do |ip|
						args[:node_ip] = ip
						ttl = Recu_er.get_ttl_value(args)
						r << 'failed' if ttl != "300"
					end
					r << Recu_er.reset_cache_settings(args)
				rescue
					puts "unknown error on #{@case_ID}"
					r << 'failed'
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_8009(args)
				# 更改否定缓存默认时间生效
				@case_ID                 = __method__.to_s.split('_')[1]
				r                        = []
				args[:view_name]         = "default"
				args[:owner_list]        = Node_Name_List
				args[:domain_name]       = "no.baidu.com"
				args[:max_neg_cache_ttl] = "30"
				begin
					# 先清除所有缓存, 保证不受其他case影响
					Recu_er.del_all_cache_all_device(args)
					# 更改否定缓存默认时间
					Node_Name_List.each do |nodeName|
						args[:nodeName] = nodeName
						r << Recu_er.change_cache_settings(args)
					end
					# 验证
					Node_IP_List.each do |ip|
						args[:node_ip] = ip
						ttl = Recu_er.get_neg_ttl_value(args)
						r << 'failed' if ttl != "30"
					end
					r << Recu_er.reset_cache_settings(args)
				rescue
					puts "unknown error on #{@case_ID}"
					r << 'failed'
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_16169(args)
				# 清除所有的设备缓存后查询验证
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:view_name]   = 'default'
				args[:owner_list]  = Node_Name_List
				args[:domain_name] = "baidu.com"
				args[:rtype]       = 'A'
				begin
					# 先清除所有缓存, 保证不受其他case影响
					r << Recu_er.del_all_cache_all_device(args)
					# 生成缓存
					r << DNS.dig_all_node_to_make_cache(args)
					Node_Name_List.each do |nodeName|
						args[:nodeName] = nodeName
						# 查询, 不为空
						r << Recu_er.search_domain_in_cache(args, result = true)
						# 清理缓存
						r << Recu_er.del_cache_of_device(args)
						# 再查询, 为空
						r << Recu_er.search_domain_in_cache(args, result = false)
					end
				rescue
					puts "unknown error on #{@case_ID}"
					r << 'failed'
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_16170(args)
				# 清除所有的视图缓存后查询验证
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:view_name]   = 'default'
				args[:owner_list]  = Node_Name_List
				args[:domain_name] = 'knet.cn'
				args[:rtype]       = 'A'
				begin
					# 先清除所有缓存, 保证不受其他case影响
					r << Recu_er.del_all_cache_all_device(args)
					# 生成缓存
					r << DNS.dig_all_node_to_make_cache(args)
					Node_Name_List.each do |nodeName|
						args[:nodeName] = nodeName
						# 查询, 不为空
						r << Recu_er.search_domain_in_cache(args, result = true)
						# 清理缓存
						r << Recu_er.del_cache_of_view(args)
						# 再查询, 为空
						r << Recu_er.search_domain_in_cache(args, result = false)
					end
				rescue
					puts "unknown error on #{@case_ID}"
					r << 'failed'
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_16171(args)
				# 清除所有的域名缓存后查询验证
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:view_name]   = 'default'
				args[:owner_list]  = Node_Name_List
				args[:domain_name] = 'knet.cn'
				args[:rtype]       = 'A'
				begin
					# 先清除所有缓存, 保证不受其他case影响
					r << Recu_er.del_all_cache_all_device(args)
					# 生成缓存
					r << DNS.dig_all_node_to_make_cache(args)
					Node_Name_List.each do |nodeName|
						args[:nodeName] = nodeName
						# 查询, 不为空
						r << Recu_er.search_domain_in_cache(args, result = true)
						# 清理缓存
						r << Recu_er.del_cache_of_domain(args)
						# 再查询, 为空
						r << Recu_er.search_domain_in_cache(args, result = false)
					end
				rescue
					puts "unknown error on #{@case_ID}"
					r << 'failed'
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_16166(args)
				# 删除查询到的域名
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:view_name]   = 'default'
				args[:owner_list]  = Node_Name_List
				args[:domain_name] = 'knet.cn'
				qq_ttl             = '600'
				args[:rtype]       = 'A'
				begin
					# 先清除所有缓存, 保证不受其他case影响
					r << Recu_er.del_all_cache_all_device(args)
					# 生成缓存
					r << DNS.dig_all_node_to_make_cache(args)
					Node_Name_List.each do |nodeName|
						args[:nodeName] = nodeName
						# 查询后删除
						r << Recu_er.search_domain_in_cache(args, result = true)
						r << Recu_er.del_searched_domain_from_cache
					end
					Node_IP_List.each do |node_ip|
						args[:node_ip] = node_ip
						ttl = Recu_er.get_ttl_value(args)
						r << 'fail' if ttl != qq_ttl
					end
				rescue
					puts "unknown error on #{@case_ID}"
					r << 'failed'
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_16167(args)
				# 清除一个域名缓存查询其他域名缓存
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:view_name]  = 'default'
				args[:owner_list] = Node_Name_List
				domain_1          = 'baidu.com'
				domain_2          = 'sohu.com'
				args[:rtype]      = 'A'
				begin
					# 先清除所有缓存, 保证不受其他case影响
					r << Recu_er.del_all_cache_all_device(args)
					# 生成缓存
					[domain_1, domain_2].each do |domain|
						args[:domain_name] = domain
						r << DNS.dig_all_node_to_make_cache(args)
					end
					# 清理baidu.com后查询sohu.com
					Node_Name_List.each do |nodeName|
						args[:nodeName]    = nodeName
						args[:domain_name] = domain_1
						r << Recu_er.del_cache_of_domain(args)
						r << Recu_er.search_domain_in_cache(args, result = false)
						args[:domain_name] = domain_2
						r << Recu_er.search_domain_in_cache(args, result = true)
					end
				rescue
					puts "unknown error on #{@case_ID}"
					r << 'failed'
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_16168(args)
				# 清除一个设备缓存查询其他设备缓存
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:view_name]   = 'default'
				args[:owner_list]  = Node_Name_List
				args[:domain_name] = 'knet.cn'
				args[:rtype]       = 'A'
				begin
					# 先清除所有缓存, 保证不受其他case影响
					r << Recu_er.del_all_cache_all_device(args)
					# 生成缓存
					r << DNS.dig_all_node_to_make_cache(args)
					# 清理master后查询为空
					args[:nodeName] = Master_Device
					r << Recu_er.del_cache_of_device(args)
					r << Recu_er.search_domain_in_cache(args, result = false)
					# 查询slave不为空
					args[:nodeName] = Slave_Device
					r << Recu_er.search_domain_in_cache(args, result = true)
				rescue
					puts "unknown error on #{@case_ID}"
					r << 'failed'
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_16165(args)
				# 清除一个视图缓存查询其他视图缓存
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				tmp_view_name      = "view_#{@case_ID}"
				args[:acl_name]    = "acl_#{@case_ID}"
				args[:acl_list]    = Local_Network
				args[:owner_list]  = Node_Name_List
				args[:domain_name] = "baidu.com"
				args[:rtype]       = 'A'
				begin
					# 先清除所有缓存, 保证不受其他case影响
					r << Recu_er.del_all_cache_all_device(args)
					# 生成default视图缓存
					r << DNS.dig_all_node_to_make_cache(args)
					# 生成view视图缓存
					args[:view_name] = tmp_view_name
					r << ACL_er.create_acl(args)
					r << View_er.create_view(args)
					sleep 5 # waiting the new view works
					r << DNS.dig_all_node_to_make_cache(args)
					# 清理deault缓存后查询为空
					Node_Name_List.each do |nodeName|
						args[:nodeName]  = nodeName
						args[:view_name] = 'default'
						r << Recu_er.del_cache_of_view(args)
						r << Recu_er.search_domain_in_cache(args, result = false)
						# 查询view视图不为空
						args[:view_name] = tmp_view_name
						r << Recu_er.search_domain_in_cache(args, result = true)
					end
					# 清理
					r << View_er.del_view(args)
					r << ACL_er.del_acl(args)
				rescue
					puts "unknown error on #{@case_ID}"
					r << 'failed'
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_16160(args)
				# 选择错误类型查询
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:view_name]   = 'default'
				args[:owner_list]  = Node_Name_List
				args[:domain_name] = "sohu.com"
				args[:rtype]       = 'A'
				rtype_list         = ['AAAA', 'MX', 'CNAME', 'NAPTR', 'SRV', 'PTR', 'TXT', 'DNAME']
				begin
					# 先清除所有缓存, 保证不受其他case影响
					r << Recu_er.del_all_cache_all_device(args)
					# 生成default视图缓存
					r << DNS.dig_all_node_to_make_cache(args)
					Node_Name_List.each do |nodeName|
						args[:nodeName]  = nodeName
						rtype_list.each do |rtype|
							args[:rtype] = rtype
							r << Recu_er.search_domain_in_cache(args, result = false)
						end
					end
				rescue
					puts "unknown error on #{@case_ID}"
					r << 'failed'
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_16161(args)
				# 输入错误域名查询
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:view_name]   = 'default'
				args[:owner_list]  = Node_Name_List
				args[:domain_name] = "baidu.com"
				args[:rtype]       = 'A'
				wrong_domain_list  = ['b@id5.c0m', '$0.c0w', '#2^%!', '(?.*)']
				begin
					# 先清除所有缓存, 保证不受其他case影响
					r << Recu_er.del_all_cache_all_device(args)
					# 生成default视图缓存
					r << DNS.dig_all_node_to_make_cache(args)
					Node_Name_List.each do |nodeName|
						args[:nodeName] = nodeName
						wrong_domain_list.each do |domain|
							args[:domain_name] = domain
							r << Recu_er.search_domain_in_cache(args, result = false)
						end
					end
				rescue
					puts "unknown error on #{@case_ID}"
					r << 'failed'
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_22510(args)
				# 查询中文域名缓存
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:view_name]  = 'default'
				args[:owner_list] = Node_Name_List
				domain_1          = 'xn--xkry9kk1bz66a.xn--fiqs8s' # 清华大学.中国
				domain_2          = 'xn--fiqa61aj10a6mlyo9bnxag3d.xn--fiqs8s' # 中国互联网络中心.中国
				args[:rtype]      = 'A'
				begin
					# 先清除所有缓存, 保证不受其他case影响
					r << Recu_er.del_all_cache_all_device(args)
					# 生成default视图缓存
					[domain_1, domain_2].each do |d_name|
						args[:domain_name] = d_name
						r << DNS.dig_all_node_to_make_cache(args)
					end
					Node_Name_List.each do |nodeName|
						args[:nodeName] = nodeName
						args[:rtype]    = 'ANY'
						['中国互联网络中心.中国', '清华大学.中国'].each do |d_name|
							args[:domain_name] = d_name
							r << Recu_er.search_domain_in_cache(args, result = true)
						end
					end
				rescue
					puts "unknown error on #{@case_ID}"
					r << 'failed'
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
		end
	end
end