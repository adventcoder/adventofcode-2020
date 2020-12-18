require_relative 'common.rb'

require 'set'

input = get_input(11)

DIR8 = [*-1 .. 1].product([*-1 .. 1]).select { |(x, y)| [x.abs, y.abs].max == 1 }

def all_seats(state)
  state.flat_map.with_index { |row, y| row.chars.filter_map.with_index { |c, x| [x, y] unless c == '.' } }
end

def count_occupied_seats(state)
  state.sum { |row| row.count('#') }
end

def seat_occupied?(state, x, y)
  return false unless y.between?(0, state.size - 1) && x.between?(0, state[y].size - 1)
  state[y][x] == '#'
end

def seat_occupied_in_direction?(state, x, y, dx, dy)
  loop do
    x += dx
    y += dy
    return false unless y.between?(0, state.size - 1) && x.between?(0, state[y].size - 1)
    return state[y][x] == '#' unless state[y][x] == '.'
  end
end

def simulate1(state)
  active = Set.new(all_seats(state))
  until active.empty?
    next_state = state.map(&:dup)
    active.each do |x, y|
      occupied = DIR8.count { |dx, dy| seat_occupied?(state, x + dx, y + dy) }
      if state[y][x] == 'L' && occupied == 0
        next_state[y][x] = '#'
      elsif state[y][x] == '#' && occupied >= 4
        next_state[y][x] = 'L'
      else
        active.delete([x, y])
      end
    end
    state = next_state
  end
  state
end

def simulate2(state)
  active = Set.new(all_seats(state))
  state = state.map(&:dup)
  until active.empty?
    next_state = state.map(&:dup)
    active.each do |x, y|
      occupied = DIR8.count { |dx, dy| seat_occupied_in_direction?(state, x, y, dx, dy) }
      if state[y][x] == 'L' && occupied == 0
        next_state[y][x] = '#'
      elsif state[y][x] == '#' && occupied >= 5
        next_state[y][x] = 'L'
      else
        active.delete([x, y])
      end
    end
    state = next_state
  end
  state
end

initial_state = input.lines.map(&:chomp)
puts count_occupied_seats(simulate1(initial_state))
puts count_occupied_seats(simulate2(initial_state))
