
require_relative '00_common.rb'

report = []
get_input(1).each_line do |line|
  report << line.chomp.to_i
end

report.combination(2) do |a, b|
  if a + b == 2020
    puts a * b
  end
end

report.combination(3) do |a, b, c|
  if a + b + c == 2020
    puts a * b * c
  end
end
