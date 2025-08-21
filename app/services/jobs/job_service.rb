module Jobs
  class JobService
    class CreateService
      def initialize(current_user:, params: {})
        @params = params
        @current_user = current_user
      end

      def call
        form = JobForm.new(nil, @params.merge(created_by: @current_user))
        return ResultService.failure(form.errors) unless form.save

        ResultService.success(form.job)
      end
    end

    class UpdateService
      def initialize(job:, params: {})
        @job = job
        @params = params
      end

      def call
        form = JobForm.new(@job, @params)
        return ResultService.failure(form.errors) unless form.save

        ResultService.success(form.job)
      end
    end
  end
end
