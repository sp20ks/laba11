# frozen_string_literal: true

# class of controller
class ElementsController < ApplicationController
  include ElementsHelper

  before_action :set_values, only: :result

  def index; end

  def home; end

  def find_seq; end

  def res_of_search
    @res = Element.find_by(arr: params[:str_seq])
    redirect_to find_path, notice: 'There is no such sequence' if @res.nil?
  end

  def result
    unless Element.find_by(arr: @str).nil?
      redirect_to '/elements/index', notice: 'There is record with same sequence'
      return
    end
    redirect_to '/elements/index', notice: @element.errors.full_messages.join(' and ') unless @element.save
  end

  def show_all
    @elements = Element.all
    respond_to do |format|
      format.html
      format.xml { render xml: @elements }
    end
  end
end
