# frozen_string_literal: true

module RAWG
  module Utils
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def lazy_attr_accessor(*attrs, init: nil)
        attrs.each do |attr|
          define_method("#{attr}=") do |value|
            instance_variable_set("@#{attr}", value)
          end
          define_method(attr) do
            send(init) if init && !instance_variable_get("@#{attr}")
            instance_variable_get("@#{attr}")
          end
        end
      end
    end

    def assign_attributes(attrs)
      return unless attrs.is_a?(Hash)

      attrs.each do |k, v|
        send("#{k}=", v) if respond_to?("#{k}=")
      end
    end
  end
end
