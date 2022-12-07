# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

# testing ElementsHelper
RSpec.describe ElementsHelper do
  include ElementsHelper
  it 'returns true if value is a power of 5' do
    expect(power_of_5?(0)).to eq(false)
    expect(power_of_5?(1)).to eq(true)
    expect(power_of_5?(5)).to eq(true)
  end
end

# testing responses
RSpec.describe ElementsController, type: :controller do
  describe 'GET index' do
    context 'check index page' do
      it 'has a 200 status code' do
        get :index
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'GET home' do
    context 'check home' do
      it 'has a 200 status code' do
        get :home
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'GET find_seq' do
    context 'check find_seq' do
      it 'has a 200 status code' do
        get :find_seq
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'GET show_all' do
    context 'check show_all' do
      it 'has a 200 status code' do
        get :show_all
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'Test model' do
    it 'should save new element' do
      element = Element.new do |elem|
        elem.arr = '6 7 8 9 4 5 6 7 8'
        elem.length = 9
        elem.res_arr = '[[5]]'
        elem.max_subarr = '[5]'
      end
      expect(element.save).to eq(true)
    end
  end

  it 'should increase the number of records by one' do
    count = Element.all.length
    element = Element.new do |elem|
      elem.arr = '3'
      elem.length = 1
      elem.res_arr = '[]'
      elem.max_subarr = '[]'
    end
    element.save
    expect(Element.all.length).to eq(count + 1)
  end
end

# testing requests
RSpec.describe ElementsController, type: 'request' do
  it 'expects to see sequences of powers of 5' do
    get '/elements/result?length=7&str_elem=1+2+3+4+5+6+7'
    expect(assigns[:length]).to eq(7)
  end

  it 'expects to get nil in result of searching by sequence' do
    get '/elements/res_of_search?str_seq=0+0+0+0+0+0+0+0+0+0+0+0&commit=search'
    expect(assigns[:res]).to eq(nil)
  end
end

# testing page
RSpec.describe 'Selenium test of page' do
  it 'check url of page' do
    driver = Selenium::WebDriver.for :firefox
    driver.get('localhost:3000')
    expect(driver.current_url).to eq('http://localhost:3000/')
    driver.quit
  end

  it 'show message about sequence error' do
    driver = Selenium::WebDriver.for :firefox
    driver.get('localhost:3000/elements/index')
    driver.manage.timeouts.implicit_wait = 500

    num_field = driver.find_element(id: 'number')
    sequence_field = driver.find_element(id: 'str')
    btn = driver.find_element(id: 'btn')

    num_field.send_keys(10)
    sequence_field.send_keys('1 2 erer')
    btn.click

    driver.manage.timeouts.implicit_wait = 500
    flash = driver.find_element(id: 'flash').text
    expect(flash).to eq("Arr isn't correct and Length isn't correct")
    driver.quit
  end

  it 'show message about length error' do
    driver = Selenium::WebDriver.for :firefox
    driver.get('localhost:3000/elements/index')
    driver.manage.timeouts.implicit_wait = 500

    num_field = driver.find_element(id: 'number')
    sequence_field = driver.find_element(id: 'str')
    btn = driver.find_element(id: 'btn')

    num_field.send_keys(19)
    sequence_field.send_keys('1 2 3 4 5 6 6 6 6 6')
    btn.click

    driver.manage.timeouts.implicit_wait = 500
    flash = driver.find_element(id: 'flash').text
    expect(flash).to eq("Length isn't correct")
    driver.quit
  end

  it 'show message about not found sequence' do
    driver = Selenium::WebDriver.for :firefox
    driver.get('localhost:3000/elements/find_seq')
    driver.manage.timeouts.implicit_wait = 500

    field = driver.find_element(id: 'field')
    link = driver.find_element(id: 'link')
    field.send_keys('0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0')
    link.click

    driver.manage.timeouts.implicit_wait = 500
    flash = driver.find_element(id: 'flash').text
    expect(flash).to eq('There is no such sequence')
    driver.quit
  end

  it 'show message about found sequence' do
    driver = Selenium::WebDriver.for :firefox
    driver.get('localhost:3000/elements/find_seq')
    driver.manage.timeouts.implicit_wait = 500

    field = driver.find_element(id: 'field')
    link = driver.find_element(id: 'link')
    field.send_keys('1')
    link.click

    driver.manage.timeouts.implicit_wait = 500
    expect(driver.find_element(id: 'result').text).to eq('We have found this: 1, 1, [[1]], [1]')
    driver.quit
  end

  it 'show message about repeating sequence' do
    driver = Selenium::WebDriver.for :firefox
    driver.get('localhost:3000/elements/index')
    driver.manage.timeouts.implicit_wait = 500

    num_field = driver.find_element(id: 'number')
    sequence_field = driver.find_element(id: 'str')
    btn = driver.find_element(id: 'btn')

    num_field.send_keys(7)
    sequence_field.send_keys('1 2 3 4 5 6 7')
    btn.click

    driver.manage.timeouts.implicit_wait = 500
    flash = driver.find_element(id: 'flash').text
    expect(flash).to eq('There is record with same sequence')
    driver.quit
  end
end