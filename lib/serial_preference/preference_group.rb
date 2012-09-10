module SerialPreference
  class PreferenceGroup

    attr_reader :name, :label

    def initialize(name, opts = {})
      @preferences = {}
      @name = name.to_s
      @label = opts[:label]
    end

    alias :to_s :name

    def label
      @label.presence || name.titleize
    end
    alias :titleize :label

    def preference_keys
      @preferences.keys
    end

    def preferences
      @preferences.values
    end

    def pref(name,opts = {})
      @preferences[name] = Preference.new(name,opts)
    end

    SerialPreference::Preference::SUPPORTED_TYPES.each do |dt|
      define_method dt do |name,opts = {}|
        pref(name,opts.merge!(:data_type => dt))
      end
    end

    def respond_to?(name,*opts)
      SerialPreference::Preference::SUPPORTED_TYPES.include?(name) ||
      @preferences.has_key?(name) || 
      super
    end

    def method_missing(name,*opts,&block)
      if @preferences.has_key?(name)
        @preferences[name]
      else
        pref(name,*opts)
      end
    end

  end
end