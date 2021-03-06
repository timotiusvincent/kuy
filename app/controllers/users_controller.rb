class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    @user.avatar.attach(params[:avatar]) if params[:avatar].present?
    if @user.save
      avatar = nil
      avatar = url_for(@user.avatar) if @user.avatar.attached?
      render json: {
        status: 'SUCCESS',
        message: 'User saved',
        data: @user,
        avatar: avatar},
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
        success: false,
        message: 'User Not Found',
        data: nil},
        status: :not_found
    else
      @avatar = @user.avatar
      @reviews = @user.reviews
      average_stars = calc_average_stars(@reviews)
      avatar = nil
      avatar = url_for(@user.avatar) if @user.avatar.attached?
      render json: {
        status: 'SUCCESS',
        success: true,
        message: 'User Found',
        id: @user['id'],
        name: @user['name'],
        email: @user['email'],
        gender: @user['gender'],
        fun_fact: @user['fun_fact'],
        access_token: @user['access_token'],
        rating: average_stars,
        #data: @user,
        avatar: avatar},
        status: :ok
    end
  end

  def index
    @user = User.find_by(access_token: params[:access_token]) if params[:access_token].present?
    @user = User.find(params[:id]) if params[:id].present?
    if @user.nil?
      render json: {
        status: 'NOT FOUND',
        success: false,
        message: 'User Not Found',
        data: nil},
        status: :not_found
    else
      @avatar = @user.avatar
      @reviews = @user.reviews
      average_stars = calc_average_stars(@reviews)
      avatar = nil
      avatar = url_for(@user.avatar) if @user.avatar.attached?
      render json: {
        status: 'SUCCESS',
        success: true,
        message: 'User Found',
        id: @user['id'],
        name: @user['name'],
        email: @user['email'],
        gender: @user['gender'],
        fun_fact: @user['fun_fact'],
        access_token: @user['access_token'],
        rating: average_stars,
        #data: @user,
        avatar: avatar},
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
      avatar = nil
      avatar = url_for(@user.avatar) if @user.avatar.attached?
      render json: {
        status: 'SUCCESS',
        message: 'User updated',
        data: @user,
        avatar: avatar},
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

  def calc_average_stars(reviews)
    if reviews.nil?
      return 0.0
    end
    count = 0
    sum = 0.0
    reviews.each do |review|
      sum += review[:stars]
      count += 1
    end
    avg = sum / count
    return avg
  end
end
