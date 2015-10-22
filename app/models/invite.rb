class Invite
  REDIS_KEY = "invite_nonces"

  def self.generate(user)
    new(user: user).token
  end

  def self.from_token(token)
    new(token: token)
  end

  def initialize(user: nil, token: nil)
    @uid = user.id if user
    @user = user
    @token = token
  end

  def valid?
    user && user.admin? && !redeemed?
  end

  def token
    @token ||= generate_token
  end

  def redeem!
    redis.sadd(REDIS_KEY, nonce)
  end

  private

  def user
    @user ||= User.find(uid)
  end

  def uid
    @uid ||= parse_token["uid"]
  end

  def nonce
    @nonce ||= SecureRandom.hex(8)
  end

  def redeemed?
    redis.sismember(REDIS_KEY, nonce)
  end

  def redis
    Rails.application.config.redis
  end

  def generate_token
    c = OpenSSL::Cipher::AES256.new(:CBC)
    c.encrypt
    c.key = Rails.application.config.crypto_key
    iv = c.random_iv
    payload = JSON.dump nonce: nonce, uid: uid
    ct = c.update payload
    ct << c.final
    packed = [iv, ct].pack('A16A*')
    encoded = Base64.urlsafe_encode64 packed
  end

  def parse_token
    c = OpenSSL::Cipher::AES256.new(:CBC)
    c.decrypt
    c.key = Rails.application.config.crypto_key
    packed = Base64.urlsafe_decode64 token
    c.iv, ct = packed.unpack('A16A*')
    pt = c.update ct
    pt << c.final
    JSON.load pt
  end
end
