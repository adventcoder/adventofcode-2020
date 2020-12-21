require_relative 'common'

input = get_input(21)

allergen_candidates = {}
ingredient_count = Hash.new(0)

input.each_line do |line|
  allergens = []
  if line.slice!(/\(contains (.*)\)/)
    allergens = $1.split(', ')
  end
  ingredients = line.split

  ingredients.each do |food|
    ingredient_count[food] += 1
  end

  allergens.each do |allergen|
    if allergen_candidates[allergen] == nil
      allergen_candidates[allergen] = ingredients
    else
      allergen_candidates[allergen] &= ingredients
    end
  end
end

puts (ingredient_count.keys - allergen_candidates.values.flatten).sum { |k| ingredient_count[k] }

allergens = {}
until allergen_candidates.empty?
  allergen = allergen_candidates.keys.find { |k| allergen_candidates[k].size == 1 }
  ingredient = allergen_candidates.delete(allergen).first
  allergens[ingredient] = allergen
  allergen_candidates.each_value { |ingredients| ingredients.delete(ingredient) }
end

puts allergens.keys.sort_by { |ingredient| allergens[ingredient] }.join(',')
