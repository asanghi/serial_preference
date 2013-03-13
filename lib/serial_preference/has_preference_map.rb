module SerialPreference
  module HasSerialPreferences
    extend ActiveSupport::Concern

    included do
      class_attribute :_preferences_attribute
      self._preferences_attribute = :preferences
      class_attribute :_preference_map
      self._preference_map = SerialPreference::Preferenzer.new
    end

    module ClassMethods

      def preference_groups
        _preference_map.preference_groups
      end

      def preferences(storage_attribute = nil, &block)
        self._preferences_attribute = storage_attribute || self._preferences_attribute
        _preference_map.draw(&block)
        build_preference_definitions
      end

      def preference_definition(name)
        _preference_map.definition_for(name)
      end

      private

      def build_preference_definitions
        serialize self._preferences_attribute, Hash

        _preference_map.all_preference_definitions.each do |preference|

          key = preference.name
          define_method("#{key}=") do |value|
            write_preference_attribute(self.class._preferences_attribute,key,self.class.preference_definition(key).value(value))
          end

          define_method(key) do
            value = read_preference_attribute(self.class._preferences_attribute,key)
            self.class.preference_definition(key).value(value)
          end

          if preference.boolean?
            define_method("#{key}?") do
              value = read_preference_attribute(self.class._preferences_attribute,key)
              self.class.preference_definition(key).value(value)
            end
          end

        end
      end
    end

    protected

    def read_preference_attribute(store_attribute, key)
      attribute = send(store_attribute)
      attribute[key.to_sym]
    end

    def write_preference_attribute(store_attribute, key, value)
      attribute = send(store_attribute)
      if value != attribute[key]
        send :"#{store_attribute}_will_change!"
        attribute[key.to_sym] = value
      end
    end

  end
end
