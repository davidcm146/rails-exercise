class JobsController < ApplicationController
  skip_before_action :authorize_request, only: %i[ public_view ]

  def public_view
    job = Job.find_by(share_link: params[:share_link])
    if job && job.published?
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
    job = @current_user.jobs.build(job_params)
    if job.save
      render json: { message: "Job created successfully!", job: job }, status: :created
    else
      render json: { errors: job.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    job = Job.find(params[:id])
    authorize job
    if job.update(job_params)
      render json: { message: "Job updated successfully!", job: job }, status: :ok
    else
      render json: { errors: job.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    job = Job.find(params[:id])
    authorize job
    job.destroy!
    render json: { message: "Job deleted!" }
  end

  private 

  def job_params
    params.permit(:title, :published_date, :created_by_id, :salary_from, :salary_to, :status, :share_link)
  end
end
