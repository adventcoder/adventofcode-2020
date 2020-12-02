
require_relative '00_common.rb'

report = []
get_input(1).each_line do |line|
  report << line.chomp.to_i
end
report.sort!

for i in 0 ... (report.size - 1)
  if j = report.find_index(2020 - report[i], i + 1)
    puts report[i] * report[j]
  end
end

for i in 0 ... (report.size - 2)
  for j in (i + 1) ... (report.size - 1)
    if k = report.find_index(2020 - report[i] - report[j], j + 1)
      puts report[i] * report[j] * report[k]
    end
  end
end
