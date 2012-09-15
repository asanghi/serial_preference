require 'spec_helper'

describe SerialPreference::Preferenzer do

  before(:each) do
    @base = described_class::PreferenceGroup.new(:base,"Base",{})
    @preferenzer = described_class.new
  end

  it "should have proper readers" do
    [:preference_groups,:preference,:preference_groups,:all_preference_definitions,:all_preference_names,:current_group].each do |a|
      @preferenzer.should respond_to(a)
    end
  end

  context "default instance behaviour" do
    it "should report empty preference groups" do
      @preferenzer.preference_groups.should include(@base)
    end
    it "should report current_contex to be nil" do
      @preferenzer.current_group.should eq(@base)
    end
    it "should report all preference name to be empty" do
      @preferenzer.all_preference_names.should be_empty
    end
    it "should report all preference definitions to be empty" do
      @preferenzer.all_preference_definitions.should be_empty
    end
  end

  context "allows for preferences/groups to be setup using instance" do

    it "should allow for addition of preference using pref" do
      @preferenzer.pref("whatever")
      @preferenzer.all_preference_names.should include("whatever")
    end

    it "should allow for addition of preference using preference" do
      @preferenzer.preference("whatever")
      @preferenzer.all_preference_names.should include("whatever")
    end

    it "should alias preference to pref" do
      described_class.instance_method(:pref).should eq(described_class.instance_method(:preference))
    end

    it "should allow for addition of preference group" do
      @preferenzer.preference_group(:new_group) do
        preference :new_preference
      end
      @preferenzer.all_preference_names.should include("new_preference")
    end

  end

  context "allows for drawing of preference map" do
    it "should setup preferences using draw" do
      @preferenzer.draw do
        preference :name
        pref :age, data_type: :integer
        pref :sex, default: "male"
        preference_group :notifications, label: "Email Notifications" do
          email default: false
          switch_off_hour default: 23
        end
      end
      @preferenzer.all_preference_names.should include("age","name","sex","email","switch_off_hour")
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
      @preferenzer.all_groups.should include(:string, :symbol)
    end
  end
end