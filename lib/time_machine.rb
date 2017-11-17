require 'grape'
require 'json'
require 'pry'
require './lib/clock'
require './lib/clock_store'

module TimeMachine
  class API < Grape::API
    format :json

    get '/clocks' do
      ClockStore.as_json
    end

    post '/clocks' do
      clock = Clock.new
      ClockStore.add(clock)
      header 'Location', "clocks/#{clock.id}"
      body '{}'
    end

    get '/clocks/:id' do
      ClockStore.find(params[:id]).as_json
    end

    desc 'patch updates the time with a fake time'
    params do
      requires :time, type: DateTime
    end
    patch '/clocks/:id' do
      ClockStore.find(params[:id]).set_fake_time(params[:time])
      body '{}'
    end

    delete '/clocks/:id' do
      ClockStore.delete(params[:id])
      body '{}'
    end
  end
end
