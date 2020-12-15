require_relative '00_common.rb'

def get_num(final_turn, starting_nums)
  last_turn = {}
  for turn in 1 ... starting_nums.size
    last_turn[starting_nums[turn - 1]] = turn
  end
  num = starting_nums.last
  for turn in starting_nums.size ... final_turn
    second_last_turn = last_turn[num]
    last_turn[num] = turn
    num = second_last_turn ? turn - second_last_turn : 0
  end
  num
end

starting_nums = get_input(15).split(',').map(&:to_i)
puts get_num(2020, starting_nums)
puts get_num(30000000, starting_nums)
