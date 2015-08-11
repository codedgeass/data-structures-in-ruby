#
# Created by Steve Petropulos.
#
# An iterative implementation of a binary search tree.
# The nodes contain pointers to their parents. Tree rotations occur to the right.
#

class Node
  attr_accessor :data, :parent, :lchild, :rchild
  
  def initialize(data = nil, parent = nil, lchild = nil, rchild = nil)
    @data = data
    @parent = parent
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
      current_node = @root
      while current_node
        if data == current_node.data
          return current_node
        elsif data < current_node.data
          if current_node.lchild.nil?
            current_node.lchild = Node.new(data)
            current_node.lchild.parent = current_node
            return current_node.lchild
          else
            current_node = current_node.lchild
          end
        else  # data > current_node.data
          if current_node.rchild.nil?
            current_node.rchild = Node.new(data)
            current_node.rchild.parent = current_node
            return current_node.rchild
          else
            current_node = current_node.rchild
          end
        end
      end
      raise RuntimeError, 'Node insertion failed. Thus, the insert method is buggy.'
    end
  end
  
  def delete(data)
    if data == @root.data
      old_root = @root
      circumvent_root
      return old_root
    else
      parent = @root
      current_node = find_next_node(data, @root)
      while current_node
        if data == current_node.data
          circumvent_node(data, parent, current_node)
          return current_node
        else  # data < next_node.data || data > next_node.data
          parent = current_node
          current_node = find_next_node(data, current_node)
        end
      end
      return nil  # The data does not exist in the tree.
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
  
  def circumvent_root
    if @root.lchild.nil? && @root.rchild.nil?
      @root = nil
    elsif @root.lchild && @root.rchild.nil?
      @root = @root.lchild
      @root.parent = nil
    elsif @root.lchild.nil? && @root.rchild
      @root = @root.rchild
      @root.parent = nil
    elsif @root.lchild && @root.rchild
      merge_branches(@root.lchild, @root.rchild)
      @root = @root.lchild
      @root.parent = nil
    end
  end
  
  def circumvent_node(data, parent, node)
    if node.lchild.nil? && node.rchild.nil?
      set_child_reference_in_parent_to_nil(data, parent)
    elsif node.lchild && node.rchild.nil?
      set_child_reference_in_parent_to_child_of_node(data, parent, node.lchild)
      node.lchild.parent = parent
    elsif node.lchild.nil? && node.rchild
      set_child_reference_in_parent_to_child_of_node(data, parent, node.rchild)
      node.rchild.parent = parent
    elsif node.lchild && node.rchild  # Rotate tree to the right.
      set_child_reference_in_parent_to_child_of_node(data, parent, node.lchild)
      node.lchild.parent = parent
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
  
  def set_child_reference_in_parent_to_nil(data, parent)
    if data < parent.data
      parent.lchild = nil
    else  # data > parent.data
      parent.rchild = nil
    end
  end
  
  def set_child_reference_in_parent_to_child_of_node(data, parent, child)
    if data < parent.data
      parent.lchild = child
    else  # data > parent.data
      parent.rchild = child
    end
  end
  
  def merge_branches(lchild, rchild)
    largest_leaf = find_largest_leaf(lchild.rchild)
    if largest_leaf.nil?
      rchild.parent = lchild
    else
      smallest_leaf = find_smallest_leaf(rchild.lchild)
      if smallest_leaf.nil?
        largest_leaf.parent = rchild
        rchild.lchild = largest_leaf
      else
        largest_leaf.parent = smallest_leaf
        smallest_leaf.lchild = largest_leaf
      end
    end
  end
  
  def find_largest_leaf(node)
    while node && node.rchild
      node = node.rchild
    end
    return node
  end
  
  def find_smallest_leaf(node)
    while node && node.lchild
      node = node.lchild
    end
    return node
  end
end