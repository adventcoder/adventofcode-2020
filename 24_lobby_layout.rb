require_relative 'common'

require 'set'

# w = nwsw
# e = nese
DIRS = {
  'nw' => [-1, -1],
  'ne' => [ 1, -1],
  'sw' => [-1,  1],
  'se' => [ 1,  1],
  'w'  => [-2,  0],
  'e'  => [ 2,  0]
}

input = get_input(24)

class Array
  def +(other)
    Array.new(size) { |i| self[i] + other[i] }
  end
end

def identify(line)
  pos = [0, 0]
  i = 0
  while i < line.size
    for key, dir in DIRS
      if line[i, key.size] == key
        pos += dir
        i += key.size
        break
      end
    end
  end
  pos
end

flipped = Set.new

input.each_line do |line|
  pos = identify(line.chomp)
  if flipped.include?(pos)
    flipped.delete(pos)
  else
    flipped.add(pos)
  end
end

puts flipped.size

100.times do |i|
  counts = Hash.new(0)
  for pos in flipped
    DIRS.each_value do |dir|
      counts[pos + dir] += 1
    end
  end
  next_flipped = Set.new
  for pos in flipped
    next_flipped << pos if counts[pos].between?(1, 2)
  end
  for pos, count in counts
    next if flipped.include?(pos)
    next_flipped << pos if count == 2
  end
  flipped = next_flipped
end

puts flipped.size
