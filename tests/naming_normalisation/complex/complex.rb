class TwoFer
  def two_fer
    "foo"
  end

  def foobar
    two_fer = "cat"
    return TwoFer.two_fer
  end
end
