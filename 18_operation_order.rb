require_relative 'common.rb'

input = get_input(18)

class RPN
  def initialize
    @stack = []
  end

  def pop
    @stack.pop
  end

  def <<(token)
    case token
    when '+'
      a, b = @stack.pop(2)
      @stack << a + b
    when '*'
      a, b = @stack.pop(2)
      @stack << a * b
    else
      @stack << token.to_i
    end
  end
end

def evaluate(expr, precedence)
  rpn = RPN.new
  ops = []
  for token in tokenize(expr)
    if token == '('
      ops << token
    elsif token == ')'
      rpn << ops.pop until ops.last == '('
      ops.pop
    elsif precedence.has_key?(token)
      rpn << ops.pop while precedence.has_key?(ops.last) && precedence[ops.last] >= precedence[token]
      ops << token
    else
      rpn << token
    end
  end
  rpn << ops.pop until ops.empty?
  rpn.pop
end

def tokenize(line)
  line = line.gsub('(', ' ( ')
  line = line.gsub(')', ' ) ')
  line.split
end

precedence1 = { '+' => 1, '*' => 1 }
precedence2 = { '+' => 2, '*' => 1 }
puts input.lines.sum { |line| evaluate(line, precedence1) }
puts input.lines.sum { |line| evaluate(line, precedence2) }
