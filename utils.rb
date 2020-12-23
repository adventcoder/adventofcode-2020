
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

  def swap(i, j)
    temp = self[i]
    self[i] = self[j]
    self[j] = temp
  end
end

class Integer
  def sgn
    self <=> 0
  end
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

class PriorityQueue
  def initialize
    @heap = []
  end

  def empty?
    @heap.empty?
  end

  def size
    @heap.size
  end

  def push(value, priority)
    @heap << [value, priority]
    heapify_up(@heap.size - 1)
    self
  end

  def pop
    return nil if @heap.empty?
    if @heap.size == 1
      @heap.pop[0]
    else
      pair = @heap[0]
      @heap[0] = @heap.pop
      heapify_down(0)
      pair[0]
    end
  end

  def set_priority(value, priority)
    index = @heap.index { |pair| pair[0].eql?(value) }
    return if index == nil
    old_priority = @heap[index][1]
    @heap[index][1] = priority
    if priority > old_priority
      heapify_down(index)
    elsif priority < old_priority
      heapify_up(index)
    end
  end

  def heapify_up(index)
    while index > 0
      parent_index = parent(index)
      break if @heap[index][1] >= @heap[parent_index][1]
      temp = @heap[index]
      @heap[index] = @heap[parent_index]
      @heap[parent_index] = temp
      index = parent_index
    end
  end

  def heapify_down(index)
    while right_child(index) < @heap.size
      min_child_index = right_child(index)
      min_child_index = left_child(index) if @heap[left_child(index)][1] < @heap[min_child_index][1]
      return if @heap[index][1] <= @heap[min_child_index][1]
      @heap.swap(index, min_child_index)
      index = min_child_index
    end
    if left_child(index) < @heap.size
      child_index = left_child(index)
      return if @heap[index][1] <= @heap[child_index][1]
      @heap.swap(index, child_index)
      index = child_index
    end
  end

  def parent(index)
    (index - 1) / 2
  end

  def left_child(index)
    2 * index + 1
  end

  def right_child(index)
    2 * index + 2
  end
end
