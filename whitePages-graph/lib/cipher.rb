class Cipher

  def initialize()
    shuffled = ['q','1','7','8','d','4','f','9','g','h','j','k','l','1','7','8','9','0','w','e','r','2','F','1','7','8','G','H','J','K','3','4','5','6','t','y','u','i','o','p','a','s','d','f','g','h','j','k','l','1','7','8','9','0','z','x','c','v','b','n','A','S','D','L']
    normal = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a + [' ']
    @map = normal.zip(shuffled).inject(:encrypt => {} , :decrypt => {}) do |hash,(a,b)|
      hash[:encrypt][a] = b
      hash[:decrypt][b] = a
      hash
    end
  end

  def encrypt(str)
    str.split(//).map { |char| @map[:encrypt][char] }.join
  end

  def decrypt(str)
    str.split(//).map { |char| @map[:decrypt][char] }.join
  end

end