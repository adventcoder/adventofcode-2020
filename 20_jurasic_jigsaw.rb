require_relative 'common'

class Array
  def left; map { |row| row[0] }.join; end
  def right; map { |row| row[-1] }.join; end
  def top; self[0]; end
  def bottom; self[-1]; end

  def sides
    [left, right, top, bottom]
  end

  def orientations
    orientations = []
    orientation = self
    4.times do
      orientations << orientation
      orientations << orientation.reverse
      orientation = orientation.rotate
    end
    orientations
  end

  def rotate
    Array.new(self[0].size) do |x|
      Array.new(size) { |y| self[size - 1 - y][x] }.join
    end
  end

  def rotate!
    replace(rotate)
  end

  def reverse_rows!
    each { |row| row.reverse! }
  end

  def detect_monster(monster)
    for y in 0 ... size - monster.size
      for x in 0 ... self[0].size - monster[0].size
        if monster_at?(x, y, monster)
          for monster_y in 0 ... monster.size
            for monster_x in 0 ... monster[monster_y].size
              self[y + monster_y][x + monster_x] = 'O' if monster[monster_y][monster_x] == '#'
            end
          end
        end
      end
    end
  end

  def monster_at?(x, y, monster)
    for monster_y in 0 ... monster.size
      for monster_x in 0 ... monster[monster_y].size
        return false if monster[monster_y][monster_x] == '#' && self[y + monster_y][x + monster_x] != '#'
      end
    end
    true
  end
end

class Jigsaw
  def initialize(input)
    @tiles = {}
    for chunk in input.split("\n\n")
      id = chunk.lines.first[/\d+/].to_i
      tile = chunk.lines.drop(1).map(&:chomp)
      @tiles[id] = tile
    end

    @edges = Hash.new { |h, k| h[k] = [] }
    for id, tile in @tiles
      @edges[tile.left] << id
      @edges[tile.right] << id
      @edges[tile.top] << id
      @edges[tile.bottom] << id
      @edges[tile.left.reverse] << id
      @edges[tile.right.reverse] << id
      @edges[tile.top.reverse] << id
      @edges[tile.bottom.reverse] << id
    end

    size = Math.sqrt(@tiles.size)
    @grid = Array.new(size) { Array.new(size) }
  end

  def border?(side)
    @edges[side].size == 1
  end

  def corner?(id)
    @tiles[id].sides.count { |side| border?(side) } == 2
  end

  def corners
    @tiles.keys.select { |id| corner?(id) }
  end

  def bottom(id)
    (@edges[@tiles[id].bottom] - [id]).first
  end

  def right(id)
    (@edges[@tiles[id].right] - [id]).first
  end

  def tile(x, y)
    @tiles[@grid[y][x]]
  end

  def assemble
    @grid[0][0] = corners.first
    tile(0, 0).rotate! until border?(tile(0, 0).left) && border?(tile(0, 0).top)

    for y in 1 ... @grid.size
      @grid[y][0] = bottom(@grid[y - 1][0])
      tile(0, y).rotate! until tile(0, y).top == tile(0, y - 1).bottom || tile(0, y).top.reverse == tile(0, y - 1).bottom
      tile(0, y).reverse_rows! unless tile(0, y).top == tile(0, y - 1).bottom
    end

    for y in 0 ... @grid.size
      for x in 1 ... @grid[y].size
        @grid[y][x] = right(@grid[y][x - 1])
        tile(x, y).rotate! until tile(x, y).left == tile(x - 1, y).right || tile(x, y).left.reverse == tile(x - 1, y).right
        tile(x, y).reverse! unless tile(x, y).left == tile(x - 1, y).right
      end
    end
  end

  def to_a
    tile_size = 8
    rows = Array.new(@grid.size * tile_size) { |y| ' ' * (@grid[y / tile_size].size * tile_size) }
    for y in 0 ... @grid.size
      for x in 0 ... @grid[y].size
        next if @grid[y][x] == nil
        for tile_y in 0 ... tile_size
          for tile_x in 0 ... tile_size
            rows[y * tile_size + tile_y][x * tile_size + tile_x] = @tiles[@grid[y][x]][tile_y + 1][tile_x + 1]
          end
        end
      end
    end
    rows
  end
end

jigsaw = Jigsaw.new(get_input(20))
puts jigsaw.corners.prod

jigsaw.assemble
image = jigsaw.to_a

monster = <<-EOS.lines.map(&:chomp)
                  # 
#    ##    ##    ###
 #  #  #  #  #  #   
EOS

for orientation in monster.orientations
  image.detect_monster(orientation)
end
puts image.sum { |row| row.count('#') }
