require "test_helper"

# The purpose of these tests it to ensure that things
# can actually work in reality rather than just in theory,
# that feedback can be sensibly given. It is a sanity check
# for the whole process of representing as much as just this
# Ruby representer.

class SanityTest < Minitest::Test
  def test_1
    code_1 = <<-CODE
      def add_2(a)
        a + 2
      end

      def add_3(a)
        a + 3
      end
    CODE

    code_2 = <<-CODE
      def add_2(a)
        a + 2
      end

      def add_3(b)
        b + 3
      end
    CODE

    code_3 = <<-CODE
      def add_2(b)
        b + 2
      end

      def add_3(b)
        b + 3
      end
    CODE

    representation_1 = Representation.new(code_1)
    representation_1.normalize!

    representation_2 = Representation.new(code_2)
    representation_2.normalize!

    representation_3 = Representation.new(code_3)
    representation_3.normalize!

    assert_equal representation_1.ast, representation_2.ast
    assert_equal representation_1.ast, representation_3.ast
  end
end

#   def test_1
#     code_1 = <<-CODE
#       foobar = "This is nice"

#       def add_2(a)
#         a + 2
#       end

#       def add_3(a)
#         a + 3
#       end

#       class TwoFer
#         def two_fer
#           "foo"
#         end

#         def foobar
#           two_fer = "cat"
#           return TwoFer.two_fer
#         end
#       end
#     CODE

#     code_2 = <<-CODE
#       something = "This is nice"

#       class TwoFer
#         def two_fer
#           "foo"
#         end

#         def foobar
#           mouse = "cat"
#           return TwoFer.two_fer
#         end
#       end
#     CODE

#     representation = Representation.new(code)
#     representation.normalize!

#     # Let's give feedback on the first

#     """
#     """
