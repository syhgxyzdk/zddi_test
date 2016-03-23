# encoding: utf-8
require File.dirname(__FILE__) + '/../../zddi'
module ZDDI
	module DNS
		class Feedback
			def case_23433(args)
				@case_ID = __method__.to_s.split('_')[1]
				r        = []
				begin
					# 启动/停止NTP服务
					args[:process_name] = 'ntpd'
					Node_Name_List.each do |nodeName|
						args[:node_name] = nodeName
						args[:owner_list]  = [nodeName]
						r << Cloud.stop_device_ntp_service(args)
						r << DNS.grep_process_node(args, process_gone = true)
						r << Cloud.start_device_ntp_service(args)
						r << DNS.grep_process_node(args, process_gone = false)
					end
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_1111(args)
				@case_ID = __method__.to_s.split('_')[1]
				r        = []
				# begin
					# get svg element
					# Node_Name_List.each do |nodeName|
						args[:node_name] = Master_Device
						r << Cloud.open_device(args)
						# puts ZDDI.browser.span(:class=>"dnsChartTitle").text
						# puts ZDDI.browser.div(:class=>"dnsChart_wrap").svg(:height=>"260")
						puts ZDDI.browser.element_by_xpath('//*[@id="dnsStatusCharts"]/div/div/div/div/ul/li[1]/div/div/svg').double_click
						puts 'after double clicking'
					# end
				# rescue
				# 	puts "unknown error on #{@case_ID}"
				# 	return "failed case #{@case_ID}"
				# end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
        end
    end
end			