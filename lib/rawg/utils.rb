# frozen_string_literal: true

module RAWG
  # A collection of useful methods.
  module Utils
    def self.included(base)
      base.extend(ClassMethods)
    end

    # A collection of useful class methods.
    module ClassMethods
      def lazy_attr_accessor(*attrs, init:)
        attr_writer(*attrs)
        lazy_attr_reader(*attrs, init: init)
      end

      def lazy_attr_reader(*attrs, init:)
        attrs.each do |attr|
          define_method(attr) do
            instance_variable_get("@#{attr}") || begin
              instance_eval(&init)
              instance_variable_get("@#{attr}")
            end
          end
        end
      end
    end

    def assign_attributes(attrs)
      return unless attrs.is_a?(Hash)

      attrs.each do |attr, value|
        send("#{attr}=", value) if respond_to?("#{attr}=")
      end
    end
  end
end
