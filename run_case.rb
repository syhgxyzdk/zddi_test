# encoding: utf-8
require File.dirname(__FILE__) + '/zddi'

class Run_suits
    URL           = "https://#{Master_IP}/index"
    Browser       = 'chrome'
    User          = 'admin'
    Passwd        = 'zdns'
    Git_Br        = 'master'
    @@start_time  = nil
    @@end_time    = nil
    @@suit_result = "" # [Feature: #{suit} Total: 10  Pass: 10 Fail: 0]
    @@case_result = "" # [Pass_case_1234, Fail_case_#{suit}_4321]
    @@case_total  = 0
    @@case_pass   = 0
    @@case_fail   = 0
	def start_browser
		ZDDI.init_browser(Browser)
		ZDDI.login(URL, User, Passwd)
	end
    def clean_up
        ZDDI.clean_up
    end
    def quit_browser
        ZDDI.browser.close
    end
	def run_suit(suit, resetData)
        start_browser
        clean_up if resetData
        puts "\n--> Ready To Test: #{suit}\n"
        @total  = 0
        @pass   = 0
        @fail   = 0
        @result = ""
		begin
			r_list = ZDDI.send(suit)
            @total = r_list.size
			r_list.each do |r|
				if r.include?('succeed') && !r.include?('failed')
                    @pass += 1
                    @@case_result += "Pass_case_#{r.split("\s")[3]}\n"
			    else
                    @fail += 1
                    @@case_result += "--> Fail_case_#{suit}_#{r.split("\s")[2]}\n"
			    end
		    end
        rescue SyntaxError => e
            puts e
        rescue
            puts "#{$@.inspect}\n"
            puts "=> Code error : #{$!}\n"
        ensure
            quit_browser
        end
        @result = "Total: #{@total}  Pass: #{@pass}  Fail: #{@fail}  Name: #{suit}\n"
        puts @result
        @@case_total  += @total
        @@case_pass   += @pass
        @@case_fail   += @fail
        @@suit_result += @result
	end
	def run_suit_list(suit_list, resetData = true)
        @@start_time = DateTime.now if !@@start_time
        begin
			suit_list.each { |suit| run_suit(suit, resetData) }
		rescue
			puts "\n Code Error!!! Please Debug..."
		end
		@@end_time = DateTime.now # 刷新结束时间
	end
    def restart_pc
        `shutdown -r -t 20`
    end
    def send_report
        @test_report = ""
        @history_log = File.new(File.dirname(__FILE__) + '/case/log/history_result.log', 'a')
        @latest_log  = File.new(File.dirname(__FILE__) + '/case/log/latest_result.log','w')
        test_result  = []
        test_result << "\tAll Cases Pass !!!\n" if @@case_total == @@case_pass && @@case_total > 0
        test_result << "------------------------------------------\n"
        test_result << "=>\tGit Branch :\t#{Git_Br}\n"
        test_result << "------------------------------------------\n"
        test_result << "=>\tStart Time :\t#{@@start_time.strftime("%Y-%m-%d %H:%M:%S")}\n"
        test_result << "=>\tEnd Time   :\t#{@@end_time.strftime("%Y-%m-%d %H:%M:%S")}\n"
        test_result << "------------------------------------------\n"
        test_result << "=>\tMaster:\t#{Master_IP}\n"
        test_result << "=>\tSlave :\t#{Slave_IP}\n"
        test_result << "------------------------------------------\n"
        test_result << "Total => #{@@case_total}\nPass => #{@@case_pass}\nFail => #{@@case_fail}\n"
        test_result << "#{format("%0.2f", @@case_pass.to_f/@@case_total.to_f * 100)}% Pass\n"
        test_result << "------------------------------------------\n"
        test_result << @@suit_result
        test_result << "------------------------------------------\n"
        test_result << @@case_result
        test_result << "----------->  End Of Report  <-----------"
        # write log && send report
        test_result.each do |result|
            @history_log.puts(result)
            @latest_log.puts(result)
            @test_report += result
        end
        @history_log.close
        @latest_log.close
        ZDDI.send_mail(@test_report)
        # reset statistic
        @@start_time  = nil
        @@end_time    = nil
        @@suit_result = ""
        @@case_result = ""
        @@case_total  = 0
        @@case_pass   = 0
        @@case_fail   = 0
    end
end

############   re-run failed case(s) in latest_result.log   ############

