# typed: strict
# frozen_string_literal: true

require "rubocop"
require "sorbet-runtime"

module RuboCop
  module Cop
    module Quality
      class NoInlineClass < RuboCop::Cop::Base
        extend T::Sig

        EntityNode = T.type_alias { T.any(RuboCop::AST::ClassNode, RuboCop::AST::ModuleNode) }
        MSG = "Inline class/module definitions are forbidden. Extract '%<name>s' to its own file."

        sig { params(node: RuboCop::AST::ClassNode).void }
        def on_class(node)
          check(node)
        end

        sig { params(node: RuboCop::AST::ModuleNode).void }
        def on_module(node)
          check(node)
        end

        private

        sig { params(node: EntityNode).void }
        def check(node)
          ancestor = enclosing_entity(node)
          return unless ancestor
          return if pure_wrapper_chain?(ancestor, node)

          add_offense(node, message: format(MSG, name: node.identifier.const_name))
        end

        sig { params(node: EntityNode).returns(T.nilable(EntityNode)) }
        def enclosing_entity(node)
          node.each_ancestor(:class, :module).first
        end

        sig { params(ancestor: EntityNode, node: EntityNode).returns(T::Boolean) }
        def pure_wrapper_chain?(ancestor, node)
          return false unless ancestor.body.equal?(node)

          parent = enclosing_entity(ancestor)
          return true unless parent

          pure_wrapper_chain?(parent, ancestor)
        end
      end
    end
  end
end
