require_relative '00_common.rb'

input = get_input(14)

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
  mask = '0' * 36
  input.each_line do |line|
    case line.chomp
    when /^mask = (.*)$/
      mask = $1
    when /^mem\[([^\]]+)\] = (.*)$/
      addr = $1.to_i.to_s(2).rjust(36, '0')
      value = $2.to_i
      write(mem, addr, value, mask)
    end
  end
  mem.values.sum
end

def write(mem, addr, value, mask, i = 0)
  while i < 36
    if mask[i] == 'X'
      addr[i] = '0'
      write(mem, addr.dup, value, mask, i + 1)
      addr[i] = '1'
    elsif mask[i] == '1'
      addr[i] = '1'
    end
    i += 1
  end
  mem[addr.to_i(2)] = value
end

input = get_input(14)
puts part1(input)
puts part2(input)
