#https://old.reddit.com/r/adventofcode/comments/kmzuc8/one_extra_puzzle_to_end_this_year/
#https://csokavar.hu/projects/casette/

module Enumerable
  def squeeze
    result = []
    each do |value|
      result << value unless result.size > 0 && value == result.last
    end
    result
  end
end

def sample(frequency, t)
  127.5 * Math.sin(2.0 * Math::PI * t * frequency) - 0.5
end

def samples(frequency, length, n)
  t0 = rand / frequency
  dt = length / n
  Array.new(n) { |i| sample(frequency, t0 + i * dt).floor }
end

def frequency(samples, length)
  min_count = 0
  samples = samples.squeeze
  for i in 0 ... samples.size
    a = samples[(i - 1) % samples.size]
    b = samples[i]
    c = samples[(i + 1) % samples.size]
    min_count += 1 if b < a && b < c
  end
  min_count / length
end

def encode(c)
  digits = []
  n = c.ord
  5.times do
    digits << n % 3
    n /= 3
  end
  [0, *digits.reverse, 1, 2]
end

def decode(digits)
  digits[1 ... -2].inject(0) { |n, d| n * 3 + d }.chr
end

def generate(input, output)
  while c = input.getc
    for d in encode(c)
      frequency = 1000 + d * 1000
      output.puts(samples(frequency, 0.004, 72).join(','))
    end
  end
end

def solve(input, output)
  until input.eof?
    digits = []
    8.times do
      samples = input.gets.split(',').map(&:to_i)
      digits << (frequency(samples, 0.004) - 1000) / 1000
    end
    output.putc(decode(digits))
  end
end

=begin
def render(samples)
  chunks = []

  file_header = Array.new(5, 0)
  file_header[0] = 'B'.ord | ('M'.ord << 8)
  file_header[1] = 14 + 40 + samples.size * 255 * 4
  file_header[4] = 14 + 40
  chunks << file_header.pack('vVvvV')

  info_header = Array.new(11, 0)
  info_header[0] = 40
  info_header[1] = samples.size
  info_header[2] = 255
  info_header[3] = 1
  info_header[4] = 32
  chunks << info_header.pack('VVVvvVVVVVV')

  rows = Array.new(255) { Array.new(samples.size, 0xFFFFFF) }
  for x in 0 ... samples.size
    y = samples[x] + 128
    for y2 in 0 ... y
      rows[y2][x] = 0xCCCCCC
    end
    rows[y][x] = 0x000000
  end
  for row in rows
    chunks << row.pack('V*')
  end

  chunks.join
end
=end

if __FILE__ == $0
  case ARGV[0]
  when 'solve'
    solve($stdin, $stdout)
  when 'generate'
    generate($stdin, $stdout)
  else
    $stderr.puts("Usage: ruby #{$0} [solve|generate]")
    exit false
  end
end
