module SerialPreference
  class Preference

    SUPPORTED_TYPES = [:string,:integer,:real,:float,:boolean,:password]

    attr_accessor :data_type, :name, :default, :required, :label, :hint, :field_type

    def initialize(name,opts = {})
      self.data_type = opts[:data_type] || :string
      self.name = name.to_s
      self.default = opts[:default]
      self.required = !!opts[:required]
      self.label = opts[:label]
      self.hint = opts[:hint]
      self.field_type = opts[:field_type]
    end

    def required?
      required
    end

    def numerical?
      [:integer,:float,:real].include?(data_type)
    end

    def field_type
      @field_type || (numerical? ? :string : data_type)
    end

    def value(value)
      value = value.nil? ? default : value
      if !value.nil?
        case data_type
        when :string, :password
          value.to_s
        when  :integer
          value.respond_to?(:to_i) ? value.to_i : nil
        when :float, :real
          value.respond_to?(:to_f) ? value.to_f : nil
        when :boolean
          return false if value == 0
          return false if value == ""
          return false if value == nil
          return false if value.to_s.downcase == "false"
          return false if value == "0"
          return false if value.to_s.downcase == "no"
          !!value
        else
          nil
        end
      end
    end

  end
end