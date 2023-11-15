class SupervisorsController < ApplicationController
  before_action :authorize_supervisor

  def index_coordinator
    @coordinators = Coordinator.joins(:user)
                               .order(active: :desc, created_at: :desc)
  end

  def index_researcher
    @researchers = Researcher.joins(:user)
                             .order(active: :desc, created_at: :desc)
  end

  def index_project
    @projects = filtered_projects

    render :template => "projects/index"
  end

  def search_project
    @query = params["query"]

    @projects = Project.all

    if @query.present?
      @projects = Project.joins(:student)
                         .where("LOWER(projects.ric_number) LIKE ? OR LOWER(projects.project_title) LIKE ? OR LOWER(students.name) LIKE ?",
                                "%#{@query.downcase}%", "%#{@query.downcase}%", "%#{@query.downcase}%")
                         .order(project_status: :asc, created_at: :desc)
    end

    render :template => "projects/index"
  end

  def show_project
    @project = Project.find(params[:id])

    render :template => "projects/show"
  end

  private

  def authorize_supervisor
    unless current_user&.supervisor? && current_user&.active?
      redirect_to root_path, alert: 'Acesso não autorizado'
    end
  end

  def filtered_projects
    projects = Project.all

    if params[:status].present? && Project.project_statuses.include?(params[:status])
      case params[:status]
      when 'aprovado', 'interrompido'
        projects = projects.where(project_status: params[:status]).order(feedback_date: :desc, project_status: :asc)
      else
        projects = projects.where(project_status: params[:status]).order(project_status: :asc, created_at: :desc)
      end
    else
      projects = projects.order(project_status: :asc, created_at: :desc)
    end

    projects
  end
end
