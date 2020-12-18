
require_relative 'common.rb'

def rotate(x, y, n)
  case n % 360 / 90
  when 0 then return x, y
  when 1 then return -y, x
  when 2 then return -x, -y
  when 3 then return y, -x
  end
end

def part1(input)
  x, y = 0, 0
  dx, dy = 1, 0
  input.each_line do |line|
    n = line[1 .. -1].to_i
    case line[0]
    when 'N' then y += n
    when 'S' then y -= n
    when 'W' then x -= n
    when 'E' then x += n
    when 'L' then dx, dy = rotate(dx, dy, n)
    when 'R' then dx, dy = rotate(dx, dy, -n)
    when 'F' then x, y = x + dx * n, y + dy * n
    end
  end
  x.abs + y.abs
end

def part2(input)
  x, y = 0, 0
  dx, dy = 10, 1
  input.each_line do |line|
    n = line[1 .. -1].to_i
    case line[0]
    when 'N' then dy += n
    when 'S' then dy -= n
    when 'W' then dx -= n
    when 'E' then dx += n
    when 'L' then dx, dy = rotate(dx, dy, n)
    when 'R' then dx, dy = rotate(dx, dy, -n)
    when 'F' then x, y = x + dx * n, y + dy * n
    end
  end
  x.abs + y.abs
end

input = get_input(12)
puts part1(input)
puts part2(input)
