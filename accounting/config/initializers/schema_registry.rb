# frozen_string_literal: true

SchemaRegistry.configure do |config|
  config.schemas_root_path = Rails.root.join('schemas')
end
