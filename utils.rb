
Infinity = Float::INFINITY

module Enumerable
  def sum(zero = 0)
    if block_given?
      inject(zero) { |acc, x| acc + (yield x) }
    else
      inject(zero) { |acc, n| acc + n }
    end
  end

  def prod(one = 1)
    if block_given?
      inject(one) { |acc, x| acc * (yield x) }
    else
      inject(one) { |acc, n| acc * n }
    end
  end

  def filter_map
    return enum_for(:filter_map) unless block_given?
    ys = []
    each do |x|
      y = yield x
      ys << y unless y.nil?
    end
    ys
  end
end

class Range
  def bsearch(target)
    min = first
    max = exclude_end? ? last - 1 : last
    while min < max
      mid = (min + max) / 2
      case (yield mid) <=> target
      when -1
        min = mid + 1
      when 1
        max = mid - 1
      when 0
        return mid
      end
    end
    if min == max
      return min if (yield min) == target
    end
    nil
  end
end

class Array
  def bsearch_index(target, first = 0, last = size)
    (first ... last).bsearch(target) { |i| self[i] }
  end
end

class Integer
  def sgn
    self <=> 0
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

class DisjointSet
  attr_reader :size

  def initialize(size)
    @parent = Array.new(size) { |i| i }
    @height = Array.new(size, 1)
    @size = size
  end

  def find(i)
    root = i
    until @parent[root] == root
      root = @parent[root]
    end
    until @parent[i] == root
      i, @parent[i] = @parent[i], root
    end
    root
  end

  def merge(i, j)
    i = find(i)
    j = find(j)
    return if i == j
    if @height[i] < @height[j]
      @parent[i] = j
    elsif @height[j] < @height[i]
      @parent[j] = i
    else
      @parent[i] = j
      @height[j] += 1
    end
    @size -= 1
  end
end
