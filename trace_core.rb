# encoding = utf-8
# Stop automation and send mail if found the 'core.xxxx' file on master/slave.
# require "win32ole"
require  File.dirname(__FILE__) + '/zddi'

found_core_dump = false
node_user       = 'root'
proc_name       = 'ruby.exe'
ls_file         = 'ls /usr/local/zddi/dns/etc/'

sleep 60 # waiting automation running

while !found_core_dump
	Node_IP_List.each_index do |index|
		node_ip  = Node_IP_List[index]
		node_pwd = Node_Pwd_List[index]
		Net::SSH.start(node_ip, node_user, :password=>node_pwd) do |ssh|
		    file_list = ssh.exec!(ls_file)
		    if file_list.include?('core.')
		    	puts "!!! Found Core Dump on #{node_ip} !!!"
		    	found_core_dump = true
		    	ZDDI.send_mail("Warning!!!   Found CORE DUMP File!!!  on #{node_ip}")
		    	sleep 5
		    	# `rundll32 powrprof.dll,SetSuspendState`
		    else
		    	sleep 60
		    	puts 'No Core Dump' 
			end
		end
	end
end