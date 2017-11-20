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
      clock = ClockStore.find(params[:id])
      body clock.as_json
      clock.reduce_counter
    end

    desc 'patch updates the time with a fake time'
    params do
      requires :time, regexp: /(?:[1-9]\d{3}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1\d|2[0-8])|(?:0[13-9]|1[0-2])-(?:29|30)|(?:0[13578]|1[02])-31)|(?:[1-9]\d(?:0[48]|[2468][048]|[13579][26])|(?:[2468][048]|[13579][26])00)-02-29)T(?:[01]\d|2[0-3]):[0-5]\d:[0-5]\d(?:Z|[+-][01]\d:[0-5]\d)/
      requires :counter, type: Integer
    end
    patch '/clocks/:id' do
      ClockStore.find(params[:id]).set_fake_time(params[:time], params[:counter])
      body '{}'
    end

    delete '/clocks/:id' do
      ClockStore.delete(params[:id])
      body '{}'
    end
  end
end
