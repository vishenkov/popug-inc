require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Popug < OmniAuth::Strategies::OAuth2
      option :name, :popug

      option :client_options, {
        site: 'http://localhost:3000/'
      }

      uid { raw_info['public_id'] }

      info do
        {
          email: raw_info['email'],
          full_name: raw_info['full_name'],
          role: raw_info['role'],
          public_id: raw_info['public_id']
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/users/current').parsed
      end
    end
  end
end
