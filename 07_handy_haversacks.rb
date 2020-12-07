require_relative '00_common.rb'

input = get_input(7)

$contained = Hash.new { |h,k| h[k] = [] }

input.each_line do |line|
  next if line.include?('contain no other')
  lhs, rhs = line.delete('.').gsub(/bags?/, '').split('contain', 2)
  color = lhs.strip
  rhs.split(',').each do |s|
    n, subcolor = s.strip.split(' ', 2)
    $contained[color] << [n.to_i, subcolor]
  end
end

def contains?(color, target)
  color == target || $contained[color].any? { |(n, inner)| contains?(inner, target) }
end

def expanded_size(color)
  $contained[color].inject(0) { |size, (n, inner)| size + n + n * expanded_size(inner) }
end

puts $contained.keys.select { |color| color != 'shiny gold' and contains?(color, 'shiny gold') }.size
puts expanded_size('shiny gold')
