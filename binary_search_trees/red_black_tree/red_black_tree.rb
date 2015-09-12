#
# Created by Steve Petropulos.
#
# A recursive implementation of a red-black tree.
# It is assumed when either a left or right tree rotation will suffice, a right rotation is performed.
# A sentinel node is used to serve as the leaf for every branch in the tree.
#

require 'singleton'

class Sentinel
  include Singleton
  attr_reader :data, :color
  
  def initialize
    @color = 0
  end
  
  def is_sentinel?
    true
  end
end

class Node
  attr_accessor :data, :color, :parent, :lchild, :rchild
  
  def initialize(data = nil, color = 1)
    @data   = data
    @color  = color
    @parent = nil
    @lchild = RedBlackTree.sentinel
    @rchild = RedBlackTree.sentinel
  end
  
  def is_sentinel?
    false
  end
  
  def get_sibling(node)
    parent = node.parent
    if parent.lchild.equal?(node)
      parent.rchild
    else
      parent.lchild
    end
  end
end

class RedBlackTree 
  @@sentinel = Sentinel.instance
  
  attr_accessor :root
  
  def self.sentinel
    @@sentinel
  end
   
  def initialize
    @root = nil
  end
  
  def search(data)
    return nil if @root.nil?
    node = find_node_with_data_or_final_position(data, @root)
    data == node.data ? node : nil  # nil indicates the data does not exist in the tree.
  end
  
  def insert(data)
    if @root.nil?
      @root = Node.new(data, 0)
      @root
    else
      current_node = find_node_with_data_or_final_position(data, @root)
      return current_node if data == current_node.data  # The data already exists in the tree.
      appended_node = append_data_to_tree(data, current_node)
      enforce_color_constraints_after_insertion(appended_node)
      appended_node
    end
  end
  
  def delete(data)
    if data == @root.data
      old_root = @root
      circumvent_root
      return old_root
    else
      next_node = find_next_node(data, @root)
      return nil if next_node.is_sentinel?  # The data does not exist in the tree.
      node_with_data = find_node_with_data_or_final_position(data, next_node)
      return nil if node_with_data.data != data
      return circumvent_node(data, node_with_data)
    end
  end
  
  private  ####################################################################################################
  
  def find_node_with_data_or_final_position(data, current_node)
    if data == current_node.data
      current_node
    elsif data < current_node.data
      if current_node.lchild.is_sentinel?  # If the child is the sentinel, the data doesn't exist in the tree.
        current_node
      else
        find_node_with_data_or_final_position(data, current_node.lchild)
      end
    else  # data > current_node.data
      if current_node.rchild.is_sentinel?  # If the child is the sentinel, the data doesn't exist in the tree.
        current_node
      else
        find_node_with_data_or_final_position(data, current_node.rchild)
      end
    end
  end
  
  def append_data_to_tree(data, current_node)
    new_node        = Node.new(data)
    new_node.parent = current_node
    adopt_child(current_node, new_node)
    new_node
  end
  
  def adopt_child(parent, child)
    if child.data < parent.data
      parent.lchild = child
    else  # child.data > parent.data
      parent.rchild = child
    end
    child.parent = parent
  end
  
  def enforce_color_constraints_after_insertion(current_node)
    if current_node.parent.color == 1
      parent      = current_node.parent
      grandparent = current_node.parent.parent
      uncle       = find_uncle(parent)
      if uncle.color == 1
        parent.color = 0
        uncle.color  = 0
        if !grandparent.equal?(@root)
          grandparent.color = 1
          enforce_color_constraints_after_insertion(grandparent)
        end
      else  # uncle.color == 0
        if current_node.data < grandparent.data
          prep_and_execute_right_rotation(current_node, parent, grandparent)
        elsif current_node.data > grandparent.data
          prep_and_execute_left_rotation(current_node, parent, grandparent)
        end
        @root = parent if grandparent.equal?(@root)
      end
    end
  end
  
  def find_uncle(parent)
    if parent.equal?(parent.parent.lchild)
      parent.parent.rchild
    else
      parent.parent.lchild
    end
  end
  
  def prep_and_execute_left_rotation(current_node, parent, grandparent)
    if current_node.equal?(parent.lchild)
      current_node.parent = grandparent
      current_node.rchild = parent
      parent.parent       = current_node
      parent.rchild       = @@sentinel
      parent.lchild       = @@sentinel
      grandparent.rchild  = current_node
      rotate_left(current_node, grandparent, grandparent.parent)
      current_node.color = 0
      grandparent.color  = 1
    elsif current_node.equal?(parent.rchild)
      rotate_left(parent, grandparent, grandparent.parent)
      parent.color      = 0
      grandparent.color = 1
    end
  end
  
  def rotate_left(node, parent, grandparent) # TODO: Make this so parent is the node.
    adopt_child(grandparent, node) if grandparent
    parent.parent = node
    parent.lchild ||= @@sentinel
    parent.rchild = node.lchild || @@sentinel
    node.lchild  = parent
    node.parent  = grandparent
  end
  
  def prep_and_execute_right_rotation(current_node, parent, grandparent)
    if current_node.equal?(parent.rchild)
      current_node.parent = grandparent
      current_node.lchild = parent
      parent.parent       = current_node
      parent.rchild       = @@sentinel
      parent.lchild       = @@sentinel
      grandparent.lchild  = current_node
      rotate_right(current_node, grandparent, grandparent.parent)
      current_node.color = 0
      grandparent.color  = 1
    elsif current_node.equal?(parent.lchild)
      rotate_right(parent, grandparent, grandparent.parent)
      parent.color      = 0
      grandparent.color = 1
    end
  end
  
  def rotate_right(node, parent, grandparent)  # TODO: Make this so parent is the node.
    adopt_child(grandparent, node) if grandparent
    parent.parent = node
    parent.rchild ||= @@sentinel
    parent.lchild = node.rchild || @@sentinel
    node.rchild   = parent
    node.parent   = grandparent
  end
  
  def find_next_node(data, node)
    if data < node.data
      return node.lchild
    else  # data > node.data
      return node.rchild
    end
  end
  
  def circumvent_root
    if @root.lchild.is_sentinel? && @root.rchild.is_sentinel?
      @root = nil
    elsif @root.lchild.data && @root.rchild.is_sentinel?
      @root = @root.lchild
      @root.color = 0
    elsif @root.lchild.is_sentinel? && @root.rchild.data
      @root = @root.rchild
      @root.color = 0
    elsif @root.lchild.data && @root.rchild.data
      @root.data = find_largest_leaf(@root.lchild).data
      node_to_be_deleted = find_node_with_data_or_final_position(@root.data, @root.lchild)
      circumvent_node(@root.data, node_to_be_deleted)
    end
  end
  
  def circumvent_node(data, node)
    if node.lchild.is_sentinel? && node.rchild.is_sentinel?
      set_child_pointer_in_parent_to_sentinel(node)
      # Equal means the node's data was copied to its parent and is being deleted.
      direction = data <= node.parent.data ? 'left' : 'right'
      enforce_color_constraints_after_deletion_case1(node.parent, direction) if node.color == 0
    elsif !node.lchild.is_sentinel? && node.rchild.is_sentinel?
      # It can be presumed that the node is black and its child red due to the properties of a red-black tree.
      adopt_child(node.parent, node.lchild)
      node.lchild.color = 0
    elsif node.lchild.is_sentinel? && !node.rchild.is_sentinel?
      # It can be presumed that the node is black and its child red due to the properties of a red-black tree.
      adopt_child(node.parent, node.rchild)
      node.rchild.color = 0
    elsif !node.lchild.is_sentinel? && !node.rchild.is_sentinel?
      node.data = find_largest_leaf(node.lchild).data
      node_to_be_deleted = find_node_with_data_or_final_position(node.data, node.lchild)
      node = circumvent_node(node.data, node_to_be_deleted)
    end
    node
  end
  
  def find_largest_leaf(node)
    return node if node.rchild.is_sentinel?
    find_largest_leaf(node.rchild)
  end
  
  def set_child_pointer_in_parent_to_sentinel(node)
    if node.data <= node.parent.data  # Equal means the node's data was copied to its parent and should be deleted.
      node.parent.lchild = @@sentinel
    else  # node.data > node.parent.data
      node.parent.rchild = @@sentinel
    end
  end
  
  def enforce_color_constraints_after_deletion_case1(node, direction)
    if node.color == 0 && node.lchild.color == 1 && direction == 'right'
      node.lchild.color = 0
      node.color        = 1
      rotate_right(node.lchild, node, node.parent)
    elsif node.color == 0 && node.rchild.color == 1 && direction == 'left'
      node.rchild.color = 0
      node.color        = 1
      rotate_left(node.rchild, node, node.parent)
    end
    enforce_color_constraints_after_deletion_case2(node, direction)
  end
  
  def enforce_color_constraints_after_deletion_case2(node, direction)
    if node.color == 0 && node.rchild.color == 0 && direction == 'left' && node.rchild.rchild.color == 0 && node.rchild.lchild.color == 0
      node.rchild.color = 1
      if !node.equal?(@root)
        direction = node.data <= node.parent.data ? 'left' : 'right'
        enforce_color_constraints_after_deletion_case1(node.parent, direction)
      end
    elsif node.color == 0 && node.lchild.color == 0 && direction == 'right' && node.lchild.lchild.color == 0 && node.lchild.rchild.color == 0
      node.lchild.color = 1
      if !node.equal?(@root)
        direction = node.data <= node.parent.data ? 'left' : 'right'
        enforce_color_constraints_after_deletion_case1(node.parent, direction)
      end
    else
      enforce_color_constraints_after_deletion_case3(node, direction)
    end
  end
  
  def enforce_color_constraints_after_deletion_case3(node, direction)
    if node.color == 1 && node.rchild.color == 0 && direction == 'left' && node.rchild.rchild.color == 0 && node.rchild.lchild.color == 0  # FIXME Do we need to check if rchild is a sentinel?
      node.color = 0
      node.rchild.color = 1
    elsif node.color == 1 && node.lchild.color == 0 && direction == 'right' && node.lchild.lchild.color == 0 && node.lchild.rchild.color == 0
      node.color = 0
      node.lchild.color = 1
    else
      enforce_color_constraints_after_deletion_case4(node, direction)
    end
  end
  
  def enforce_color_constraints_after_deletion_case4(node, direction)
    if node.lchild.color == 0 && !node.lchild.is_sentinel? && node.lchild.rchild.color == 1 && node.lchild.lchild.color == 0 && direction == 'right'
      node.lchild.color = 1
      node.lchild.rchild.color = 0
      rotate_left(node.lchild.rchild, node.lchild, node)
    elsif node.rchild.color == 0 && !node.rchild.is_sentinel? && node.rchild.lchild.color == 1 && node.rchild.rchild.color == 0 && direction == 'left'
      node.rchild.color = 1
      node.rchild.lchild.color = 0
      rotate_right(node.rchild.lchild, node.rchild, node)
    end
    enforce_color_constraints_after_deletion_case5(node, direction)
  end
  
  def enforce_color_constraints_after_deletion_case5(node, direction)
    if node.lchild.color == 0 && !node.lchild.is_sentinel? && node.lchild.lchild.color == 1 && direction == 'right'
      node.lchild.lchild.color = 0
      node.lchild.color = node.color
      node.color = 0
      rotate_right(node.lchild, node, node.parent)
    elsif node.rchild.color == 0 && !node.rchild.is_sentinel? && node.rchild.rchild.color == 1 && direction == 'left'
      node.rchild.rchild.color = 0
      node.rchild.color = node.color
      node.color = 0
      rotate_left(node.rchild, node, node.parent)
    end
  end
end
