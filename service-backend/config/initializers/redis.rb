# redis基本配置
$redis_config = YAML.load_file(::Rails.root.to_s + '/config/redis.yml')
$redis_config_env = $redis_config[Rails.env].collect {|key, value|
  [key.to_sym, value]
}.to_h

$redis_cache = Redis::Namespace.new(
    $redis_config_env[:namespace],
    redis: Redis.new($redis_config_env)
)

def _redis_key(name, **properties)
  property_tag = (properties || {}).to_a.sort.collect {|item| "#{item[0]}_#{item[1]}"}.join("_")
  "name_#{name}_properties_#{property_tag}"
end

def redis_keys(name, **properties)
  $redis_cache.keys _redis_key(name, **properties)
end

def redis_remove_keys(name, **properties)
  keys = redis_keys name, **properties
  if keys.present?
    $redis_cache.del keys
  else
    0
  end
end

def redis_set_cache(name, value, expire = nil, **properties)
  $redis_cache.set_cache _redis_key(name, **properties), value, expire
end

def redis_set_cache_expire_at(name, value, expire_at = nil, **properties)
  $redis_cache.set_cache_expire_at _redis_key(name, **properties), value, expire_at
end

def redis_get(name, **properties)
  $redis_cache.get_object _redis_key(name, **properties)
end