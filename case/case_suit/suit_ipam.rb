# encoding: utf-8
require File.dirname(__FILE__) + '/../../zddi'
module ZDDI
	module Address
		class IPAM
			def case_000(args)
				@case_ID = __method__.to_s.split('_')[1]
				r        = []
				# begin
					# 新建30条网络
					args[:owner_list] = [Master_Device]
					30.times do |i|
						args[:network] = "1.2.#{i}.0/24"
						r << IPAM_er.create_network(args)
					end
				# rescue
				# 	puts "unknown error on #{@case_ID}"
				# 	return "failed case #{@case_ID}"
				# end
				r.to_s.include?('fail') ? "failed case #{@case_ID}": "succeed in case #{@case_ID}"
			end
        end
    end
end