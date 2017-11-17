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

  before do
    ClockStore.clear_clocks
    allow(SecureRandom).to receive(:uuid).and_return('2c82348f-0a9c-44af-896c-dfc3b6cbf196')
  end

  describe 'GET /clocks' do
    it 'returns an array' do
      get '/clocks'
      expect(last_response.status).to eq 200
      expect(response_body).to eq []
    end
  end

  describe 'GET /clocks/:id' do
    before do
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
    before { post '/clocks' }

    it 'should set time to a fake time' do
      patch '/clocks/2c82348f-0a9c-44af-896c-dfc3b6cbf196', { time: '2017-11-16 00:00:00 +0000'}
      expect(last_response.status).to eq 200
    end

    it 'should not change the time if no time is supplied' do
      patch '/clocks/2c82348f-0a9c-44af-896c-dfc3b6cbf196', {}
      expect(last_response.status).to eq 400
    end

    it 'should not change the time if it is not provided as DateTime' do
      patch '/clocks/2c82348f-0a9c-44af-896c-dfc3b6cbf196', { time: 'time'}
      expect(last_response.status).to eq 400
    end
  end

  describe 'POST /clocks' do
    before do
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
      post '/clocks'
    end

    it 'should delete a clock object' do
      delete '/clocks/2c82348f-0a9c-44af-896c-dfc3b6cbf196'
      expect(last_response.status).to eq 200
    end
  end
end
