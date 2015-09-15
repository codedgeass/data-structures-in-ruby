#
# Created by Steve Petropulos
#
# An RSpec test suite for general behaviors shared by all types of binary search trees.
# It is assumed when either a left or right tree rotation will suffice, a right rotation is performed.
#

shared_examples 'generic binary search tree' do |binary_search_tree_type|
  let!(:bst) { binary_search_tree_type.new }
  
  context 'with no nodes' do
    describe '#search' do
      it 'returns nil' do
        expect(nil).to eq bst.search(100)
      end
    end
    
    describe '#insert' do
      let(:root) { bst.insert(100) }
      
      it 'adds a root' do
        expect(root).to eq bst.root
      end
    end
  end
  
  context 'with one node' do
    let!(:root) { bst.insert(100) }
    
    describe '#search' do
      context 'when targeting the root data' do
        let(:root_search) { bst.search(100) }
        
        it 'returns the root' do
          expect(root).to eq root_search
        end
      end
      
      context 'when not targeting the root data' do
        let(:nonexistant_data_search) { bst.search(200) }
        
        it 'returns nil' do
          expect(nonexistant_data_search).to eq nil
        end
      end
    end
    
    describe '#insert' do
      context 'when targeting new data' do
        let(:new_node) { bst.insert(200) }
        
        it 'appends the data to the tree' do
          expect(new_node).to eq root.rchild
        end
      end
      
      context 'when targeting existing data' do
        let(:existing_data_insertion) { bst.insert(100) }
        
        it %q(returns the node with the existing data) do
          expect(existing_data_insertion).to eq root
        end
      end
    end
    
    describe '#delete' do
      context 'when targeting the root' do
        let!(:deleted_root) { bst.delete(100) }
        
        it 'nullifies the tree' do
          expect(bst.root).to eq nil
        end
        
        it 'returns the root' do
          expect(deleted_root).to eq root
        end
      end
      
      context 'when targeting new data' do
        let!(:deleted_node) { bst.delete(200) }
        
        it 'does not alter the tree' do
          expect(bst.root).to eq root
        end
        
        it 'returns nil' do
          expect(deleted_node).to eq nil
        end
      end
    end
  end
  
  context 'with more than one node' do
    let!(:root) { bst.insert(100) }
    
    before do
      bst.insert(90)
      bst.insert(200)
    end
        
    describe '#search' do
      context 'when targeting an existing node' do
        let(:existing_node_search) { bst.search(90) }
        
        it 'returns the existing node' do
          expect(existing_node_search).to eq root.lchild
        end
      end
    end
    
    describe '#delete' do
      context 'when targeting a leaf' do
        let!(:leaf_to_delete) { bst.root.rchild }
        let!(:deleted_leaf) { bst.delete(200) }
        
        it 'nullifies the reference to the leaf' do
          expect(bst.root.rchild).to eq nil || binary_search_tree_type.sentinel
        end
        
        it 'returns the deleted leaf' do
          expect(deleted_leaf).to eq leaf_to_delete
        end
        
      end
      
      context 'when targeting the root' do
        before { bst.delete(100) }
        
        it %q(replaces the root's data with its left child's) do
          expect(bst.root.data).to eq 90
        end
      end
      
      context 'when targeting an inner node with one child' do
        let!(:child) { bst.insert(300) }
        
        before { bst.delete(200) }
        
        it %q(replaces the inner node with the child's branch) do
          expect(root.rchild).to eq child
        end
      end
      
      context 'when targeting an inner node with two leaves' do
        before do
          # Set up the subtree.
          bst.insert(150)
          bst.insert(300)
          
          bst.delete(200)
        end
        
        it %q(replaces the inner node's data with its left child's) do
          expect(root.rchild.data).to eq 150
        end
        
        it %q(removes the inner node's left child) do
          expect(root.rchild.lchild).to eq nil || binary_search_tree_type.sentinel
        end
      end
      
      context 'when targeting an inner node with many descendants' do
        before do
          # Set up the subtree.
          bst.insert(150)
          bst.insert(300)
          
          # Keep the tree balanced.
          bst.insert(80)
          bst.insert(95)
        end
        
        let!(:in_order_predecessor) { bst.insert(175) }
        let!(:deleted_node) { bst.delete(200) }
        
        it %q(replaces the inner node's data with its inorder predecessor's) do
          expect(root.rchild.data).to eq 175
        end
        
        it %q(removes the inner node's inorder predecessor) do
          expect(root.rchild.lchild.rchild).to eq nil || binary_search_tree_type.sentinel
        end
        
        it %q(returns the inner node's inorder predecessor) do
          expect(deleted_node).to eq in_order_predecessor
        end
      end
    end
  end
end
