require 'rails_helper'

RSpec.describe 'Entities', type: :system do
  include Devise::Test::IntegrationHelpers
  before do
    driven_by(:rack_test)
    @user = User.create(name: 'Toussaint Saraza', password: '12345678', email: 'try@gmail.com')
    @group = @user.groups.create(name: 'Birthday', icon: 'https://google.com')
    @entity = @user.entities.create(name: 'Samsung', amount: 20.0)
    @group_entity = @entity.group_entities.create(group_id: @group.id, entity_id: @entity.id)
    sign_in @user
  end
  bundle exec rspec
  it 'should show correct entity ' do
    visit group_entities_path(@group)
    expect(page).to have_content(@entity.name)
  end

  it 'should have the correct amount' do
    visit group_entities_path(@group)
    expect(page).to have_content(@entity.amount)
  end

  it 'should redirect to add new transaction' do
    visit group_entities_path(@group)
    click_on 'Add Transaction'
    expect(page).to have_current_path(new_group_entity_path(@group))
  end
end
