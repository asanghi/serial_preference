# SerialPreference

If you have a large number of settings/preferences on your model
(like a company or a businesss) and you store each preference in
a separate model or in separate columns on the model itself, it
gets hairy, quickly.

Additionally you require those settings/preferences to be read in
from a form and then you need an easy way to validate them too.

Personally, I found that putting settings in the database relationally
was hellish.

SerialPreference stores preferences serialized in a hash in your model.
All in one place with a DSL to define your settings along with validations
and other niceties.

Scratching my own itch.

## Installation

Add this line to your application's Gemfile:

    gem 'serial_preference'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install serial_preference

## Usage

    class Company < ActiveRecord::Base

      include SerialPreference::Preferencability # will change this

      preference_map :preferences do

        preference :taxable data_type: :boolean, required: true, label: "Taxable?", hint: "Is this business taxable?"
        preference :vat_no required: false, label: "VAT"
        preference :max_invoice_items data_type: :integer

        # default data type is :string
        # default label is name of preference titleized
        # if the preference is required, then a validation is added to the model
        # if the data type is numerical, then a numericality validation is added
        # preferences can be grouped in preference groups

        preference_group :ledgers, label: "Preferred Ledgers" do
          income_ledger_id data_type: :integer, default: 1
        end

        # Let me know what you think of this experimental new DSL?

        + :name_of_preference, data_type: :string
        + :name_of_another_preference, default: "Hello"

        * :name_of_preference_group, label: "Notifications" do
          + :email_delivery, data_type: :boolean, default: true
        end

      end

    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
