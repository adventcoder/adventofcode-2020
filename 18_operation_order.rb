require_relative 'common'

def tokenize(str)
  str = str.gsub('(', '( ')
  str = str.gsub(')', ' )')
  str.split
end

def parse(tokens)
  tree = []
  stack = [tree]
  for token in tokens
    case token
    when '('
      stack << []
    when ')'
      child = stack.pop
      stack.last << child
    else
      stack.last << token
    end
  end
  tree
end

def eval1(tree)
  case tree
  when Array
    acc = eval1(tree.first)
    tree.drop(1).each_slice(2) do |op, child|
      case op
      when '+'
        acc += eval1(child)
      when '*'
        acc *= eval1(child)
      end
    end
    acc
  else
    tree.to_i
  end
end

def eval2(tree)
  case tree
  when Array
    stack = [eval2(tree.first)]
    tree.drop(1).each_slice(2) do |op, child|
      case op
      when '+'
        stack << stack.pop + eval2(child)
      when '*'
        stack << eval2(child)
      end
    end
    stack.inject(&:*)
  else
    tree.to_i
  end
end

sum1 = 0
sum2 = 0
get_input(18).each_line do |line|
  tree = parse(tokenize(line.chomp))
  sum1 += eval1(tree)
  sum2 += eval2(tree)
end
puts sum1
puts sum2
