require_relative 'common'

class Tile
  attr_reader :rows

  def initialize(rows)
    @rows = rows
  end

  def size
    @rows.size
  end

  def [](x, y)
    return nil if y >= @rows.size
    @rows[y][x]
  end

  def top; @rows[0]; end
  def bottom; @rows[-1]; end
  def left; @rows.map { |row| row[0] }.join; end
  def right; @rows.map { |row| row[-1] }.join; end

  def each_orientation
    return enum_for(:each_orientation) unless block_given?
    tile = self
    4.times do
      yield tile
      yield tile.flip
      tile = tile.rotate
    end
  end

  def flip
    Tile.new(@rows.reverse)
  end

  def rotate
    Tile.new(Array.new(@rows.size) { |y|
      Array.new(@rows.size) { |x|
        @rows[x][@rows.size - 1 - y]
      }.join
    })
  end

  def to_s
    @rows.join("\n")
  end
end

input = get_input(20)

tiles = {}
for part in input.split("\n\n")
  id = part.lines.first[/\d+/].to_i
  rows = part.lines.drop(1).map(&:chomp)
  tiles[id] = Tile.new(rows)
end

orientations = {}
tiles.each do |id, tile|
  tile.each_orientation.with_index do |orientation, i|
    orientations[[id, i]] = orientation
  end
end

left = {}
right = {}
top = {}
bottom = {}
# Could do half as many iterations here since relation is symmetric but who cares.
orientations.each do |i, a|
  orientations.each do |j, b|
    next if i[0] == j[0]
    left[i] = j if a.left == b.right
    right[i] = j if a.right == b.left
    top[i] = j if a.top == b.bottom
    bottom[i] = j if a.bottom == b.top
  end
end

corners = orientations.keys.select { |i| top[i] == nil && left[i] == nil }
puts corners.map { |(id, i)| id }.uniq.prod

size = Math.sqrt(tiles.size).to_i
grid = Array.new(size) { Array.new(size) }
grid[0][0] = corners[0]
for x in 1 ... size
  grid[0][x] = right[grid[0][x - 1]]
end
for x in 0 ... size
  for y in 1 ... size
    grid[y][x] = bottom[grid[y - 1][x]]
  end
end

tile_size = orientations[grid[0][0]].size - 2
rows = Array.new(tile_size * size) { " " * (tile_size * size) }
for y in 0 ... size
  for x in 0 ... size
    for tile_y in 0 ... tile_size
      for tile_x in 0 ... tile_size
        rows[y * tile_size + tile_y][x * tile_size + tile_x] = orientations[grid[y][x]][tile_x + 1, tile_y + 1]
      end
    end
  end
end
mega_tile = Tile.new(rows)

monster = [
  '                  # ',
  '#    ##    ##    ###',
  ' #  #  #  #  #  #   '
]
monster_deltas = []
for y in 0 ... monster.size
  for x in 0 ... monster[y].size
    if monster[y][x] == '#'
      monster_deltas << [x, y]
    end
  end
end

mega_tile.each_orientation do |orientation|
  monster_count = 0
  wave_count = 0
  for y in 0 ... orientation.size
    for x in 0 ... orientation.size
      wave_count += 1 if mega_tile[x, y] == '#'
      monster_count += 1 if monster_deltas.all? { |(dx, dy)| orientation[x + dx, y + dy] == '#' }
    end
  end
  if monster_count > 0
    puts wave_count - monster_count * monster_deltas.size
    break
  end
end
