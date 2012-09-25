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
      DummyClass.new.respond_to?(:taxable?)
    end
  end

  context "Validations behaviour" do
    it "should be return correct validation" do
      d = DummyClass.new
      d.respond_to?(:_validators)
      d._validators.should be_kind_of(Hash)
      d._validators[:taxable].should be_kind_of(Array)
      d._validators[:max_invoice_items].should be_kind_of(Array)
      d._validators[:income_ledger_id].should be_kind_of(Array)
      d._validators[:taxable][0].options.should eq({})
      d._validators[:max_invoice_items][0].options.should eq({:allow_blank=>true})
      d._validators[:income_ledger_id][0].options.should eq({:allow_blank=>true})
    end
  end
end
