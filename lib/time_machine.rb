require 'grape'
require 'json'
require 'pry'
require 'yaml'
require './lib/clock'
require './lib/clock_store'
require './lib/time_machine_logger'

module TimeMachine
  class API < Grape::API
    format :json
    logger TimeMachineLogger.new

    helpers do
      def logger
        API.logger.logger
      end
    end

    desc 'reads all the clocks'
    get '/clocks' do
      logger.debug("get /clocks")
      ClockStore.as_json
    end

    desc 'creates new clock'
    post '/clocks' do
      clock = Clock.new
      clock_location = clock.id
      logger.info("post /clocks, location: clocks/#{clock_location}")
      ClockStore.add(clock)
      header 'Location', "clocks/#{clock_location}"
      body({})
    end

    desc 'reads a clock with a specific id'
    get '/clocks/:id' do
      logger.error("get /clocks/#{params[:id]}, clock #{params[:id]} does not exist") unless ClockStore.find(params[:id])
      clock = ClockStore.find(params[:id])
      body clock.as_json
      clock.reduce_counter
    end

    desc 'updates the time of a specific clock with a fake time'
    params do
      requires :time, regexp: /(?:[1-9]\d{3}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1\d|2[0-8])|(?:0[13-9]|1[0-2])-(?:29|30)|(?:0[13578]|1[02])-31)|(?:[1-9]\d(?:0[48]|[2468][048]|[13579][26])|(?:[2468][048]|[13579][26])00)-02-29)T(?:[01]\d|2[0-3]):[0-5]\d:[0-5]\d(?:Z|[+-][01]\d:[0-5]\d)/
      requires :counter, type: Integer
    end
    patch '/clocks/:id' do
      clock = ClockStore.find(params[:id])
      logger.error("patch /clocks/#{params[:id]}, clock #{params[:id]} does not exist") unless clock
      logger.debug("patch /clocks/#{params[:id]}")
      logger.info("patch /clocks/#{params[:id]}, id: #{params[:id]}, time: #{params[:time]}, counter: #{params[:counter]}")
      clock.set_fake_time(params[:time], params[:counter])
      body({})
    end

    desc 'deletes a clock with a specific id'
    delete '/clocks/:id' do
      logger.error("delete /clocks/#{params[:id]}, clock #{params[:id]} does not exist") unless ClockStore.find(params[:id])
      logger.debug("delete /clocks/#{params[:id]}")
      logger.info("delete /clocks/#{params[:id]}, id: #{params[:id]}")
      ClockStore.delete(params[:id])
      body({})
    end
  end
end
