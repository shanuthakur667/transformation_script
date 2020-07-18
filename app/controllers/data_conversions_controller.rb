class DataConversionsController < ApplicationController
  RestClient.proxy = nil
  include Utility

  def index

  end

  def convert_data
    begin
      response = call_api
    rescue RestClient::ExceptionWithResponse => e
      response = e.response
    end
    response = JSON.parse(response)
    data = manipulate_response response
    send_data data, :type => 'application/json; header=present', :disposition => "attachment; filename=transformed.json"
  end
end
