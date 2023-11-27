class NoticesController < ApplicationController
  before_action :authorize_coordinator

  def index
    @notices = Notice.order(start_date: :desc)
  end

  def new
    @notice = Notice.new
  end

  def create
    @notice = Notice.new(notice_params)

    if @notice.save
      return redirect_to notices_path, notice: 'Edital criado com sucesso.'
    end

    flash.now.alert = 'Não foi possível cadastrar o edital.'
    render :new, status: :unprocessable_entity
  end

  def edit
    @notice = Notice.find(params[:id])
  end

  def update
    @notice = Notice.find(params[:id])

    if @notice.update(notice_params)
      return redirect_to notices_path, notice: 'Edital atualizado com sucesso.'
    end

    flash.now.notice = 'Não foi possível atualizar o edital.'
    render :edit, status: :unprocessable_entity
  end

  def destroy
    @notice = Notice.find(params[:id])

    @notice.destroy
    redirect_to notices_path, notice: 'Edital excluído com sucesso.'
  end

  private
  def notice_params
    params.require(:notice).permit(
      :name,
      :start_date,
      :end_date
    )
  end

  def authorize_coordinator
    unless current_user&.coordinator? && current_user&.active? || current_user&.supervisor? && current_user&.active?
      redirect_to root_path, alert: 'Acesso não autorizado'
    end
  end

end
