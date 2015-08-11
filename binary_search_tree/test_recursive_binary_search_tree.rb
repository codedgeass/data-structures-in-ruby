#
# Created by Steve Petropulos.
#
# A test suite for a recursive implementation of a binary search tree.
# There are three methods to test: insert, delete, and search.
#

require 'minitest/autorun'
require_relative 'recursive_binary_search_tree'

class TestBinarySearchTree < Minitest::Test
  def setup
    @bst = BinarySearchTree.new
  end
  
  
  # Test inserting a node.
  
  def test_that_a_leaf_can_be_added
    root = @bst.insert(100)
    node = @bst.insert(80)
    assert root.lchild.equal?(node)
  end
  
  def test_that_a_redundant_node_will_not_be_added
    node = @bst.insert(100)
    assert node.equal?(@bst.insert(100))
  end
  
  # Edge case
  
  def test_that_a_root_can_be_added
    root = @bst.insert(100)
    assert root.equal?(@bst.root)
  end
  
  
  # Test deleting a node.
  
  def test_that_nothing_is_altered_if_the_node_doesnt_exist
    node = @bst.insert(100)
    @bst.delete(200)
    assert node.equal?(@bst.root)
  end
  
  def test_that_the_correct_node_is_removed
    node_added   = @bst.insert(100)
    node_removed = @bst.delete(100)
    assert node_added.equal?(node_removed)
  end
  
  def test_that_a_leaf_has_its_reference_nullified
    parent = @bst.insert(100)
    @bst.insert(200)
    @bst.delete(200)
    assert_nil parent.lchild
  end
  
  def test_when_an_inner_node_with_one_child_is_removed_it_is_replaced_by_its_childs_branch
    parent       = @bst.insert(100)
    @bst.insert(75)
    child        = @bst.insert(50)
    @bst.delete(75)
    assert parent.lchild.equal?(child)
  end
  
  def test_when_an_inner_node_with_two_children_is_removed_it_is_replaced_by_the_smaller_child
    parent        = @bst.insert(100)
    node_removed  = @bst.insert(200)
    smaller_child = @bst.insert(150)
    @bst.insert(300)
    @bst.delete(200)
    assert parent.rchild.equal?(smaller_child)
  end
  
  def test_that_branches_are_merged_when_an_inner_node_with_two_children_is_removed
    @bst.insert(100)
    @bst.insert(200)
    @bst.insert(150)
    @bst.insert(300)
    largest_leaf  = @bst.insert(175)
    smallest_leaf = @bst.insert(250)
    @bst.delete(200)
    assert smallest_leaf.lchild.equal?(largest_leaf)
  end
  
  # Edge cases
  
  def test_that_a_lone_root_can_be_removed
    @bst.insert(100)
    @bst.delete(100)
    assert_nil @bst.root
  end
  
  def test_that_a_root_can_be_replaced
    @bst.insert(100)
    node = @bst.insert(200)
    @bst.delete(100)
    assert node.equal?(@bst.root)
  end
  
  def test_that_branches_are_merged_when_a_root_with_two_children_is_removed
    @bst.insert(100)
    @bst.insert(50)
    larger_child = @bst.insert(200)
    largest_leaf = @bst.insert(75)
    @bst.delete(100)
    assert larger_child.lchild.equal?(largest_leaf)
  end
  

  # Test searching for a node.
  
  def test_that_a_non_root_node_can_be_found
    @bst.insert(100)
    node = @bst.insert(200)
    assert node.equal?(@bst.search(200))
  end
  
  def test_that_nil_is_returned_when_a_number_does_not_exist_in_the_tree
    @bst.insert(100)
    assert_nil @bst.search(200)
  end
  
  # Edge cases
  
  def test_that_a_search_returns_nil_when_the_tree_is_empty
    assert_nil @bst.search(100)
  end
  
  def test_that_the_root_can_be_found
    root = @bst.insert(100)
    assert root.equal?(@bst.search(100))
  end
end
