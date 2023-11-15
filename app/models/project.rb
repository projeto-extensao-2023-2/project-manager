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
  before_validation :generate_ric_number, on: :create

  private
  def generate_ric_number
    puts ""
    puts ""
    puts ""
    puts "TESTEEEE"
    puts ""
    puts ""
    puts ""
    loop do
      ric = SecureRandom.random_number(9_999_999_999 - 1_000_000_000) + 1_000_000_000
      unless Project.exists?(ric_number: ric)
        self.ric_number = ric
        break
      end
    end
  end
end
