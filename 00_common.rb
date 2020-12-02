
require 'fileutils'
require 'net/http'

$session = '53616c7465645f5f94f67249ed8c1e08e108122e681df69d04ea3d25508f69905766331a36e522358d4045256b258a51'

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
      warn("unable to cache remote file: #{error.message}")
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

class Array
  def find_index(x, lo = 0, hi = size)
    while hi - lo > 1
      i = lo + (hi - lo) / 2
      if self[i] < x
        lo = i + 1
      elsif self[i] > x
        hi = i
      else
        return j
      end
    end
    return lo if hi > lo && self[lo] == x
    nil
  end
end
