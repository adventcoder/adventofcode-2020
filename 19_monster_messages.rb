require_relative 'common'

def parse_rules(input)
  rules = {}
  input.each_line do |line|
    lhs, rhs = line.split(":", 2)
    number = lhs.to_i
    if rhs =~ /"([^"]+)"/
      rules[number] = $1
    else
      rules[number] = rhs.split("|").map do |branch|
        branch.split.map(&:to_i)
      end
    end
  end
  rules
end

def make_regexp_str(rules, number)
  case rules[number]
  when String
    Regexp.escape(rules[number])
  when Array
    strs = rules[number].map do |branch|
      strs = branch.map do |child_number|
        make_regexp_str(rules, child_number)
      end
      "(" + strs.join(")(") + ")"
    end
    "(" + strs.join(")|(") + ")"
  end
end

parts = get_input(19).split("\n\n")
rules = parse_rules(parts[0])
messages = parts[1].lines.map(&:chomp)

rule0 = Regexp.compile("^#{make_regexp_str(rules, 0)}$")
puts messages.count { |message| message =~ rule0 }

alias old_make_regexp_str make_regexp_str
def make_regexp_str(rules, number)
  case number
  when 8
    "(#{make_regexp_str(rules, 42)})+"
  when 11
    rule42_str = make_regexp_str(rules, 42)
    rule31_str = make_regexp_str(rules, 31)
    str = "(#{rule42_str})(#{rule31_str})"
    10.times do
      str = "(#{rule42_str})(#{str})?(#{rule31_str})"
    end
    str
  else
    old_make_regexp_str(rules, number)
  end
end

rule0_prime = Regexp.compile("^#{make_regexp_str(rules, 0)}$")
puts messages.count { |message| message =~ rule0_prime }
