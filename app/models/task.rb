class Task < ActiveRecord::Base
  belongs_to :project
  acts_as_list scope: :project

  validates :name, presence: true
  with_options if: -> { name.present? } do
    validates :name, uniqueness: { :scope => :project_id }
  end

  default_scope        -> { order('tasks.position DESC') }
  scope :recent_first, -> { order('tasks.created_at DESC') }

  def self.create_procedure(params)
     new_task = self.create!(params)
     new_task
  end

  def update_procedure(params)
    updated_task = self.update(params)
    updated_task
  end

  def challenge_completed(params)
    self.update(params)
  end

  def prioritization(params)
    self.insert_at(params[:position])
  end

  def destroy_procedure(params)
    self.where(id: params[:task][:task_ids]).destroy_all
  end
end
