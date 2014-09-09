class TeamsController < ApplicationController
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordNotFound, with: :team_not_found
  before_action :set_teams_breadcrumb
  before_action :set_team, only: [:show, :edit, :update, :destroy, :autocomplete_users]
  after_action :verify_policy_scoped, :only => :index
  after_action :verify_authorized, :except => :index

  def index
    @teams = policy_scope(Team)
  end

  def show
    authorize @team

    add_breadcrumb @team.name, team_url(@team)
  end

  def new
    authorize Team

    @team = Team.new

    add_breadcrumb 'New', new_team_url
  end

  def edit
    authorize @team

    add_breadcrumb @team.name, team_url(@team)
    add_breadcrumb 'Edit', edit_team_url(@team)
  end

  def create
    authorize Team

    @team = Team.new(team_params)
    @team.users << current_user
    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: "Team \"#{@team.name}\" was successfully created" }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @team

    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: "Team \"#{@team.name}\" was successfully updated" }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @team

    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: "Team \"#{@team.name}\" was successfully destroyed" }
      format.json { head :no_content }
    end
  end

  def autocomplete_users
    authorize @team

    @users = User.search(search_user_params[:search]).take(10)
  end

  private

  def team_not_found
    redirect_to teams_url, alert: 'Team not found'
  end

  def set_teams_breadcrumb
    add_breadcrumb 'Teams', teams_url
  end

  def set_team
    @team = Team.find(params[:id])
  end

  def team_params
    params[:team].permit(:name, :description, :access_level)
  end

  def search_user_params
    params[:users].permit(:search)
  end
end
