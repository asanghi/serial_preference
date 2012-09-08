class Preference

  SUPPORTED_TYPES = [:string,:integer,:real,:float,:boolean,:password]

  attr_accessor :data_type, :name, :default, :required, :label, :hint

  def initialize(name,opts = {})
    self.data_type = opts[:data_type] || :string
    self.name = name
    self.default = opts[:default]
    self.required = !!opts[:required]
    self.label = opts[:label]
    self.hint = opts[:hint]
  end

  def required?
    required
  end

  def numerical?
    [:integer,:float,:real].include?(data_type)
  end

  def value(value)
    value = value.presence || default
    if !value.nil?
      case data_type
      when :string, :password
        value.to_s
      when  :integer
        value.to_i
      when :float, :real
        value.to_f
      when :boolean
        !!value
      else
        nil
      end
    end
  end

end
