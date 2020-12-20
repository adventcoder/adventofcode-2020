require_relative 'common'

class Image
  attr_reader :rows, :width, :height

  def initialize(rows, width = rows[0].size, height = rows.size)
    @rows = rows
    @width = width
    @height = height
  end

  def top
    @rows[0]
  end

  def bottom
    @rows[@height - 1]
  end

  def left
    Array.new(@height) { |y| @rows[y][0] }.join
  end

  def right
    Array.new(@height) { |y| @rows[y][@width - 1] }.join
  end

  def sides
    [top, bottom, left, right]
  end

  def each_orientation
    image = self
    yield image
    3.times do
      image = image.rotate
      yield image
    end
    image = image.flip
    yield image
    3.times do
      image = image.rotate
      yield image
    end
  end

  def rotate
    new_rows = Array.new(@width) do |y|
      Array.new(@height) do |x|
        @rows[@height - x - 1][y]
      end.join
    end
    Image.new(new_rows, @height, @width)
  end

  def flip
    Image.new(@rows.reverse, @width, @height)
  end

  def count(c)
    @rows.sum { |row| row.count(c) }
  end

  def to_s
    @rows.join("\n")
  end
end

def unmatched?(target, skip_id, tiles)
  for id, tile in tiles
    next if id == skip_id
    for side in tile.sides
      return false if side == target || side == target.reverse
    end
  end
  true
end

def pick_top_left_tile(tiles)
  for id, tile in tiles
    tile.each_orientation do |orientation|
      if unmatched?(orientation.left, id, tiles) && unmatched?(orientation.top, id, tiles)
        tiles.delete(id)
        return orientation
      end
    end
  end
end

def pick_top_tile(tiles, left)
  for id, tile in tiles
    tile.each_orientation do |orientation|
      if left.right == orientation.left && unmatched?(orientation.top, id, tiles)
        tiles.delete(id)
        return orientation
      end
    end
  end
end

def pick_left_tile(tiles, top)
  for id, tile in tiles
    tile.each_orientation do |orientation|
      if top.bottom == orientation.top && unmatched?(orientation.left, id, tiles)
        tiles.delete(id)
        return orientation
      end
    end
  end
end

def pick_middle_tile(tiles, left, top)
  for id, tile in tiles
    tile.each_orientation do |orientation|
      if orientation.top == top.bottom && orientation.left == left.right
        tiles.delete(id)
        return orientation
      end
    end
  end
end

def make_image(tiles)
  size = Math.sqrt(tiles.size).floor
  image = Array.new(size) { Array.new(size) }
  image[0][0] = pick_top_left_tile(tiles)
  for x in 1 ... image.size
    image[0][x] = pick_top_tile(tiles, image[0][x - 1])
  end
  for y in 1 ... image.size
    image[y][0] = pick_left_tile(tiles, image[y - 1][0])
  end
  for y in 1 ... image.size
    for x in 1 ... image.size
      image[y][x] = pick_middle_tile(tiles, image[y][x - 1], image[y - 1][x])
    end
  end
  tile_width = image[0][0].width
  tile_height = image[0][0].height
  rows = Array.new((tile_height - 2) * size) { ' ' * ((tile_width - 2) * size) }
  for y in 0 ... size
    for x in 0 ... size
      for yy in 0 ... tile_height - 2
        for xx in 0 ... tile_width - 2
          rows[y * (tile_height - 2) + yy][x * (tile_width - 2) + xx] = image[y][x].rows[yy + 1][xx + 1]
        end
      end
    end
  end
  Image.new(rows, (tile_width - 2) * size, (tile_height - 2) * size)
end

def count_matches(sea, monster)
  count = 0
  sea.each_orientation do |orientation|
    for y in 0 ... orientation.height - monster.height
      for x in 0 ... orientation.width - monster.width
        matched = true
        for yy in 0 ... monster.height
          for xx in 0 ... monster.width
            next unless monster.rows[yy][xx] == '#'
            if orientation.rows[y + yy][x + xx] != '#'
              matched = false
              break
            end
          end
        end
        count += 1 if matched
      end
    end
    break if count > 0
  end
  count
end

input = get_input(20)

tiles = {}
for part in input.split("\n\n")
  id = part.lines.first[/(\d+)/, 1].to_i
  tiles[id] = Image.new(part.lines.drop(1).map(&:chomp))
end

puts tiles.prod { |id, tile| tile.sides.count { |side| unmatched?(side, id, tiles) } == 2 ? id : 1 }

sea = make_image(tiles)
monster = Image.new([
  '                  # ',
  '#    ##    ##    ###',
  ' #  #  #  #  #  #   '
])

puts sea.count('#') - count_matches(sea, monster) * monster.count('#')
