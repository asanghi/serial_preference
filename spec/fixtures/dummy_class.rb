class DummyClass < ActiveRecord::Base
  include SerialPreference::HasSerialPreferences
  preferences do
    preference :taxable, data_type: :boolean, required: true, default: true
    preference :required_number, data_type: :integer, required: :true
    preference :vat_no, required: false
    preference :max_invoice_items, data_type: :integer
    preference_group "Preferred Ledgers" do
      income_ledger_id data_type: :integer, default: 1
      creditable data_type: :boolean, default: false
    end
  end
end
