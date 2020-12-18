
require_relative 'common.rb'

def sum2(nums, target)
  i = 0
  j = nums.size - 1
  while i < j
    if nums[i] + nums[j] > target
      j -= 1
    elsif nums[i] + nums[j] < target
      i += 1
    else
      return nums[i], nums[j]
    end
  end
  nil
end

def sum3(nums, target)
  for num in nums
    if pair = sum2(nums, target - num)
      return [*pair, num]
    end
  end
  nil
end

report = get_input(1).lines.map(&:to_i)
report.sort!
puts sum2(report, 2020).prod
puts sum3(report, 2020).prod
