require 'grape'
require 'json'
require 'pry'
require './lib/clock'
require './lib/clock_store'

module TimeMachine
  class API < Grape::API
    format :json
    content_type :json, 'application/json'

    get '/clocks' do
      ClockStore.clocks.each(&:current_time)
      ClockStore.clocks.map(&:as_json)
    end

    post '/clocks' do
      ClockStore.add_clock(Clock.new)
      body ClockStore.clocks.last.as_json
      header 'Location', "clocks/#{ClockStore.clocks.last.id}"
    end

    get '/clocks/:id' do
      ClockStore.clocks.find { |clock| clock.id == params[:id]  }.as_json
    end

    patch '/clocks/:id' do
      { "message" => "I am in the patch with id #{params[:id]}", "id" => params[:id] }.to_json
    end

    delete '/clocks/:id' do
      ClockStore.clocks.delete_if { |clock| clock.id == params[:id] }
    end

    delete '/clocks' do
      ClockStore.clear_clocks
    end
  end
end
