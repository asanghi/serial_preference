module SerialPreference
  class Preferenzer
    PreferenceGroup = Struct.new(:name,:preferences)

    attr_reader :preference_groups, :current_group

    def initialize
      @preference_names_cache = HashWithIndifferentAccess.new
      @preference_groups = []
      activate_group
    end

    def draw(&block)
      instance_exec(&block)
    end

    def respond_to?(name)
      [:string, :integer, :boolean, :float].include?(name) || @preference_names_cache[name].present? || super
    end

    def method_missing(name,*args,&block)
      preference(name,args.extract_options!)
    end

    [:string,:integer,:boolean,:float].each do |dt|
      define_method(dt) do |name,opts = {}|
        preference(name,opts.merge!(:data_type => dt))
      end
    end

    def preference(name,opts = {})
      Array(name).each do |n|
        push_preference SerialPreference::PreferenceDefinition.new(n.to_sym,opts)
      end
    end
    alias :pref :preference

    def preference_group(name,&block)
      activate_group(name)
      instance_exec(&block)
    end

    def all_preference_definitions
      preference_groups.map{|x|x.preferences.values}.flatten
    end

    def all_preference_names
      @preference_names_cache.keys
    end

    def all_groups
      @preference_groups.map{|x|x.name}
    end

    private

    def activate_group(group_name = :base)
      @current_group = find_or_create_group(group_name)
    end

    def push_preference(preference)
      @preference_names_cache[preference.name] = 1
      @current_group.preferences[preference.name] = preference
    end

    def find_or_create_group(name)
      find_group(name) || create_group(name)
    end

    def find_group(name)
      @preference_groups.find{|x|x.name == name}
    end

    def create_group(name = :base)
      PreferenceGroup.new(name,{}).tap do |pg|
        @preference_groups.push(pg)
      end
    end

  end
end