
require_relative '00_common.rb'

input = get_input(5)

min = Infinity
max = -1
occupied = 0
input.each_line do |line|
  seat_id = line.tr('FBLR', '0101').to_i(2)
  min = seat_id if seat_id < min
  max = seat_id if seat_id > max
  occupied ^= seat_id
end

def xor_upto(n)
  case n % 4
  when 0 then n
  when 1 then 1
  when 2 then n + 1
  when 3 then 0
  end
end

available = xor_upto(max) ^ xor_upto(min-1)

puts max
puts available ^ occupied
