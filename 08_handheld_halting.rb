require_relative 'common.rb'

require 'set'

code = []
get_input(8).each_line do |line|
  a, b = line.split
  code << [a, b.to_i]
end

def part1(code)
  seen = Set.new
  ip = 0
  acc = 0
  while seen.add?(ip)
    op, n = code[ip]
    case op
    when 'acc'
      acc += n
      ip += 1
    when 'jmp'
      ip += n
    when 'nop'
      ip += 1
    end
  end
  acc
end

def part2(code)
  halting_ips = find_halting_ips(code)
  swap = true
  ip = 0
  acc = 0
  while ip < code.size
    op, n = code[ip]
    case op
    when 'acc'
      acc += n
      ip += 1
    when 'jmp'
      if swap && halting_ips.include?(ip + 1)
        ip += 1
        swap = false
      else
        ip += n
      end
    when 'nop'
      if swap && halting_ips.include?(ip + n)
        ip += n
        swap = false
      else
        ip += 1
      end
    end
  end
  acc
end

def find_halting_ips(code)
  prev_ips = Hash.new { |h, k| h[k] = [] }
  code.each_with_index do |(op, n), ip|
    case op
    when 'acc', 'nop'
      prev_ips[ip + 1] << ip
    when 'jmp'
      prev_ips[ip + n] << ip
    end
  end
  ips = Set.new
  stack = [code.size]
  until stack.empty?
    ip = stack.pop
    ips << ip
    stack.concat(prev_ips[ip])
  end
  ips
end

puts part1(code)
puts part2(code)
