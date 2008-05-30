class FormsController < AdminController
  # GET /forms
  # GET /forms.xml
  def index
    @forms = Form.find(:all, :conditions => {:is_template => true})

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @forms }
    end
  end

  # GET /forms/1
  # GET /forms/1.xml
  def show
    @form = Form.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @form }
    end
  end

  # GET /forms/new
  # GET /forms/new.xml
  def new
    @form = Form.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @form }
    end
  end

  # GET /forms/1/edit
  def edit
    @form = Form.find(params[:id])
  end

  # POST /forms
  # POST /forms.xml
  def create
    @form = Form.new(params[:form])

    respond_to do |format|
      if @form.save_and_initialize_form_elements
        flash[:notice] = 'Form was successfully created.'
        format.html { redirect_to(@form) }
        format.xml  { render :xml => @form, :status => :created, :location => @form }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @form.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /forms/1
  # PUT /forms/1.xml
  def update
    @form = Form.find(params[:id])

    respond_to do |format|
      if @form.update_attributes(params[:form])
        flash[:notice] = 'Form was successfully updated.'
        format.html { redirect_to(@form) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @form.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /forms/1
  # DELETE /forms/1.xml
  def destroy
    @form = Form.find(params[:id])
    @form.destroy

    respond_to do |format|
      format.html { redirect_to(forms_url) }
      format.xml  { head :ok }
    end
  end
  
  def builder
    @form = Form.find(params[:id])
    @library_elements = FormElement.roots(:conditions => ["form_id IS NULL"])

    respond_to do |format|
      format.html { render :template => "forms/builder" }
    end
  end
  
  def publish
    @form = Form.find(params[:id])
    begin
      @form.publish!
      respond_to do |format|
        flash[:notice] = "Form was successfully published"
        format.html { redirect_to forms_path }
      end
    rescue Exception => ex
      logger.debug ex
      flash[:notice] = "Unable to publish the form at this time"
      format.html { render :template => "forms/builder" }
    end
  end
  
  def order_section_children
    begin
      @section = FormElement.find(params[:id])
      section_name, section_items = params.find { |k, v| k =~ /children$/ }
      reorder_ids = section_items.collect {|id| id.to_i}
      @section.reorder_children reorder_ids
      flash[:notice] = 'The form elements were successfully reordered.'
      @form = Form.find(@section.form_id)
    rescue Exception => ex
      logger.debug ex
      flash[:notice] = 'An error occurred during the reordering process.'
      render :template => 'rjs-error'
    end
  end
  
  def to_library
    element_id = params[:id].split("_")[1]
    @form_element = FormElement.find(element_id)
    if @form_element.add_to_library
      @library_elements = FormElement.roots(:conditions => ["form_id IS NULL"])
      render :partial => "library_elements"
    else
      flash[:notice] = "Unable to copy #{@form_element.type.humanzie} to library."
      render :template => 'rjs-error'
    end
  end

  def from_library
    parent_id = params[:id]
    lib_element_id = params[:lib_element_id]
    @form_element = FormElement.find(parent_id)
    if @form_element.copy_from_library(lib_element_id)
      @form = Form.find(@form_element.form_id)
      render :partial => "elements"
    else
      flash[:notice] = "Unable to copy element to form."
      render :template => 'rjs-error'
    end
  end

end
