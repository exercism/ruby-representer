def initialize(a, b)
  @alphabet = ('a'..'z').to_a
  @key = [a, b]; coprime_check(key[0])
  @cipherbet = make_cipherbet.join
end
