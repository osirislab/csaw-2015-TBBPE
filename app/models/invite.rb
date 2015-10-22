class Invite
  REDIS_KEY = "used_invites"

  def self.generate_token
    new.token
  end

  def self.from_token(token)
    id = multipass.decode(token)[:id]
    new(id, token)
  end

  def initialize(id = nil, token = nil)
    @id    = id
    @token = token
  end

  def id
    @id ||= SecureRandom.hex
  end

  def token
    @token ||= self.class.multipass.encode(id: id)
  end

  def redeem!
    redis.sadd(REDIS_KEY, id)
  end

  def valid?
    id && token && !redeemed?
  end

  def redeemed?
    redis.sismember(REDIS_KEY, id)
  end

  private

  def redis
    Rails.application.config.redis
  end

  def self.multipass
    @multipass ||= MultiPass.new(
      Rails.application.config.multipass_site_key,
      Rails.application.config.multipass_api_key
      # url_safe: true
    )
  end
end
