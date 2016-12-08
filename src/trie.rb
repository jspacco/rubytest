class Trie
  def initialize
    @word = false
    # this uses the hash constructor to set the default value
    # for any key that we can't find to be a new empty Trie node
    @letters = Hash.new { |hash, key| hash[key] = Trie.new }
  end
  attr_reader :word
  attr_reader :letters

  def insert(word)
    if word.length == 0
      @word=true
    else
      # look up (or create a new node) for first letter of the word
      # then recursively insert the rest of the word
      @letters[word[0]].insert(word[1..-1])
    end
  end

  def dig(word)
    # Base Case: for an empty string, that means we've walked the whole
    # tree to this current node. So return a reference to the current node
    if word==''
      return self
    end
    if @letters.key?(word[0])==nil
      # this means we don't have a child node for the given letter
      return nil
    else
      # recursive step: look up the child node for the first letter
      # then recursively dig the rest of the word
      return @letters[word[0]].dig(word[1..-1])
    end
  end

  def contains(word)
    # use our dig helper method above!
    node=self.dig(word)
    if node==nil
      return false
    else
      # if we get back a node, then either the node ends a word, or it doesn't
      return node.word
    end
  end

  def all_words(path, list)
    if @word
      list << path
    end
    @letters.each do |letter, trie|
      trie.all_words(path+letter, list)
    end
  end

  def close_words_rec(rest, n, path, list)
    if n==0
      p 'done: ' + rest
      trie = self.dig(rest)
      if trie != nil && trie.word
        list << path+rest
      end
    else
      # try to change very possible letter
      for i in 0..rest.length-1
        # npath is everything up to, but not including, the letter we're changing
        # nrest is everything after (not including) the letter we're changing
        npath = rest[0...i]
        nrest = rest[i+1..-1]
        # try to walk the path
        node = dig(npath)
        if node != nil
          # go through each possible swapped letter
          node.letters.each do |letter, trie|
            #p 'nrest=%s, npath=%s, letter=%s' % [nrest, npath, letter]
            # TODO: disallow the original letter
            if rest[i] != letter
              trie.close_words_rec(nrest, n-1, npath+letter, list)
            end
          end
        end
      end
    end
  end

  def close_words(word, n)
    result=[]
    self.close_words_rec(word, n, '', result)
    return result
  end

end
