class ProjectsController < ApplicationController
  before_action :authorize_access_view, only: [:index, :show, :search]
  before_action :authorize_researcher_create, only: [:new, :create]
  before_action :authorize_coordinator_update, only: [:edit, :update]

  def index
    @projects = filtered_projects
  end

  def show
    @project = Project.find(params[:id])
  end

  def new
    @researcher = current_user.researcher
    @project = @researcher.projects.build
    @student = @project.build_student
    @student.build_address

    @coordinators = Coordinator.joins(:user).where(users: { active: true })
  end

  def create
    @researcher = current_user.researcher
    @project = @researcher.projects.build(project_params)

    if @project.save
      return redirect_to root_path, notice: 'Projeto cadastrado com sucesso.'
    end

    @coordinators = Coordinator.joins(:user).where(users: { active: true })
    flash.now.alert = 'Não foi possível cadastrar o projeto'
    render :new, status: :unprocessable_entity
  end

  def edit
    @coordinator = current_user.coordinator
    @project = Project.find(params[:id])
  end

  def update
    @coordinator = current_user.coordinator
    @project = Project.find(params[:id])
    @project.feedback_date = Date.today

    if params[:interrupt_button]
      @project.project_status = 'interrompido'
    else
      @project.project_status = 'aprovado'
    end

    if @project.update(project_params)
      return redirect_to coordinator_project_path(@project), notice: 'Projeto atualizado com sucesso.'
    end

    flash.now.notice = 'Não foi possível atualizar o projeto.'
    render :edit, status: :unprocessable_entity
  end

  def search
    @query = params["query"]

    @projects = case
                when current_user.coordinator?
                  Project.where(coordinator: current_user.coordinator)
                when current_user.researcher?
                  Project.where(researcher: current_user.researcher)
                else
                  Project.none
                end

    if @query.present?
      @projects = Project.joins(:student)
                         .where("LOWER(projects.ric_number) LIKE ? OR LOWER(projects.project_title) LIKE ? OR LOWER(students.name) LIKE ?",
                                "%#{@query.downcase}%", "%#{@query.downcase}%", "%#{@query.downcase}%")
                         .where(students: { project_id: @projects.ids })
                         .order(project_status: :asc, created_at: :desc)

    end

    render :template => "projects/index"
  end

  private

  def project_params
    params.require(:project).permit(
      :coordinator_id,
      :project_type,
      :institution,
      :course,
      :study_area,
      :research_line,
      :ods,
      :project_title,
      :project_summary,
      :key_words,
      :annotation,
      student_attributes: [
        :name,
        :social_security_number,
        :identity_card_number,
        :birth_date,
        :phone_number,
        :email,
        :academic_field,
        :course,
        :semester,
        :has_subject_dependencies,
        :is_regular_student,
        address_attributes: [
          :street,
          :district,
          :complement,
          :postal_code,
          :city,
          :state
        ]
      ]
    )
  end

  def authorize_access_view
    unless current_user&.researcher? && current_user&.active? || current_user&.coordinator? && current_user&.active?
      redirect_to root_path, alert: 'Acesso não autorizado'
    end
  end

  def authorize_researcher_create
    unless current_user&.researcher? && current_user&.active?
      redirect_to root_path, alert: 'Acesso não autorizado'
    end
  end

  def authorize_coordinator_update
    unless current_user&.coordinator? && current_user&.active?
      redirect_to root_path, alert: 'Acesso não autorizado'
    end
  end

  def filtered_projects
    projects = case
               when current_user.coordinator?
                 Project.where(coordinator: current_user.coordinator)
               when current_user.researcher?
                 Project.where(researcher: current_user.researcher)
               else
                 Project.none
               end

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
