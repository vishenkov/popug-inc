# frozen_string_literal: true

SchemaRegistry.configure do |config|
  config.schemas_root_path = Rails.root.join('schemas')
end

format_proc = lambda { |value|
  raise JSON::Schema::CustomFormatError, 'Title should not contain []' if (value.include? '[') || (value.include? ']')
}

JSON::Validator.register_format_validator('jira-checker', format_proc)
