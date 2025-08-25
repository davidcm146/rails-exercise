module Jobs
  class JobForm
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :title, :string
    attribute :salary_from, :integer
    attribute :salary_to, :integer
    attribute :status, :integer
    attribute :published_date, :date

    attr_reader :job
    attr_accessor :created_by

    validates :title, :salary_from, :salary_to, presence: true, on: :create
    validates :status, inclusion: { in: Job.statuses.values }
    validate :salary_range_check

    def initialize(job = nil, params = {})
      @job = job || Job.new
      @params = params
      # super(params) automatically called by ActiveModel::Attributes and assigns attributes variable
    end

    def save
      return false unless valid?

      @job.assign_attributes(job_attributes)
      @job.save
    end

    private

    def job_attributes
      if @created_by.present?
        @params.compact_blank.merge(created_by: @created_by)
      else
        @params.compact_blank
      end
    end

    def salary_range_check
      return unless salary_from.present? && salary_to.present? && salary_from > salary_to

      errors.add(:base, 'Salary from cannot be greater than salary to')
    end
  end
end
