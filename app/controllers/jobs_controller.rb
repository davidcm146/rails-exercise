# frozen_string_literal: true

class JobsController < ApplicationController
  skip_before_action :authorize_request, only: %i[public_view]

  def public_view
    job = Job.find_by(share_link: params[:share_link])
    if job&.published?
      render json: job, each_serializer: JobSerializer, status: :ok
    else
      render json: { error: 'Not Found or Not Published' }, status: :not_found
    end
  end

  def index
    jobs = Job.where(created_by_id: @current_user.id)
    render json: jobs, each_serializer: JobSerializer, status: :ok
  end

  def create
    result = Jobs::JobService::CreateService.new(current_user: @current_user, params: job_params).call
    # debugger
    if result.success?
      render json: { message: 'Job created successfully!', job: result.data }, status: :created
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  def update
    job = Job.find(params[:id])
    authorize job

    result = Jobs::JobService::UpdateService.new(job: job, params: job_params).call
    if result.success?
      render json: { job: result.data, message: 'Job updated successfully!' }, status: :ok
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    job = Job.find(params[:id])
    authorize job
    job.destroy!
    render json: { message: 'Job deleted!' }
  end

  private

  def job_params
    params.require(:job).permit(:title, :published_date, :salary_from, :salary_to, :status, :share_link)
  end
end
