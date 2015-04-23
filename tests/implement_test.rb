require 'test_helper'
require 'tins'

module Tins
  class ImplementTest < Test::Unit::TestCase
    require 'tins/xt/implement'

    class A
      implement :foo

      implement :bar, :subclass

      implement :baz, :submodule

      implement :qux, 'blub %{method_name} blob %{module}'

      implement :quux, 'blab'
    end

    def test_implement_default
      assert_equal(
        'method foo not implemented in module Tins::ImplementTest::A',
        error_message { A.new.foo }
      )
    end

    def test_implement_subclass
      assert_equal(
        'method bar has to be implemented in subclasses of '\
        'Tins::ImplementTest::A',
        error_message { A.new.bar }
      )
    end

    def test_implement_submodule
      assert_equal(
        'method baz has to be implemented in submodules of '\
        'Tins::ImplementTest::A',
        error_message { A.new.baz }
      )
    end

    def test_implement_custom_with_vars
      assert_equal(
        'blub qux blob Tins::ImplementTest::A',
        error_message { A.new.qux }
      )
    end

    def test_implement_custom_without_vars
      assert_equal('blab', error_message { A.new.quux })
    end

    private

    def error_message
      yield
    rescue NotImplementedError => e
      e.message
    end
  end
end
