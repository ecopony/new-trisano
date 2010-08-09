module EventsSpecHelper

  def given_a_morb_with_disease(disease)
    Factory.create(:morbidity_event, :disease_event => Factory.create(:disease_event, :disease => disease))
  end
  
  def given_a_contact_for_morb(morb, options={})
    returning Factory.create(:contact_event, options) do |contact|
      contact.update_attributes!(:parent_event => morb)
    end
  end

end
