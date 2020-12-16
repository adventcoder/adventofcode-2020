require_relative '00_common.rb'

parts = get_input(16).split("\n\n")

rules = {}
parts[0].each_line do |line|
  if line =~ /^(.*): (\d+)-(\d+) or (\d+)-(\d+)$/
    rules[$1] = [$2.to_i .. $3.to_i, $4.to_i .. $5.to_i]
  end
end
my_ticket = parts[1].lines.drop(1).first.chomp.split(",").map(&:to_i)
nearby_tickets = parts[2].lines.drop(1).map { |line| line.chomp.split(',').map(&:to_i) }

def rule_check(value, rule)
  rule.any? { |range| range.include?(value) }
end

def error_rate(ticket, rules)
  ticket.sum { |value| rules.none? { |field, rule| rule_check(value, rule) } ? value : 0 }
end

puts nearby_tickets.sum { |ticket| error_rate(ticket, rules) }

nearby_tickets.reject! { |ticket| error_rate(ticket, rules) > 0 }

def rule_check_all(tickets, j, rule)
  tickets.all? { |ticket| rule_check(ticket[j], rule) }
end

options = Array.new(my_ticket.size) do |j|
  rules.keys.select { |field| rule_check_all(nearby_tickets, j, rules[field]) }
end

# TODO: this can probably fail
fields = []
while i = options.index { |opt| opt.size == 1 }
  fields[i] = options[i][0]
  options.each do |opts|
    opts.delete(fields[i])
  end
end

puts fields.zip(my_ticket).prod { |field, value| field.start_with?('departure') ? value : 1 }
