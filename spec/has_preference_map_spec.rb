require 'spec_helper'
describe SerialPreference::HasSerialPreferences do

  before do
    class DummyClass < ActiveRecord::Base
      include SerialPreference::HasSerialPreferences
      preferences :settings do
        preference :taxable, data_type: :boolean, required: true, label: "Taxable?", hint: "Is this business taxable?"
        preference :vat_no, required: false, label: "VAT"
        preference :max_invoice_items, data_type: :integer
        preference_group :ledgers, label: "Preferred Ledgers" do
          income_ledger_id data_type: :integer, default: 1
        end
      end
    end
    class DefaultClass < ActiveRecord::Base
      include SerialPreference::HasSerialPreferences
      preferences  do
        preference :abc, hint: "DefaultClass"
      end
    end
  end

  context "default behaviour" do
    it "should return preferences as a default _preferences_attribute" do
      DefaultClass._preferences_attribute.should eq(:preferences)
    end
    it "should return settings as a _preferences_attribute" do
      DummyClass._preferences_attribute.should eq(:settings)
    end
    it "should be return an Object when _preference_map call" do
      DummyClass._preference_map.should be_kind_of(Object)
    end
    it "should be return a collection of array when all_preference_definitions call through _preference_map"  do
      DummyClass._preference_map.all_preference_definitions.should be_kind_of(Array)
    end
    it "should be return collection of array when all_preference_names method call" do
      DummyClass._preference_map.all_preference_names.should be_kind_of(Array)
    end
    it "should be return collection of array when all_preference_names method call" do
      DummyClass._preference_map.all_groups.should be_kind_of(Array)
    end
    it "should be return an Object when preference method call through _preference_map" do
      DummyClass._preference_map.preference("base").should be_kind_of(Object)
    end
    it "should be return an Object when preference method call through _preference_map" do
      DummyClass._preference_map.preference_groups.should be_kind_of(Array)
    end
  end

  context "all_preference_names behaviour" do
    it "should include all_preference_names" do
      DummyClass._preference_map.all_preference_names.should eq(["taxable", "vat_no", "max_invoice_items", "income_ledger_id", "base"])
      DefaultClass._preference_map.all_preference_names.should eq(["abc"])
    end
  end

  context "all_preference_definitions behaviour" do
    it "should be return correct label" do
      DummyClass._preference_map.all_preference_definitions[0].label.should eq("Taxable?")
      DummyClass._preference_map.all_preference_definitions[1].label.should eq("VAT")
    end
    it "should be correct hint" do
      DummyClass._preference_map.all_preference_definitions[0].hint.should eq("Is this business taxable?")
      DefaultClass._preference_map.all_preference_definitions[0].hint.should eq("DefaultClass")
    end
    it "should be correct data_type" do
      DummyClass._preference_map.all_preference_definitions[0].data_type.should eq(:boolean)
      DummyClass._preference_map.all_preference_definitions[1].data_type.should eq(:string)
      DummyClass._preference_map.all_preference_definitions[2].data_type.should eq(:integer)
      DummyClass._preference_map.all_preference_definitions[3].data_type.should eq(:integer)
    end
    it "should be return correct required value" do
      DummyClass._preference_map.all_preference_definitions[0].required.should eq(true)
      DummyClass._preference_map.all_preference_definitions[1].required.should eq(false)
    end
    it "should return correct default value" do
      DummyClass._preference_map.all_preference_definitions[3].default.should eq(1)
    end
  end

  context "all_groups behaviour" do
    it "should include all_groups" do
      DummyClass._preference_map.all_groups.should eq([:base, :ledgers])
      DefaultClass._preference_map.all_groups.should eq([:base])
    end
  end

  context "preference behaviour" do
    it "should be return correct name of given preference" do
      DummyClass._preference_map.preference("taxable").name.should eq("taxable")
      DefaultClass._preference_map.preference("abc").name.should eq("abc")
    end
  end 
end
