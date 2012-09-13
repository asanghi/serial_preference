require 'singleton'
require "serial_preference/version"
require 'serial_preference/preference'
require 'serial_preference/preference_group'
require "serial_preference/has_preference_map"
require 'active_support/all'

module SerialPreference
  class Preferenzer

    include Singleton

    attr_reader :preference_groups, :current_context

    def draw(context = :base, &block)
      setup(context)
      instance_exec(&block)
      preferences_for(context)
    end

    def self.total_reset
      instance.total_reset
      nil
    end

    def reset(context = :base)
      preference_groups && preference_groups.try(:delete,context)
      nil
    end

    def reset_preference_group(preference_group_name)
      if preference_groups
        preference_groups.keys.each do |context|
          group_for(context).delete(preference_group_name)
        end
      end
    end

    def reset_preference(preference_name)
      if preference_groups
        preference_groups.keys.each do |context|
          group_for(context).values.each do |pg|
            pg.remove_preference(preference_name)
          end
        end
      end
    end

    def pref(name,opts = {})
      pg = base_group
      pg.pref(name,opts)
    end
    alias :preference :pref

    def preference_value(name,value,context = :base)
      p = preferences_for(context).find{|x| x.name == name }
      p ? p.value(value) : nil
    end

    def preference_group(name, opts={},&block)
      setup
      @preference_groups[current_context][name] ||= SerialPreference::PreferenceGroup.new(name,opts)
      @preference_groups[current_context][name].instance_exec(&block)
    end

    def self.method_missing(name,*args,&block)
      if instance.respond_to?(name)
        instance.send(name,*args,&block)
      else
        super
      end
    end

    def all_contexts
      preference_groups && preference_groups.keys
    end

    def all_groups
      (preference_groups && preference_groups.map{|x,y|y.keys}.flatten) || []
    end

    def all_preference_names(context = :base)
      group_for(context).values.map do |pg|
        pg.preferences.map do |pref|
          pref.name
        end
      end.flatten
    end

    def preferences_for(context = :base)
      group_for(context).values.map do |pg|
        pg.preferences.map do |pref|
          pref
        end
      end.flatten
    end

    def each_preference(context = :base)
      group_for(context).values.each do |pg|
        pg.preferences.each do |pref|
          yield(pref)
        end
      end
    end

    def group_for(context = :base)
      (preference_groups && preference_groups[context]) || {}
    end

    def setup(context = :base)
      @preference_groups ||= {}
      @preference_groups[context] ||= {}
      @current_context = context
    end

    def total_reset
      @current_context = nil
      @preference_groups = nil
      @base_group = nil
    end

    private

    def base_group
      @base_group ||= begin
        setup
        pg = SerialPreference::PreferenceGroup.new(:base,:label => current_context.to_s.titleize)
        @preference_groups[current_context][:base] = pg
        pg
      end
    end

  end
end

