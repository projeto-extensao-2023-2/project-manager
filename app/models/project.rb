class Project < ApplicationRecord
  belongs_to :researcher
  belongs_to :coordinator
  has_one :student
  accepts_nested_attributes_for :student

  enum project_type: {
    PIBIC: 0,
    PIBIC_CNPQ: 1,
    PIVITI: 2
  }

  enum project_status: {
    em_analise: 0,
    aprovado: 5,
    interrompido: 9
  }

  validates :project_type, :institution, :course, :study_area, :research_line, :ods,
            :project_title, :project_summary, :key_words, presence: true
  before_validation :generate_ric_number, :verify_date, on: :create

  private
  def generate_ric_number
    loop do
      ric = SecureRandom.random_number(9_999_999_999 - 1_000_000_000) + 1_000_000_000
      unless Project.exists?(ric_number: ric)
        self.ric_number = ric
        break
      end
    end
  end

  def verify_date
    unless Notice.where.not(id: id).any? do |existed_notice|
      (DateTime.now..DateTime.now).overlaps?(existed_notice.start_date..existed_notice.end_date)
    end
      errors.add(:base, "Não existe um edital criado no momento.")
    end
  end
end
