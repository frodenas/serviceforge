class MembershipsController < ApplicationController
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  before_action :set_team, only: [:create, :destroy]
  before_action :set_user, only: [:create, :destroy]
  after_action :verify_authorized

  def create
    authorize @team

    @team.users << @user
    respond_to do |format|
      if @team.save
        format.html { redirect_to :back, notice: "User \"#{@user.first_name} #{@user.last_name}\" has been successfully added to team \"#{@team.name}\"" }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @team

    @team.users.destroy(@user)
    respond_to do |format|
      if @team.errors.any?
        format.html { redirect_to :back, alert: @team.errors.full_messages.join('. ') }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      else
        format.html { redirect_to :back, notice: "User \"#{@user.first_name} #{@user.last_name}\" has been successfully removed from team \"#{@team.name}\"" }
        format.json { head :no_content }
       end
    end
  end

  private

  def record_not_found
    redirect_to teams_url, alert: 'Record not found'
  end

  def set_team
    @team = Team.find(params[:team_id])
  end

  def set_user
    @user = User.find(params[:id])
  end
end
