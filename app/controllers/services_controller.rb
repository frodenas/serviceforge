class ServicesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :service_not_found
  before_action :set_services_breadcrumb
  before_action :set_service, only: [:show, :edit, :update, :destroy]
  after_action :verify_policy_scoped, :only => :index
  after_action :verify_authorized, :except => :index

  def index
    @services = policy_scope(Service)
  end

  def show
    authorize @service

    @teams = policy_scope(Team)
    @service_plans = @service.plans

    add_breadcrumb (@service.display_name.blank? ? @service.name : @service.display_name), service_url(@service)
  end

  def new
    authorize Service

    @service = Service.new

    add_breadcrumb 'New', new_service_url
  end

  def edit
    authorize @service

    add_breadcrumb (@service.display_name.blank? ? @service.name : @service.display_name), service_url(@service)
    add_breadcrumb 'Edit', edit_service_url(@service)
  end

  def create
    authorize Service

    @service = Service.new(service_params)
    @service.creator = current_user
    respond_to do |format|
      if @service.save
        format.html { redirect_to @service, notice: "Service \"#{@service.name}\" was successfully created" }
        format.json { render :show, status: :created, location: @service }
      else
        format.html { render :new }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @service

    respond_to do |format|
      if @service.update(service_params)
        format.html { redirect_to @service, notice: "Service \"#{@service.name}\" was successfully updated" }
        format.json { render :show, status: :ok, location: @service }
      else
        format.html { render :edit }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @service

    @service.destroy
    respond_to do |format|
      format.html { redirect_to services_url, notice: "Service \"#{@service.name}\" was successfully destroyed" }
      format.json { head :no_content }
    end
  end

  private

  def service_not_found
    redirect_to services_url, alert: 'Service not found'
  end

  def set_services_breadcrumb
    add_breadcrumb 'Services', services_url
  end

  def set_service
    @service = Service.find(params[:id])
  end

  def service_params
    params.require(:service).permit(:name, :description, :bindable, :tags, :requires_syslog_drain, :display_name,
                                    :image, :long_description, :provider, :documentation_url, :support_url,
                                    :source_url, :license, :public)
  end
end
