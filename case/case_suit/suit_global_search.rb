# encoding: utf-8
require File.dirname(__FILE__) + '/../../zddi'

module ZDDI
	module DNS
		class Global_search
			def case_1660(args)
				# 全局搜索+编辑
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:view_name]   = 'default'
				args[:zone_name]   = "zone.#{@case_ID}"
				args[:owner_list]  = Node_Name_List
				rname_edit         = 'search_edit'
				rname_del          = 'search_del'
				rdata_edit         = '1.2.3.4'
				rdata_del          = '4.3.2.1'
				args[:domain_list] = [
					{'rname'=>rname_edit, 'rtype'=>'A', 'rdata'=>rdata_edit},
					{'rname'=>rname_del, 'rtype'=>'A', 'rdata'=>rdata_del}]
				begin
			        r << Zone_er.create_zone(args)
			        r << Domain_er.create_domain(args)
			        # 全局搜索, 编辑
					args[:search_item] = "#{rname_edit}.#{args[:zone_name]}"
					args[:ttl]         = '600'
					args[:rdata]       = '192.168.16.60'
			  		r << Search_er.search_and_edit(args)
			  		# 全局搜索, 删除
			  		args[:search_item] = rdata_del
			  		r << Search_er.search_and_del(args)
			  		# Dig编辑
			  		Node_IP_List.each do |ip|
						args[:dig_ip]      = ip
						args[:domain_name] = "#{rname_edit}.#{args[:zone_name]}"
						args[:rtype]       = 'A'
			  			r << DNS.dig_as_noerror(args)
				  	end 		
			  		# Dig删除
			  		Node_IP_List.each do |ip|
						args[:dig_ip]      = ip
						args[:domain_name] = "#{rname_del}.#{args[:zone_name]}"
						args[:rtype]       = 'A'
			  			r << DNS.dig_as_nxdomain(args)
				  	end 
			        # 清理
			  		r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1661(args)
				# 全局搜索 编辑输入错误
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				rname              = '1661'
				rdata              = '192.168.16.61'
				ttl_wrong          = '2147483648'
				rdata_wrong        = '192.168.16.256'
				args[:view_name]   = 'default'
				args[:zone_name]   = "zone.#{@case_ID}"
				args[:owner_list]  = Node_Name_List
				args[:domain_list] = [{'rname'=>rname, 'rtype'=>'A', 'rdata'=>rdata}]
				begin
			        r << Zone_er.create_zone(args)
			        r << Domain_er.create_domain(args)
			        # 全局搜索 -> 编辑 -> Error
			        args[:error_type] = 'before_OK'
			        DNS.open_search_page
	                DNS.search_elem(rdata)
	                DNS.popup_right_menu('edit', true)
                    DNS.popwin.text_field(:name, "ttl").set(ttl_wrong)
                    args[:error_info] = 'TTL值的范围为:0-2147483647'
			        r << DNS.error_validator_on_popwin(args)
			        DNS.search_elem(rdata)
			        DNS.popup_right_menu('edit', true)
			        DNS.popwin.text_field(:name, "rdata").set(rdata_wrong)
			        args[:error_info] = '输入合法的IPv4地址，例如：192.168.1.1'
					r << DNS.error_validator_on_popwin(args)
					# 清理
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1667(args)
				# 全局搜索删除ns记录失败
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:view_name]   = 'default'
				args[:zone_name]   = "zone.#{@case_ID}"
				args[:owner_list]  = Node_Name_List
				begin
			        r << Zone_er.create_zone(args)
			        DNS.open_search_page
	                DNS.search_elem("ns.zone.#{@case_ID}")
	                DNS.popup_right_menu('del', true)
	                args[:error_type] = 'after_OK'
			        args[:error_info] = 'ns.zone.1667. A 127.0.0.1:该glue记录被其他记录使用'
					r << DNS.error_validator_on_popwin(args)
					# 清理
					r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1649(args)
				# 全局搜索 *cn*
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:view_name]   = 'default'
				args[:zone_name]   = 'cn'
				args[:owner_list]  = Node_Name_List
				rname_1            = 'cn_begin'
				rname_2            = 'middle_cn'
				rname_3            = 'end_cn'
				rname_4			   = '中文'
				rdata              = '192.168.16.49'
				args[:domain_list] = [
					{'rname'=>rname_1, 'rtype'=>'A', 'rdata'=>rdata},
					{'rname'=>rname_2, 'rtype'=>'A', 'rdata'=>rdata},
					{'rname'=>rname_3, 'rtype'=>'A', 'rdata'=>rdata},
					{'rname'=>rname_4, 'rtype'=>'A', 'rdata'=>rdata}]
				begin
			        r << Zone_er.create_zone(args)
			        r << Domain_er.create_domain(args)
					{'cn*'=>3, '*cn*'=>7, '*cn'=>7, '中文*'=>0}.each_pair do |item, number|
						args[:search_item] = item
				  		s = Search_er.get_search_result(args)
				  		r << 'fail' if s.size != number
				  	end
			        # 清理
			  		r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1685(args)
				# 搜索错误关键字
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:view_name]   = 'default'
				@view_name         = "view_#{@case_ID}"
				args[:zone_name]   = "zone.#{@case_ID}"
				args[:owner_list]  = [Master_Device]
				rname              = 'search_wrong'
				rdata              = '192.168.1.1'
				args[:domain_list] = [{'rname'=>rname, 'rtype'=>'A', 'rdata'=>rdata}]
				begin
			        r << Zone_er.create_zone(args)
			        r << Domain_er.create_domain(args)
					args[:search_item] = '!search?'
			  		s = Search_er.get_search_result(args)
			  		r << 'fail' if s.size != 0
			        # 清理
			  		r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_21104(args)
				# 全局搜索 ip*
				@case_ID          = __method__.to_s.split('_')[1]
				r                 = []
				args[:view_name]  = 'default'
				@view_name        = "view_#{@case_ID}"
				args[:zone_name]  = "zone.#{@case_ID}"
				args[:owner_list] = [Master_Device]
				rname             = 'search'
				rdata_1           = '192.168.1.1'
				rdata_2           = '192.168.1.2'
				rdata_3           = '192.168.1.3'
				args[:domain_list] = [
					{'rname'=>rname, 'rtype'=>'A', 'rdata'=>rdata_1},
					{'rname'=>rname, 'rtype'=>'A', 'rdata'=>rdata_2},
					{'rname'=>rname, 'rtype'=>'A', 'rdata'=>rdata_3} ]
				begin
			        r << Zone_er.create_zone(args)
			        r << Domain_er.create_domain(args)
					args[:search_item] = '192.168*'
			  		s = Search_er.get_search_result(args)
			  		r << 'fail' if s.size != 3
			        # 清理
			  		r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_21102(args)
				# 全局搜索 domain*
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:view_name]   = 'default'
				@view_name         = "view_#{@case_ID}"
				args[:zone_name]   = "zone.#{@case_ID}"
				args[:owner_list]  = [Master_Device]
				rname_1            = 'search_1'
				rname_2            = 'search_2'
				rname_3            = 'search_3'
				rdata              = '192.168.1.1'
				args[:domain_list] = [
					{'rname'=>rname_1, 'rtype'=>'A', 'rdata'=>rdata},
					{'rname'=>rname_2, 'rtype'=>'A', 'rdata'=>rdata},
					{'rname'=>rname_3, 'rtype'=>'A', 'rdata'=>rdata} ]
				begin
			        r << Zone_er.create_zone(args)
			        r << Domain_er.create_domain(args)
					args[:search_item] = 'search*'
			  		s = Search_er.get_search_result(args)
			  		r << 'fail' if s.size != 3
			        # 清理
			  		r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_21105(args)
				# 搜索并编辑IPv6地址
				@case_ID           = __method__.to_s.split('_')[1]
				r                  = []
				args[:view_name]   = 'default'
				@view_name         = "view_#{@case_ID}"
				args[:zone_name]   = "zone.#{@case_ID}"
				args[:owner_list]  = Node_Name_List
				rname              = 'search_ipv6'
				rdata              = '1AB:2CD::3EF'
				rdata_new          = '1AB:2CD:3EF::400'
				args[:domain_list] = [{'rname'=>rname, 'rtype'=>'AAAA', 'rdata'=>rdata}]
				begin
			        r << Zone_er.create_zone(args)
			        r << Domain_er.create_domain(args)
			        # 全局搜索, 编辑
					args[:search_item] = rdata
					args[:ttl]         = '600'
					args[:rdata]       = rdata_new
			  		r << Search_er.search_and_edit(args)
			  		# Dig验证编辑
			  		Node_IP_List.each do |ip|
						args[:dig_ip]      = ip
						args[:domain_name] = "#{rname}.#{args[:zone_name]}"
						args[:rtype]       = 'AAAA'
			  			r << DNS.dig_as_noerror(args)
				  	end
				  	# 全局搜索, 删除
			  		args[:search_item] = rdata_new
			  		r << Search_er.search_and_del(args)		
			  		# Dig验证删除成功
			  		Node_IP_List.each do |ip|
						args[:dig_ip]      = ip
						args[:domain_name] = "#{rname}.#{args[:zone_name]}"
						args[:rtype]       = 'AAAA'
			  			r << DNS.dig_as_nxdomain(args)
				  	end 
			        # 清理
			  		r << Zone_er.del_zone(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
        end
    end
end