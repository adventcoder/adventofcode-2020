
require_relative '00_common.rb'

input = get_input(5)

seats = Array.new(128, 0)
max_seat_id = -1

input.each_line do |line|
  id = line.tr('FBLR', '0101').to_i(2)
  r = id >> 3
  c = id & 7
  seats[r] |= 1 << c
  max_seat_id = id if id > max_seat_id
end

puts max_seat_id

for r in 1 ... (seats.size - 1)
  next unless seats[r - 1] == 0xFF
  next unless seats[r + 1] == 0xFF

  for c in 0 ... 8
    if seats[r][c] == 0
      seat_id = (r << 3) | c
      puts seat_id
    end
  end
end
