# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  require_relative '../../lib/popug_oauth_strategy'
  # TODO: hide secrets
  provider :popug, 'rumTLjg4AIdxsLKnG7Q5qxVIaMdrGIhZTMIr2qo9vfk', 'roTvkDRlGg6VIQkakGzeqerzFZnMjxmZoYY4zxg1SF8',
           scope: 'public write'
end
