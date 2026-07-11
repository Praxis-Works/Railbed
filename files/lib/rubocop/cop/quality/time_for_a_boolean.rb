# typed: strict
# frozen_string_literal: true

require "rubocop"
require "sorbet-runtime"

module RuboCop
  module Cop
    module Quality
      class TimeForABoolean < RuboCop::Cop::Base
        extend T::Sig

        MSG = "Use a timestamp column and `time_for_a_boolean` instead of a boolean column."
        TYPE_ARGUMENT = T.let(
          { add_column: 2, change: 1, change_column: 2, column: 1 }.freeze,
          T::Hash[Symbol, Integer]
        )

        sig { params(node: RuboCop::AST::SendNode).void }
        def on_send(node)
          add_offense(node) if node.method?(:boolean) || boolean_column?(node)
        end

        private

        sig { params(node: RuboCop::AST::SendNode).returns(T::Boolean) }
        def boolean_column?(node)
          type_argument = TYPE_ARGUMENT[node.method_name]
          return false unless type_argument

          node.arguments[type_argument]&.value == :boolean
        end
      end
    end
  end
end
