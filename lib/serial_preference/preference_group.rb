class PreferenceGroup

  attr_accessor :name, :label

  def initialize(name, opts = {})
    @preferences = {}
    @name = name
    @label = opts[:label]
  end

  def label
    @label.presence || name.to_s.titleize
  end

  def preference_keys
    @preferences.keys
  end

  def preferences
    @preferences.values
  end

  def pref(name,opts = {})
    @preferences[name] = Preference.new(name,opts)
  end

  Preference::SUPPORTED_TYPES.each do |dt|
    define_method dt do |name,opts = {}|
      pref(name,opts.merge!(:data_type => dt))
    end
  end

  def respond_to?(name,*opts)
    @preferences[name].present?
  end

  def method_missing(name,*opts,&block)
    pref(name,*opts)
  end

end
