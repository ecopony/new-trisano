Then /^I should see help text for all (.*) event core fields$/ do |type|
  core_fields = CoreField.event_fields("#{type}_event").values.each do |core_field|
    next if core_field.disease_specific or core_field.container?
    response.should have_tag("span#core_help_text_#{core_field.id}")
  end
end

Then /^I should see all the core fields$/ do
  CoreField.all(:conditions => ['field_type != ?', 'event']).each do |cf|
    response.should have_tag('a', cf.name)
  end
end

Given /^a disease specific core field$/i do
  @core_field = Factory.create(:cmr_core_field, :disease_specific => true)
end
