# encoding: utf-8
$LOAD_PATH.unshift(File.dirname(__FILE__)) unless $LOAD_PATH.include?(File.dirname(__FILE__))

require 'date'
require 'timeout'
require 'win32ole'
require 'Dnsruby'
require 'net/ssh'
require 'net/sftp'
require 'net/smtp'
require 'base64'
require 'simpleidn'
require 'ipaddress'
require 'watir-webdriver'
require File.dirname(__FILE__) + '/step/cloud'       # 云中心
require File.dirname(__FILE__) + '/step/dns'         # 权威管理
require File.dirname(__FILE__) + '/step/recursion'   # 递归管理
require File.dirname(__FILE__) + '/step/acl_manage'  # 访问控制
require File.dirname(__FILE__) + '/step/address'     # 地址管理
require File.dirname(__FILE__) + '/step/system'	     # 系统管理
require File.dirname(__FILE__) + '/case/test_cloud'
require File.dirname(__FILE__) + '/case/test_dns'
require File.dirname(__FILE__) + '/case/test_recursion'
require File.dirname(__FILE__) + '/case/test_acl_manage'
require File.dirname(__FILE__) + '/case/test_ipam'
require File.dirname(__FILE__) + '/case/test_dhcp'
require File.dirname(__FILE__) + '/case/test_system'

ACL_er        = ZDDI::DNS::ACL.new        # 访问控制列表
View_er       = ZDDI::DNS::View.new       # 视图管理
Zone_er       = ZDDI::DNS::Zone.new       # 区管理
Domain_er     = ZDDI::DNS::Domain.new     # 区记录
Share_zone_er = ZDDI::DNS::Share_zone.new # 共享区
Share_rr_er   = ZDDI::DNS::ShareRR.new    # 共享记录
Search_er     = ZDDI::DNS::Search.new     # 全局搜索
Dig_er        = ZDDI::DNS::SyncData.new   # Dig Tool
Recu_er       = ZDDI::DNS::Recursion.new  # 存根/转发/重定向/根配置/本地策略/缓存管理/请求源地址/失败转发
ACL_Mng_er    = ZDDI::DNS::ACL_Manage.new # 解析限速/宕机切换/自动路由切换
IPAM_er       = ZDDI::Address::IPAM.new
User_er       = ZDDI::System::User.new
AUTOIT        = WIN32OLE.new('AutoItX3.Control') # Windows"打开"对话框

