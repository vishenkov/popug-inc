Rails.application.config.middleware.use OmniAuth::Builder do
  require_relative '../../lib/popug_oauth_strategy'
  provider :popug, "EjMEd6KvXE-xjKlNF6P_5c1wK7waesa46gDs2qrr6P8", "LSOPCjK4tvlo7ngvSbYkSyCCIQry6unN_AysQhQ3Obk", scope: 'public write'
end
