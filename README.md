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

````ruby
    class Company < ActiveRecord::Base

      include SerialPreference::HasSerialPreferences

      preferences do

        preference :taxable data_type: :boolean, required: true
        preference :vat_no required: false
        preference :max_invoice_items data_type: :integer

        float :rate_of_interest

        # default data type is :string
        # if the preference is required, then a validation is added to the model
        # if the data type is numerical, then a numericality validation is added
        # preferences can be grouped in preference groups

        preference_group "Preferred Ledgers" do
          income_ledger_id data_type: :integer, default: 1
        end

        password field_type: :password

      end

    end
````

* Fetching Preference/Groups

````ruby
    # something you can customize in your form perhaps?
    Company.preference_groups.each do |pg| # => returns an array of preference groups
      # pg.name => Name of Preference Group as specified in map e.g. Preferred Ledgers
      # pg.preferences => Array of Preference Definitions
      pg.preferences.each do |preference|
        # preference => PreferenceDefinition
        f.input preference.name, required: preference.required?, placeholder: preference.default, as: preference.field_type
      end
    end
````

````ruby
    # List of Preferences
    Company.preference_names # => [:income_ledger_id]
````

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Build Status

* [![Build Status](https://travis-ci.org/asanghi/serial_preference.svg?branch=master)](https://travis-ci.org/asanghi/serial_preference)
