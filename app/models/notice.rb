class Notice < ApplicationRecord

  validates :name, :start_date, :end_date, presence: true
  validate :no_overlap, :valid_date

  private
  def no_overlap
    if Notice.where.not(id: id).any? do |existed_notice|
      (start_date..end_date).overlaps?(existed_notice.start_date..existed_notice.end_date)
    end
      errors.add(:base, "Já existe um edital cadastrado neste período.")
    end
  end

  def valid_date
    if start_date && end_date
      if start_date > end_date
        errors.add(:base, "A data de início não pode ser maior que a data final.")
      end
      if start_date < DateTime.now
        errors.add(:base, "A data de início deve ser futura.")
      end
    end
  end

end
