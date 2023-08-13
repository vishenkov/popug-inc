Rails.application.config.middleware.use OmniAuth::Builder do
  require_relative '../../lib/popug_oauth_strategy'
  # todo: hide secrets
  provider :popug, "yAjdkl1nI7a2dq1rxRX4LE38fY62eW8cmYu5tIv0U1s", "9T5QrotNKVsV17393DRuqz2mSr4RQDOEzty-zIp1eRs", scope: 'public write'
end
