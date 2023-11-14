class CoordinatorsController < ApplicationController
  before_action :authorize_coordinator
  before_action :set_coordinator, only: [:show, :edit, :update]

  def show; end

  def edit; end

  def update
    if @coordinator.update(coordinator_params)
      return redirect_to @coordinator, notice: 'Perfil atualizado com sucesso.'
    end

    flash.now.alert = 'Não foi possui atualizar o perfil'
    render :edit, status: :unprocessable_entity
  end

  private
  def coordinator_params
    params.require(:coordinator).permit(
      :name,
      :phone_number,
      :academic_field,
      address_attributes: [
        :id,
        :street,
        :district,
        :complement,
        :postal_code,
        :city,
        :state
      ]
    )
  end

  def authorize_coordinator
    unless current_user&.coordinator? && current_user&.active? || current_user&.supervisor? && current_user&.active?
      redirect_to root_path, alert: 'Acesso não autorizado'
    end
  end

  def set_coordinator
    begin
      @coordinator = Coordinator.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @coordinator = nil
    end
  end
end
