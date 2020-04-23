module UtilsHelper
  class UtilsMiddleware
    private
    include HTTParty
    base_uri $middleware_host.to_s

    def self.sym_data(response)
      JSON.parse response, symbolize_names: true
    end

    def self.no_nil(**hash)
      (hash || {}).select {|key, value| !value.nil?}
    end

    public
    def self.authenticate(username, password)
      sym_data post('/authenticate/unified', body: no_nil(username: username, password: password), format: :plain)
    end

    DEFAULT_EXPIRE = 300

    def self.image_url(token, expire = DEFAULT_EXPIRE)
      sym_data get('/image/url', query: no_nil(token: token, expire: expire), format: :plain)
    end

    def self.image_upload(path, token = nil, filename = nil)
      sym_data post('/image/upload', body: no_nil(path: path, token: token, filename: filename), format: :plain)
    end
  end
end
