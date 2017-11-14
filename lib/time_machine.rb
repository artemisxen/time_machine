require 'grape'

module TimeMachine
  class API < Grape::API
    @@clocks = []

    get '/clocks' do
      @@clocks
    end

    post '/clocks' do
      @@clocks << { message: "I am in the post" }
    end
  end
end
