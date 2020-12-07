
require_relative '00_common.rb'

report = []
get_input(1).each_line do |line|
  report << line.chomp.to_i
end
report.sort!

def find_disparities(report, n, target, start = 0)
  if n == 1
    return [target] if report.bsearch_index(target, start)
  else
    for i in start ... report.size - (n - 1)
      break if (n - 1) * report[i] > target
      if prices = find_disparities(report, n - 1, target - report[i], i + 1)
        return [report[i], *prices]
      end
    end
  end
  nil
end

puts find_disparities(report, 2, 2020).prod
puts find_disparities(report, 3, 2020).prod
