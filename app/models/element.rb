# frozen_string_literal: true

# class of model
class Element < ApplicationRecord
  validates_each :arr do |record, attr, value|
    record.errors.add(attr, " isn't correct") if /[^\d^\s]/.match(value)
  end
  validate :length_valid?
  def length_valid?
    errors.add(:length, " isn't correct") if arr.split.map!(&:to_i).length != length
  end

  before_save :segments_of_powers

  private

  def segments_of_powers
    seg_arr = []
    buf = []
    arr.split.map!(&:to_i).each do |elem|
      if power_of_5?(elem) then buf << elem
      elsif !buf.length.zero?
        seg_arr << buf
        buf = []
      end
    end
    seg_arr << buf unless buf.length.zero?
    self.res_arr = seg_arr.join(' ')
    largest_segment(seg_arr)
  end

  def largest_segment(arr)
    unless arr.length.zero?
      max = arr[0]
      arr.each { |elem| max = elem if max.length < elem.length }
      self.max_subarr = max
    end
  end

  def power_of_5?(num)
    tmp = 0
    return false if num.zero?

    while tmp.zero?
      tmp = num % 5
      num /= 5
    end
    if tmp.eql?(1) && num.zero? then true
    else
      false
    end
  end
end
