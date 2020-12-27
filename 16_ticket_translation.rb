require_relative 'common.rb'

require 'set'

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

def rule_check_all(tickets, i, rule)
  tickets.all? { |ticket| rule_check(ticket[i], rule) }
end

options = {}
rules.each do |field, rule|
  options[field] = (0 ... my_ticket.size).select { |i| rule_check_all(nearby_tickets, i, rule) }
end

fields = []
until options.empty?
  field = options.each_key.find { |field| options[field].size == 1 }
  index = options.delete(field).first
  fields[index] = field
  options.each_value { |indices| indices.delete(index) }
end

puts fields.zip(my_ticket).prod { |field, value| field.start_with?('departure') ? value : 1 }
