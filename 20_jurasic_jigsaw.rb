require_relative 'common'

input = get_input(20)
SIZE = 12

tiles = {}
for part in input.split("\n\n")
  tile_id = part.lines.first[/(\d+)/, 1].to_i
  tile = part.lines.drop(1).map(&:chomp)
  tiles[tile_id] = tile
end

def borders(tile)
  borders = [0, 0, 0, 0]
  for i in 0 ... 10
    top = tile[0][i] == '#' ? 1 : 0
    bottom = tile[9][i] == '#' ? 1 : 0
    left = tile[i][0] == '#' ? 1 : 0
    right = tile[i][9] == '#' ? 1 : 0
    borders[0] |= top << i
    borders[1] |= right << i
    borders[2] |= bottom << i
    borders[3] |= left << i
  end
  borders
end

def rotate(tile)
  new_tile = Array.new(tile.size) { "." * tile.size }
  for y in 0 ... tile.size
    for x in 0 ... tile.size
      new_tile[x][tile.size - y - 1] = tile[y][x]
    end
  end
  new_tile
end

def flip(tile)
  new_tile = Array.new(tile.size) { '.' * tile.size }
  for y in 0 ... tile.size
    for x in 0 ... tile.size
      new_tile[x][tile.size - y - 1] = tile[x][y]
    end
  end
  new_tile
end

def all_orientations(tile)
  os = []
  4.times do
    tile = rotate(tile)
    os << borders(tile)
  end
  tile = flip(tile)
  4.times do
    tile = rotate(tile)
    os << borders(tile)
  end
  os
end

def orient_to_tile(target, tile)
  4.times do
    tile = rotate(tile)
    return tile if borders(tile) == target
  end
  tile = flip(tile)
  4.times do
    tile = rotate(tile)
    return tile if borders(tile) == target
  end
  nil
end

def reverse(side)
  new_side = 0
  10.times do |i|
    new_side <<= 1
    new_side |= ((side >> i) & 1)
  end
  new_side
end

borders = {}
orients = {}
for id, tile in tiles
  orients[id] = all_orientations(tile)
  borders[id] = borders(tile)
end

def options(image, orients, i)
  x = i % SIZE
  y = i / SIZE
  top = nil
  if y > 0
    top = image[(y - 1) * SIZE + x][1][2]
  end
  left = nil
  if x > 0
    left = image[y * SIZE + (x - 1)][1][1]
  end
  orients.each do |id, options|
    options.each do |border|
      yield id, border if (top == nil or border[0] == top) and (left == nil or border[3] == left)
    end
  end
end

def fill(image, orients, start)
  if start == image.size
    return true
  end
  options(image, orients, start) do |id, borders|
    image[start] = [id, borders]
    copy = orients.dup
    copy.delete(id)
    if fill(image, copy, start + 1)
      return true
    end
  end
  image[start] = nil
  return false
end

image = Array.new(SIZE * SIZE)
fill(image, orients, 0)

image2 = Array.new(SIZE) { Array.new(SIZE) }
for y in 0 ... SIZE
  for x in 0 ... SIZE
    image2[y][x] = orient_to_tile(image[y * SIZE + x][1], tiles[image[y * SIZE + x][0]])
  end
end

joined = Array.new(SIZE * 8) { "." * (SIZE * 8) }
for y in 0 ... SIZE
  for x in 0 ... SIZE
    for yy in 0 ... 8
      for xx in 0 ... 8
        joined[y * 8 + yy][x * 8 + xx] = image2[y][x][yy + 1][xx + 1]
      end
    end
  end
end

monster = <<-EOS
                  # 
#    ##    ##    ###
 #  #  #  #  #  #   
EOS
monster = monster.lines.map(&:chomp)

def monster_at(image, x, y, monster)
  for yy in 0 ... monster.size
    for xx in 0 ... monster[yy].size
      next unless monster[yy][xx] == '#'
      return false if image[y + yy][x + xx] != '#'
    end
  end
  return true
end

def delete_monster(image, monster)
  for y in 0 ... image.size - monster.size
    for x in 0 ... image[y].size - monster[0].size
      if monster_at(image, x, y, monster)
        for yy in 0 ... monster.size
          for xx in 0 ... monster[yy].size
            next unless monster[yy][xx] == '#'
            image[y + yy][x + xx] = 'O'
          end
        end
      end
    end
  end
end

0.times { joined = rotate(joined) }
delete_monster(joined, monster)
for row in joined
  puts row
end
puts

count = 0
for y in 0 ... joined.size
  for x in 0 ... joined[y].size
    count += 1 if joined[y][x] == '#'
  end
end
puts count

