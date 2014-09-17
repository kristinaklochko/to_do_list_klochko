class Project < ActiveRecord::Base
  belongs_to :user
  has_many   :tasks

  validates :name, presence: true

  with_options if: -> { name.present? } do
    validates :name, uniqueness: true
  end

  scope :recent_first, -> { order('projects.created_at DESC') }

  def self.show_procedure(page)
    show_all = self.page(page).recent_first
    show_all
  end

  def self.create_procedure(params)
     new_project = self.create!(params)
     new_project
  end

  def update_procedure(params)
    updated_project = self.update(params)
    updated_project
  end
end
