require_relative '00_common.rb'

code = []
get_input(8).each_line do |line|
  a, b = line.split
  code << [a, b.to_i]
end

def run(code)
  seen = Hash.new(false)
  ip = 0
  acc = 0
  while ip < code.size and not seen[ip]
    seen[ip] = true
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

def fix(code)
  prev_ips = Hash.new { |h, k| h[k] = [] }
  code.each_with_index do |(op, n), ip|
    case op
    when 'acc', 'nop'
      prev_ips[ip + 1] << ip
    when 'jmp'
      prev_ips[ip + n] << ip
    end
  end

  halts = Hash.new(false)
  stack = [code.size]
  until stack.empty?
    ip = stack.pop
    halts[ip] = true
    stack.concat(prev_ips[ip])
  end

  for ip in 0 ... code.size
    op, n = code[ip]
    if op == 'jmp' and halts[ip + 1]
      code[ip][0] = 'nop'
    elsif op == 'nop' and ip + n >= 0 and halts[ip + n]
      code[ip][0] = 'jmp'
    end
  end

  code
end

puts run(code)
puts run(fix(code))
