require_relative 'common.rb'

require 'set'

input = get_input(11)

class Simulation
  def initialize(input)
    @grid = input.lines.map(&:chomp)
    @active = Set.new(find('#L'))
  end

  def find(options)
    @grid.flat_map.with_index { |row, y| row.chars.filter_map.with_index { |c, x| [x, y] if options.include?(c) } }
  end

  def in_bounds?(x, y)
    y.between?(0, @grid.size - 1) && x.between?(0, @grid[y].size - 1)
  end

  def occupied?(x, y, dx, dy)
    in_bounds?(x + dx, y + dy) && @grid[y + dy][x + dx] == '#'
  end

  def occupied_neighbours(x, y)
    count = 0
    for dy in -1 .. 1
      for dx in -1 .. 1
        next if dx == 0 && dy == 0
        count += 1 if occupied?(x, y, dx, dy)
      end
    end
    count
  end

  def max_occupied_neighbours
    4
  end

  def active?
    @active.size > 0
  end

  def tick
    next_grid = @grid.map(&:dup)
    @active.each do |x, y|
      if @grid[y][x] == 'L' && occupied_neighbours(x, y) == 0
        next_grid[y][x] = '#'
      elsif @grid[y][x] == '#' && occupied_neighbours(x, y) >= max_occupied_neighbours
        next_grid[y][x] = 'L'
      else
        @active.delete([x, y])
      end
    end
    @grid = next_grid
  end
end

class Simulation2 < Simulation
  def occupied?(x, y, dx, dy)
    begin
      x += dx
      y += dy
    end while in_bounds?(x, y) && @grid[y][x] == '.'
    in_bounds?(x, y) && @grid[y][x] == '#'
  end

  def max_occupied_neighbours
    5
  end
end

input = get_input(11)

sim = Simulation.new(input)
sim.tick while sim.active?
puts sim.find('#').size

sim2 = Simulation2.new(input)
sim2.tick while sim2.active?
puts sim2.find('#').size
