require_relative '00_common.rb'

$map = get_input(3).lines.map(&:chomp)

def tree_count(dx, dy)
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

puts tree_count(3, 1)
puts  [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]].prod { |(dx, dy)| tree_count(dx, dy) }
