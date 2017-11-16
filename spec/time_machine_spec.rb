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

  before { ClockStore.clear_clocks }

  describe 'GET /clocks' do
    it 'returns an array' do
      get '/clocks'
      expect(last_response.status).to eq 200
      expect(response_body).to eq []
    end

    it 'updates the time of all the clocks to the current time' do
      allow(Time).to receive(:now).and_return('2017-11-16 10:45:18 +0000')
      post '/clocks'
      allow(Time).to receive(:now).and_return('2017-11-16 10:45:30 +0000')
      get '/clocks'
      expect(response_body.first["time"]).to eq '2017-11-16 10:45:30 +0000'
    end
  end

  describe 'GET /clocks/:id' do
    before do
      allow(SecureRandom).to receive(:uuid).and_return('2c82348f-0a9c-44af-896c-dfc3b6cbf196')
      post '/clocks'
      get '/clocks/2c82348f-0a9c-44af-896c-dfc3b6cbf196'
    end

    it 'returns the clock object' do
      expect(last_response.status).to eq 200
    end

    it 'returns json in the body' do
      expect(response_body["id"]).to eq "2c82348f-0a9c-44af-896c-dfc3b6cbf196"
    end
  end

  describe 'PATCH /clocks/:id' do
    it 'should create a clock object' do
      patch '/clocks/:id'
      expect(last_response.status).to eq 200
    end
  end

  describe 'POST /clocks' do
    before do
      allow(SecureRandom).to receive(:uuid).and_return('2c82348f-0a9c-44af-896c-dfc3b6cbf196')
      post '/clocks'
    end

    it 'should create a clock object' do
      expect(ClockStore.clocks).not_to be_empty
      expect(last_response.status).to eq 201
    end

    it 'headers should include location' do
      expect(last_response.headers["Location"]).to eq 'clocks/2c82348f-0a9c-44af-896c-dfc3b6cbf196'
    end
  end

  describe 'DELETE /clocks/:id' do
    before do
      allow(SecureRandom).to receive(:uuid).and_return('2c82348f-0a9c-44af-896c-dfc3b6cbf196')
      post '/clocks'
    end

    it 'should delete a clock object' do
      delete '/clocks/2c82348f-0a9c-44af-896c-dfc3b6cbf196'
      expect(last_response.status).to eq 204
    end
  end

  describe 'DELETE /clocks' do
    it 'should delete all clocks' do
      post '/clocks'
      delete '/clocks'
      expect(last_response.status).to eq 204
      expect(response_body).to be_empty
    end
  end
end
