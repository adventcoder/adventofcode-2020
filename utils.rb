class Integer
  def lsb_index
    #TODO
  end

  def msb_index
    #TODO
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

def find_path(start)
  prev = { start => nil }
  queue = [start]
  until queue.empty?
    curr = queue.shift

    if curr.goal?
      path = [curr]
      path << curr while curr = prev[curr]
      path.reverse!
      return path
    end

    curr.each_neighbour do |neighbour|
      next if prev.include?(neighbour)
      prev[neighbour] = curr
    end
  end
  nil
end

def find_path_with_cost(start)
  open = { start => 0 }
  prev = { start => nil }
  cost = {}
  until open.empty?
    curr = open.min { |a, b| a[1] <=> b[1] }[0]
    cost[curr] = open.delete(curr)

    if curr.goal?
      path = [curr]
      path << curr while curr = prev[curr]
      path.reverse!
      return path, cost[curr]
    end

    curr.each_neighbour_with_cost do |neighbour, delta|
      next if closed.has_key?(neighbour)
      next if open[neighbour] && open[neighbour] < cost[curr] + delta
      open[neighbour] = cost[curr] + delta
      prev[neighbour] = curr
    end
  end
  nil
end
