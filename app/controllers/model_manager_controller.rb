class ModelManagerController < ApplicationController
  include ModelManagerHelper

  # Look at the requested url and get the class of the object we are trying to manage
  before_filter :discover_class

  # GET /foos
  def index
    @current_objects = @klass.all.paginate

    render :template => "/model_manager/index"
  end

  # GET /foos/12
  def show
    @current_object = @klass.find(params[:id])

    render :template => "/model_manager/show"
  end

  # GET /foos/new
  def new
    @current_object = @klass.new

    render :template => "/model_manager/new"
  end

  # POST /foos
  def create
    @current_object = @klass.new(params[@klass.to_s.underscore.to_sym])

    if @current_object.save
      path = self.send("#{@klass.to_s.underscore}_path", @current_object)
      redirect_to object_path(@current_object) and return
    end

    flash[:error] = "There was an error creating the #{human_name(@klass)}"
    render :template => "/model_manager/new"
  end

  # GET /foos/12/edit
  def edit
    @current_object = @klass.find(params[:id])
    render :template => "/model_manager/edit"
  end

  # PUT /foos/12
  def update
    @current_object = @klass.find(params[:id])

    if @current_object.update_attributes(params[@klass.to_s.underscore.to_sym])
      redirect_to object_path(@current_object) and return
    else
      flash[:error] = "There was an error updating the #{human_name(@klass)}"
    end

    render :template => "/model_manager/edit"
  end

  # DELETE /foos/12
  def destroy
    @current_object = @klass.find(params[:id])
    @current_object.destroy

    flash[:notice] = "Successfully deleted #{human_name(@klass)}"
    redirect_to index_path(@klass) and return
  end

  private
    def discover_class
      @klass = controller_name.classify.constantize
    end
end