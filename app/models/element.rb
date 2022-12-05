class Element < ApplicationRecord
  attr_accessor :arr, :length

  include ActiveModel::Model
  include ActiveModel::Validations

  validates_each :arr do |record, attr, value|
    record.errors.add(attr, " isn't correct") if /[^\d^\s]/.match(value)
  end
  validate :length_valid?
  def length_valid?
    errors.add(:length, " isn't correct") if arr.split.map!(&:to_i).length != length
  end

end
