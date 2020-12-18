
require_relative 'common.rb'

require 'set'

input = get_input(17)

def parse(input, n)
  hypercube = Set.new
  input.lines.each_with_index do |line, y|
    line.chars.each_with_index do |c, x|
      if c == '#'
        pos = Array.new(n, 0)
        pos[0] = x
        pos[1] = y
        hypercube.add(pos)
      end
    end
  end
  hypercube
end

def neighbours(pos)
  return enum_for(:neighbours, pos) unless block_given?
  [*-1 .. 1].repeated_permutation(pos.size) do |delta|
    yield Array.new(pos.size) { |i| pos[i] + delta[i] } unless delta.all?(&:zero?)
  end
end

def tick(hypercube, n)
  result = Set.new
  boundary = Set.new
  hypercube.each do |pos|
    count = 0
    neighbours(pos) do |neigh|
      if hypercube.include?(neigh)
        count += 1
      else
        boundary.add(neigh)
      end
    end
    result.add(pos) if count.between?(2, 3) # stay active
  end
  boundary.each do |pos|
    count = 0
    neighbours(pos) do |neigh|
      count += 1 if hypercube.include?(neigh)
    end
    result.add(pos) if count == 3 # become active
  end
  result
end

for n in [3, 4]
  hypercube = parse(input, n)
  6.times { hypercube = tick(hypercube, n) }
  puts hypercube.size
end
