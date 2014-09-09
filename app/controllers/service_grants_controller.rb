class ServiceGrantsController < ApplicationController
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  before_action :set_resource, only: [:create]
  before_action :set_service, only: [:destroy]
  before_action :set_team, only: [:destroy]
  after_action :verify_authorized

  def create
    authorize @service

    @service.teams << @team
    respond_to do |format|
      if @service.save
        format.html { redirect_to :back, notice: "Successfully granted access from Team \"#{@team.name}\" to Service \"#{@service.name}\"" }
        format.json { render :show, status: :created, location: @service }
      else
        format.html { render :new }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @service

    @service.teams.destroy(@team)
    respond_to do |format|
      if @service.errors.any?
        format.html { redirect_to :back, alert: @service.errors.full_messages.join('. ') }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      else
        format.html { redirect_to :back, notice: "Successfully revoked access from Team \"#{@team.name}\" to Service \"#{@service.name}\"" }
        format.json { head :no_content }
      end
    end
  end

  private

  def record_not_found
    redirect_to services_url, alert: 'Record not found'
  end

  def set_resource
    @service = Service.find(params[:service_id])
    @team = Team.find(params[:service][:teams])
  end

  def set_service
    @service = Service.find(params[:service_id])
  end

  def set_team
    @team = Team.find(params[:id])
  end
end
