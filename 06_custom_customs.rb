
require_relative 'common.rb'

input = get_input(6)

sum1 = 0
sum2 = 0
for chunk in input.split("\n\n")
  any_answered = []
  all_answered = [*'a' .. 'z']
  chunk.each_line do |line|
    answers = line.chomp.split('')
    any_answered |= answers
    all_answered &= answers
  end
  sum1 += any_answered.size
  sum2 += all_answered.size
end

puts sum1
puts sum2
