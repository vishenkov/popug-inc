# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  require_relative '../../lib/popug_oauth_strategy'
  # TODO: hide secrets
  provider :popug, '3a0-XVxqTPUPjyA1Q_p8qgO6iW7rTOWVliXa5oHI6u4', 'lOSiZTYzURVsmqYip7441s8k7SW4oHQ-Gf-YwyNzeMU',
           scope: 'public write'
end
