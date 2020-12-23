require_relative 'common'


class Cups
  class Node
    include Enumerable 

    attr_accessor :cup, :next

    def initialize(cup, _next = nil)
      @cup = cup
      @next = _next
    end
  
    def delete(n)
      return nil if n <= 0
      last = self
      n.times { last = last.next }
      node = @next
      @next = last.next
      last.next = nil
      node
    end
  
    def insert(node)
      return if node == nil
      last = node
      last = last.next until last.next == nil
      last.next = @next
      @next = node
    end

    def each
      node = self
      until node == nil
        yield node.cup
        node = node.next
      end
    end
  end

  def initialize(cups, size = cups.size)
    @nodes = {}
    head = Node.new(cups[0])
    @nodes[head.cup] = head
    tail = head
    for cup in cups[1 ... size]
      node = Node.new(cup)
      @nodes[node.cup] = node
      tail.next = node
      tail = node
    end
    @min_cup = cups.min
    @max_cup = cups.max
    (size - cups.size).times do
      @max_cup += 1
      node = Node.new(@max_cup)
      @nodes[node.cup] = node
      tail.next = node
      tail = node
    end
    tail.next = head
    @curr = head
  end

  def mix(verbose = false)
    picked_up = @curr.delete(3)
    puts "pick up: #{picked_up.to_a.join(', ')}" if verbose

    dest = @curr
    begin
      dest = node(dest.cup - 1)
    end while picked_up.include?(dest.cup)
    puts "destination: #{dest.cup}" if verbose

    dest.insert(picked_up)
    @curr = @curr.next
  end

  def node(cup)
    @nodes[wrap(cup)]
  end

  def wrap(cup)
    (cup - @min_cup) % size + @min_cup
  end

  def size
    @max_cup - @min_cup + 1
  end

  def to_s(offset = 0)
    ["(#{@curr.cup})", *@curr.next.take(size - 1)].rotate(-offset).join(' ')
  end
end

=begin
cups = get_input(23).chomp.chars.map(&:to_i)
min_cup = cups.min
max_cup = cups.max
(1_000_000 - cups.size).times do
  max_cup += 1
  cups << max_cup
end
10_000_000.times do |i|
  picked_up = cups.slice!(1, 3)
  dest = cups[0]
  begin
    dest = dest == min_cup ? max_cup : dest - 1
  end while picked_up.include?(dest)

  cups[cups.index(dest) + 1, 0] = picked_up

  cups.rotate!(1)
end
cups.rotate!(cups.index(1))
puts cups[1] * cups[2]
=end

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
puts cups.node(1).next.take(cups.size - 1).join

cups = Cups.new(input, 1_000_000)
10_000_000.times { cups.mix }
puts cups.node(1).next.take(2).prod
