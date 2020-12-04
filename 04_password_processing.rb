
require_relative '00_common.rb'

input = get_input(4)

def is_valid?(port, strict = false)
  return false unless ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid'] - port.keys == []
  if strict
    return false unless port['byr'] =~ /^([0-9]{4})$/ and $1.to_i.between?(1920, 2002)
    return false unless port['iyr'] =~ /^([0-9]{4})$/ and $1.to_i.between?(2010, 2020)
    return false unless port['eyr'] =~ /^([0-9]{4})$/ and $1.to_i.between?(2020, 2030)
    if port['hgt'] =~ /^(\d+)cm$/
      return false unless $1.to_i.between?(150, 193)
    elsif port['hgt'] =~ /^(\d+)in$/
      return false unless $1.to_i.between?(59, 76)
    else
      return false
    end
    return false unless port['hcl'] =~ /^#[0-9a-f]{6}$/
    return false unless ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'].include?(port['ecl'])
    return false unless port['pid'] =~ /^[0-9]{9}$/
  end
  return true
end

count1 = 0
count2 = 0
curr = {}
input.each_line do |line|
  if line.strip.empty?
    count1 += 1 if is_valid?(curr, false)
    count2 += 1 if is_valid?(curr, true)
    curr = {}
  else
    for entry in line.strip.split
      curr[entry.split(':')[0]] = entry.split(':')[1]
    end
  end
end

puts count1
puts count2
