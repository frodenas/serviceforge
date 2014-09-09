class ServicePlansController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :service_plan_not_found
  before_action :set_service
  before_action :set_service_plan, only: [:show, :edit, :update, :destroy]
  before_action :set_service_plans_breadcrumb
  after_action :verify_policy_scoped, :only => :index
  after_action :verify_authorized, :except => :index

  def index
    @service_plans = policy_scope(@service.plans)
  end

  def show
    authorize @service_plan

    add_breadcrumb (@service_plan.display_name.blank? ? @service_plan.name : @service_plan.display_name), service_plan_url(@service, @service_plan)
  end

  def new
    authorize ServicePlan

    @service_plan = ServicePlan.new

    add_breadcrumb 'New', new_service_plan_url(@service)
  end

  def edit
    authorize @service_plan

    add_breadcrumb (@service_plan.display_name.blank? ? @service_plan.name : @service_plan.display_name), service_plan_url(@service, @service_plan)
    add_breadcrumb 'Edit', edit_service_plan_url(@service, @service_plan)
  end

  def create
    authorize ServicePlan

    @service_plan = ServicePlan.new(service_plan_params)
    @service_plan.service = @service
    @service_plan.creator = current_user
    respond_to do |format|
      if @service_plan.save
        format.html { redirect_to service_plan_url(@service, @service_plan), notice: "Service Plan \"#{@service_plan.name}\" was successfully created" }
        format.json { render :show, status: :created, location: @service_plan }
      else
        format.html { render :new }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @service_plan

    respond_to do |format|
      if @service_plan.update(service_plan_params)
        format.html { redirect_to service_plan_url(@service, @service_plan), notice: "Service Plan \"#{@service_plan.name}\" was successfully updated" }
        format.json { render :show, status: :ok, location: @service_plan }
      else
        format.html { render :edit }
        format.json { render json: @service_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @service_plan

    @service_plan.destroy
    respond_to do |format|
      format.html { redirect_to @service, notice: "Service Plan \"#{@service_plan.name}\" was successfully destroyed" }
      format.json { head :no_content }
    end
  end

  private

  def service_plan_not_found
    redirect_to service_plan_url(@service), alert: 'Service Plan not found'
  end

  def set_service
    @service = Service.find(params[:service_id])
  end

  def set_service_plans_breadcrumb
    add_breadcrumb 'Services', services_url
    add_breadcrumb (@service.display_name.blank? ? @service.name : @service.display_name), service_url(@service)
    add_breadcrumb 'Plans', service_plans_url(@service)
  end

  def set_service_plan
    @service_plan = ServicePlan.find(params[:id])
  end

  def service_plan_params
    params.require(:service_plan).permit(:name, :description, :bullets, :free, :display_name, :public)
  end
end
