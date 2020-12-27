require_relative '../utils'

require 'set'

def split(str)
  str.scan(/[A-Za-z][a-z]*/)
end

rules = Hash.new { |h, k| h[k] = [] }
inverse_rules = {}
parts = DATA.read.split("\n\n")
parts[0].each_line do |line|
  lhs, rhs = line.chomp.split(" => ")
  rules[split(lhs)[0]] << split(rhs)
  inverse_rules[split(rhs)] = split(lhs)[0]
end
molecule = split(parts[1].chomp)

def replace(molecule, rules)
  replacements = Set.new
  for i in 0 ... molecule.size
    for sub in rules[molecule[i]]
      replacements.add(molecule.take(i) + sub + molecule.drop(i + 1))
    end
  end
  replacements
end

def reduce(molecule, inverse_rules)
  total_steps = 0
  stack = []
  i = 0
  while i < molecule.size
    if molecule[i] == 'Rn'
      stack << i
    elsif molecule[i] == 'Y' || molecule[i] == 'Ar'
      start = stack.pop + 1
      replacement, steps = reduce_simple(molecule[start ... i], inverse_rules)
      total_steps += steps
      molecule[start ... i] = replacement
      i = start + replacement.size
      stack << i if molecule[i] == 'Y'
    end
    i += 1
  end
  molecule, steps = reduce_simple(molecule, inverse_rules)
  return molecule, total_steps + steps
end

def reduce_simple(molecule, inverse_rules)
  key_sizes = inverse_rules.keys.map(&:size).uniq
  heap = Heap.new { |a, b| a[0].size <=> b[0].size }
  heap << [molecule, 0]
  until heap.empty?
    molecule, steps = heap.pop
    return molecule, steps if molecule.size == 1
    for key_size in key_sizes
      for i in 0 ... molecule.size - key_size + 1
        if sub = inverse_rules[molecule[i, key_size]]
          heap << [molecule.take(i) + [sub] + molecule.drop(i + key_size), steps + 1]
        end
      end
    end
  end
end

puts replace(molecule, rules).size
puts reduce(molecule, inverse_rules)[1]

__END__
Al => ThF
Al => ThRnFAr
B => BCa
B => TiB
B => TiRnFAr
Ca => CaCa
Ca => PB
Ca => PRnFAr
Ca => SiRnFYFAr
Ca => SiRnMgAr
Ca => SiTh
F => CaF
F => PMg
F => SiAl
H => CRnAlAr
H => CRnFYFYFAr
H => CRnFYMgAr
H => CRnMgYFAr
H => HCa
H => NRnFYFAr
H => NRnMgAr
H => NTh
H => OB
H => ORnFAr
Mg => BF
Mg => TiMg
N => CRnFAr
N => HSi
O => CRnFYFAr
O => CRnMgAr
O => HP
O => NRnFAr
O => OTi
P => CaP
P => PTi
P => SiRnFAr
Si => CaSi
Th => ThCa
Ti => BP
Ti => TiTi
e => HF
e => NAl
e => OMg

ORnPBPMgArCaCaCaSiThCaCaSiThCaCaPBSiRnFArRnFArCaCaSiThCaCaSiThCaCaCaCaCaCaSiRnFYFArSiRnMgArCaSiRnPTiTiBFYPBFArSiRnCaSiRnTiRnFArSiAlArPTiBPTiRnCaSiAlArCaPTiTiBPMgYFArPTiRnFArSiRnCaCaFArRnCaFArCaSiRnSiRnMgArFYCaSiRnMgArCaCaSiThPRnFArPBCaSiRnMgArCaCaSiThCaSiRnTiMgArFArSiThSiThCaCaSiRnMgArCaCaSiRnFArTiBPTiRnCaSiAlArCaPTiRnFArPBPBCaCaSiThCaPBSiThPRnFArSiThCaSiThCaSiThCaPTiBSiRnFYFArCaCaPRnFArPBCaCaPBSiRnTiRnFArCaPRnFArSiRnCaCaCaSiThCaRnCaFArYCaSiRnFArBCaCaCaSiThFArPBFArCaSiRnFArRnCaCaCaFArSiRnFArTiRnPMgArF
