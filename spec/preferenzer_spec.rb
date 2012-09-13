require 'spec_helper'

describe SerialPreference::Preferenzer do

  it "should have proper readers" do
    [:preference_groups,:current_context,:preference,:pref].each do |a|
      @preferenzer.respond_to?(a).should be_true
      @preferenzer.respond_to?("#{a}=").should be_false
    end
  end

  it "should be a singleton" do
    @a = described_class.instance
    @b = described_class.instance
    @a.should eq(@b)
  end 

  context "default instance behaviour" do
    it "should have no context" do
      @preferenzer.current_context.should be_nil
      @preferenzer.preference_groups.should be_nil
    end
    it 'should report group_for to be empty hash' do
      @preferenzer.group_for.should eq({})
    end
    it "should report each_preference to be empty" do
      @preferenzer.each_preference.should eq([])
    end
    it "should report preference_for to be empty" do
      @preferenzer.preferences_for.should eq([])
    end
    it "should report all_preference_names to be empty" do
      @preferenzer.all_preference_names.should eq([])
    end
    it "should report nil when reset" do
      @preferenzer.reset.should be_nil
    end
  end

  context "setup should setup the preferenzer" do
    before do
      @preferenzer = described_class.instance
      @preferenzer.setup
    end
    it "should ensure that preference_groups are initialized" do
      @preferenzer.preference_groups.should eq({:base => {}})
    end
    it "should set current_contex to :base" do
      @preferenzer.current_context.should eq(:base)
    end
    it "should setup according to given context" do
      @preferenzer.setup(:my_context)
      @preferenzer.current_context.should eq(:my_context)
      @preferenzer.preference_groups.should eq({:base => {}, :my_context => {}})
    end
  end

  context "allows for preferences/groups to be setup using instance" do
    before do
      @preferenzer.setup
    end

    it "should allow for addition of preference using pref" do
      @preferenzer.pref("whatever")
      @preferenzer.all_preference_names.should include("whatever")
      @preferenzer.preferences_for(:base).each do |pref|
        pref.class.should eq(SerialPreference::Preference)
      end
      @preferenzer.group_for(:base)[:base].class.should eq(SerialPreference::PreferenceGroup)
    end

    it "should allow for addition of preference using preference" do
      @preferenzer.preference("whatever")
      @preferenzer.all_preference_names.should include("whatever")
      @preferenzer.preferences_for(:base).each do |pref|
        pref.class.should eq(SerialPreference::Preference)
      end
      @preferenzer.group_for(:base)[:base].class.should eq(SerialPreference::PreferenceGroup)
    end

    it "should alias preference to pref" do
      described_class.instance_method(:pref).should eq(described_class.instance_method(:preference))
    end

    it "should allow for addition of preference group" do
      @preferenzer.preference_group(:new_group) do
        preference :new_preference
      end
      @preferenzer.all_preference_names.should include("new_preference")
      @preferenzer.preferences_for("new_group").each do |pref|
        pref.class.should eq(SerialPreference::Preference)
      end
      @preferenzer.group_for.keys.should include(:new_group)
    end

  end

  context "allows for drawing of preference map" do
    it "should setup preferences using draw" do
      described_class.draw do
        preference :name
        pref :age, data_type: :integer
        pref :sex, default: "male"
        preference_group :notifications, label: "Email Notifications" do
          boolean :email, default: false
          integer :switch_off_hour, default: 23
        end
      end
      @preferenzer.all_preference_names.should include("age","name","sex","email","switch_off_hour")
      @preferenzer.all_groups.should include(:base,:notifications)
    end

    it "should allow for reset of preference group", :it => true do
      @preferenzer.reset_preference_group(:notifications)
      @preferenzer.all_groups.should_not include(:notifications)
    end

    it "should allow for reset of preference" do
      @preferenzer.reset_preference(:switch_off_hour)
      @preferenzer.all_preference_names.should_not include("switch_off_hour")
    end

    it "should allow for addition of preference in given context" do
      @preferenzer.all_groups.should_not include(:new_group)
      @preferenzer.preference_group(:new_group) do
        preference "addition"
      end
      @preferenzer.all_preference_names.should include("addition")
    end

    it "should allow overriding of preference if defined twice" do
      @preferenzer.preference_group(:overriding) do
        preference :overriding_name
        preference :overriding_name
      end
      @preferenzer.all_preference_names.should include("overriding_name", "overriding_name")
    end
    
    it "should allow addition of preference to an existing preference group" do
      @preferenzer.preference_group(:notifications) do
        preference :new_preference
      end
      @preferenzer.all_preference_names.should include("new_preference")
    end

    it "should allow for preference names to be strings or symbols" do
      @preferenzer.preference_group(:notifications) do
        preference "string"
        preference :symbol
      end
      @preferenzer.all_preference_names.should include("string", "symbol")
    end
    
    it "should allow for preference_group names to be strings or symbols" do
      @preferenzer.preference_group(:symbol) do
        preference "string"
      end
      @preferenzer.preference_group("string") do
        preference :symbol
      end
      @preferenzer.all_groups.should include("string", :symbol)
    end
  end  
end