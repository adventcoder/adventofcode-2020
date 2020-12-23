
require_relative 'common.rb'

input = get_input(4)

validators = {}
validators['byr'] = lambda { |v| v =~ /^([0-9]{4})$/ && $1.to_i.between?(1920, 2002) }
validators['iyr'] = lambda { |v| v =~ /^([0-9]{4})$/ && $1.to_i.between?(2010, 2020) }
validators['eyr'] = lambda { |v| v =~ /^([0-9]{4})$/ && $1.to_i.between?(2020, 2030) }
validators['hgt'] = lambda { |v| (v =~ /^([0-9]+)cm$/ && $1.to_i.between?(150, 193)) || (v =~ /^([0-9]+)in$/ && $1.to_i.between?(59, 76)) }
validators['hcl'] = lambda { |v| v =~ /^#[0-9a-f]{6}$/ }
validators['ecl'] = lambda { |v| ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'].include?(v) }
validators['pid'] = lambda { |v| v =~ /^[0-9]{9}$/ }

count1 = 0
count2 = 0
for chunk in input.split("\n\n")
  passport = {}
  chunk.each_line do |line|
    for token in line.split
      passport.store(*token.split(':'))
    end
  end
  if validators.keys.all? { |field| passport.has_key?(field) }
    count1 += 1
    if validators.all? { |field, validator| validator.call(passport[field]) }
      count2 += 1
    end
  end
end

puts count1
puts count2
