require_relative 'common'

input = get_input(25)

def transform(subject, size)
  value = 1
  while size > 0
    value = (value * subject) % 20201227 if size % 2 == 1
    subject = (subject * subject) % 20201227
    size /= 2
  end
  value
end

def inverse_transform(subject, public_key)
  value = 1
  size = 0
  until value == public_key
    value = (value * subject) % 20201227
    size += 1
  end
  size
end

door_key, card_key = input.lines.map(&:to_i)
card_size = inverse_transform(7, card_key)
puts transform(door_key, card_size)
