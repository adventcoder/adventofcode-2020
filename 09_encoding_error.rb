
require_relative '00_common.rb'

input = get_input(9)

nums = []
input.each_line do |line|
  nums << line.chomp.to_i
end

def valid?(n, ns)
  ns.combination(2) do |a, b|
    if a + b == n
      return true
    end
  end
  false
end

for i in 25 ... nums.size
  if !valid?(nums[i], nums[i - 25 ... i])
    x = nums[i]
    break
  end
end

puts x


for l in 2 ... 50
  nums.each_cons(l) do |as|
    if as.inject(0, &:+) == x
      puts as.min + as.max
    end
  end
end
