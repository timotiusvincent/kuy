class ReviewsController < ApplicationController
  def index
    # filter by user
    if params[:user_id].present?
      @reviews = @reviews.filter_by_user(params[:user_id])
      # filter without is_skip
      @reviews = @reviews.filter_skipped(True)
      @reviews = @reviews.filter_by_stars(nil)
    end
    if params[:from_user].present?
      @reviews = @reviews.filter_from_user(params[:from_user])
      @reviews = @reviews.filter_by_nil(nil)
    end
    render json: {
      status: 'SUCCESS',
      message: 'Loaded Reviews',
      data: @reviews},
      status: :ok
  end

  def show
    @review = Review.find(params[:id])
    render json: {
      status: 'SUCCESS',
      message: 'Loaded Review',
      data: @review},
      status: :ok
  end

  def create
    # create empty review when event is completed
      @review = Review.new(review_params)
      @review[:stars] = nil
      @review[:is_skip] = False
      if @review.save
        render json: {
          status: 'SUCCESS',
          message: 'Review saved',
          data: @review},
          status: :created
      else
        render json: {
          status: 'ERROR',
          message: 'Review not saved',
          data: @review.errors},
          status: :unprocessable_entity
      end
  end

  def update
    # update stars and text or set is_skip
    # if stars is not null, can't update
    @review = Review.find(params[:id])
    if params.has_key?(:skip)
      @review[:is_skip] = True
      @review.save!
      render json: {
        status: 'SUCCESS',
        message: 'Review updated',
        data: @review},
        status: :ok
    end
    if @review[:stars].nil?
      render json: {
        status: 'ERROR',
        message: 'Review has been filled',
        data: @review},
        status: :forbidden
    end
    if @review.update(update_review_params)
      render json: {
        status: 'SUCCESS',
        message: 'Review updated',
        data: @review},
        status: :ok
    else
      render json: {
        status: 'ERROR',
        message: 'Review not updated',
        data: @review.errors},
        status: :unprocessable_entity
    end
  end

  private

  def review_params
    params.permit(:user_id, :from_user)
  end

  def update_review_params
    params.permit(:notes, :stars)
  end
end
