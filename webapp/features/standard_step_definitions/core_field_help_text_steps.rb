Then /^I should see help text for all (.*) event core fields$/ do |type|
  core_fields = CoreField.event_fields("#{type}_event").values.reject(&:disease_specific)
  core_fields.each do |cf|
    response.should have_tag("span#core_help_text_#{cf.id}")
  end
end
