require_relative 'common.rb'

def trial(map, dx, dy)
  x = 0
  y = 0
  count = 0
  while y < map.size
    count += 1 if map[y][x] == '#'
    x = (x + dx) % map[y].size
    y += dy
  end
  count
end

map = get_input(3).lines.map(&:chomp)

slopes = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]
counts = slopes.map { |(dx, dy)| trial(map, dx, dy) }

puts counts[1]
puts counts.prod
