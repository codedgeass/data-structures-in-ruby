#
# Created by Steve Petropulos.
#
# A queue requires enqueue, dequeue, peek, and size methods.
#

class Queue
  def initialize
    @queue = Array.new
  end
  
  def enqueue(element)
    @queue.push(element)
    self
  end
  
  def dequeue
    @queue.shift
  end
  
  def peek
    @queue.first
  end
  
  def size
    @queue.size
  end
end

queue = Queue.new
queue.enqueue(1)
queue.enqueue(2)
queue.enqueue(3)
puts "Peek at the queue: #{queue.peek}"
puts "Dequeue: #{queue.dequeue}"
puts "Peek at the queue: #{queue.peek}"
puts "Size of the queue: #{queue.size}"
puts "Dequeue: #{queue.dequeue}"
puts "Size of the queue: #{queue.size}"