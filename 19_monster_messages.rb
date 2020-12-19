require_relative 'common'

parts = get_input(19).split("\n\n")

$rules = Hash.new { |h, k| h[k] = [] }
parts[0].each_line do |line|
  lhs, rhs = line.split(":", 2)
  i = lhs.to_i
  if rhs =~ /"([^"]+)"/
    $rules[i] << $1
  else
    for alt in rhs.split("|")
      $rules[i] << alt.split.map(&:to_i)
    end
  end
end

$messages = parts[1].lines.map(&:chomp)

def match_completely(message, i)
  match(message, i, 0) do |end_index|
    return true if end_index == message.size
  end
  false
end

def match(message, i, start, &block)
  for alt in $rules[i]
    case alt
    when String
      block.call(start + alt.size) if message[start, alt.size] == alt
    when Array
      match_sequence(message, alt, start, &block)
    end
  end
end

def match_sequence(message, is, start, &block)
  if is.empty?
    block.call(start)
  else
    match(message, is.first, start) do |next_start|
      match_sequence(message, is.drop(1), next_start, &block)
    end
  end
end

puts $messages.count { |message| match_completely(message, 0) }
$rules[8] = [[42], [42, 8]]
$rules[11] = [[42, 31], [42, 11, 31]]
puts $messages.count { |message| match_completely(message, 0) }
