require 'grape'

module TimeMachine
  class API < Grape::API
    @@clocks = []

    get '/clocks' do
      @@clocks
    end
  end
end
