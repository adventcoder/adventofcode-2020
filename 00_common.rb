
require 'fileutils'
require 'net/http'

require_relative 'utils.rb'

begin
  $session = File.read('session.txt')
rescue Errno::ENOENT
  puts "Helpful message here"
  exit false
end

def get_input(day)
  path = "inputs/#{$session}/#{day}.txt"
  if File.exist?(path)
    File.read(path)
  else
    input = fetch_input(day)
    begin
      FileUtils.mkdir_p(File.dirname(path))
      File.write(path, input)
    rescue => error
      warn("unable to save local copy of input: #{error.message}")
    end
    input
  end
end

def fetch_input(day)
  http = Net::HTTP.new('adventofcode.com', 443)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new("/2020/day/#{day}/input")
  request['Cookie'] = "session=#{$session}"

  response = http.request(request)
  case response
  when Net::HTTPSuccess
    response.body
  else
    response.error!
  end
end
