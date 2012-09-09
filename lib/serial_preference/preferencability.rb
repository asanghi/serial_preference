module Preferencability
  extend ActiveSupport::Concern

  included do
    class_attribute :preference_context
    class_attribute :preference_storage_attribute
    self.preference_context = table_name.to_sym
    self.preference_storage_attribute = :preferences
  end

  def default_preference_for(name)
    self.class.default_preference_for(name)
  end

  def preferences_for(group_name)
    send(preference_storage_attribute).slice(*self.class.preferences_for(group_name))
  end

  module ClassMethods

    def preferences_for(group_name)
      SerialPreference::Preferenzer.group_for(self.preference_context)[group_name].try(:preference_keys) || []
    end

    def preference_map(store_accessor = :preferences, context = nil, &block)
      self.preference_context = context || self.preference_context
      SerialPreference::Preferenzer.draw(preference_context,&block)
      prefers(store_accessor,preference_context)
    end

    def default_preference_for(name)
      SerialPreference::Preferenzer.preference(name,nil,preference_context)
    end

    def prefers(store_accessor = :preferences, context = nil)
      self.preference_context = context || self.preference_context
      self.preference_storage_attribute = store_accessor || self.preference_storage_attribute
      serialize preference_storage_attribute, Hash

      preferences = SerialPreference::Preferenzer.preferences_for(preference_context)

      preferences.each do |preference|
        key = preference.name
        define_method("#{key}=") do |value|
          send(:preferences)[key] = SerialPreference::Preferenzer.preference(key,value,context)
          send("preferences_will_change!")
        end

        define_method(key) do
          SerialPreference::Preferenzer.preference(key,send(:preferences)[key],context)
        end

        if preference.required?
          validates key, :presence => true
        end

        if preference.numerical?
          validates key, :numericality => true, :allow_blank => true
        end

      end

    end

  end

end