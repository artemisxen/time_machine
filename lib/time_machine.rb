require 'grape'
require 'json'
require 'pry'
require './lib/clock'
require './lib/clock_store'

module TimeMachine
  class API < Grape::API
    format :json

    get '/clocks' do
      ClockStore.display_clocks
    end

    post '/clocks' do
      clock = Clock.new
      ClockStore.add_clock(clock)
      header 'Location', "clocks/#{clock.id}"
    end

    get '/clocks/:id' do
      ClockStore.find_clock(params[:id]).as_json
    end

    desc 'patch updates the time with a fake time'
    params do
      requires :time, type: DateTime
    end
    patch '/clocks/:id' do
      ClockStore.find_clock(params[:id]).set_fake_time(params[:time])
    end

    delete '/clocks/:id' do
      ClockStore.delete_clock(params[:id])
    end

    delete '/clocks' do
      ClockStore.clear_clocks
    end
  end
end
