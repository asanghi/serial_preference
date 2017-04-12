require 'spec_helper'
require 'fixtures/dummy_class'
describe SerialPreference::HasSerialPreferences do

  before(:all) do
    rebuild_model
  end

  context "default behaviour" do
    it "should return preferences as a default _preferences_attribute" do
      expect(DummyClass._preferences_attribute).to eq(:preferences)
    end
    it "should return settings as a _preferences_attribute" do
      class OverriddenPreferenceAttributeClass < ActiveRecord::Base
        include SerialPreference::HasSerialPreferences
        preferences :settings  do
          preference :abc
        end
      end
      expect(OverriddenPreferenceAttributeClass._preferences_attribute).to eq(:settings)
    end
  end

  context "class methods behaviour" do
    it "should be possible to describe preference map thru preferences" do
      expect(DummyClass.respond_to?(:preferences)).to be_truthy
    end

    it "should be possble to retrieve preference groups from class" do
      expect(DummyClass.respond_to?(:preference_groups)).to be_truthy
    end

    it "should be possble to retrieve preference names from class" do
      expect(DummyClass.respond_to?(:preference_names)).to be_truthy
    end
  end


  context "should define accessors" do
    it "should have readers available" do
      d = DummyClass.new
      expect(d.respond_to?(:taxable)).to be_truthy
      expect(d.respond_to?(:vat_no)).to be_truthy
      expect(d.respond_to?(:max_invoice_items)).to be_truthy
      expect(d.respond_to?(:income_ledger_id)).to be_truthy
    end

    it "should ensure that the readers returns the correct data" do
      d = DummyClass.new
      d.preferences = {:vat_no => "abc"}
      expect(d.vat_no).to eq("abc")
    end

    it "should have writers available" do
      d = DummyClass.new
      expect(d.respond_to?(:taxable=)).to be_truthy
      expect(d.respond_to?(:vat_no=)).to be_truthy
      expect(d.respond_to?(:max_invoice_items=)).to be_truthy
      expect(d.respond_to?(:income_ledger_id=)).to be_truthy
    end

    it "should ensure that the writer write the correct data" do
      d = DummyClass.new
      d.vat_no = "abc"
      expect(d.vat_no).to eq("abc")
    end

    it "should ensure that the querier the correct data" do
      d = DummyClass.new
      d.taxable = true
      expect(d).to be_taxable
      d.taxable = false
      expect(d).to_not be_taxable
    end

    it "should have query methods available for booleans" do
      DummyClass.new.respond_to?(:taxable?)
    end

    it "should respond properly for default true preferences" do
      expect(DummyClass.new.taxable).to eq(true)
      expect(DummyClass.new.taxable?).to eq(true)
    end

    it "should respond properly for default false preferences" do
      expect(DummyClass.new.creditable).to eq(false)
      expect(DummyClass.new.creditable?).to eq(false)
    end

    it "should clear existing preference value" do
      d = DummyClass.new
      d.vat_no = "abc"
      expect(d.vat_no).to eq("abc")
      d.vat_no = nil
      expect(d.vat_no).to eq(nil)
    end
  end



=begin
  context "should define validations" do
    it "should define presence validation on required preferences" do
      d = DummyClass.new
      d.should validate_presence_of(:taxable)
    end

    it "should define presence and numericality on required preference which are numeric" do
      d = DummyClass.new
      d.taxable = true
      d.should validate_presence_of(:required_number)
      d.should validate_numericality_of(:required_number)
    end

    it "should define numericality on preference which are numeric" do
      d = DummyClass.new
      d.should validate_numericality_of(:required_number)
      d.should validate_numericality_of(:income_ledger_id)
    end
  end

=end

end
