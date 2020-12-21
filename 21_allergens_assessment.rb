require_relative 'common'

input = get_input(21)

candidates = {}
counts = Hash.new(0)

input.each_line do |line|
  allergens = []
  if line.slice!(/\(contains (.*)\)/)
    allergens = $1.split(', ')
  end
  ingredients = line.split

  ingredients.each do |ingredient|
    counts[ingredient] += 1
  end

  allergens.each do |allergen|
    if candidates[allergen] == nil
      candidates[allergen] = ingredients
    else
      candidates[allergen] &= ingredients
    end
  end
end

puts (counts.keys - candidates.values.flatten).sum { |ingredient| counts[ingredient] }

allergens = {}
until candidates.empty?
  allergen = candidates.keys.find { |allergen| candidates[allergen].size == 1 }
  ingredient = candidates.delete(allergen).first
  allergens[ingredient] = allergen
  candidates.each_value { |ingredients| ingredients.delete(ingredient) }
end

puts allergens.keys.sort_by { |ingredient| allergens[ingredient] }.join(',')
