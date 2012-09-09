require 'singleton'
require "serial_preference/version"
require 'serial_preference/preference'
require 'serial_preference/preference_group'
require "serial_preference/has_preference_map"

module SerialPreference
	class Preferenzer

		include Singleton

		attr_accessor :preference_groups, :current_context

		def self.draw(context = :base, &block)
			i = instance
			i.preference_groups ||= {}
			i.preference_groups[context] ||= {}
			i.current_context = context
			i.instance_exec(&block)
		end

    def +(name,opts = {})
      preference(name,opts)
    end

    def *(name,opts = {},&block)
      preference_group(name,opts,&block)
    end

		def preference(name,opts = {})
			pg = base_group
			pg.pref(name,opts)
		end

		def preference_group(name, opts={},&block)
			self.preference_groups[current_context] ||= {}
			self.preference_groups[current_context][name] ||= SerialPreference::PreferenceGroup.new(name,opts)
			self.preference_groups[current_context][name].instance_exec(&block)
		end

		def self.method_missing(name,*args,&block)
			if instance.respond_to?(name)
				instance.send(name,*args,&block)
			else
				super
			end
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

		def preference(name,value,context = :base)
			p = preferences_for(context).find{|x| x.name == name }
			p ? p.value(value) : nil
		end

		def group_for(context = :base)
			preference_groups[context] || {}
		end

		private

		def base_group
			@base_group ||= begin
				pg = SerialPreference::PreferenceGroup.new(:base,:label => current_context.to_s.titleize)
				self.preference_groups[current_context] ||= {}
				self.preference_groups[current_context][:base] = pg
				pg
			end
		end

	end
end

