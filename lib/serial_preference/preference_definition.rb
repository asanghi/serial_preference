module SerialPreference
  class PreferenceDefinition

    SUPPORTED_TYPES = [:string,:integer,:decimal,:float,:boolean]

    attr_accessor :data_type, :name, :default, :required, :label, :hint, :field_type

    def initialize(name,*args)
      opts = args.extract_options!
      self.name = name.to_s
      opts.assert_valid_keys(:data_type,:default,:required,:label,:hint,:field_type)
      self.data_type = @type = opts[:data_type] || :string
      @column = ActiveRecord::ConnectionAdapters::Column.new(name.to_s,opts[:default],@type.to_s)
      self.default = opts[:default]
      self.required = !!opts[:required]
      self.label = opts[:label]
      self.hint = opts[:hint]
      self.field_type = opts[:field_type]
    end

    def name
      @column.name
    end

    def default_value
      @column.default
    end

    def required?
      required
    end

    def numerical?
      @column.number?
    end

    def boolean?
      @column.type == :boolean
    end

    def type_cast(value)
      v = @column.type_cast(value)
      v.nil? ? default_value : v
    end

    def field_type
      @field_type || (numerical? ? :string : data_type)
    end

    def query(value)
      if !(value = type_cast(value))
        false
      elsif numerical?
        !value.zero?
      else
        !value.blank?
      end
    end

    def value(v)
      v = v.nil? ? default : v
      if !v.nil?
        case data_type
        when :string, :password
          v.to_s
        when  :integer
          v.respond_to?(:to_i) ? v.to_i : nil
        when :float, :real
          v.respond_to?(:to_f) ? v.to_f : nil
        when :boolean
          return false if v == 0
          return false if v == ""
          return false if v == nil
          return false if v.to_s.downcase == "false"
          return false if v == "0"
          return false if v.to_s.downcase == "no"
          !!v
        else
          nil
        end
      end
    end

  end
end