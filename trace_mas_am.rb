# encoding = utf-8
# Stop automation and send mail if found the 'core.xxxx' file on master/slave.
# require "win32ole"
require  File.dirname(__FILE__) + '/zddi'

mas_process_gone    = false
log_process_gone    = false
node_user       = 'root'
proc_name       = 'ruby.exe'
grep_mas        = 'ps aux |  grep -v grep | grep mas'
grep_log_server = 'ps aux |  grep -v grep | grep log_server'


sleep 60 # waiting automation running

while !mas_process_gone or !log_process_gone
	Node_IP_List.each_index do |index|
		node_ip  = Node_IP_List[index]
		node_pwd = Node_Pwd_List[index]
		Net::SSH.start(node_ip, node_user, :password=>node_pwd) do |ssh|
		    grep_mas_result = ssh.exec!(grep_mas)
		    grep_log_result = ssh.exec!(grep_log_server)
		    if !grep_mas_result.include?('zdns:mas_am') && !mas_process_gone
		    	puts "!!! mas_am disappered!!"
		    	mas_process_gone = true
		    	ZDDI.send_mail("Warning!!!  !!! mas_am disappered!!  on #{node_ip}")
		    	sleep 5
		    	# `rundll32 powrprof.dll,SetSuspendState`
		    elsif !grep_log_result.include?('/usr/local/zddi/dns/log/query.log') && !log_process_gone
		    	puts "!!! log_server disappered!!"
		    	log_process_gone = true
		    	ZDDI.send_mail("Warning!!!  !!! log_server disappered!!  on #{node_ip}")
		    	sleep 5
		    elsif
		    	sleep 60
		    	puts 'Process mas_am and log_server OK!' 
			end
		end
	end
end