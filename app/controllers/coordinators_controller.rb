class CoordinatorsController < ApplicationController
  before_action :authorize_supervisor

  def index
    @coordinators = Coordinator.joins(:user)
                               .order(active: :desc, created_at: :desc)

  end

  private
  def authorize_supervisor
    unless current_user&.supervisor? && current_user&.active?
      redirect_to root_path, alert: 'Acesso não autorizado'
    end
  end
end
