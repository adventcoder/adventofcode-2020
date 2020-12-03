require_relative '00_common.rb'

$map = get_input(3).lines.map(&:chomp)

def trees(dx, dy)
  x = 0
  y = 0
  count = 0
  while y < $map.size
    count += 1 if $map[y][x] == '#'
    x = (x + dx) % $map[y].size
    y += dy
  end
  count
end

puts trees(3, 1)
puts trees(1, 1) * trees(3, 1) * trees(5, 1) * trees(7, 1) * trees(1, 2)
