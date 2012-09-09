module HasPreferenceMap
  extend ActiveSupport::Concern

  included do
    class_attribute :preference_context
    class_attribute :preference_storage_attribute
    self.preference_storage_attribute = :preferences
    self.preference_context = "#{preference_storage_attribute}_#{table_name.downcase}".to_sym
  end

  def default_preference_for(name)
    self.class.default_preference_for(name)
  end

  def preferences_for(group_name)
    send(preference_storage_attribute).slice(*self.class.preferences_for(group_name))
  end

  def preference_map
    SerialPreference::Preferenzer.preferences_for(self.class.preference_context)
  end

  module ClassMethods

    def preference_groups
      SerialPreference::Preferenzer.group_for(preference_context).try(:values) || []
    end

    def preferences_for(group_name)
      SerialPreference::Preferenzer.group_for(preference_context)[group_name].try(:preference_keys) || []
    end

    def preference_map(store_attribute = nil, &block)
      self.preference_storage_attribute = store_attribute || preference_storage_attribute
      self.preference_context = "#{preference_storage_attribute}_#{table_name.downcase}".to_sym
      SerialPreference::Preferenzer.reset(preference_context)
      preferences = SerialPreference::Preferenzer.draw(preference_context,&block)

      make_functions(preferences,store_attribute,preference_context)
    end

    def default_preference_for(name)
      SerialPreference::Preferenzer.preference(name,nil,preference_context)
    end

    private

    def make_functions(preferences,store_attribute,context)
      serialize store_attribute, Hash

      preferences.each do |preference|
        key = preference.name
        define_method("#{key}=") do |value|
          send(store_attribute)[key] = SerialPreference::Preferenzer.preference(key,value,context)
          send("#{store_attribute}_will_change!")
        end

        define_method(key) do
          value = send(store_attribute)[key]
          SerialPreference::Preferenzer.preference(key,value,context)
        end

        opts = {}
        if preference.required?
          opts[:presence] = true
        end
        if preference.numerical?
          opts[:numericality] = true
          opts[:allow_blank] = true unless opts[:presence].present?
        end
        validates key, opts if opts.present?

      end
    end

  end

end