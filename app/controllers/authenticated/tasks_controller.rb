class Authenticated::TasksController < Authenticated::BaseController
  before_filter :find,    only: [ :update, :prioritize, :complete, :create ]

  def create
    @task = @project.tasks.create_procedure(new_params)
    render json: full_hash(@task.errors), status: 400 and return unless @task
    render json: full_hash(render_to_string(partial: 'task', locals: { task: @task }),
                              message: I18n.t('flash.authenticated.tasks.create.notice')),
                   status: 200
  end

  def update
    render text: @task.errors.full_messages and return unless @task
    @task.update_procedure(new_params)
    render json: @task, status: 200
  end

  def complete
    @task.challenge_completed(completed: !@task.completed) if @task
    head :ok
  end

  def prioritize
    @task.prioritization(params) if @task
    head :ok
  end

  def destroy
    current_user.tasks.destroy_procedure(params)
    head :ok
  end

private

    def new_params
      params.require(:task).permit(:name, :position)
    end

    def find
      @project = current_user.projects.find(params[:task][:project_id]) if params[:task][:project_id]
      @task = current_user.tasks.find(params[:id]) if params[:id]
    end

    def full_hash(entry = nil,message = nil,errors = nil)
      {entry: entry, message: message, errors: errors}
    end
end
