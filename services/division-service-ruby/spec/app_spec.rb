require 'rspec'
require 'rack/test'
require 'json'
require_relative '../app'

RSpec.describe 'Division Service' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'GET /health' do
    it 'returns healthy status' do
      get '/health'
      
      expect(last_response).to be_ok
      json_response = JSON.parse(last_response.body)
      expect(json_response['status']).to eq('healthy')
    end
  end

  describe 'POST /divide' do
    it 'performs basic division' do
      post '/divide', { a: 10, b: 2 }.to_json, { 'CONTENT_TYPE' => 'application/json' }
      
      expect(last_response).to be_ok
      json_response = JSON.parse(last_response.body)
      expect(json_response['result']).to eq(5.0)
    end

    it 'handles decimal divisions' do
      post '/divide', { a: 10.5, b: 2.5 }.to_json, { 'CONTENT_TYPE' => 'application/json' }
      
      expect(last_response).to be_ok
      json_response = JSON.parse(last_response.body)
      expect(json_response['result']).to eq(4.2)
    end

    it 'handles negative numbers' do
      post '/divide', { a: -10, b: 2 }.to_json, { 'CONTENT_TYPE' => 'application/json' }
      
      expect(last_response).to be_ok
      json_response = JSON.parse(last_response.body)
      expect(json_response['result']).to eq(-5.0)
    end

    it 'rejects division by zero' do
      post '/divide', { a: 10, b: 0 }.to_json, { 'CONTENT_TYPE' => 'application/json' }
      
      expect(last_response.status).to eq(400)
      json_response = JSON.parse(last_response.body)
      expect(json_response['error']).to include('Division by zero')
    end

    it 'rejects missing parameters' do
      post '/divide', { a: 10 }.to_json, { 'CONTENT_TYPE' => 'application/json' }
      
      expect(last_response.status).to eq(400)
      json_response = JSON.parse(last_response.body)
      expect(json_response['error']).to include('Missing required parameters')
    end

    it 'rejects invalid JSON' do
      post '/divide', 'not valid json', { 'CONTENT_TYPE' => 'application/json' }
      
      expect(last_response.status).to eq(400)
      json_response = JSON.parse(last_response.body)
      expect(json_response['error']).to include('Invalid JSON')
    end
  end
end