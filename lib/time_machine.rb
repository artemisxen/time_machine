require 'grape'
require 'json'
require 'pry'
require './lib/clock'
require './lib/clock_store'

module TimeMachine
  class API < Grape::API
    format :json

    get '/clocks' do
      ClockStore.clocks
    end

    post '/clocks' do
      ClockStore.add_clock(Clock.new)
    end

    get '/clocks/:id' do
      { "message" => "I am in the get with id #{params[:id]}", "id" => params[:id] }
    end

    patch '/clocks/:id' do
      { "message" => "I am in the patch with id #{params[:id]}", "id" => params[:id] }.to_json
    end

    delete '/clocks/:id' do
      { "message" => "I am in the get with id #{params[:id]}", "id" => params[:id] }
    end
  end
end
