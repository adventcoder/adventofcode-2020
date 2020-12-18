
require_relative 'common.rb'

require 'set'

def find_invalid(nums)
  prev = Set.new
  prev.merge(nums.take(25))
  for i in 25 ... nums.size
    return nums[i] if prev.none? { |p| prev.include?(nums[i] - p) }
    prev.delete(nums[i - 25])
    prev.add(nums[i])
  end
  nil
end

def find_weakness1(nums, invalid)
  # sum(first ... last) = sums[last] - sums[first]
  sums = [0]
  nums.each { |num| sums << sums.last + num }
  for first in 0 ... nums.size - 1
    for last in first + 1 ... nums.size
      if sums[last + 1] - sums[first] == invalid
        range = nums[first .. last]
        return range.min + range.max
      end
    end
  end
  nil
end

def find_weakness2(nums, invalid)
  first = 0
  last = 0
  sum = nums[0]
  until sum == invalid
    if sum > invalid
      sum -= nums[first]
      first += 1
    else
      last += 1
      sum += nums[last]
    end
  end
  range = nums[first .. last]
  return range.min + range.max
end

nums = get_input(9).lines.map(&:to_i)
invalid = find_invalid(nums)
puts invalid
weakness = find_weakness2(nums, invalid)
puts weakness
