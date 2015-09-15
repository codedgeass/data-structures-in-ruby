#
# Created by Steve Petropulos.
#
# An RSpec test suite for an iterative implementation of a binary search tree.
# Tree rotations occur to the right.
#

require_relative 'iterative_binary_search_tree'
require_relative '../general_tests_for_any_binary_search_tree'

describe BinarySearchTree do
  include_examples 'generic binary search tree', BinarySearchTree
end