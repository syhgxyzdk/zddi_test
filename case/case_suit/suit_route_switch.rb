# encoding: utf-8
require File.dirname(__FILE__) + '/../../zddi'
module ZDDI
	module DNS
		# 路由切换 + 后台检测
		class Route_switch
			def case_10911(args)
				# bind进程正常, ospdf进程正常
				@case_ID       = __method__.to_s.split('_')[1]
				r              = []
				route_pro_list = ['ospfd', 'zebra']
				bind_process   = '/usr/local/sbin/zdns -c'
				begin
					# 先检查route_switch进程
					args[:owner_list]   = Node_Name_List
					args[:process_name] = 'route_switch'
					r << DNS.grep_process_node(args)
					if r.to_s.include?('fail')
						puts "route_switch is not working, cancelled #{@case_ID}" 
						return "failed case #{@case_ID}"
					end
					# bind进程正常, 则zebra/ospfd正常
					args[:process_name] = bind_process
					if DNS.grep_process_node(args) == 'succeed'
						route_pro_list.each do |ps|
							args[:process_name] = ps
							r << DNS.grep_process_node(args)
						end
					end
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_10910(args)
				# bind进程关闭 ospfd进程退出
				@case_ID       = __method__.to_s.split('_')[1]
				r              = []
				route_pro_list = ['ospfd', 'zebra']
				bind_process   = '/usr/local/sbin/zdns -c'
				begin
					# 先检查route_switch进程
					args[:owner_list]   = Node_Name_List
					args[:process_name] = 'route_switch'
					r << DNS.grep_process_node(args)
					if r.to_s.include?('fail')
						puts "route_switch is not working, cancelled #{@case_ID}" 
						return "failed case #{@case_ID}"
					end
					# kill bind进程, 则zebra/ospfd退出
					args[:process_name] = bind_process
					[Master_Device, Slave_Device].each do |device|
						args[:kill_device] = device
						r << DNS.kill_process_node(args)
					end
					if DNS.grep_process_node(args, process_gone = true) == 'succeed'
						route_pro_list.each do |ps|
							args[:process_name] = ps
							r << DNS.grep_process_node(args, process_gone = true)
						end
					end
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_20790(args)
				# bind进程关闭后自动重启bind
				@case_ID     = __method__.to_s.split('_')[1]
				r            = []
				bind_process = '/usr/local/sbin/zdns -c'
				begin
					# 先检查route_switch进程
					args[:owner_list]   = Node_Name_List
					args[:process_name] = 'route_switch'
					r << DNS.grep_process_node(args)
					if r.to_s.include?('fail')
						puts "route_switch is not working, cancelled #{@case_ID}" 
						return "failed case #{@case_ID}"
					end
					# kill bind进程, 10s后自动重启bind
					args[:process_name] = bind_process
					[Master_Device, Slave_Device].each do |device|
						args[:kill_device] = device
						r << DNS.kill_process_node(args)
					end
					sleep 10
					r << DNS.grep_process_node(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_20791(args)
				# route_switch进程关闭后自动重启route_switch
				@case_ID = __method__.to_s.split('_')[1]
				r        = []
				route    = 'route_switch'
				begin
					# 先检查route_switch进程
					args[:owner_list]   = Node_Name_List
					args[:process_name] = route
					r << DNS.grep_process_node(args)
					if r.to_s.include?('fail')
						puts "route_switch is not working, cancelled #{@case_ID}" 
						return "failed case #{@case_ID}"
					end
					# kill route进程, 10s后自动重启bind
					args[:process_name] = route
					[Master_Device, Slave_Device].each do |device|
						args[:kill_device] = device
						r << DNS.kill_process_node(args)
					end
					sleep 10
					r << DNS.grep_process_node(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_20773(args)
				# zdns:dcp_agent/cms_cloud进程不在=>重启整个服务
				@case_ID  = __method__.to_s.split('_')[1]
				r         = []
				dcp_agent = "zdns:dcp_agent"
				cms_cloud = "zdns:cms_cloud"
				begin
					# 先检查route_switch进程
					args[:owner_list]   = Node_Name_List
					args[:process_name] = 'route_switch'
					r << DNS.grep_process_node(args)
					if r.to_s.include?('fail')
						puts "route_switch is not working, cancelled #{@case_ID}" 
						return "failed case #{@case_ID}"
					end
					# 开始测试, kill目标进程, 检查是否重启成功
					args[:process_name] = dcp_agent # dcp_agent在Master/Slave都有
					[Master_Device, Slave_Device].each do |device|
						args[:kill_device] = device
						r << DNS.kill_process_node(args)
					end
					args[:kill_device]  = Master_Device # cms_cloud只在master才有
					args[:process_name] = cms_cloud
					r << DNS.kill_process_node(args)
					sleep 60
					args[:process_name] = dcp_agent
					r << DNS.grep_process_node(args)
					args[:owner_list]   = [Master_Device]
					args[:process_name] = cms_cloud
					r << DNS.grep_process_node(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_20774(args)
				@case_ID  = __method__.to_s.split('_')[1]
				r         = []
				log_server = "log_server"
				begin
					# 先检查route_switch进程
					args[:owner_list]   = Node_Name_List
					args[:process_name] = 'route_switch'
					r << DNS.grep_process_node(args)
					if r.to_s.include?('fail')
						puts "route_switch is not working, cancelled #{@case_ID}" 
						return "failed case #{@case_ID}"
					end
					# 开始测试, kill目标进程, 检查是否重启成功
					args[:process_name] = log_server
					[Master_Device, Slave_Device].each do |device|
						args[:kill_device] = device
						r << DNS.kill_process_node(args)
					end
					sleep 30
					r << DNS.grep_process_node(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
			def case_20775(args)
				@case_ID = __method__.to_s.split('_')[1]
				r        = []
				mas_am   = "zdns:mas_am"
				begin
					# 先检查route_switch进程
					args[:owner_list]   = Node_Name_List
					args[:process_name] = 'route_switch'
					r << DNS.grep_process_node(args)
					if r.to_s.include?('fail')
						puts "route_switch is not working, cancelled #{@case_ID}" 
						return "failed case #{@case_ID}"
					end
					# 开始测试, kill目标进程, 检查是否重启成功
					args[:process_name] = mas_am
					[Master_Device, Slave_Device].each do |device|
						args[:kill_device] = device
						r << DNS.kill_process_node(args)
					end
					sleep 30
					r << DNS.grep_process_node(args)
				rescue
					puts "unknown error on #{@case_ID}"
					return "failed case #{@case_ID}"
				end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
		end
	end
end