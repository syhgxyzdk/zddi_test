# encoding: utf-8
foo = File.open("/root/dnsperf/tmp.txt", 'w')
["baidu.com"].each do |domain|
    foo.puts("#{domain} A")
end
foo.close
qps_result = `cd /root/dnsperf/ && ./dnsperf -s 202.173.12.18 -d tmp.txt -l 100 -Q 60 -q 999999999 | grep "Queries per second:"`
qps = qps_result.split(" ")[3]
`rm -f /root/dnsperf/tmp.txt`
puts qps
