class Authenticated::ProjectsController < Authenticated::BaseController
  before_filter :find_or_create, only: [ :index,:update, :destroy]

  def index
    @projects = current_user.projects.show_procedure(params[:page])
  end

  def create
    @project = current_user.projects.create_procedure(new_params)
    render json: full_hash(@project.errors),
                 status: 400 and return unless @project
    render json: full_hash(render_to_string(partial: 'project',
                           locals: { project: @project }),
                           I18n.t('flash.authenticated.projects.create.notice')),
                  status:200
  end

  def update
    render text: @project.errors.full_messages and return unless @project
    @project.update_procedure(new_params)
    render json: @project
  end

  def destroy
    @project.destroy if @project
    render json: full_hash(I18n.t('flash.authenticated.projects.destroy.notice')), 
                status: 200
  end

private

    def find_or_create
      @project  = Project.new unless params[:id]
      @project = current_user.projects.find(params[:id]) if params[:id]
    end

    def new_params
      params.require(:project).permit(:name)
    end

    def full_hash(entry = nil,message = nil,errors = nil)
      {entry: entry, message: message, errors: errors}
    end


end
