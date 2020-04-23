# 微信相关配置
$wechat_config = $system_config_env[:wechat]
$wechat_app_config = $wechat_config[:app]
$wechat_appid = $wechat_app_config[:id]
$wechat_secret = $wechat_app_config[:secret]
$wechat_host = $wechat_config[:host]

# 中间件相关配置
$middleware_config = $system_config_env[:middleware]
$middleware_host = $middleware_config[:host]

# 图床相关配置
$cos_config = $system_config_env[:cos]
$cos_public = $cos_config[:public]
$cos_public_picture = $cos_public[:picture]
$cos_default_club_logo = $cos_public[:default_club_logo]
