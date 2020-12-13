require_relative '00_common.rb'

lines = get_input(13).lines.to_a
my_earliest_time = lines[0].to_i
bus_ids = lines[1].split(',').map(&:to_i)

def wait_time(earliest_time, bus_id)
  (-earliest_time) % bus_id
end

my_bus_id = bus_ids.reject(&:zero?).min_by { |bus_id| wait_time(my_earliest_time, bus_id) }
puts my_bus_id * wait_time(my_earliest_time, my_bus_id)

# Solves: gcd(|a|, |b|) = a*x + b*y
def bezout(a, b)
  curr = [a.abs, a.sgn, 0]
  succ = [b.abs, 0, b.sgn]
  while succ[0] != 0
    q = curr[0] / succ[0]
    3.times do |i|
      curr[i], succ[i] = succ[i], curr[i] - q * succ[i]
    end
  end
  curr
end

t0 = 0
dt = 1
bus_ids.each_with_index do |bus_id, i|
  next if bus_id == 0
  d, x, y = bezout(bus_id, -dt)
  t0 += y * (t0 + i) * dt / d
  dt *= bus_id / d
  t0 %= dt
end
puts t0
