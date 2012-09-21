require 'spec_helper'
describe SerialPreference::HasSerialPreferences do

  before do
    class DummyClass
      include ActiveRecord::AttributeMethods::Serialization
      include ActiveRecord::Validations
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
  end

  context "class methods behaviour" do
    it "should be access through _preference_map attribute" do
      DummyClass._preference_map.respond_to?(:all_preference_definitions)
      DummyClass._preference_map.respond_to?(:all_preference_names)
      DummyClass._preference_map.respond_to?(:all_groups)
      DummyClass._preference_map.respond_to?(:preference)
      DummyClass._preference_map.respond_to?(:preference_group)
    end
  end


  context "define method behaviour" do
    it "should be call through class instance" do
      DummyClass.new.respond_to?(:taxable?)
      DummyClass.new.respond_to?(:vat_no?)
      DummyClass.new.respond_to?(:max_invoice_items?)
      DummyClass.new.respond_to?(:income_ledger_id?)
      DummyClass.new.respond_to?(:taxable)
      DummyClass.new.respond_to?(:vat_no)
      DummyClass.new.respond_to?(:max_invoice_items)
      DummyClass.new.respond_to?(:income_ledger_id)
      DummyClass.new.respond_to?(:taxable=)
      DummyClass.new.respond_to?(:vat_no=)
      DummyClass.new.respond_to?(:max_invoice_items=)
      DummyClass.new.respond_to?(:income_ledger_id=)
    end
  end

  context "boolean behaviour" do
    it "should be return correct boolean behaviour" do
      DummyClass._preference_map.all_preference_definitions[0].respond_to?(:boolean?)
      DummyClass._preference_map.all_preference_definitions[1].respond_to?(:boolean?)
      DummyClass._preference_map.all_preference_definitions[2].respond_to?(:boolean?)
      DummyClass._preference_map.all_preference_definitions[3].respond_to?(:boolean?)
    end
  end

  context "numerical behaviour" do
    it "should be return correct numerical behaviour" do
      DummyClass._preference_map.all_preference_definitions[0].respond_to?(:numerical?)
      DummyClass._preference_map.all_preference_definitions[1].respond_to?(:numerical?)
      DummyClass._preference_map.all_preference_definitions[2].respond_to?(:numerical?)
      DummyClass._preference_map.all_preference_definitions[3].respond_to?(:numerical?)
    end
  end

  context "required behaviour" do
    it "should be return correct required behaviour" do
      DummyClass._preference_map.all_preference_definitions[0].respond_to?(:required?)
      DummyClass._preference_map.all_preference_definitions[1].respond_to?(:required?)
      DummyClass._preference_map.all_preference_definitions[2].respond_to?(:required?)
      DummyClass._preference_map.all_preference_definitions[3].respond_to?(:required?)
    end
  end
end
