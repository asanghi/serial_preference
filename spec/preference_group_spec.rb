require 'spec_helper'
require 'serial_preference/preference'
require 'serial_preference/preference_group'

describe SerialPreference::PreferenceGroup do
  before do
    @pg = @blank_group = described_class.new("whatever")
  end

  it "should have proper accessors" do
    [:name,:label].each do |a|
      @blank_group.respond_to?(a).should be_true
    end
  end

  it "should respond to Preference supported types" do
    SerialPreference::Preference::SUPPORTED_TYPES.each do |st|
      @blank_group.respond_to?(st).should be_true
    end
  end

  it "should resort to name for to_s" do
    described_class.instance_method(:to_s).should eq(described_class.instance_method(:name))
  end

  context "should report correct label" do
    it "should report given label"
    it "should report titleized name if no label is provided"
  end

  it "should alias titleize to label" do
    described_class.instance_method(:titleize).should eq(described_class.instance_method(:label))
  end

  context "should report preference keys" do
    it "should report blank array when no preferences"
    it "should report with array of preference names when non-blank"
  end

  context "should report preference values" do
    it "should report blank array when no preferences"
    it "should report with array of preference objects when non-blank"
  end

  context "should allow addition of preferences" do
    it "should add a preference when provided using pref method call" do
      @pg = described_class.new("my_group")
      o = @pg.pref(:whatever)
      o.class.should eq(SerialPreference::Preference)
      o.name.should eq("whatever")
      @pg.preferences.should include(o)
      @pg.preference_keys.should include(:whatever)
      @pg.respond_to?(:whatever).should be_true
      @pg.whatever.should eq(o)
    end

    it "should allow creation of preference using data type api" do
      p = @pg.string :user
      @pg.preference_keys.should include(:user)
      @pg.preferences.should include(p)
      @pg.respond_to?(:user).should be_true
      @pg.user.should eq(p)
      SerialPreference::Preference::SUPPORTED_TYPES.each do |st|
        p = @pg.send(st,"#{st}_field".to_sym)
        @pg.preference_keys.should include("#{st}_field".to_sym)
        p.data_type.should eq(st)
        @pg.preferences.should include(p)
        @pg.respond_to?("#{st}_field".to_sym).should be_true
        @pg.send("#{st}_field").should eq(p)
      end
    end

    it "should allow creation of preference using method missing" do
      p = @pg.blah
      @pg.preference_keys.should include(:blah)
      @pg.preferences.should include(p)
      p.name.should eq("blah")
      @pg.respond_to?(:blah).should be_true
      @pg.blah.should eq(p)

      q = @pg.some_pref data_type: :boolean
      @pg.preferences.should include(q)
      @pg.preference_keys.should include(:some_pref)
      q.name.should eq("some_pref")
      q.data_type.should eq(:boolean)
      @pg.respond_to?(:some_pref).should be_true
      @pg.some_pref.should eq(q)

    end

  end

end
