require 'grape'
require 'json'
require 'pry'
require './lib/clock'

module TimeMachine
  class API < Grape::API
    format :json

    get '/clocks' do
      Clock.clocks
    end

    post '/clocks' do
      { "message" => "I am in the post", "id" => SecureRandom.uuid }
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
