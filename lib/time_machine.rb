require 'grape'
require 'json'

module TimeMachine
  class API < Grape::API
    @@clocks = []

    get '/clocks' do
      @@clocks
    end

    post '/clocks' do
      obj = { "message" => "I am in the post" }.to_json
      p JSON.parse(obj)["message"]
      @@clocks << obj
      p @@clocks
      obj
    end
  end
end
