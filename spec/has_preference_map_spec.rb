require 'spec_helper'
describe SerialPreference::HasSerialPreferences do

  before do
    class DummyClass
      include SerialPreference::Preferenzer
      preference_map :settings do
        preference_group :general_settings do
          company_name_in_hi :label => "Company Name in Hindi"
          records_per_page :data_type => :integer, :default => 10
          financial_year_start :data_type => :integer, :default => 2005
          advocate_name_in_hi :label => "Advocate's Name in Hindi"
          cao_name_in_hi :label => "CAO Name in Hindi"
          cao_mobile_no :label => "CAO Mobile Number"
          area_based_sequences :data_type => :boolean, :label => "Use Area Based Sequences?"
          display_irr_roi_in_amortization_receipt_pdf :data_type => :boolean, :label => "Display IRR in Amortization Receipt PDF?"
        end
        preference_group :charges do
          over_due_charges_percent :data_type => :float, :default => 48.0, :label => "Overdue Charges %"
          rebate_percent :data_type => :float, :default => 4.0, :label => "Rebate %"
          over_due_flat_charges :data_type => :float, :default => 0.0, :label => "Overdue Flat Charges"
        end
        preference_group :case_closure do
          cash_ledger_charges_check_at_loan_closure :data_type => :boolean, :label => "Check Cash Loan Ledger on Closure?"
          cash_access_income_closure_settlement_ledger :label => "Cash Access Income Closure Settlement Ledger"
          hyp_ledger_charges_check_at_loan_closure :data_type => :boolean, :label => "Check Hypo Loan Ledger on Closure?"
          hyp_access_income_closure_settlement_ledger :label => "Hypo Access Income Closure Settlement Ledger"
          home_ledger_charges_check_at_loan_closure :data_type => :boolean, :label => "Check Home Loan Ledger on Closure?"
          home_access_income_closure_settlement_ledger :label => "Home Access Income Closure Settlement Ledger"
        end
        preference_group :fully_flexible_plan_settings do
          fully_flexible_min_finance_amount :data_type => :float, :label => "Minimum Finance Amount", :default => 1000.0
          fully_flexible_max_finance_amount :data_type => :float, :label => "Maximum Finance Amount", :default => 10_000_000.0
          fully_flexible_min_tenure :data_type => :integer, :label => "Minimum Tenure", :default => 0
          fully_flexible_max_tenure :data_type => :integer, :label => "Maximum Tenure", :default => 120
          fully_flexible_min_rate_of_interest :data_type => :float, :label => "Minimum Rate of Interest", :default => 0
          fully_flexible_max_rate_of_interest :data_type => :float, :label => "Maximum Rate of Interest", :default => 90
        end
        preference_group :account_heads do
          [:sundry_creditor,:bank_accounts,:cash_in_hand,:hp_stock,:hire_money,:income_from_business,:expense_from_business,:current_liabilities,:current_assets].each do |code|
            string "#{code}_acc_head_code".to_sym, :label => "#{code.to_s.titleize}"
          end
        end
        preference_group :reference_data do
          vehicle_type :hint => "List of Vehicle Types, separated by :", :label => "Vehicle Types"
          vehicle_category :hint => "List of Vehicle Categories, separated by :", :label => "Vehicle Categories"
          vehicle_sub_category :hint => "List of Vehicle Sub Categories, separated by :", :label => "Vehicle Sub Categories"
        end
        preference_group :misc_ledgers, :label => "Miscellaneous Ledgers" do
          addition_charges :label => "Additional Charges", :hint => "Enter Ledger Code"
          advance_insurance :hint => "Enter Ledger Code"
          cash_disbursement :hint => "Enter Ledger Code"
          cash_ledger_code :hint => "Enter Ledger Code"
          cheque_in_transit :hint => "Enter Ledger Code"
          reserves_surplus :hint => "Enter Ledger Code"
          statement_charges :hint => "Enter Ledger Code"
        end
        l = [:loan_case_stock,:loan_hire_money,:hire_money_overdue,:ledger_charges_overdue,
         :ledger_charges,:bank_bounce_charges,:loan_rebate,:loan_hire_charge_unearned,
         :loan_earned_interest, :loan_upfront_int]
        preference_group :hypo_ledgers, :label => "Hypo Ledgers" do
          l.each do |s|
            string "hyp_#{s}", :label => "Hypo #{s.to_s.titleize}", :hint => "Enter Ledger Code"
          end
        end
        preference_group :cash_ledgers, :label => "Cash Ledgers" do
          l.each do |s|
            string "cash_#{s}".to_sym, :label => "Cash #{s.to_s.titleize}", :hint => "Enter Ledger Code"
          end
        end
        preference_group :home_loan_ledgers, :label => "Home Loan Ledgers" do
          l.each do |s|
            string "home_#{s}".to_sym, :label => "Home Loan #{s.to_s.titleize}", :hint => "Enter Ledger Code"
          end
        end
        preference_group :weekly_ledgers, :label => "Weekly Ledgers" do
          l.each do |s|
            string "weekly_#{s}".to_sym, :label => "Weekly #{s.to_s.titleize}", :hint => "Enter Ledger Code"
          end
        end
        preference_group :hire_purchase_ledgers, :label => "Hire Purchase Ledgers" do
          l.each do |s|
            string "hire_purchase_#{s}".to_sym, :label => "Hire Purchase #{s.to_s.titleize}", :hint => "Enter Ledger Code"
          end
        end
        preference_group :hire_purchase_ledgers, :label => "Hire Purchase Ledgers" do
          l.each do |s|
            string "hire_purchase_#{s}".to_sym, :label => "Hire Purchase #{s.to_s.titleize}", :hint => "Enter Ledger Code"
          end
        end
        preference_group :fd_ledgers, :label => "FD Ledgers" do
          public_fixed_deposit :hint => "Enter Ledger Code"
          employee_fixed_deposit :hint => "Enter Ledger Code"
          shareholder_fixed_deposit :hint => "Enter Ledger Code"
          directors_fixed_deposit :hint => "Enter Ledger Code"
          nri_fixed_deposit :hint => "Enter Ledger Code", :label => "NRI Fixed Deposit"

          public_interest_payable_on_fd :label => "Public Interest Payable on FD", :hint => "Enter Ledger Code"
          employee_interest_payable_on_fd :label => "Employee Interest Payable on FD", :hint => "Enter Ledger Code"
          shareholder_interest_payable_on_fd :label => "Shareholder Interest Payable on FD", :hint => "Enter Ledger Code"
          directors_interest_payable_on_fd :label => "Directors Interest Payable on FD", :hint => "Enter Ledger Code"
          nri_interest_payable_on_fd :label => "NRI Interest Payable on FD", :hint => "Enter Ledger Code"

          public_interest_on_fd :label => "Public Interest on FD", :hint => "Enter Ledger Code"
          employee_interest_on_fd :label => "Employee Interest on FD", :hint => "Enter Ledger Code"
          shareholder_interest_on_fd :label => "Shareholder Interest on FD", :hint => "Enter Ledger Code"
          directors_interest_on_fd :label => "Directors Interest on FD", :hint => "Enter Ledger Code"
          nri_interest_on_fd :label => "NRI Interest on FD", :hint => "Enter Ledger Code"

          matured_fd :label => "Matured FD", :hint => "Enter Ledger Code"
          tds_on_fixed_deposit :label => "TDS on FD", :hint => "Enter Ledger Code"
        end
        preference_group :default_voucher_narration do
          adv_emi_voucher_text :default => "Installment Due", :label => "Advance EMI Voucher"
          future_emi_voucher_text :default => "Being Installment Due", :label => "Future EMI Voucher"
          pdc_post_voucher_text :default => "Cheque in posting", :label => "PDC Posting Voucher"
          pdc_undo_post_voucher_text :default => "Undo Cheque Posting", :label => "PDC Undo Posting Voucher"
          pdc_bounce_voucher_text :default => "Bounce Posting", :label => "PDC Bouncing Voucher"
          pdc_clear_voucher_text :default => "Clear Installment", :label => "PDC Clearance Voucher"
          foreclosure_voucher_text :default => "Closed Loan Case", :label => "Foreclosure Voucher"
          initial_voucher_text :default => "Amount Financed", :label => "Initial Voucher"
          fd_interest_payment_voucher_text :default => "FD Interest Payment Voucher", :label => "FD Interest Payment Voucher"
          fd_tds_on_interest_voucher_text :default => "FD TDS On Interest Voucher", :label => "FD TDS Interest Voucher"
        end
        preference_group :tds_settings, :label => "TDS Settings" do
          deduct_rate_of_interest_on_fore_close :data_type => :integer, :default => 2, :label => "Deduction Rate of Interest on Foreclosure"
          total_days_per_year :data_type => :integer, :default => 364, :label => "Days Per Year for TDS"
          tds_on_minimum_interest :data_type => :float, :default => 5000.0, :label => "TDS deduction threshold", :hint => "Min interest on which TDS is deducted"
          minimum_age_for_senior_citizen :data_type => :integer, :default => 60
          surcharge_on_tds :data_type => :integer, :default => 3, :label => "Surcharge % on TDS"
          resident_tds_percent :data_type => :integer, :default => 10, :label => "TDS Rate for Residents"
          non_resident_tds_percent :data_type => :integer, :default => 10, :label => "TDS Rate for NRIs"
          domestic_comp_tds_percent :data_type => :integer, :default => 10, :label => "TDS Rate for Domestic Comp"
        end
        preference_group :security_settings do
          enable_working_hours :data_type => :boolean, :default => true
          minimum_working_hour :data_type => :integer, :default => 7
          maximum_working_hour :data_type => :integer, :default => 23
          maximum_login_attempts :data_type => :integer, :default => 14
        end
        preference_group :cibil_settings, :label => "CIBIL Settings" do
          cibil_reporting_member :label => "CIBIL Reporting Member"
          cibil_reporting_password :label => "CIBIL Reporting Password"
          cibil_short_name :label => "CIBIL Short Name"
        end
        preference_group :sms_settings, :label => "SMS Settings" do
          sms_enabled :data_type => :boolean, :default => false, :label => "Enable SMS?"
          sms_user :label => "SMS User", :hint => "Username to log into SMS provider"
          sms_password :label => "SMS Password", :hint => "Password to log into SMS provider"
          sms_sender :label => "SMS Sender Id", :hint => "SenderId for SMS provider"
          emi_due_notification_days :data_type => :integer, :label => "EMI Due Notification Days", :hint => "Number of days before EMI due to send SMS notification"
        end
      end
    end
  end

end
