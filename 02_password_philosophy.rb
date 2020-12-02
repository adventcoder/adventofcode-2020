require 'scanf'

require_relative '00_common.rb'

input = get_input(2)

count1 = 0
count2 = 0
input.each_line do |line|
  n1, n2, c, password = line.scanf('%d-%d %c: %s')

  count1 += 1 if password.count(c).between?(n1, n2)
  count2 += 1 if (password[n1-1] == c) ^ (password[n2-1] == c)
end

puts count1
puts count2
