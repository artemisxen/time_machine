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
    ClockStore.clear
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

    it 'reduces counter by 1 if a clock has been faked' do
      allow(Time).to receive(:now).and_return('2017-11-16 10:45:18 +0000')
      patch '/clocks/2c82348f-0a9c-44af-896c-dfc3b6cbf196', { time: '2017-11-16T00:00:00+0000', counter: 1}
      get '/clocks/2c82348f-0a9c-44af-896c-dfc3b6cbf196'
      get '/clocks/2c82348f-0a9c-44af-896c-dfc3b6cbf196'
      expect(response_body["counter"]).to eq 0
      expect(response_body["time"]).to eq '2017-11-16 10:45:18 +0000'
    end
  end

  describe 'PATCH /clocks/:id' do
    before do
      post '/clocks'
      patch '/clocks/2c82348f-0a9c-44af-896c-dfc3b6cbf196', { time: '2017-11-16T00:00:00+00:00', counter: 1}
    end

    it 'should set time and return 200' do
      expect(last_response.status).to eq 200
    end

    it 'should set the time to fake time' do
      get '/clocks/2c82348f-0a9c-44af-896c-dfc3b6cbf196'
      expect(response_body["time"]).to eq '2017-11-16T00:00:00+00:00'
    end

    it 'should set the counter' do
      get '/clocks/2c82348f-0a9c-44af-896c-dfc3b6cbf196'
      expect(response_body["counter"]).to eq 1
    end
  end

  describe 'PATCH /clocks/:id validations' do
    before { post '/clocks' }

    it 'should not change the time if no time is supplied' do
      patch '/clocks/2c82348f-0a9c-44af-896c-dfc3b6cbf196', {}
      expect(last_response.status).to eq 400
    end

    it 'should throw error if it is not provided in iso8601' do
      patch '/clocks/2c82348f-0a9c-44af-896c-dfc3b6cbf196', { time: '2017-11-17 16:46:37 +00:00', counter: 1}
      expect(last_response.status).to eq 400
      expect(response_body["error"]).to eq ("time is invalid")
    end

    it 'should throw error if counter is not provided' do
      patch '/clocks/2c82348f-0a9c-44af-896c-dfc3b6cbf196', { time: '2017-11-16T00:00:00+00:00'}
      expect(last_response.status).to eq 400
    end

    it 'should throw error if counter is not provided as an integer' do
      patch '/clocks/2c82348f-0a9c-44af-896c-dfc3b6cbf196', { time: '2017-11-16T00:00:00+00:00', counter: "one" }
      expect(last_response.status).to eq 400
      expect(response_body["error"]).to eq "counter is invalid"
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
