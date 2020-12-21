require_relative 'common'

input = get_input(21)

allergen_counts = Hash.new { |h, k| h[k] = Hash.new(0) }
min_count = Hash.new { |h, k| h[k] = 0 }
all_foods = []
food_counts = Hash.new { |h, k| h[k] = 0 }

input.each_line do |line|
  i1 = line.index('(')
  i2 = line.index(')', i1 + 1)
  x = line[(i1 + 1) ... i2]
  allergens = line[(i1 + 1 + 'contains'.size) ... i2].split(',').map(&:strip)
  foods = line[0 ... i1].split
  foods.each do |f|
    food_counts[f] += 1
  end
  all_foods |= foods
  allergens.each do |a|
    min_count[a] += 1
    foods.each do |f|
      allergen_counts[a][f] += 1
    end
  end
end

possible = Hash.new { |h, k| h[k] = [] }
all_possible = []
allergen_counts.each do |a, fs|
  fs.each do |f, c|
    if c >= min_count[a]
      possible[a] << f
    end
  end
  all_possible |= possible[a]
end

puts (all_foods - all_possible).sum { |f| food_counts[f] }

actual = {}
until possible.empty?
  a = possible.keys.find { |a| possible[a].size == 1 }
  f = possible[a][0]
  actual[f] = a
  possible.delete(a)
  possible.each_value { |fs| fs.delete(f) }
end

puts actual.keys.sort_by { |f| actual[f] }.join(',')
