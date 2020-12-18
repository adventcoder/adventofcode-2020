require_relative '00_common.rb'

def tokenize(line)
  line = line.gsub('(', ' ( ')
  line = line.gsub(')', ' ) ')
  line.split
end

def eval1(tokens)
  num, expr = lambda do
    case t = tokens.shift
    when '('
      acc = expr.call
      raise unless tokens.shift == ')'
      acc
    else
      t.to_i
    end
  end, lambda do
    acc = num.call
    while tokens.first == '*' || tokens.first == '+'
      case tokens.shift
      when '*'
        acc *= num.call
      when '+'
        acc += num.call
      end
    end
    acc
  end
  expr.call
end

def eval2(tokens)
  num, sum, product = lambda do
    case t = tokens.shift
    when '('
      acc = product.call
      raise unless tokens.shift == ')'
      acc
    else
      t.to_i
    end
  end, lambda do
    acc = num.call
    while tokens.first == '+'
      tokens.shift
      acc += num.call
    end
    acc
  end, lambda do
    acc = sum.call
    while tokens.first == '*'
      tokens.shift
      acc *= sum.call
    end
    acc
  end
  product.call
end

input = get_input(18)
puts input.lines.sum { |line| eval1(tokenize(line)) }
puts input.lines.sum { |line| eval2(tokenize(line)) }
