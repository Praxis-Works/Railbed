# typed: strict
# frozen_string_literal: true

require "rubocop"
require "sorbet-runtime"

module RuboCop
  module Cop
    module Quality
      class PreferBarewordReaders < RuboCop::Cop::Base
        extend T::Sig

        MSG = "Use the `%<reader>s` reader instead of reading `%<ivar>s` directly."

        sig { params(node: RuboCop::AST::Node).void }
        def on_ivar(node)
          return unless node.each_ancestor(:class, :module, :sclass).first

          reader = node.children.fetch(0).to_s.delete_prefix("@").to_sym
          return if inside_reader?(node, reader)

          add_offense(node, message: format(MSG, reader: reader, ivar: node.source))
        end

        private

        sig { params(node: RuboCop::AST::Node, reader: Symbol).returns(T::Boolean) }
        def inside_reader?(node, reader)
          method = node.each_ancestor(:def, :defs).first
          return false unless method

          T.cast(method, RuboCop::AST::DefNode).method_name == reader
        end
      end
    end
  end
end
