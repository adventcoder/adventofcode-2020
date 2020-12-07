require_relative '00_common.rb'

input = get_input(7)

$contained = Hash.new { |h,k| h[k] = [] }

input.each_line do |line|
  next if line.include?('contain no other')
  lhs, rhs = line.delete('.').gsub(/bags?/, '').split('contain', 2)
  color = lhs.strip
  rhs.split(',').each do |s|
    n, contained_color = s.strip.split(' ', 2)
    $contained[color] << [n.to_i, contained_color]
  end
end

def contains?(color, target)
  color == target || $contained[color].any? { |(n, contained)| contains?(contained, target) }
end

def expanded_size(color)
  $contained[color].sum { |n, contained| n + n * expanded_size(contained) }
end

puts $contained.keys.count { |color| color != 'shiny gold' and contains?(color, 'shiny gold') }
puts expanded_size('shiny gold')
