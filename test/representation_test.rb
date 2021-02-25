require "test_helper"

class RepresentationTest < Minitest::Test
  def test_basic_representation
    code = '
      class TwoFer
        def two_fer
          "foo"
        end
      end
    '
    representation = Representation.new(code)
    representation.normalize!

    mapping = {
      "TwoFer" => "PLACEHOLDER_0",
      "two_fer" => "placeholder_1"
    }
    assert_equal mapping, representation.mapping

    ast = '(class  (const nil :PLACEHOLDER_0) nil  (def :placeholder_1    (args)    (str "foo")))'
    assert_equal ast, representation.ast
  end

  def test_lasagna
    code = '
      class Lasagna
        EXPECTED_MINUTES_IN_OVEN = 40
        PREPARATION_MINUTES_PER_LAYER = 2

        def remaining_minutes_in_oven(actual_minutes_in_oven)
          EXPECTED_MINUTES_IN_OVEN - actual_minutes_in_oven
        end

        def preparation_time_in_minutes(layers)
          layers * PREPARATION_MINUTES_PER_LAYER
        end

        def total_time_in_minutes(number_of_layers:, actual_minutes_in_oven:)
          preparation_time_in_minutes(number_of_layers) + actual_minutes_in_oven
        end
      end
    '
    representation = Representation.new(code)
    representation.normalize!

    mapping = {
      "Lasagna" => "PLACEHOLDER_0", "remaining_minutes_in_oven" => "placeholder_1", "actual_minutes_in_oven" => "placeholder_2", "preparation_time_in_minutes" => "placeholder_3", "layers" => "placeholder_4", "total_time_in_minutes" => "placeholder_5", "number_of_layers:" => "placeholder_6", "actual_minutes_in_oven:" => "placeholder_7"
    }
    assert_equal mapping, representation.mapping

    ast = '(class  (const nil :PLACEHOLDER_0) nil  (begin    (casgn nil :EXPECTED_MINUTES_IN_OVEN      (int 40))    (casgn nil :PREPARATION_MINUTES_PER_LAYER      (int 2))    (def :placeholder_1      (args        (arg :placeholder_2))      (send        (const nil :EXPECTED_MINUTES_IN_OVEN) :-        (lvar :placeholder_2)))    (def :placeholder_3      (args        (arg :placeholder_4))      (send        (lvar :placeholder_4) :*        (const nil :PREPARATION_MINUTES_PER_LAYER)))    (def :placeholder_5      (args        (kwarg :number_of_layers)        (kwarg :placeholder_2))      (send        (send nil :placeholder_3          (lvar :number_of_layers)) :+        (lvar :placeholder_2)))))'
    assert_equal ast, representation.ast
  end
end
