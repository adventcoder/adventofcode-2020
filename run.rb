
show_time = false
while index = ARGV.index { |arg| arg.start_with?('-') }
  opt = ARGV.delete_at(index)
  case opt
  when '--time'
    show_time = true
  when '--'
    break
  else
    $stderr.puts("Unrecognised option: #{opt}")
  end
end

paths = []
ARGV.each do |arg|
  case arg
  when 'all'
    paths |= Dir.glob('??_*.rb')
  when /\d+/
    paths |= Dir.glob(sprintf('%02d_*.rb', arg.to_i)).take(1)
  else
    $stderr.puts("Invalid argument: #{arg}")
  end
end

total_time = 0

paths.each_with_index do |path, i|
  name = File.basename(path, File.extname(path))

  day = name[0, 2].to_i
  title = name[3 .. -1].split('_').map(&:capitalize).join(' ')

  puts if i > 0
  puts "--- Day #{day} : #{title} ---"

  start_time = Time.now
  output = IO.popen(['ruby', path]) { |io| io.read }
  time = Time.now - start_time
  total_time += time

  puts output
  if show_time
    puts
    puts "Time taken: #{sprintf('%.3f', time)} seconds"
  end
end

if show_time && paths.size > 1
  puts
  puts "Total time taken: #{sprintf('%.3f', total_time)} seconds"
end
