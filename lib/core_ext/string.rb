require 'attach_function'

#These are stolen from active_support (Ruby on Rails, (TM)) and modified (no acronyms in case of camelize; made into a mixin instead of 
#monkey peatching core classes directly.

module CoreExt
  module String


    # Converts strings to UpperCamelCase.
    # If the +uppercase_first_letter+ parameter is set to false, then produces
    # lowerCamelCase.
    #
    # Also converts '/' to '::' which is useful for converting
    # paths to namespaces.
    #
    #   camelize('active_model')                # => "ActiveModel"
    #   camelize('active_model', false)         # => "activeModel"
    #   camelize('active_model/errors')         # => "ActiveModel::Errors"
    #   camelize('active_model/errors', false)  # => "activeModel::Errors"
    #
    # As a rule of thumb you can think of +camelize+ as the inverse of
    # underscore.
    #
    # (This is a mechanical method that doesn't understand human stuff like acronyms.)
    def camelize(string, first_letter_small = false)
      string = string.to_s
      if !first_letter_small
        string = string.sub(/^[a-z\d]*/) { $&.capitalize }
      else
        string = string.sub(/^(?:(?=\b|[A-Z_])|\w)/) { $&.downcase }
      end
      string.gsub!(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }
      string.gsub!(/\//, '::')
      string
    end

    alias_method :camelcase, :camelize
    module_function :camelize, :camelcase

    # Makes an underscored, lowercase form from the expression in the string.
    #
    # Changes '::' to '/' to convert namespaces to paths.
    #
    #   underscore('ActiveModel')         # => "active_model"
    #   underscore('ActiveModel::Errors') # => "active_model/errors"
    #
    # As a rule of thumb you can think of +underscore+ as the inverse of
    # #camelize
    #
    #   camelize(underscore('SSLError'))  # => "SslError"
    #
    def underscore(camel_cased_word)
      return camel_cased_word unless camel_cased_word =~ /[A-Z-]|::/
      word = camel_cased_word.to_s.gsub(/::/, '/')
      word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      word.tr!("-", "_")
      word.downcase!
      word
    end
    alias_method :snakecase, :underscore
    module_function :underscore, :snakecase

    module MethodVersions
      extend AttachFunction
      attach_outer_class_methods!
    end
  end
end

