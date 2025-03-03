require 'date'
require "dotenv/load"

class Team

  # @@api_football_key = ENV.fetch("MY_FOOTBALL_KEY")

  def initialize(league_id)
    @league_id = league_id
  end

  # This method returns the list of teams for each league
  def team_list
    url = URI("https://v3.football.api-sports.io/teams?league=#{@league_id}&season=2022")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-host"] = 'v3.football.api-sports.io'
    request["x-rapidapi-key"] = ENV.fetch("MY_FOOTBALL_KEY")
    response = http.request(request)
    response_read = response.read_body

    parsed_response = JSON.parse(response_read)
    league_keys = parsed_response.keys
    return teams = parsed_response.fetch("response").map { |item| item["team"]["name"] }
  end

  # This method returns a list of domestic fixtures for the selected team
  def fixture_list(selected_team = nil)
    url = URI("https://v3.football.api-sports.io/fixtures?league=#{@league_id}&season=2022")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-host"] = 'v3.football.api-sports.io'
    request["x-rapidapi-key"] = ENV.fetch("MY_FOOTBALL_KEY")
    response = http.request(request)
    response_read = response.read_body
    parsed_response = JSON.parse(response_read)
    fixtures = parsed_response.fetch("response").map do |item|
      {
        date: DateTime.parse(item["fixture"]["date"]).strftime("%m-%d-%Y"),
        venue: {
          name: item["fixture"]["venue"]["name"],
          city: item["fixture"]["venue"]["city"]
        },
        league: {
          round: item["league"]["round"]
        },
        teams: {
          home: {
            name: item["teams"]["home"]["name"],
            logo: item["teams"]["home"]["logo"],
            winner: item["teams"]["home"]["winner"]
          },
          away: {
            name: item["teams"]["away"]["name"],
            logo: item["teams"]["away"]["logo"],
            winner: item["teams"]["away"]["winner"]
          }
        },
        goals: {
          home: item["goals"]["home"],
          away: item["goals"]["away"]
        },
        score: {
          fulltime: item["score"]["fulltime"]
        }
      }
    end

    fixtures = fixtures.filter do |fixture|
      fixture[:teams][:home][:name] == selected_team || fixture[:teams][:away][:name] == selected_team
    end

    return fixtures
  end 

  # Return total wins, draws, and losses
  def results_list(selected_team = nil)
    url = URI("https://v3.football.api-sports.io/fixtures?league=#{@league_id}&season=2022")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-host"] = 'v3.football.api-sports.io'
    request["x-rapidapi-key"] = ENV.fetch("MY_FOOTBALL_KEY")
    response = http.request(request)
    response_read = response.read_body
    parsed_response = JSON.parse(response_read)
    results = parsed_response.fetch("response").map do |item|
      {
        teams: {
          home: {
            name: item["teams"]["home"]["name"],
            logo: item["teams"]["home"]["logo"],
            winner: item["teams"]["home"]["winner"]
          },
          away: {
            name: item["teams"]["away"]["name"],
            logo: item["teams"]["away"]["logo"],
            winner: item["teams"]["away"]["winner"]
          }
        }
      }
    end

    results = results.filter do |result|
      result[:teams][:home][:name] == selected_team || result[:teams][:away][:name] == selected_team
    end

    return results
  end 

  # This method returns detailed information for each team
  def team_info(team_name)
    url = URI("https://v3.football.api-sports.io/teams?league=#{@league_id}&season=2022")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-host"] = 'v3.football.api-sports.io'
    request["x-rapidapi-key"] = ENV.fetch("MY_FOOTBALL_KEY")
    response = http.request(request)
    response_read = response.read_body
    parsed_response = JSON.parse(response_read)  
    team_details = parsed_response.fetch("response").map do |item|
      {
        team: {
          id: item["team"]["id"],
          name: item["team"]["name"],
          country: item["team"]["country"],
          founded: item["team"]["founded"],
          logo: item["team"]["logo"]
        },
        venue: {
          name: item["venue"]["name"],
          address: item["venue"]["address"],
          city: item["venue"]["city"],
          image: item["venue"]["image"]
        }
      }
    end

    team = team_details.filter do |team|
      team[:team][:name] == team_name
    end

    return team
  end

end
