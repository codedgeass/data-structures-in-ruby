#
# Created by Steve Petropulos.
#
# An iterative implementation of a binary search tree.
# Tree rotations occur to the right.
#

class Node
  attr_accessor :data, :lchild, :rchild
  
  def initialize(data = nil, lchild = nil, rchild = nil)
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
      return traverse_iteratively_and_insert(data, @root)
    end
  end
  
  def delete(data)
    if data == @root.data
      return circumvent_root
    else
      return traverse_iteratively_and_delete( data, @root, find_next_node(data, @root) )
    end
  end
  
  def search(data)
    current_node = @root
    while current_node != nil
      return current_node if data == current_node.data
      current_node = find_next_node(data, current_node)
    end
    return nil  # The data does not exist in the tree.
  end
  
  
  private  ####################################################################################################
  
  def traverse_iteratively_and_insert(data, current_node)
    while current_node
      if data == current_node.data
        return current_node  # The data already exists.
      elsif data < current_node.data
        if current_node.lchild.nil?
          current_node.lchild = Node.new(data)
          return current_node.lchild
        else
          current_node = current_node.lchild
        end
      else  # data > current_node.data
        if current_node.rchild.nil?
          current_node.rchild = Node.new(data)
          return current_node.rchild
        else
          current_node = current_node.rchild
        end
      end
    end
    raise RuntimeError, 'Node insertion failed. Thus, the insert method is buggy.'
  end
  
  def circumvent_root
    if @root.lchild.nil? && @root.rchild.nil?
      deleted_node = @root
      @root = nil
    elsif @root.lchild && @root.rchild.nil?
      deleted_node = @root
      @root = @root.lchild
    elsif @root.lchild.nil? && @root.rchild
      deleted_node = @root
      @root = @root.rchild
    elsif @root.lchild && @root.rchild
      @root.data = find_largest_leaf(@root.lchild).data
      deleted_node = traverse_iteratively_and_delete(@root.data, @root, @root.lchild)
    end
    deleted_node
  end
  
  def circumvent_node(data, parent, node)
    if node.lchild.nil? && node.rchild.nil?
      set_child_pointer_to_nil(data, parent)
    elsif node.lchild && node.rchild.nil?
      set_child_pointer_to_grandchild(data, parent, node.lchild)
    elsif node.lchild.nil? && node.rchild
      set_child_pointer_to_grandchild(data, parent, node.rchild)
    elsif node.lchild && node.rchild  # Rotate tree to the right.
      node.data = find_largest_leaf(node.lchild).data
      node = traverse_iteratively_and_delete(node.data, node, node.lchild)
    end
    node
  end
  
  def traverse_iteratively_and_delete(data, parent, current_node)
    while current_node
      if data == current_node.data
        return circumvent_node(data, parent, current_node)
      end
      parent = current_node
      current_node = find_next_node(data, current_node)
    end
    return nil  # The data does not exist in the tree.
  end
  
  def find_next_node(data, node)
    if data < node.data
      return node.lchild
    else  # data > node.data
      return node.rchild
    end
  end
  
  def find_largest_leaf(node)
    while node && node.rchild
      node = node.rchild
    end
    return node
  end
  
  def set_child_pointer_to_nil(data, node)
    if data < node.data
      node.lchild = nil
    else  # data > node.data
      node.rchild = nil
    end
  end
  
  def set_child_pointer_to_grandchild(data, node, grandchild)
    if data < node.data
      node.lchild = grandchild
    else  # data > node.data
      node.rchild = grandchild
    end
  end
end