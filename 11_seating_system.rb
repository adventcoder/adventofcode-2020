require_relative '00_common.rb'

DIR8 = [*-1 .. 1].product([*-1 .. 1]).select { |(x, y)| [x.abs, y.abs].max == 1 }

def valid?(grid, x, y)
  y.between?(0, grid.size - 1) && x.between?(0, grid[y].size - 1)
end

def occupied_adjacent(grid, x, y)
  count = 0
  for dx, dy in DIR8
    x1 = x + dx
    y1 = y + dy
    count += 1 if valid?(grid, x1, y1) && grid[y1][x1] == '#'
  end
  count
end

def occupied_visible(grid, x, y)
  count = 0
  for dx, dy in DIR8
    x1 = x + dx
    y1 = y + dy
    while valid?(grid, x1, y1) && grid[y1][x1] == '.'
      x1 += dx
      y1 += dy
    end
    count += 1 if valid?(grid, x1, y1) && grid[y1][x1] == '#'
  end
  count
end

def simulate(input, occupied, max_occupied)
  grid = input.lines.map(&:chomp)
  temp = grid.map(&:dup)
  loop do
    changed = false
    for y in 0 ... grid.size
      for x in 0 ... grid[y].size
        if grid[y][x] == 'L' && occupied.call(grid, x, y) == 0
          temp[y][x] = '#'
          changed = true
        elsif grid[y][x] == '#' && occupied.call(grid, x, y) >= max_occupied
          temp[y][x] = 'L'
          changed = true
        else
          temp[y][x] = grid[y][x]
        end
      end
    end
    return grid if !changed
    grid, temp = temp, grid
  end
end

input = get_input(11)
puts simulate(input, method(:occupied_adjacent), 4).sum { |row| row.count('#') }
puts simulate(input, method(:occupied_visible), 5).sum { |row| row.count('#') }
