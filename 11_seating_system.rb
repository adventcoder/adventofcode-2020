require_relative '00_common.rb'

require 'set'

input = get_input(11)

DIR8 = [*-1 .. 1].product([*-1 .. 1]).select { |(x, y)| [x.abs, y.abs].max == 1 }

def parse(input)
  height = input.lines.count
  width = input.lines.map { |line| line.chomp.size }.max
  occupied = {}
  input.lines.each_with_index do |line, y|
    line.chomp.chars.each_with_index do |c, x|
      if c == 'L'
        occupied[[x, y]] = false
      elsif c == '#'
        occupied[[x, y]] = true
      end
    end
  end
  return occupied, width, height
end

def cast(occupied, origin, dir, max_radius)
  1.upto(max_radius) do |r|
    seat = [origin[0] + r * dir[0], origin[1] + r * dir[1]]
    break seat if occupied.has_key?(seat)
  end
end

def simulate(occupied, max_radius, max_occupied)
  active = Set.new(occupied.keys)
  until active.empty?
    next_occupied = occupied.dup
    active.each do |seat|
      count = 0
      DIR8.each do |dir|
        neighbour = cast(occupied, seat, dir, max_radius)
        count += 1 if neighbour && occupied[neighbour]
      end
      if !occupied[seat] && count == 0
        next_occupied[seat] = true
      elsif occupied[seat] && count >= max_occupied
        next_occupied[seat] = false
      else
        active.delete(seat)
      end
    end
    occupied = next_occupied
  end
  occupied
end

initial, width, height = parse(input)

result1 = simulate(initial, 1, 4)
puts result1.keys.count { |seat| result1[seat] }

result2 = simulate(initial, [width, height].max, 5)
puts result2.keys.count { |seat| result2[seat] }