module ZDDI
	def self.get_node_info
		node_info_list = []
		server_list    = IO.readlines('server.conf')
	    server_list.each do |line|
            next if line =~ /^#/ or line =~ /^$/
            ip, usr, pwd, type, gName, nName = line.split("\s")
            node_info_list << {:ip=>ip, :usr=>usr, :pwd=>pwd, :type=>type, :gName=>gName, :nName=>nName}
	    end
	    node_info_list
	end
	def self.init_browser(browser)
		@ie = case browser
		when "chrome"
			Watir::Browser.new:chrome, :switches => %w[--start-maximized] #,:profile => profile
		when "ff"
			Watir::Browser.new:ff, :profile=>"default"
		when "ie"
			Watir::Browser.new:ie
		else
			puts "Unknown browser type, fail to init!"
		end
	end
	def self.browser
		@ie
	end
	def self.browser=(browser)
		@ie = browser
	end
	def self.login(site, username, password)
		begin
			ZDDI.browser.goto(site)
			ZDDI.browser.text_field(:name, "login").wait_until_present #等待登录页面
			ZDDI.browser.text_field(:name, "login").set(username)
			ZDDI.browser.text_field(:name, "password").set(password)
			ZDDI.browser.send_keys("\r\n") # '回车'登录
			sleep 1
			puts "succeed to login #{site}"
			return 'succeed'
		rescue
			puts "failed to login #{site}"
			return 'failed'
		end
	end
	def self.clean_up
		# reset page data by open_page -> select && delete records
		dns_page_list = %w[open_default_view_page open_share_rr_page open_stub_zone_page open_forward_zone_page open_redirect_page open_hint_zone_page open_local_policies_page open_query_source_page open_query_source_monitor_page open_view_manage_page goto_default_view_sortlist_page open_acl_page open_ip_rrls_page open_domain_rrls_page open_monitor_strategies_page open_redirections_page]
		sys_page_list = %w[open_user_page]
		dns_page_list.each do |open_page|
			begin
        		DNS.send(open_page)
        		del_failed_items
        	rescue
        		puts "-> Error of clear_up...#{open_page}"
        	end
    	end
    	sys_page_list.each do |open_page|
	    	begin
        		System.send(open_page)
        		del_failed_items
        	rescue
        		puts "-> Error of clear_up...#{open_page}"
        	end
        end
    	# delete *.txt which in '~/Download/' folder.
    	Dir.entries(Download_Dir).each do |file_name|
		 	file = File.join(Download_Dir, file_name)
			File.delete(file) if file_name.include?('.txt')
		end
	end
	def self.del_failed_items
		ZDDI.browser.checkbox(:class, "checkAll").set
		# uncheck "default" view and "admin" user since they are not deletable!
		if ZDDI.browser.checkbox(:value, "default").exist?
			ZDDI.browser.checkbox(:value, "default").clear
		end
		if ZDDI.browser.checkbox(:value, "admin").exist?
			ZDDI.browser.checkbox(:value, "admin").clear
		end
		if !ZDDI.browser.button(:class, "del").disabled?
			ZDDI.browser.button(:class, "del").click
        	DNS.waiting_operate_finished
        end
	end
	def self.send_mail(test_result)
	    smtp_host   = 'smtp.knet.cn'
	    smtp_domain = 'knet.cn'
	    from        = From_Mail
	    pwd         = Mail_Pwd
	    to          = To_Mail
	    head_msg    = <<HEAD_MSG
From: Automation_Testing_Master_Branch
To: ZDNS QE Team
Date: #{Time.now}
Subject: Automation testing report
Content-type: text/html;charset=utf-8

HEAD_MSG

	    reports = test_result.split("\n")
	    body_msg = ""
	    reports.each do |log|
	      body_msg += log
	      body_msg += "<br>"
	    end
	    msg = head_msg + body_msg
	    Net::SMTP.start(smtp_host, 25, smtp_domain, from, pwd, :plain) do |smtp|
	      smtp.send_message(msg, from, to)
	    end
    end
end

Node_Info_List  = ZDDI.get_node_info
Node_IP_List    = []
Node_User_List  = []
Node_Pwd_List   = []
Node_Group_List = []
Node_Name_List  = []

Node_Info_List.each do |node_info|
    Node_IP_List     << node_info[:ip]
    Node_User_List   << node_info[:usr]
    Node_Pwd_List    << node_info[:pwd]
    Node_Group_List  << node_info[:gName]
    Node_Name_List   << node_info[:nName]
end

Master_IP     = Node_IP_List[0]
Master_Device = Node_Name_List[0]
Master_Group  = Node_Group_List[0]

Slave_IP      = Node_IP_List[1]
Slave_Device  = Node_Name_List[1]
Slave_Group   = Node_Group_List[1]

Named_Conf    = '/usr/local/zddi/dns/etc/zdns.conf'
Node_DB_dir   = '/usr/local/zddi/'
Dnsperf_Dir   = '/root/dnsperf/'
Local_Network = ['203.119.0.0/16', '202.173.0.0/16']
DNS_Port      = '53'

Download_Dir  = "C:\\Users\\#{ENV['USERNAME']}\\Downloads\\"               # 导出文件默认在'下载'目录(win7)
Upload_Dir    = (File.dirname(__FILE__) + '/case/upload/').gsub("/", "\\") # 导入/批量添加的本地起始路径

From_Mail     = 'sendmail@knet.cn'
Mail_Pwd      = 'S2e3N4d5M7'
To_Mail       = 'zhangdakang@knet.cn'

Monitor_Strtime = 300 # 5 mins for monitor_strategy taking effects
Slave_Zone_Expiration = 900 # Slave Zone Expire...
Lock_User_Msg   = '连续5次登录失败，15分钟之内禁止登录.'