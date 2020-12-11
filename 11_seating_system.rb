require_relative '00_common.rb'

input = get_input(11)

def valid?(rows, x, y)
  y >= 0 and y < rows.size and x >= 0 and x < rows[y].size
end

def count(rows)
  rows.sum { |row| row.count('#') }
end

def count_adjacent(rows, x, y)
  n = 0
  for dy in -1 .. 1
    for dx in -1 .. 1
      next if dx == 0 and dy == 0
      x1 = x + dx
      y1 = y + dy
      n += 1 if valid?(rows, x1, y1) and rows[y1][x1] == '#'
    end
  end
  n
end

def count_visible(rows, x, y)
  n = 0
  for dy in -1 .. 1
    for dx in -1 .. 1
      next if dx == 0 and dy == 0
      x1 = x + dx
      y1 = y + dy
      while valid?(rows, x1, y1) and rows[y1][x1] == '.'
        x1 += dx
        y1 += dy
      end
      n += 1 if valid?(rows, x1, y1) and rows[y1][x1] == '#'
    end
  end
  n
end

curr = input.lines.map { |line| line.chomp }
loop do
  prev = curr.map { |row| row.dup }
  for y in 0 ... curr.size
    for x in 0 ... curr[y].size
      if curr[y][x] == 'L' and count_adjacent(prev, x, y) == 0
        curr[y][x] = '#'
      elsif curr[y][x] == '#' and count_adjacent(prev, x, y) >= 4
        curr[y][x] = 'L'
      end
    end
  end
  if curr == prev
    puts count(curr)
    break
  end
end


curr = input.lines.map { |line| line.chomp }
loop do
  prev = curr.map { |row| row.dup }
  for y in 0 ... curr.size
    for x in 0 ... curr[y].size
      if curr[y][x] == 'L' and count_visible(prev, x, y) == 0
        curr[y][x] = '#'
      elsif curr[y][x] == '#' and count_visible(prev, x, y) >= 5
        curr[y][x] = 'L'
      end
    end
  end
  if curr == prev
    puts count(curr)
    break
  end
end
