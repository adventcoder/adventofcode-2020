
require_relative '00_common.rb'

input = get_input(10)

jolts = []
input.each_line do |line|
  jolts << line.chomp.to_i
end

jolts.sort!
jolts.unshift(0)
jolts << jolts.last + 3

diffs = Hash.new(0)
jolts.each_cons(2) { |a, b| diffs[b - a] += 1 }

puts diffs[3] * diffs[1]

def combs_recur(jolts, start = 0, memo = {})
  memo[start] ||= begin
    n = 0
    if start == jolts.size - 1
      n += 1
    else
      # add up the combinations for each possible next adapter
      for i in start + 1 ... jolts.size
        break unless jolts[i] - jolts[start] <= 3
        n += combs_recur(jolts, i, memo)
      end
    end
    n
  end
end

# Not my solution but of course the number of ways to end at an adapter is the number of ways for all the possible previous adapters.
def combs_dp(jolts)
  combs = Hash.new(0)
  combs[jolts.first] = 1
  for jolt in jolts.drop(1)
    combs[jolt] = combs[jolt - 1] + combs[jolt - 2] + combs[jolt - 3]
  end
  combs[jolts.last]
end

puts combs_recur(jolts)
