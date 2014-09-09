class UsersController < ApplicationController
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordNotFound, with: :user_not_found
  before_action :set_users_breadcrumb
  before_action :set_user, only: [:edit, :update, :destroy]
  after_action :verify_authorized

  def index
    authorize User

    @users = User.all
  end

  def edit
    authorize @user

    add_breadcrumb "#{@user.first_name} #{@user.last_name}"
    add_breadcrumb 'Edit', edit_user_url(@user)
  end

  def update
    authorize @user

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_url, notice: "User \"#{@user.first_name} #{@user.last_name}\" was successfully updated" }
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @user

    @user.destroy
    respond_to do |format|
      if @user.errors.any?
        format.html { redirect_to users_url, alert: @user.errors.full_messages.join('. ') }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      else
        format.html { redirect_to users_url, notice: "User \"#{@user.first_name} #{@user.last_name}\" was successfully destroyed" }
        format.json { head :no_content }
      end
    end
  end

  private

  def user_not_found
    redirect_to users_url, alert: 'User not found'
  end

  def set_users_breadcrumb
    add_breadcrumb 'Users', users_url
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params[:user].permit(:first_name, :last_name, :email, :public, :role)
  end
end
