class ProjectsController < ApplicationController
  before_action :authorize_researcher

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

    @coordinators = Coordinator.all
    flash.now.alert = 'Não foi possível cadastrar o projeto'
    render :new, status: :unprocessable_entity
  end

  def search
    @query = params["query"]

    if @query.present?
      @projects = Project.joins(:student)
                         .where(researcher: current_user.researcher)
                         .where("LOWER(projects.ric_number) LIKE ? OR LOWER(projects.project_title) LIKE ? OR LOWER(students.name) LIKE ?",
                                "%#{@query.downcase}%", "%#{@query.downcase}%", "%#{@query.downcase}%")
                         .order(project_status: :asc, created_at: :desc)

      render :template => "projects/index"
    end
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

  def authorize_researcher
    unless current_user&.researcher? && current_user&.active? || current_user&.supervisor? && current_user&.active?
      redirect_to root_path, alert: 'Acesso não autorizado'
    end
  end

  def filtered_projects
    if params[:status].present? && Project.project_statuses.include?(params[:status])
      projects = Project.where(researcher: current_user.researcher, project_status: params[:status])

      case params[:status]
      when 'aprovado', 'interrompido'
        projects.order(feedback_date: :desc, project_status: :asc)
      else
        projects.order(project_status: :asc, created_at: :desc)
      end
    else
      Project.where(researcher: current_user.researcher).order(project_status: :asc, created_at: :desc)
    end
  end
end
