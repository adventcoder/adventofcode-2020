require_relative 'common'

class Tile
  def self.collapse(grid)
    id = grid[0][0].id * grid[0][-1].id * grid[-1][0].id * grid[-1][-1].id
    rows = grid.flat_map do |row|
      row.map(&:center).transpose.map(&:join)
    end
    new(id, rows)
  end

  attr_reader :id, :rows

  def initialize(id, rows)
    @id = id
    @rows = rows
  end

  def to_s
    ["Tile #{@id}:", *@rows].join("\n")
  end

  def top; @rows[0]; end
  def bottom; @rows[-1]; end
  def left; @rows.map { |row| row[0] }.join; end
  def right; @rows.map { |row| row[-1] }.join; end
  def sides; [top, bottom, left, right]; end
  def center; @rows[1 .. -2].map { |row| row[1 .. -2] }; end

  def rotate!
    @rows = Array.new(@rows[0].size) { |x| @rows.map { |row| row[-1 - x] }.join }
  end

  def flip!
    @rows.reverse!
  end

  def flip_rows!
    @rows.each { |row| row.reverse! }
  end

  def scan!(pattern)
    for y in 0 ... @rows.size - pattern.size + 1
      for x in 0 ... @rows[0].size - pattern[0].size + 1
        if match?(x, y, pattern)
          for dy in 0 ... pattern.size
            for dx in 0 ... pattern[dy].size
              next if pattern[dy][dx] == ' '
              @rows[y + dy][x + dx] = 'O'
            end
          end
        end
      end
    end
  end

  def match?(x, y, pattern)
    for dy in 0 ... pattern.size
      for dx in 0 ... pattern[0].size
        next if pattern[dy][dx] == ' '
        return false unless @rows[y + dy][x + dx] == pattern[dy][dx]
      end
    end
    true
  end

  def count(c)
    @rows.sum { |row| row.count(c) }
  end
end

class Tileset
  def initialize(input)
    @tiles = []
    for chunk in input.split("\n\n")
      rows = chunk.lines.map(&:chomp)
      id = rows.shift[/\d+/].to_i
      @tiles << Tile.new(id, rows)
    end
    @edges = Hash.new { |h, k| h[k] = [] }
    for tile in @tiles
      for side in tile.sides
        @edges[side] << tile
        @edges[side.reverse] << tile
      end
    end
  end

  def border?(side)
    @edges[side].size == 1
  end

  def corner?(tile)
    (border?(tile.top) || border?(tile.bottom)) && (border?(tile.left) || border?(tile.right))
  end

  def find_top_left_corner
    for tile in @tiles
      if corner?(tile)
        tile.rotate! until border?(tile.top) && border?(tile.left)
        return tile
      end
    end
    nil
  end

  def find_right_neighbour(left)
    for tile in @edges[left.right]
      next if tile.id == left.id
      tile.rotate! until tile.left == left.right || tile.left == left.right.reverse
      tile.flip! unless tile.left == left.right
      return tile
    end
    nil
  end

  def find_bottom_neighbour(above)
    for tile in @edges[above.bottom]
      next if tile.id == above.id
      tile.rotate! until tile.top == above.bottom || tile.top == above.bottom.reverse
      tile.flip_rows! unless tile.top == above.bottom
      return tile
    end
    nil
  end

  def arrange(width, height)
    grid = Array.new(height) { Array.new(width) }
    grid[0][0] = find_top_left_corner
    for y in 1 ... height
      grid[y][0] = find_bottom_neighbour(grid[y - 1][0])
    end
    for y in 0 ... height
      for x in 1 ... width
        grid[y][x] = find_right_neighbour(grid[y][x - 1])
      end
    end
    grid
  end
end

tileset = Tileset.new(get_input(20))
image = Tile.collapse(tileset.arrange(12, 12))
monster = <<-EOS.lines.map(&:chomp)
                  # 
#    ##    ##    ###
 #  #  #  #  #  #   
EOS
2.times do
  4.times do
    image.scan!(monster)
    image.rotate!
  end
  image.flip!
end
puts image.id
puts image.count('#')
