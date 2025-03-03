require "sinatra"
require "sinatra/reloader"
require 'uri'
require 'net/http'
require 'openssl'
require 'date'
require_relative 'teams'

$leagues = { 78 => "Bundesliga", 140 => "La Liga", 254 => "NWSL", 39 => "Premier League", 44 => "WSL" }

get("/") do
  erb :home
end

get '/clubs/:league_id' do
  content_type :json
  league_id = params[:league_id].to_i 
  teams = Team.new(league_id).team_list 
  teams.to_json
end

get '/stats' do
  @league_select = params[:league]
  @team_selection = params[:team]
  id = @league_select.to_i
  @selected_teams = Team.new(id) 
  @fixture_list = @selected_teams.fixture_list(@team_selection)
  @team_details = @selected_teams.team_info(@team_selection)
  @results_list = @selected_teams.results_list(@team_selection)
  erb :stats
end
