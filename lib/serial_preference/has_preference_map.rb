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

      def preferences(storage_attribute = nil, &block)
        self._preference_attribute = storage_attribute || self._preference_attribute
        _preference_map.draw(&block)
        build_preference_definitions
      end

      protected
      def read_store_attribute(store_attribute, key)
        attribute = initialize_store_attribute(store_attribute)
        attribute[key]
      end
      def write_store_attribute(store_attribute, key, value)
        attribute = initialize_store_attribute(store_attribute)
        if value != attribute[key]
          send :"#{store_attribute}_will_change!"
          attribute[key] = value
        end
      end

      private
      def build_preference_definitions
        serialize self._preferences_attribute, Hash

        preferences.each do |preference|
          key = preference.name
          define_method("#{key}=") do |value|
            write_store_attribute(_preferences_attribute,key,preference.val(key,value))
          end

          define_method(key) do
            value = read_store_attribute(_preferences_attribute,key)
            preference.val(key,value)
          end

          if preference.boolean?
            define_method("#{key}?") do
              read_store_attribute(_preferences_attribute,key).present?
            end
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
end