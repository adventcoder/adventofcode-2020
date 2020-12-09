
require_relative '00_common.rb'

input = get_input(9)

nums = []
input.each_line do |line|
  nums << line.chomp.to_i
end

for i in 25 ... nums.size
  if nums[i - 25 ... i].combination(2).none? { |a, b| a + b == nums[i] }
    invalid = nums[i]
    break
  end
end
puts invalid

first = 0
last = 0
sum = nums[0]
until sum == invalid
  if sum < invalid
    last += 1
    sum += nums[last]
  else
    sum -= nums[first]
    first += 1
  end
end
range = nums[first .. last]
weakness = range.min + range.max
puts weakness
