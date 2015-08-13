#
# Created by Steve Petropulos using the guide at:
# https://blog.engineyard.com/2013/hash-lookup-in-ruby-why-is-it-so-fast.
#

HashEntry = Struct.new(:key, :value)

class HashTable
  attr_accessor :bins
  attr_accessor :bin_count
  
  def initialize
    self.bin_count = 100_000
    self.bins = []
  end
  
  def <<(entry)
    index = bin_for(entry.key)
    self.bins[index] ||= []
    self.bins[index] << entry
  end
  
  def [](key)
    index = bin_for(key)
    self.bins[index].detect do |entry|
      puts entry.key
      entry.key == key
    end
  end
  
  def bin_for(key)
    key.hash % self.bin_count
  end
end

entry = HashEntry.new(:foo, :bar)
table = HashTable.new
table << entry

require 'benchmark'

#
# HashTable instance
#
table = HashTable.new

#
# CREATE 1,000,000 entries and add them to the table
#

(1..1_000_000).each do |i|
  entry = HashEntry.new(i.to_s, "bar#{i}")
  
  table << entry
end

#
# Look for an element at the beginning, middle, and end of the HashTable
# Benchmark it.
#
%w(100000 500000 900000).each do |key|
  v = nil
  time = Benchmark.realtime do
    v = table[key]
  end
  if v
    puts "Finding #{key} took #{time * 1000} ms"
  else
    puts "The key #{key} was not found."
  end
end