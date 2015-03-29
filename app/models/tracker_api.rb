class TrackerAPI
  def initialize
    @connection = Faraday.new(:url => 'https://www.pivotaltracker.com')
  end

  def projects(token)
    response = @connection.get do |req|
      req.url "/services/v5/projects"
       req.headers['Content-Type'] = 'application/json'
       req.headers['X-TrackerToken'] = token
     end
    JSON.parse(response.body, symbolize_names: true)
  end

  def stories(token, project_id)
    response = @connection.get do |req|
      req.url "/services/v5/projects/#{project_id}/stories"
      req.headers['Content-Type'] = 'application/json'
      req.headers['X-TrackerToken'] = token
    end
    JSON.parse(response.body, symbolize_names: true)
  end
end
