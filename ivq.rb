# encoding: utf-8

str = 'asdfsleowep23rwesdfxcvsdf'

p str.size
p str.split('').uniq.size

str.split('').uniq.each do |x|
	count_x = "count_#{x}"
	counter = 0
	str.split('').each { |y| counter += 1 if y == x }
	puts "#{count_x}: #{counter}"
end
