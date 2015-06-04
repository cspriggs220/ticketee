require 'rails_helper'

RSpec.feature 'Viewing tickets' do
	before do
		author = FactoryGirl.create(:user)

		sublime = FactoryGirl.create(:project, name: 'Sublime Text 3')
		assign_role!(author, :viewer, sublime)
		FactoryGirl.create(:ticket,
			project: sublime,
			author: author,
			title: 'Make it shiny!',
			description: 'Gradients! Starbursts! Oh my!')

		ie = FactoryGirl.create(:project, name: "Internet Explorer")
		assign_role!(author, :viewer, ie)
		FactoryGirl.create(:ticket,
			project: ie,
			author: author,
			title: "Standards comlicance",
			description: "Isn't a joke.")

		login_as(author)
		visit "/"
	end

	scenario 'for a given project' do
		click_link 'Sublime Text 3'

		expect(page).to have_content('Make it shiny!')
		expect(page).to_not have_content('Standards compliance')
		click_link 'Make it shiny'
		within("#ticket h2") do
			expect(page).to have_content("Make it shiny!")
		end

		expect(page).to have_content("Gradients! Starbursts! Oh my!")
	end
end

