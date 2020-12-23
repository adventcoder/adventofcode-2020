require_relative 'common'

class Cups
  attr_reader :size

  def initialize(cups, size = cups.max)
    @size = size
    @next = Array.new(@size + 1)
    cups.each_cons(2) do |a, b|
      @next[a] = b
    end
    last = cups.last
    for cup in (cups.max + 1) .. @size
      @next[last] = cup
      last = cup
    end
    @next[last] = cups.first
    @curr = cups.first
  end

  def mix(verbose = false)
    picked_up = self.next(@curr, 3)
    puts "pick up: #{picked_up.join(', ')}" if verbose

    dest = @curr
    begin
      dest = dest == 1 ? @size : dest - 1
    end while picked_up.include?(dest)
    puts "destination: #{dest}" if verbose

    # Delete after current
    @next[@curr] = @next[picked_up.last]

    # Insert after destination
    @next[picked_up.last] = @next[dest]
    @next[dest] = picked_up.first

    @curr = @next[@curr]
  end

  def next(cup, size)
    Array.new(size) { cup = @next[cup] }
  end

  def to_s(offset = 0)
    ["(#{@curr})", *self.next(@curr, size - 1)].rotate(-offset).join(' ')
  end
end

=begin
cups = Cups.new('389125467'.chars.map(&:to_i))
10.times do |i|
  puts "-- move #{i + 1} --"
  puts "cups: #{cups.to_s(i)}"
  cups.mix(true)
  puts
end
puts "-- final --"
puts "cups: #{cups.to_s(10)}"
=end

input = get_input(23).chomp.chars.map(&:to_i)

cups = Cups.new(input)
100.times { cups.mix }
puts cups.next(1, cups.size - 1).join

cups = Cups.new(input, 1_000_000)
10_000_000.times { cups.mix }
puts cups.next(1, 2).prod
