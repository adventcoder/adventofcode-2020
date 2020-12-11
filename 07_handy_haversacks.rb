require_relative '00_common.rb'

input = get_input(7)

$contents = Hash.new { |h, k| h[k] = [] }
input.each_line do |line|
  words = line.delete('.,').split
  words.delete_if { |word| word == 'contain' or word =~ /^bags?$/ }
  next if words.last(2) == ['no', 'other']
  bag = words.take(2).join(' ')
  words.drop(2).each_slice(3) do |n, *c|
    $contents[bag] << [n.to_i, c.join(' ')]
  end
end

def contains?(bag, target)
  $contents[bag].any? { |n, c| c == target || contains?(c, target) }
end

def count_all_contained(bag)
  $contents[bag].sum { |n, c| n + n * count_all_contained(c) }
end

puts $contents.keys.count { |bag| contains?(bag, 'shiny gold') }
puts count_all_contained('shiny gold')
