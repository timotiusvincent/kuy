class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    @user.avatar.attach(params[:avatar])
    if @user.save
      render json: {
        status: 'SUCCESS',
        message: 'User saved',
        data: @user,
        avatar: url_for(@user.avatar)},
        status: :created
    else
      render json: {
        status: 'ERROR',
        message: 'User not saved',
        data: @user.errors},
        status: :unprocessable_entity
    end
  end

  def show
    @user = User.find_by(access_token: params[:access_token]) if params[:access_token].present?
    @user = User.find(params[:id]) if params[:id].present?
    if @user.nil?
      render json: {
        status: 'NOT FOUND',
        message: 'User Not Found',
        data: @user},
        status: :not_found
    else
      @avatar = @user.avatar
      render json: {
        status: 'SUCCESS',
        message: 'User Found',
        data: @user,
        avatar: url_for(@user.avatar)},
        status: :ok
    end
  end

  def index
    @user = User.find_by(access_token: params[:access_token]) if params[:access_token].present?
    @user = User.find(params[:id]) if params[:id].present?
    if @user.nil?
      render json: {
        status: 'NOT FOUND',
        message: 'User Not Found',
        data: @user},
        status: :not_found
    else
      @avatar = @user.avatar
      render json: {
        status: 'SUCCESS',
        message: 'User Found',
        data: @user,
        avatar: url_for(@user.avatar)},
        status: :ok
    end
  end

  def update
    @user = User.find_by(access_token: params[:access_token]) if params[:access_token].present?
    @user = User.find(params[:id]) if params[:id].present?
    if params.has_key?(:avatar)
      if @user.avatar.attached?
        @user.avatar.purge
      end
      @user.avatar.attach(params[:avatar])
      @user.save!
    end
    if @user.update(user_update_params)
      render json: {
        status: 'SUCCESS',
        message: 'User updated',
        data: @user,
        avatar: url_for(@user.avatar)},
        status: :ok
    else
      render json: {
        status: 'ERROR',
        message: 'User not updated',
        data: @user.errors},
        status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:access_token, :name, :gender, :fun_fact, :email)
  end

  def user_update_params
    params.permit(:name, :fun_fact)
  end
end
