class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :block_new_user_registration, only: [:new]
  before_action :authorize_supervisor

  def new_coordinator
    @user = User.new
    coordinator = @user.build_coordinator
    coordinator.build_address
  end

  def create_coordinator
    @user = User.new
    @user.attributes = sign_up_params
    @user.role = :coordinator

    if @user.save
      return redirect_to root_path, notice: 'Cadastro realizado com sucesso.'
    end

    flash.now.notice = 'Não foi possível realizar o cadastro.'
    render :new_coordinator, status: :unprocessable_entity
  end

  def new_researcher
    @user = User.new
    researcher = @user.build_researcher
    researcher.build_address
  end

  def create_researcher
    @user = User.new
    @user.attributes = sign_up_params
    @user.role = :researcher

    if @user.save
      return redirect_to root_path, notice: 'Cadastro realizado com sucesso.'
    end

    render :new_researcher, status: :unprocessable_entity
  end

  def activate_coordinator
    coordinator = Coordinator.find(params[:id])
    coordinator.user.update(active: true)

    redirect_to coordinators_path, notice: 'Coordenador ativado com sucesso.'
  end

  def deactivate_coordinator
    coordinator = Coordinator.find(params[:id])
    coordinator.user.update(active: false)

    redirect_to coordinators_path, notice: 'Coordenador desativado com sucesso.'
  end

  def activate_researcher
    researcher = Researcher.find(params[:id])
    researcher.user.update(active: true)

    redirect_to researchers_path, notice: 'Pesquisador ativado com sucesso.'
  end

  def deactivate_researcher
    researcher = Researcher.find(params[:id])
    researcher.user.update(active: false)

    redirect_to researchers_path, notice: 'Pesquisador desativado com sucesso.'
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role, :active])
  end

  private

  def sign_up_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      coordinator_attributes: [
        :name,
        :phone_number,
        :academic_field,
        address_attributes: [
          :street,
          :district,
          :complement,
          :postal_code,
          :city,
          :state
        ]
      ],
      researcher_attributes: [
        :name,
        :phone_number,
        :academic_field,
        :cv_link,
        :orcid_id,
        :academic_title,
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

  def authorize_supervisor
    unless current_user&.supervisor? && current_user&.active?
      redirect_to root_path, alert: 'Acesso não autorizado'
    end
  end

  def block_new_user_registration
    redirect_to root_path, alert: 'Acesso não autorizado.'
  end
end
