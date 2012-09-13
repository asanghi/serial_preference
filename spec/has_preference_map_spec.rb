require 'spec_helper'


describe HasPreferenceMap do
  
  class DummyClass < ActiveRecord::Base
    include HasPreferenceMap
    preference_map :preferences do
      preference :taxable, data_type: :boolean, required: true, label: "Taxable?", hint: "Is this business taxable?"
      preference :vat_no, required: false, label: "VAT"
      preference :max_invoice_items, data_type: :integer
      preference_group :ledgers, label: "Preferred Ledgers" do
        income_ledger_id data_type: :integer, default: 1
      end
    end
  end


  context "default behaviour" do
    it "should return blank array by preference_for method for non existing group " do
      DummyClass.preferences_for("fsdafj").should eq([])
    end
    it "should return blank array by preference_groups method for non existing group " do
      DummyClass.preference_groups.should eq([])
    end
    it "should return :preferences_dummy_classes as a preference_context of dummy class" do
      DummyClass.preference_context.should eq(:preferences_dummy_classes)
    end
    it "should return :preferences by default as a preference_storage_attribute" do
      DummyClass.preference_storage_attribute.should eq(:preferences)
    end 
    it "should return on default_preference_for method" do
      debugger
      DummyClass.default_preference_for("fsdafj").should eq(nil)
    end 
  end
  
end  
