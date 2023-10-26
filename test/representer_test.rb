require "test_helper"

class RepresenterTest < Minitest::Test
  def test_that_it_converts_to_path_and_runs
    slug = mock
    solution_path = mock
    solution_pathname = mock
    output_path = mock
    output_pathname = mock
    Pathname.expects(:new).with(solution_path).returns(solution_pathname)
    Pathname.expects(:new).with(output_path).returns(output_pathname)

    RepresentSolution.expects(:call).with(slug, solution_pathname, output_pathname)
    Representer.generate(slug, solution_path, output_path)
  end

  def test_e2e
    Dir.mktmpdir("code") do |dir|
      Dir.mkdir("#{dir}/.meta")
      File.write("#{dir}/.meta/config.json", { files: { solution: ['lasagna.rb'] } }.to_json)

      File.write("#{dir}/lasagna.rb", '
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
      ')
      Representer.generate('lasagna', dir, dir)

      mapping = {
        "Lasagna" => "PLACEHOLDER_0", "remaining_minutes_in_oven" => "placeholder_1", "actual_minutes_in_oven" => "placeholder_2", "preparation_time_in_minutes" => "placeholder_3", "layers" => "placeholder_4", "total_time_in_minutes" => "placeholder_5", "number_of_layers:" => "placeholder_6", "actual_minutes_in_oven:" => "placeholder_7"
      }.to_json
      assert_equal mapping, File.read("#{dir}/mapping.json")

      ast = '(class  (const nil :PLACEHOLDER_0) nil  (begin    (casgn nil :EXPECTED_MINUTES_IN_OVEN      (int 40))    (casgn nil :PREPARATION_MINUTES_PER_LAYER      (int 2))    (def :placeholder_1      (args        (arg :placeholder_2))      (send        (const nil :EXPECTED_MINUTES_IN_OVEN) :-        (lvar :placeholder_2)))    (def :placeholder_3      (args        (arg :placeholder_4))      (send        (lvar :placeholder_4) :*        (const nil :PREPARATION_MINUTES_PER_LAYER)))    (def :placeholder_5      (args        (kwarg :number_of_layers)        (kwarg :placeholder_2))      (send        (send nil :placeholder_3          (lvar :number_of_layers)) :+        (lvar :placeholder_2)))))'
      assert_equal ast, File.read("#{dir}/representation.txt")
    end
  end
end
