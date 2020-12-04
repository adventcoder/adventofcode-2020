require_relative '00_common.rb'

$lines = get_input(3).lines.map(&:chomp)

def tree_count(dx, dy)
  x = 0
  y = 0
  count = 0
  while y < $lines.size
    count += 1 if $lines[y][x] == '#'
    x = (x + dx) % $lines[y].size
    y += dy
  end
  count
end

puts tree_count(3, 1)
puts tree_count(1, 1) * tree_count(3, 1) * tree_count(5, 1) * tree_count(7, 1) * tree_count(1, 2)
