#
# Created by Steve Petropulos.
#
# An Rspec test suite for a red-black tree.
# It is assumed when either a left or right tree rotation will suffice, a right rotation is performed.
# A sentinel node is used to serve as the leaf for every branch in the tree.
#

require_relative 'red_black_tree'
require_relative '../general_tests_for_any_binary_search_tree'

describe Node, '.new' do
  let(:node) { Node.new }
  let(:sentinel) { RedBlackTree.sentinel }
  
  it 'makes the node red' do
    expect(node.color).to eq 1
  end
  
  it  %q(makes the node's children point to the sentinel) do
    expect(node.lchild).to eq sentinel
    expect(node.rchild).to eq sentinel
  end
end

describe RedBlackTree do
  include_examples 'generic binary search tree', RedBlackTree
  
  let!(:rbt) { RedBlackTree.new }
  
  let(:sentinel) { RedBlackTree.sentinel }
    
  describe '#insert' do
    let!(:root) { rbt.insert(100) }
    
    it 'makes the root black' do
      expect(rbt.root.color).to eq 0
    end
    
    context %q(when the inserted node's parent and uncle are red) do
      let!(:parent) { rbt.insert(200) }
      let!(:uncle) { rbt.insert(90) }
      let!(:inserted_node) { rbt.insert(300) }
      
      context %q(when the inserted node's grandparent is the root) do
        it 'makes the parent black' do
          expect(parent.color).to eq 0
        end
        
        it 'makes the uncle black' do
          expect(uncle.color).to eq 0
        end
        
        it 'keeps the grandparent black' do
          expect(uncle.parent.color).to eq 0
        end
      end
      
      context %q(when the inserted node's grandparent is not the root) do
        before do
          # Keep the tree balanced. 
          rbt.insert(80)
          rbt.insert(95)
        end
        
        let!(:current_uncle) { rbt.insert(150) }
        let!(:current_parent) { inserted_node }
        
        before { rbt.insert(400) }
        
        it 'makes the parent black' do
          expect(current_parent.color).to eq 0
        end
        
        it 'makes the uncle black' do
          expect(current_uncle.color).to eq 0
        end
        
        it 'makes the grandparent red' do
          expect(current_parent.parent.color).to eq 1
        end
      end
    end
    
    context 'when creating an outer left grandchild' do
      context %q(when the grandchild's parent is red and uncle is black) do
        let!(:root) { rbt.insert(100) }
        let!(:node) { rbt.insert(90) }
        before { rbt.insert(80) }
      
        it 'performs a right rotation' do
          expect(rbt.root).to eq node
          expect(node.rchild).to eq root
        end
      end
    end
    
    context 'when creating an outer right grandchild ' do
      context %q(when the grandchild's parent is red and uncle is black) do
        let!(:root) { rbt.insert(100) }
        let!(:node) { rbt.insert(200) }
        before { rbt.insert(300) }
      
        it 'performs a left rotation' do
          expect(rbt.root).to eq node
          expect(node.lchild).to eq root
        end
      end
    end
    
    context 'when creating an inner left grandchild' do
      context %q(when the grandchild's parent is red and uncle is black) do
          let!(:parent) { rbt.insert(90) }
          let!(:child) { rbt.insert(95) }
      
          it %q(moves the grandchild into its parent's position) do
            expect(parent.parent).to eq child
             expect(child.lchild).to eq parent
          end
      
          it %q(makes the grandchild's parent a leaf) do
            expect(parent.lchild).to eq sentinel
            expect(parent.rchild).to eq sentinel
          end
      
          it 'performs a right rotation on the child' do
            expect(child.rchild).to eq root
            expect(root.parent).to eq child
          end
      
          it 'makes the root a leaf' do
            expect(root.lchild).to eq sentinel
            expect(root.rchild).to eq sentinel
          end
      
          it 'makes the new root black' do
            expect(child.color).to eq 0
          end
      
          it %q(makes the grandchild's new children red) do
            expect(parent.color).to eq 1
            expect(root.color).to eq 1
          end
        end
      end
    
    context 'when creating an inner right grandchild' do
      context %q(when the grandchild's parent is red and uncle is black) do
        let!(:parent) { rbt.insert(200) }
        let!(:child) { rbt.insert(150) }
      
        it %q(moves the grandchild into its parent's position) do
          expect(parent.parent).to eq child
           expect(child.rchild).to eq parent
        end
      
        it %q(makes the grandchild's parent a leaf) do
          expect(parent.lchild).to eq sentinel
          expect(parent.rchild).to eq sentinel
        end
      
        it 'performs a left rotation on the child' do
          expect(child.lchild).to eq root
          expect(root.parent).to eq child
        end
      
        it 'makes the root a leaf' do
          expect(root.lchild).to eq sentinel
          expect(root.rchild).to eq sentinel
        end
      
        it 'makes the new root black' do
          expect(child.color).to eq 0
        end
      
        it %q(makes the grandchild's new children red) do
          expect(parent.color).to eq 1
          expect(root.color).to eq 1
        end
      end
    end
  end
  
  describe '#delete' do
    let!(:root) { rbt.insert(100) }
    
    before { rbt.insert(200) }
    
    context 'targeting a root with one child' do
      let!(:deleted_root) { rbt.delete(100) }
      
      it 'makes the new root black' do
        expect(rbt.root.color).to eq 0
      end
    end
    
    context 'targeting a red leaf' do
      before { rbt.delete(200) }
      
      it 'removes the leaf' do
        expect(rbt.root.rchild).to eq sentinel
      end
    end
    
    context 'targeting a black leaf' do
      context 'when its the left child of its parent' do
        before do
          # Keep the tree balanced.
          rbt.insert(90)
          rbt.insert(80)
          rbt.insert(95)
        end
      
        # Set up the subtree.
        let!(:node_to_delete) { rbt.insert(150) }
        let!(:sibling) { rbt.insert(300) }
      
        let(:parent) { root.rchild }
      
        # This also tests the case of a deleted node with a red parent and black sibling since this case converts
        # its formation into the former case and then recursively enforces the color constraints again.
        context 'with a black parent and red sibling with two black children' do
          let!(:sibling_lchild) { rbt.insert(250) }
          let!(:sibling_rchild) { rbt.insert(400) }
        
          before do
            # Set up the nodes' colors.
            parent.color         = 0
            node_to_delete.color = 0
            sibling.color        = 1
            sibling_lchild.color = 0
            sibling_rchild.color = 0
          end
        
          let!(:deleted_node) { rbt.delete(150) }
        
         it %q(moves the sibling into the parent's position) do
           expect(root.rchild).to eq sibling
         end
       
         it %q(makes the sibling's left child the parent's right child) do
           expect(parent.rchild).to eq sibling_lchild
         end
       
         it 'makes the sibling black' do
           expect(sibling.color).to eq 0
         end
       
         it 'keeps the parent black' do
           expect(parent.color).to eq 0
         end
       
         it %q(makes the sibling's left child red) do
           expect(sibling_lchild.color).to eq 1
         end
        end
    
        context 'with a black parent and black sibling' do
          before do
            # Set up the nodes' colors.
            parent.color             = 0
            node_to_delete.color     = 0
            sibling.color            = 0
            root.lchild.lchild.color = 0
            root.lchild.rchild.color = 0
          end
        
          let!(:deleted_node) { rbt.delete(150) }

          it 'makes the sibling red' do
            expect(sibling.color).to eq 1
          end
          
          it 'makes the uncle red' do
            expect(root.lchild.color).to eq 1
          end
        end
      
        # This also tests the case of a deleted node with a black sibling that has one red child since this case 
        # converts its formation into the former case and then enforces the color constraints on that case.
        context 'with a black sibling having one red child' do
          # Set up the subtree.
          let!(:sibling_lchild) { rbt.insert(250) }
          
          before do
            # Set up the nodes' colors.
            parent.color         = 0
            node_to_delete.color = 0
            sibling.color        = 0
            sibling_lchild.color = 1
          end
        
          let!(:deleted_node) { rbt.delete(150) }
     
          it %q(makes the sibling's child the new subtree root) do
            expect(sibling_lchild.parent).to eq root
            expect(sibling_lchild.lchild).to eq parent
            expect(sibling_lchild.rchild).to eq sibling
            expect(parent.parent).to eq sibling_lchild
            expect(sibling.parent).to eq sibling_lchild
          end
          
          it 'makes the parent black' do
            expect(parent.color).to eq 0
          end
          
          it 'makes the sibling black' do
            expect(sibling.color).to eq 0
          end
          
          it 'makes the subtree root keep the same color as the old one' do
            expect(sibling_lchild.color).to eq 0
          end
        end
      end

      context 'when its the right child of its parent' do
        before do
          # Keep the tree balanced.
          rbt.insert(90)
          rbt.insert(80)
          rbt.insert(95)
        end
      
        # Set up the subtree.
        let!(:sibling) { rbt.insert(150) }
        let!(:node_to_delete) { rbt.insert(300) }
      
        let(:parent) { root.rchild }
      
        # This also tests the case of a deleted node with a red parent and black sibling since this case converts
        # its formation into the former case and then works on that.
        context 'with a black parent and red sibling with two black children' do
          let!(:sibling_lchild) { rbt.insert(125) }
          let!(:sibling_rchild) { rbt.insert(175) }
        
          before do
            # Set up the nodes' colors.
            parent.color         = 0
            node_to_delete.color = 0
            sibling.color        = 1
            sibling_lchild.color = 0
            sibling_rchild.color = 0
          end
        
          let!(:deleted_node) { rbt.delete(300) }
        
         it %q(moves the sibling into the parent's position) do
           expect(root.rchild).to eq sibling
         end
       
         it %q(makes the sibling's right child the parent's left child) do
           expect(parent.lchild).to eq sibling_rchild
         end
       
         it 'makes the sibling black' do
           expect(sibling.color).to eq 0
         end
       
         it 'keeps the parent black' do
           expect(parent.color).to eq 0
         end
       
         it %q(makes the sibling's right child red) do
           expect(sibling_rchild.color).to eq 1
         end
        end
    
        context 'with a black parent and black sibling' do
          before do
            # Set up the nodes' colors.
            parent.color         = 0
            node_to_delete.color = 0
            sibling.color        = 0
          end
        
          let!(:deleted_node) { rbt.delete(300) }

          it 'makes the sibling red' do
            expect(sibling.color).to eq 1
          end
          
          it 'makes the uncle red' do
            expect(root.lchild.color).to eq 1
          end
        end
      
        # This also tests the case of a deleted node with a black sibling that has one red child since this case 
        # converts its formation into the former case and then works on that.
        context 'with a black sibling having one red child' do
          # Set up the subtree.
          let!(:sibling_rchild) { rbt.insert(175) }
          
          before do
            # Set up the nodes' colors.
            parent.color         = 0
            node_to_delete.color = 0
            sibling.color        = 0
            sibling_rchild.color = 1
          end
        
          let!(:deleted_node) { rbt.delete(300) }
     
          it %q(makes the sibling's child the new subtree root) do
            expect(sibling_rchild.parent).to eq root
            expect(sibling_rchild.lchild).to eq sibling
            expect(sibling_rchild.rchild).to eq parent
            expect(parent.parent).to eq sibling_rchild
            expect(sibling.parent).to eq sibling_rchild
          end
          
          it 'makes the parent black' do
            expect(parent.color).to eq 0
          end
          
          it 'makes the sibling black' do
            expect(sibling.color).to eq 0
          end
          
          it 'makes the subtree root has the same color as the old one' do
            expect(sibling_rchild.color).to eq 0
          end
        end
      end
    end
  end
end
