$LOAD_PATH << File.expand_path(File.dirname(__FILE__)) + '/lib'

require 'sinatra'
require 'piaweb'
require 'haml'
require 'json'

set :haml, format: :html5

get '/' do
  haml :index
end

get '/services' do
  @services = service_manager.services
  haml :services
end

post '/:name/activate' do
  json_response do
    service_manager.activate(params[:name])
  end
end

post '/:name/deactivate' do
  json_response do
    service_manager.deactivate(params[:name])
  end
end

def json_response
  content_type :json
  begin
    yield
    { result: 'success' }.to_json
  rescue => e
    {
      result: 'error',
      message: e.message
    }.to_json
  end
end

def service_manager
  @service_manager ||= PiaWeb::ServiceManager.new
end
