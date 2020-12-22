
require_relative 'common.rb'

input = get_input(10)

joltages = input.lines.map(&:to_i)
joltages.sort!
joltages.unshift(0)
joltages.push(joltages.last + 3)

diffs = joltages.each_cons(2).map { |a, b| b - a }

puts diffs.count(1) * diffs.count(3)

#
# For any run of adapters only one joltage apart, we can remove a single adapter and still get a valid sequence:
#
# For example: 1,2,3,...,n and 1,3,...,n are both valid.
#
# There are n-2 ways to do this, for n >= 2.
# (We assume there is a gap of 3 on either side, so can't remove the first or last adapter.)
#
# We can also remove pairs of adapters from the run.
#
# For example: 1,2,3,4,...,n -> 1,4,...,n
# Or non-consecutive: 1,2,3,4,5,...,n -> 1,3,5,...,n
#
# There are n-2C2 ways to do this for n >= 2.
#
# It's not possible to remove three or more adapters and still get a valid sequence.
#
# This gives: n-2C0 + n-2C1 + n-2C2, sequences for n adapters all 1 joltage apart.
# Or equivalently: n-1C0 + n-1C1 + n-1C2 = 1 + nC2, sequences for n differences all equal to 1.
#

def run_sequences(diff, n)
  case diff
  when 1
    1 + (n >= 1 ? n*(n-1)/2 : 0)
  when 3
    1
  end
end

def all_sequences(diffs)
  count = 1
  i = 0
  while i < diffs.size
    start = i
    begin
      i += 1
    end while diffs[i] == diffs[start]
    count *= run_sequences(diffs[start], i - start)
  end
  count
end

puts all_sequences(diffs)
