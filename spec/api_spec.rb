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
    end
  end

  describe 'GET /clocks/:id' do
    it 'returns the clock object' do
      allow(SecureRandom).to receive(:uuid).and_return('2c82348f-0a9c-44af-896c-dfc3b6cbf196')
      post '/clocks'
      get '/clocks/2c82348f-0a9c-44af-896c-dfc3b6cbf196'
      expect(last_response.status).to eq 200
    end

    it 'returns json in the body' do
      get '/clocks/blah'
      p last_response.body
      expect(JSON.parse(last_response.body)["message"]).to eq "I am in the get with id blah"
    end
  end

  describe 'PATCH /clocks/:id' do
    it 'should create a clock object' do
      patch '/clocks/:id'
      expect(last_response.status).to eq 200
    end
  end

  describe 'POST /clocks' do
    it 'should create a clock object' do
      post '/clocks'
      expect(last_response.status).to eq 201
    end
  end

  describe 'DELETE /clocks/:id' do
    it 'should delete a clock object' do
      delete '/clocks/:id'
      expect(last_response.status).to eq 200
    end
  end
end
