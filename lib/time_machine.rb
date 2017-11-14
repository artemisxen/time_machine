require 'grape'
require 'json'

module TimeMachine
  class API < Grape::API
    @@clocks = []

    get '/clocks' do
      @@clocks
    end

    post '/clocks' do
      @@clocks << { "message" => "I am in the post", "id" => SecureRandom.hex(10) }.to_json
    end
  end
end
