# frozen_string_literal: true

class Producer
  def call(**_payload)
    puts "Produce: #{params}"
  end
end
