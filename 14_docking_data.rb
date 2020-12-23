require_relative 'common.rb'

def part1(input)
  mem = {}
  and_mask = -1
  or_mask = 0
  input.each_line do |line|
    case line.chomp
    when /^mask = (.*)$/
      or_mask = $1.tr('X', '0').to_i(2)
      and_mask = $1.tr('X', '1').to_i(2)
    when /^mem\[([^\]]+)\] = (.*)$/
      i = $1.to_i
      v = $2.to_i
      v |= or_mask
      v &= and_mask
      mem[i] = v
    end
  end
  mem.values.sum
end

def part2(input)
  mem = {}
  or_mask = 0
  floating_indexes = []
  input.each_line do |line|
    case line.chomp
    when /^mask = (.*)$/
      or_mask = $1.tr('X', '0').to_i(2)
      floating_indexes = $1.reverse.chars.filter_map.with_index { |c, i| i if c == 'X' }
    when /^mem\[([^\]]+)\] = (.*)$/
      addr = $1.to_i
      value = $2.to_i
      addr |= or_mask
      for floating_bits in 0 ... (1 << floating_indexes.size)
        mem[set_bits(addr, floating_bits, floating_indexes)] = value
      end
    end
  end
  mem.values.sum
end

def set_bits(addr, bits, indexes)
  for i in indexes
    if bits & 1 == 1
      addr |= 1 << i
    else
      addr &= ~(1 << i)
    end
    bits >>= 1
  end
  addr
end

input = get_input(14)
puts part1(input)
puts part2(input)
