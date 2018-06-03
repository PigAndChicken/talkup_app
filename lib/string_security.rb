# Generate security information about strings
class StringSecurity
  # Find entropy of a given string
  def self.entropy(string)
    length = string.length
    chars_count = string.chars.uniq
                        .map { |char| [char, string.count(char).to_f] }.to_h

    chars_count.values.reduce(0) do |entropy, count|
      prob = count / length
      entropy - prob * Math.log2(prob)
    end
  end
end
