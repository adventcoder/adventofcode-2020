require_relative '00_common.rb'

input = get_input(8)

code = []
input.each_line do |line|
  parts = line.split
  code << [parts[0], parts[1].to_i]
end

def run(code)
  seen = Hash.new(false)
  acc = 0
  i = 0
  while i < code.size
    if seen[i]
      return false, acc
    else
      seen[i] = true
      case code[i][0]
      when 'acc'
        acc += code[i][1]
        i += 1
      when 'jmp'
        i += code[i][1]
      else
        i += 1
      end
    end
  end
  return true, acc
end

puts run(code)[1]

for i in 0 ... code.size
  orig = code[i][0]
  if code[i][0] == 'jmp'
    code[i][0] = 'nop'
  elsif code[i][0] == 'nop'
    code[i][0] = 'jmp'
  else
    next
  end
  halted, acc = run(code)
  code[i][0] = orig
  if halted
    puts acc
    break
  end
end
