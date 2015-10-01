require 'spec_helper'

describe SerialPreference::PreferenceDefinition do

  before do
    @blank_pref = described_class.new("whatever")
  end

  it "should have proper accessors" do
    [:data_type, :name, :default, :required, :field_type].each do |a|
      @blank_pref.respond_to?(a).should be_truthy
    end
  end

  it "should declare supported data types" do
    described_class.constants.should include(:SUPPORTED_TYPES)
  end

  it "should stringify its name" do
    described_class.new(:whatever).name.should eq("whatever")
  end

  context "required behaviour" do
    it "should not be required when no required option provided" do
      @blank_pref.should_not be_required
    end

    it "should be required when required option is truthy" do
      [0,"yes","no","false",true].each do |truthy_values|
        p = described_class.new("whatever",{required: truthy_values})
        p.should be_required
      end
    end

    it "should not be required when required option is falsy" do
      [false,nil].each do |falsy_values|
        p = described_class.new("whatever",{required: falsy_values})
        p.should_not be_required
      end
    end
  end

  context "numericality behaviour" do
    it "should not be numerical when no data_type is provided" do
      @blank_pref.should_not be_numerical
    end

    it "should be numerical when data_type is numerical" do
      [:integer,:float,:decimal].each do |dt|
        described_class.new("whatever",{data_type: dt}).should be_numerical
      end
    end

    it "should be not numerical when data_type is non numerical" do
      [:string,:boolean,:password,:whatever].each do |dt|
        described_class.new("whatever",{data_type: dt}).should_not be_numerical
      end
    end
  end

  context "default behaviour" do
    it "should report correct name" do
      @blank_pref.name.should eq("whatever")
    end
    it "should be a string" do
      @blank_pref.data_type.should eq(:string)
    end
    it "should have nil default" do
      @blank_pref.default.should be_nil
    end
    it "should be false for required" do
      @blank_pref.required.should be_falsy
    end
    it "should have string field_type" do
      @blank_pref.field_type.should eq(:string)
    end
  end

  context "field_type behaviour" do
    it "should report field_type as provided" do
      described_class.new("whatever",{field_type: :xyz}).field_type.should eq(:xyz)
    end
    it "should report string for numerical data types" do
      described_class.new("whatever",{data_type: :integer}).field_type.should eq(:string)
    end
    it "should report data type for non numeric data types" do
      p = described_class.new("whatever",{data_type: :xyz})
      p.field_type.should eq(p.data_type)
    end
  end

  context "should report correct preferred values" do

    context "when input is nil" do
      it "should report nil when no default is given" do
        @blank_pref.value(nil).should be_nil
      end

      it "should report default when input is nil" do
        p = described_class.new("whatever",{default: "dog"})
        p.value(nil).should eq("dog")
      end

      it "should report default in appropriate data type when input is nil" do
        p = described_class.new("whatever",{default: "dog", data_type: :integer})
        p.value(nil).should eq("dog".to_i)
      end
    end

    context "should report correct string/password values" do
      before do
        @preference = described_class.new("whatever",{data_type: :string})
      end

      it "should return correct strings as passthru" do
        ["",3.0,[],{},"dog",1].each do |input_val|
          @preference.value(input_val).should eq(input_val.to_s)
        end
      end

    end

    context "should report correct integer values" do
      before do
        @preference = described_class.new("whatever",{data_type: :integer})
      end

      it "should return correct integers" do
        ["",1,3.0,"dog"].each do |input_val|
          @preference.value(input_val).should eq(input_val.to_i)
        end
      end

      it "should report nil for non numeric input" do
        [[],{}].each do |input_val|
          @preference.value(input_val).should be_nil
        end
      end
    end

    context "should report correct floaty/real values" do
      before do
        @preference = described_class.new("whatever",{data_type: :float})
      end

      it "should return correct floats" do
        ["",1,3.0,"dog"].each do |input_val|
          @preference.value(input_val).should eq(input_val.to_f)
        end
      end

      it "should report nil for non numeric input" do
        [[],{}].each do |input_val|
          @preference.value(input_val).should be_nil
        end
      end
    end

    context "should report correct boolean values" do
      before do
        @preference = described_class.new("whatever",{data_type: :boolean})
      end
      it "should report false for falsy values" do
        [nil,false].each do |falsy|
          @preference.value(falsy).should be_falsy
        end
      end

      it "should report false for false looking values" do
        [0,"0","false","FALSE","False","no","NO","No"].each do |falsy|
          @preference.value(falsy).should be_falsy
        end
      end

      it "should report true for truthy values" do
        ["yes",true,100,0.1,[],{}].each do |truthy_value|
          @preference.value(truthy_value).should be_truthy
        end
      end
    end

  end

end
