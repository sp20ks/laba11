# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

# testing model
RSpec.describe Element do
  it 'should save sequnce' do
    a = Element.new(arr: '1 2 3 4 5 5 5 5 0 9 625 625 5 5 625 625', length: 16)
    expect(a.save).to eq(true)
    Element.last.destroy
  end

  it 'should add sequnce in db' do
    num_of_elements = Element.all.length
    a = Element.create(arr: '1 2 3 4 5 5 5 5 0 9 625 625 5 5 625 625', length: 16)
    expect(Element.all.length).to eq(num_of_elements + 1)
    expect(Element.last).to eq(a)
    Element.last.destroy
  end

  it 'should initialize max_subarr before save' do
    a = Element.create(arr: '1 2 3 4 5 5 5 5 0 9 625 625 5 5 625 625', length: 16)
    expect(a.max_subarr).to eq('[625, 625, 5, 5, 625, 625]')
    Element.last.destroy
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
    expect(driver.find_element(id: 'result').text).to eq('We have found this: 1, 1, 1, [1]')
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