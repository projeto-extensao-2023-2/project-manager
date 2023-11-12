class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: {
    supervisor: 0,
    coordinator: 1,
    researcher: 3
  }

  def supervisor?
    role == 'supervisor'
  end

  has_one :supervisor, dependent: :destroy
  has_one :coordinator, dependent: :destroy
  has_one :researcher, dependent: :destroy
  accepts_nested_attributes_for :coordinator
  accepts_nested_attributes_for :researcher

  after_create :create_supervisor

  private
  def create_supervisor
    case role.to_sym
    when :supervisor
      create_supervisor!
    end
  end

end
