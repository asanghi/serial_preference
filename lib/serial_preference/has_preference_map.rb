module HasPreferenceMap
  extend ActiveSupport::Concern

  included do
    class_attribute :preference_context
    class_attribute :preference_storage_attribute
    self.preference_context = table_name.downcase.to_sym
    self.preference_storage_attribute = :preferences
  end

  def default_preference_for(name,context = nil)
    self.class.default_preference_for(name,context)
  end

  def preferences_for(group_name,storage_accessor = nil, context = nil)
    send(storage_accessor || preference_storage_attribute).slice(*self.class.preferences_for(group_name,context))
  end

  module ClassMethods

    def preferences_for(group_name,context = nil)
      SerialPreference::Preferenzer.group_for(context || preference_context)[group_name].try(:preference_keys) || []
    end

    def preference_map(store_accessor = :preferences, context = nil, &block)
      pc = context || preference_context
      sa = store_accessor || self.preference_storage_attribute
      SerialPreference::Preferenzer.draw(pc,&block)
      prefers(sa,pc)
    end

    def default_preference_for(name,context = nil)
      SerialPreference::Preferenzer.preference(name,nil,context || preference_context)
    end

    def prefers(store_accessor = :preferences, context = nil)
      pc = context || preference_context
      sa = store_accessor || self.preference_storage_attribute

      preferences = SerialPreference::Preferenzer.preferences_for(pc)

      serialize sa, Hash

      preferences.each do |preference|
        key = preference.name
        define_method("#{key}=") do |value|
          send(store_accessor)[key] = SerialPreference::Preferenzer.preference(key,value,context)
          send("#{sa}_will_change!")
        end

        define_method(key) do
          SerialPreference::Preferenzer.preference(key,send(sa)[key],context)
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