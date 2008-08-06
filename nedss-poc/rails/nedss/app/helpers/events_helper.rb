require 'csv'
require 'ostruct'

module EventsHelper
  
  def core_element(attribute, form_builder, css_class, &block)
    concat("<span class='#{css_class}'>", block.binding)
    yield
    concat("</span>", block.binding)
    unless (@event.nil? || @event.form_references.nil?)        
      @event.form_references.each do |form_reference|
        configs = form_reference.form.form_element_cache.all_cached_field_configs_by_core_path("#{form_builder.object_name}[#{attribute}]")
        configs.each do |config|
          concat(render_investigator_view(config, @event_form, form_reference.form), block.binding)
        end
      end
    end
  end
  
  def render_core_data_element(element)
    question = element.question
    field_name = question.core_data_attr
    model_name = "@" + field_name.gsub("[", ".").gsub("]", "")
    id = field_name.chop.gsub(/[\[\]]/, "_") 
    data_type = Event.exposed_attributes[field_name][:type]
    value = eval model_name

    input_element = case data_type
    when :single_line_text
      text_field_tag(field_name, value, :id => id)
    when :text_area
      text_area_tag(field_name, value, :id => id)
    when :date
      calendar_date_select_tag(field_name, value, :id => id)
    end

    content_tag(:label) do
      question.question_text + " " + input_element
    end
    
  end
  
  def render_investigator_view(view, f, form=nil)
    result = ""
    
    form_elements_cache = form.nil? ? FormElementCache.new(view) : form.form_element_cache
    
    form_elements_cache.children(view).each do |element|
      result += render_investigator_element(form_elements_cache, element, f)
    end
    
    result
  end
  
  def add_lab_link(name)
    link_to_function name do |page|
      page.insert_html :bottom, "labs", :partial => 'lab' , :object => Participation.new_lab_participation
    end
  end

  def add_hospital_link(name)
    link_to_function name do |page|
      page.insert_html :bottom, "hospitals", :partial => 'hospital' , :object => Participation.new_hospital_participation
    end
  end

  def add_diagnostic_link(name)
    link_to_function name do |page|
      page.insert_html :bottom, "diagnostics", :partial => 'diagnostic' , :object => Participation.new_diagnostic_participation
    end
  end

  def basic_controls(event, jurisdiction)
    controls = link_to('Show', cmr_path(event)) + " | "
    controls += (link_to('Edit', edit_cmr_path(event), :id => "edit_cmr_link") + " | ") if User.current_user.is_entitled_to_in?(:update_event, jurisdiction.entity_id)
    controls += link_to('Print', formatted_cmr_path(event, "print") , :target => "_blank") + " | "
    controls += link_to('Export to CSV', cmr_path(event) + '.csv')
  end

  def state_controls(event, jurisdiction)
    controls = ""
    if User.current_user.is_entitled_to_in?(:accept_event_for_lhd, jurisdiction.entity_id) && 
        (event.event_status_id ==  ExternalCode.find_by_code_name_and_the_code('eventstatus', "ASGD-LHD").id)
      controls += form_tag(state_cmr_path(event))
      controls += "<span>Accept CMR&nbsp;</span>" 
      controls += select_tag("state", options_for_select({'Accept' => 'ACPTD-LHD', 'Reject' => 'RJCTD-LHD'}), :onchange => "this.form.submit()")
      controls += "</form>"
    end
    if User.current_user.is_entitled_to_in?(:accept_event_for_investigation, jurisdiction.entity_id) && 
        (event.event_status_id ==  ExternalCode.find_by_code_name_and_the_code('eventstatus', "ASGD-INV").id)
      controls += "TBD: &nbsp;&nbsp;" + "Accept/Reject for investigation"
    end
    if User.current_user.is_entitled_to_in?(:update_event, jurisdiction.entity_id) && 
        (event.event_status_id ==  ExternalCode.find_by_code_name_and_the_code('eventstatus', "UI").id)
      controls += "TBD: &nbsp;&nbsp;" + "Mark investigation complete"
    end
    if User.current_user.is_entitled_to_in?(:approve_event_at_lhd, jurisdiction.entity_id) && 
        (event.event_status_id ==  ExternalCode.find_by_code_name_and_the_code('eventstatus', "IC").id)
      controls += "TBD: &nbsp;&nbsp;" + "Approve and send to state"
    end
    if User.current_user.is_entitled_to_in?(:approve_event_at_state, jurisdiction.entity_id) && 
        (event.event_status_id ==  ExternalCode.find_by_code_name_and_the_code('eventstatus', "APP-LHD").id)
      controls += "TBD: &nbsp;&nbsp;" + "Approve and close"
    end
    controls
  end

  def routing_controls(event, jurisdiction)
    controls = ""
    if User.current_user.is_entitled_to_in?(:route_event_to_any_lhd, jurisdiction.entity_id)
      jurisdictions = User.current_user.jurisdictions_for_privilege(:create_event)
      controls += form_tag(jurisdiction_cmr_path(event))
      controls += "<span>Route to:&nbsp;</span>" 
      controls += select_tag("jurisdiction_id", options_from_collection_for_select(jurisdictions, :entity_id, :name), :onchange => "this.form.submit()")
      controls += "</form>"
    end
    if User.current_user.is_entitled_to_in?(:route_event_to_investigator, jurisdiction.entity_id) && 
        (event.event_status_id ==  ExternalCode.find_by_code_name_and_the_code('eventstatus', "ACPTD-LHD").id)
      controls += "TO BE DONE:&nbsp;&nbsp;" + "Route to investigator"
    end
    controls
  end

  def new_cmr_link(text)
    link_to(text, new_cmr_path) if User.current_user.is_entitled_to?(:create_event)
  end

  def new_cmr_button(text)
    button_to(text, {:action => "new"}, { :method => :get }) if User.current_user.is_entitled_to?(:create_event)
  end

  private
  
  def render_investigator_element(form_elements_cache, element, f)
    result = ""
    
    case element.class.name
   
    when "SectionElement"
      result += render_investigator_section(form_elements_cache, element, f)
    when "GroupElement"
      result += render_investigator_group(form_elements_cache, element, f)
    when "QuestionElement"
      result += render_investigator_question(form_elements_cache, element, f)
    when "FollowUpElement"
      result += render_investigator_follow_up(form_elements_cache, element, f)
    end
    
    result
  end
  
  def render_investigator_section(form_elements_cache, element, f)
    result = "<br/>"
    section_id = "section_investigate_#{element.id}";
    hide_id = section_id + "_hide";
    show_id = section_id + "_show"
    result +=  "<fieldset class='form_section'>"
    result += "<legend>#{element.name} "
    result += "<span id='#{hide_id}' onClick=\"Element.hide('#{section_id}'); Element.hide('#{hide_id}'); Element.show('#{show_id}'); return false;\">[Hide]</span>"
    result += "<span id='#{show_id}' onClick=\"Element.show('#{section_id}'); Element.hide('#{show_id }'); Element.show('#{hide_id}'); return false;\" style='display: none;'>[Show]</span>"
    result += "</legend>"
    result += "<div id='#{section_id}'>"
    
    section_children = form_elements_cache.children(element)
    
    if section_children.size > 0
      section_children.each do |child|
        result += render_investigator_element(form_elements_cache, child, f)
      end
    end
    
    result += "</div></fieldset><br/>"
    
    result
  end
  
  def render_investigator_group(form_elements_cache, element, f)
    result = ""

    group_children = form_elements_cache.children(element)
    
    if group_children.size > 0
      group_children.each do |child|
        result += render_investigator_element(form_elements_cache, child, f)
      end
    end

    result
  end

  def render_investigator_question(form_elements_cache, element, f)
    
    result = "<div id='question_investigate_#{element.id}'>"
    
    @answer_object = @event.get_or_initialize_answer(element.question.id)
     
    if (f.nil?)
      result += fields_for(@event) do |f|
        f.fields_for(:new_answers, @answer_object, :builder => ExtendedFormBuilder) do |answer_template|
          answer_template.dynamic_question(form_elements_cache, element, "", {:id => "investigator_answer_#{element.id}"})
        end
      end
    else
      prefix = @answer_object.new_record? ? "new_answers" : "answers"
      index = @answer_object.new_record? ? "" : @form_index += 1
      result += f.fields_for(prefix, @answer_object, :builder => ExtendedFormBuilder) do |answer_template|
        answer_template.dynamic_question(form_elements_cache, element, index, {:id => "investigator_answer_#{element.id}"})
      end
    end

    follow_up_group = element.process_condition(@answer_object, @event.id, form_elements_cache)
      
    unless follow_up_group.nil?
      result += "<div id='follow_up_investigate_#{element.id}'>"
      result += render_investigator_follow_up(form_elements_cache, follow_up_group, f)
      result += "</div>"
    else
      result += "<div id='follow_up_investigate_#{element.id}'></div>"
    end
    
    result += "</div>"
    
    result
  end
  
  def render_investigator_follow_up(form_elements_cache, element, f)
    result = ""
    
    unless element.core_path.blank?
      result += render_investigator_core_follow_up(form_elements_cache, element, f) unless element.core_path.blank?
      return result
    end
    
    questions = form_elements_cache.children(element)
    
    if questions.size > 0
      questions.each do |child|
        result += render_investigator_question(form_elements_cache, child, f)
      end
    end

    result
  end
  
  def render_investigator_core_follow_up(form_elements_cache, element, f, ajax_render =false)
    result = ""
    
    include_children = false
    
    unless (ajax_render)
      # Debt: Replace with shorter eval technique
      core_path_with_dots = element.core_path.sub("morbidity_event[", "").gsub(/\]/, "").gsub(/\[/, ".")
      core_value = @event
      core_path_with_dots.split(".").each do |method|
        begin
          core_value = core_value.send(method)
        rescue
          break
        end
        
      end

      if (element.condition == core_value.to_s)
        include_children = true
      end
    end
    
    result += "<div id='follow_up_investigate_#{element.id}'>" unless ajax_render
    
    if (include_children || ajax_render)
      questions = form_elements_cache.children(element)
    
      if questions.size > 0
        questions.each do |child|
          result += render_investigator_question(form_elements_cache, child, f)
        end
      end
    end

    result += "</div>" unless ajax_render
    
    result
  end

  # renders events as csv. Optional block gives you the opportunity to
  # handle each event before it is converted to csv. This is handy for
  # looking up an actual event from a set of find_by_sql records.
  def render_events_csv(events, &proc)
    Exporters::Csv::Event.export(events, &proc)
  end
  
end
