ENV['RACK_ENV'] = 'test'
require 'rspec'
require 'rack/test'
require './lib/time_machine.rb'

describe 'TimeMachine' do
  include Rack::Test::Methods
  def app
    TimeMachine::API
  end

  def response_body
    JSON.parse(last_response.body)
  end

  describe 'GET /clocks' do
    it 'returns an array' do
      get '/clocks'
      expect(last_response.status).to eq 200
      expect(response_body).to eq([])
    end
  end

  describe 'POST /clocks' do
    it 'should create a clock object' do
      post '/clocks'
      expect(last_response.status).to eq 201
    end
  end
end
