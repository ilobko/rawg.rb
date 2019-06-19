# frozen_string_literal: true

module RAWG
  module Utils
    def assign_attributes(attrs)
      return unless attrs.is_a?(Hash)

      attrs.each do |k, v|
        send("#{k}=", v) if respond_to?("#{k}=")
      end
    end
  end
end
