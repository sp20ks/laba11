# frozen_string_literal: true

# helper
module ElementsHelper
  def set_values
    @element = Element.new do |elem|
      elem.arr = params[:str_elem]
      elem.length = params[:length].to_i
    end
  end
end
