require './trie'

#dictfile='../resources/words'
dictfile = '../resources/testwords'

root = Trie.new

File.open(dictfile, "r") do |f|
  f.each_line do |line|
    root.insert(line.strip)
  end
end

p root.dig('dog')==nil
p root.contains('dog')

words=Array.new
root.all_words('', words)
p words.length

p root.close_words('dol', 1)