class Run_failed_case < Run_suits
    @@failed_case_list = Array.new
    @@rerun_result_list = Array.new
    def get_failed_case
        result_lines  = IO.readlines(File.dirname(__FILE__) + '/case/log/latest_result.log')
        result_lines.each do |r|
            if r.include?('Fail_case')
                case_info    = []
                case_feature = r.split('_')[2..-2].join('_')
                case_id      = 'case_' + r.split('_')[-1].chomp
                case_info << case_feature
                case_info << case_id
                @@failed_case_list << case_info
            end
        end
    end
    def get_feature_name(suit_name)
        case suit_name
        ########   Authority manage   ##########
        when 'view_suit'
            feature = 'View'
        when 'zone_suit'
            feature = 'Zone'
        when 'domain_suit'
            feature = 'Domain'
        when 'share_zone_suit'
            feature = 'Share_zone'
        ########   Rescursion manage   ##########
        when 'stub_suit'
            feature = 'Stub'
        when 'forward_suit'
            feature = 'Forward'
        when 'redirect_suit'
            feature = 'Redirect'
        when 'hint_zone_suit'
            feature = 'Hint_zone'
        when 'local_policies_suit'
            feature = 'Local_policies'
        when 'cache_manage_suit'
            feature = 'Cache_manage'
        when 'query_source_suit'
            feature = 'Query_source'
        when 'fail_forward_suit'
            feature = 'Fail_forward'
        when 'redirections_suit'
            feature = 'Redirections'
        ########   Acl manage   ##########
        when 'acl_suit'
            feature = 'ACL'
        when 'ip_rrls_suit'
            feature = 'IP_rrls'
        when 'domain_rrls_suit'
            feature = 'Domain_rrls'
        when 'monitor_strategies_suit'
            feature = 'Monitor_strategies'
        when 'route_switch_suit'
            feature = 'Route_switch'    
        ########   System manage   ##########
        when 'user_manage_suit'
            feature = 'User_manage'
        when 'log_manage_suit'
            feature = 'Log_manage'
        when 'alarm_manage_suit'
            feature = 'Alarm_manage'
        when 'system_maintenance_suit'
            feature = 'System_maintenance'
        ########   Node manage   ##########
        when 'node_manage_suit'
            feature = 'Node_manage'
        end
        return feature
    end
    def re_run_failed_case
        get_failed_case
        start_browser
        clean_up
        quit_browser
        @@start_time = DateTime.now if !@@start_time
        @@failed_case_list.each do |case_info|
            feature = get_feature_name(case_info[0])
            case_id = case_info[1]
            begin
                start_browser
                r = ZDDI.const_get(feature).send(case_id, {})
                @@rerun_result_list << "#{feature}_#{r}"
            rescue
                puts "Error while re-run: #{feature}, #{case_id} ..."
            ensure
                quit_browser
            end
        end
        @@end_time = DateTime.now
    end
    def calc_rerun_result
        @@case_total = @@rerun_result_list.size
        @@rerun_result_list.each do |r|
            if r.include?('succeed') && !r.include?('failed')
                @@case_pass += 1
                feature = r.split('_')[0]
                case_id = r.split("\s")[3]
                @@case_result += "Pass_case_#{feature}_#{case_id}\n"
            else
                @@case_fail += 1
                feature = r.split('_')[0]
                case_id = r.split("\s")[2]
                @@case_result += "--> Fail_case_#{feature}_#{case_id}\n"
            end
        end
    end
    def send_rerun_report
        calc_rerun_result
        @test_report = ""
        @failed_log  = File.new(File.dirname(__FILE__) + '/case/log/re_run_failed_case.log','w')
        test_result  = []
        test_result << "------------------------------------------\n"
        test_result << "=>\tGit Branch :\t #{Git_Br}_Re run failed case \n"
        test_result << "------------------------------------------\n"
        test_result << "=>\tStart Time :\t#{@@start_time.strftime("%Y-%m-%d %H:%M:%S")}\n"
        test_result << "=>\tEnd Time   :\t#{@@end_time.strftime("%Y-%m-%d %H:%M:%S")}\n"
        test_result << "------------------------------------------\n"
        test_result << "=>\tMaster:\t#{Master_IP}\n"
        test_result << "=>\tSlave :\t#{Slave_IP}\n"
        test_result << "--------->   Re_run #{@@case_total} Case(s)   <---------\n"
        test_result << "Total => #{@@case_total}\nPass => #{@@case_pass}\nFail => #{@@case_fail}\n"
        test_result << "#{format("%0.2f", @@case_pass.to_f/@@case_total.to_f * 100)}% Pass\n"
        test_result << @@case_result
        test_result << "--------->  End of Results  <--------"
        # writing log && sending report
        test_result.each do |result|
            @failed_log.puts(result)
            @test_report += result
        end
        @failed_log.close
        ZDDI.send_mail(@test_report)
        # reset statistic
        @@start_time  = nil
        @@end_time    = nil
        @@case_result = ""
        @@case_total  = 0
        @@case_pass   = 0
        @@case_fail   = 0
    end
end
