require 'rails_helper'


describe Setting, type: :model do

	it "doesn't allow to create new records" do
		setting  = FactoryGirl.build :setting

		expect(setting.save).to be(false)
		expect(setting.errors.messages).to include(:base=>["there can only be one row in this table, and it already exists"])
	end

	it 'fetches settings' do
		expect(Setting.i.tax_in_percentage).to eq(5)
	end

	it 'validates and updates tax percentage' do
		settings = Setting.i
		expect( settings.update(tax_in_percentage: 120) ).to be(false)
		expect( settings.errors.messages ).to include(:tax_in_percentage=>["must be less than or equal to 100"])

		expect( settings.update(tax_in_percentage: 15.45) ).to be(true)
		expect( settings.tax_in_percentage ).to eq(15.45)
	end







end



