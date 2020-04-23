class AccessToken
  include Sidekiq::Worker
  include WechatHelper

  def perform
    token = WechatClient.fetch_access_token
    $redis_cache.set_cache(:access_token, token['access_token'], token['expires_in'].seconds)
  end
end