#
# Created by Steve Petropulos.
#
# A recursive implementation of a binary search tree. 
# Tree rotations occur to the right.
#

class Node
  attr_accessor :data, :lchild, :rchild
  
  def initialize(data, lchild = nil, rchild = nil)
    @data = data
    @lchild = lchild
    @rchild = rchild
  end
end


############
# THE TREE #
############

class BinarySearchTree
  attr_accessor :root
  
  def initialize
    @root = nil
  end
  
  def insert(data)
    if @root.nil?
      @root = Node.new(data)
      return @root
    else
      return traverse_recursively_and_insert(data, @root)
    end
  end
  
  def delete(data)
    if data == @root.data
      old_root = @root
      circumvent_root
      return old_root
    else
      return traverse_recursively_and_delete( data, @root, find_next_node(data, @root) )
    end
  end
  
  def search(data)
    if @root.nil? || data == @root.data
      return @root
    else
      return traverse_recursively_and_search( data, find_next_node(data, @root) )
    end
  end
  
  
  private  ####################################################################################################
  
  def traverse_recursively_and_insert(data, current_node)
    if data == current_node.data
      return current_node
    elsif data < current_node.data
      if current_node.lchild.nil?
        current_node.lchild = Node.new(data)
        return current_node.lchild
      else
        inserted_node = traverse_recursively_and_insert(data, current_node.lchild)
      end
    else  # data > current_node.data
      if current_node.rchild.nil?
        current_node.rchild = Node.new(data)
        return current_node.rchild
      else
        inserted_node = traverse_recursively_and_insert(data, current_node.rchild)
      end
    end
    return inserted_node
  end
  
  def traverse_recursively_and_delete(data, parent, current_node)
    if current_node.nil?
      return nil  # The data does not exist in the tree.
    elsif data == current_node.data
      circumvent_node(data, parent, current_node)
      return current_node
    else  # data < next_node.data || data > next_node.data
      return traverse_recursively_and_delete( data, find_next_node(data, parent, current_node) )
    end
  end
  
  def circumvent_root
    if @root.lchild.nil? && @root.rchild.nil?
      @root = nil
    elsif @root.lchild && @root.rchild.nil?
      @root = @root.lchild
    elsif @root.lchild.nil? && @root.rchild
      @root = @root.rchild
    elsif @root.lchild && @root.rchild
      merge_branches(@root.lchild, @root.rchild)
      @root = @root.lchild
    end
  end
  
  def circumvent_node(data, parent, node)
    if node.lchild.nil? && node.rchild.nil?
      set_child_pointer_in_parent_to_nil(data, parent)
    elsif node.lchild && node.rchild.nil?
      set_child_pointer_in_parent_to_child_of_node(data, parent, node.lchild)
    elsif node.lchild.nil? && node.rchild
      set_child_pointer_in_parent_to_child_of_node(data, parent, node.rchild)
    elsif node.lchild && node.rchild  # Rotate tree to the right.
      set_child_pointer_in_parent_to_child_of_node(data, parent, node.lchild)
      merge_branches(node.lchild, node.rchild)
    end
  end
  
  def find_next_node(data, node)
    if data < node.data
      return node.lchild
    else  # data > node.data
      return node.rchild
    end
  end
  
  def set_child_pointer_in_parent_to_nil(data, parent)
    if data < parent.data
      parent.lchild = nil
    else  # data > parent.data
      parent.rchild = nil
    end
  end
  
  def set_child_pointer_in_parent_to_child_of_node(data, parent, child)
    if data < parent.data
      parent.lchild = child
    else  # data > parent.data
      parent.rchild = child
    end
  end
  
  def merge_branches(lchild, rchild)
    largest_leaf = find_largest_leaf(lchild)
    if largest_leaf.equal?(lchild)
      return
    else
      smallest_leaf = find_smallest_leaf(rchild)
      if smallest_leaf.equal?(rchild)
        rchild.lchild = largest_leaf
      else
        smallest_leaf.lchild = largest_leaf
      end
    end
  end
  
  def find_largest_leaf(node)
    return node if node.rchild.nil?
    find_largest_leaf(node.rchild)
  end
  
  def find_smallest_leaf(node)
    return node if node.lchild.nil?
    find_smallest_leaf(node.lchild)
  end
  
  def traverse_recursively_and_search(data, current_node)
    if current_node.nil?
      return nil  # The data does not exist in the tree.
    elsif data == current_node.data
      return current_node
    else
      traverse_recursively_and_search( data, find_next_node(data, current_node) )
    end
  end
end