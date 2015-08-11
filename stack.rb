# From a stack we need push, pop, peek, and size methods.

class Stack
  def initialize
    @stack = Array.new
  end
  
  def push(element)
    @stack.push(element)
    self
  end
  
  def pop
    @stack.pop
  end
  
  def peek
    @stack.last
  end
  
  def size
    @stack.size
  end
end

stack = Stack.new
stack.push(1)
stack.push(2)
stack.push(3)
puts "Peek at the top of the stack: #{stack.peek}"
puts "Pop the top of the stack: #{stack.pop}"
puts "Peek at the top of the stack: #{stack.peek}"
puts "The current stack size: #{stack.size}"