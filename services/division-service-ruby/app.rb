require 'sinatra'
require 'sinatra/json'
require 'json'
require 'logger'

# Configure logger
logger = Logger.new(STDOUT)
logger.level = Logger::INFO

# Configure Sinatra
set :bind, '0.0.0.0'
set :port, 8004

# Health check endpoint
get '/health' do
  json status: 'healthy'
end

# Division endpoint
post '/divide' do
  begin
    request.body.rewind
    data = JSON.parse(request.body.read)
    
    # Validate parameters
    unless data.key?('a') && data.key?('b')
      status 400
      return json error: 'Missing required parameters: a, b'
    end
    
    a = data['a'].to_f
    b = data['b'].to_f
    
    # Check for division by zero
    if b.zero?
      status 400
      return json error: 'Division by zero is not allowed'
    end
    
    result = a / b
    
    logger.info("Division: #{a} / #{b} = #{result}")
    
    json result: result
  rescue JSON::ParserError => e
    status 400
    json error: 'Invalid JSON'
  rescue => e
    status 500
    json error: e.message
  end
end

logger.info "Division Service starting on port 8004"