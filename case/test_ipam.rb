# encoding: utf-8
require File.dirname(__FILE__) + '/case_suit/suit_ipam'

module ZDDI
    IPAM_50 = ZDDI::Address::IPAM.new
    def ipam_suit # ( 1/1 )
        r = []
        r << IPAM_50.case_000(:args=>'nil') # 新建50条网络
    end
end