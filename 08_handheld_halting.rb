require_relative '00_common.rb'

input = get_input(8)

code = []
input.each_line do |line|
  a, b = line.split
  code << [a, b.to_i]
end

def run(code, start = 0)
  seen = Hash.new(false)
  acc = 0
  i = start
  while i < code.size
    return false, acc if seen[i]
    seen[i] = true
    op, n = code[i]
    case op
    when 'acc'
      acc += n
      i += 1
    when 'jmp'
      i += n
    when 'nop'
      i += 1
    end
  end
  return true, acc
end

def fix(code)
  groups = DisjointSet.new(code.size + 1)
  for i in 0 ... code.size
    op, n = code[i]
    case op
    when 'jmp'
      groups.merge(i, i + n)
    else
      groups.merge(i, i + 1)
    end
  end
  start_group = groups.find(0)
  end_group = groups.find(code.size)
  for i in 0 ... code.size
    op, n = code[i]
    case op
    when 'jmp'
      if groups.find(i) == start_group and groups.find(i + 1) == end_group
        code[i][0] = 'nop'
      end
    when 'nop'
      if i + n >= 0 and groups.find(i) == start_group and groups.find(i + n) == end_group
        code[i][0] = 'jmp'
      end
    end
  end
end

def run_and_fix(code)
  prev = Hash.new { |h, k| h[k] = [] }
  for i in 0 ... code.size
    op, n = code[i]
    case op
    when 'acc', 'nop'
      prev[i + 1] << i
    when 'jmp'
      prev[i + n] << i
    end
  end
  # run backwards to find all the addresses that eventually halt
  acc_from = Array.new(code.size + 1)
  acc_from[code.size] = 0
  queue = [code.size]
  until queue.empty?
    i = queue.pop
    prev[i].each do |j|
      next if acc_from[j] != nil
      op, n = code[j]
      case op
      when 'acc'
        acc_from[j] = acc_from[i] + n
      else
        acc_from[j] = acc_from[i]
      end
      queue << j
    end
  end
  # now run forward to find the instruction to fix
  i = 0
  acc = 0
  loop do
    op, n = code[i]
    case op
    when 'acc'
      acc += n
      i += 1
    when 'nop'
      if i + n >= 0 && acc_from[i + n] != nil
        return acc + acc_from[i + n]
      else
        i += 1
      end
    when 'jmp'
      if acc_from[i + 1] != nil
        return acc + acc_from[i + 1]
      else
        i += n
      end
    end
  end
end

puts run(code)[1]
puts run_and_fix(code)
