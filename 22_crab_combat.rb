require_relative 'common'

require 'set'

def combat(deck1, deck2)
  until deck1.empty? || deck2.empty?
    card1 = deck1.shift
    card2 = deck2.shift
    if card1 > card2
      deck1 << card1 << card2
    else
      deck2 << card2 << card1
    end
  end
  return deck2.empty?
end

def recursive_combat(deck1, deck2)
  seen = Set.new
  until deck1.empty? || deck2.empty?
    state = [deck1.dup, deck2.dup]
    return true unless seen.add?(state)
    card1 = deck1.shift
    card2 = deck2.shift
    if deck1.size >= card1 && deck2.size >= card2
      round = recursive_combat(deck1.take(card1), deck2.take(card2))
    else
      round = card1 > card2
    end
    if round
      deck1 << card1 << card2
    else
      deck2 << card2 << card1
    end
  end
  return deck2.empty?
end

def score(deck)
  deck.reverse_each.with_index.sum { |card, i| card * (i + 1) }
end

def deal(input)
  input.split("\n\n").map { |chunk| chunk.lines.drop(1).map(&:to_i) }
end

input = get_input(22)
deck1, deck2 = deal(input)
puts combat(deck1, deck2) ? score(deck1) : score(deck2)
deck1, deck2 = deal(input)
puts recursive_combat(deck1, deck2) ? score(deck1) : score(deck2)
