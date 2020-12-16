require_relative '../utils.rb'

ROCKY = 0
WET = 1
NARROW = 2

NEITHER = 0
TORCH = 1
CLIMBING_GEAR = 2

class Cave
  X_FACTOR = 16807
  Y_FACTOR = 48271
  MODULUS = 20183

  attr_reader :depth, :target_x, :target_y

  def initialize(input)
    @depth = input[:depth]
    @target_x = input[:target][0]
    @target_y = input[:target][1]
    @erosion_level = {}
  end

  def mouth?(x, y)
    x == 0 && y == 0
  end

  def target?(x, y)
    x == @target_x && y == @target_y
  end

  def geological_index(x, y)
    if mouth?(x, y) || target?(x, y)
      0
    elsif y == 0
      X_FACTOR * x
    elsif x == 0
      Y_FACTOR * y
    else
      erosion_level(x - 1, y) * erosion_level(x, y - 1)
    end
  end

  def erosion_level(x, y)
    @erosion_level[[x, y]] ||= (geological_index(x, y) + @depth) % MODULUS
  end

  def type(x, y)
    erosion_level(x, y) % 3
  end

  def risk_level
    total = 0
    for x in 0 .. @target_x
      for y in 0 .. @target_y
        total += type(x, y)
      end
    end
    total
  end

  def rescue_time
    start = Rescue.new(0, 0, TORCH)
    time = { start => 0 }
    prev = { start => nil }
    open = PriorityQueue.new
    open.push(start, start.estimate_time_to_goal(self))
    closed = {}
    until open.empty?
      state = open.pop
      closed[state] = true

      if state.goal?(self)
        goal = state
        # path = []
        # until state == nil
        #   path << state
        #   state = prev[state]
        # end
        # path.reverse_each do |state|
        #   gear_name = ['NEITHER', 'TORCH', 'CLIMBING GEAR'][state.gear]
        #   puts "[#{state.x}, #{state.y}] #{gear_name} (#{time[state]} mins)"
        # end
        return time[goal]
      end

      state.each_neighbour(self) do |neighbour, dt|
        next if closed[neighbour]
        old_time = time[neighbour]
        new_time = time[state] + dt
        next if old_time != nil && old_time <= new_time
        prev[neighbour] = state
        time[neighbour] = new_time
        if old_time == nil
          open.push(neighbour, new_time + neighbour.estimate_time_to_goal(self))
        else
          open.set_priority(neighbour, new_time + neighbour.estimate_time_to_goal(self))
        end
      end
    end
  end

  def print(width, height, io = $stdout)
    for y in 0 ... height
      line = ''
      for x in 0 ... width
        if x == 0 and y == 0
          line << 'M'
        elsif x == @target_x and y == @target_y
          line << 'T'
        else
          case type(x, y)
          when ROCKY then line << '.'
          when WET then line << '='
          when NARROW then line << '|'
          else
            line << '?'
          end
        end
      end
      io.puts(line)
    end
  end
end

class Rescue
  SWITCH_TIME = 7
  MOVE_TIME = 1

  attr_reader :x, :y, :gear

  def initialize(x, y, gear)
    @x = x
    @y = y
    @gear = gear
  end

  def hash
    @x | (@y << 14) | (@gear << 28)
  end

  def eql?(other)
    @x == other.x && @y == other.y && @gear == other.gear
  end

  def goal?(cave)
    cave.target?(@x, @y) && @gear == TORCH
  end

  def estimate_time_to_goal(cave)
    (cave.target_y - @y).abs + (cave.target_x - @x).abs
  end

  def each_neighbour(cave, &block)
    if cave.target?(@x, @y)
      block.call(Rescue.new(@x, @y, TORCH), SWITCH_TIME)
    else
      move(cave, @x, @y + 1, &block)
      move(cave, @x + 1, @y, &block)
      move(cave, @x - 1, @y, &block) if @x > 0
      move(cave, @x, @y - 1, &block) if @y > 0
    end
  end

  def move(cave, x, y)
    if cave.type(x, y) == @gear # gear disallowed, switch required
      yield Rescue.new(x, y, (@gear + 1) % 3), SWITCH_TIME + MOVE_TIME unless cave.type(@x, @y) == (@gear + 1) % 3
      yield Rescue.new(x, y, (@gear + 2) % 3), SWITCH_TIME + MOVE_TIME unless cave.type(@x, @y) == (@gear + 2) % 3
    else # gear allowed, switch optional
      yield Rescue.new(x, y, @gear), MOVE_TIME
      yield Rescue.new(x, y, 3 - cave.type(x, y) - @gear), SWITCH_TIME + MOVE_TIME unless cave.type(@x, @y) == 3 - cave.type(x, y) - @gear
    end
  end

  # def each_neighbour(cave)
  #   yield Rescue.new(@x, @y + 1, @gear), MOVE_TIME if cave.type(@x, @y + 1) != @gear
  #   yield Rescue.new(@x + 1, @y, @gear), MOVE_TIME if cave.type(@x + 1, @y) != @gear
  #   yield Rescue.new(@x - 1, @y, @gear), MOVE_TIME if @x > 0 && cave.type(@x - 1, @y) != @gear
  #   yield Rescue.new(@x, @y - 1, @gear), MOVE_TIME if @y > 0 && cave.type(@x, @y - 1) != @gear
  #   yield Rescue.new(@x, @y, 3 - cave.type(@x, @y) - @gear), SWITCH_TIME
  # end
end

def read_input(io)
  input = {}
  io.each_line do |line|
    label, value = line.split(':', 2)
    case label
    when 'depth'
      input[:depth] = value.to_i
    when 'target'
      input[:target] = value.split(',').map(&:to_i)
    end
  end
  input
end

cave = Cave.new(read_input(DATA))
# cave = Cave.new({ :depth => 510, :target => [10, 10] })
# cave.print(cave.target_x + 6, cave.target_y + 6)
puts "Silver: #{cave.risk_level}"
puts "Gold: #{cave.rescue_time}"


__END__
depth: 7863
target: 14,760
