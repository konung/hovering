module Hovering
  class ClientRepresenter < Roar::Decorator
    include Roar::JSON
    property :username
    property :password
    property :domains
  end

  class Client
    API_URL = 'https://www.hover.com/api/'  unless defined? API_URL
    AUTH_URL = 'https://www.hover.com/api/login' unless defined? AUTH_URL
    # This is an alternative POST url. Currently not use, but it is used by Hover.com control panel. So may have to switch later on. 
    POST_URL = 'https://www.hover.com/api/control_panel/' unless defined? POST_URL
    attr_accessor :username, :password, :cookie, :url, :auth_url, :domains, :post_url

    def initialize(username: , password: , url: API_URL, auth_url: AUTH_URL, post_url: POST_URL )
      # In order to connect, you need to provide you Hover.com username and password
      # It's recommended that you use ENV variables from a gem like dotenv
      # API_URL (url) & AUTH_URL (auth_url) are also over-ridable because hover HAS changed endpoints in the past
      # Once connection is established :domains will return a list of domains available to your account.
      @username = username
      @password = password
      @url = url
      @auth_url = auth_url
      @post_url = post_url
      @cookie = nil
    end

    def connection(resource='domains')
      # Create a reusable Faraday connection after authenticating
      # It's a simple Faraday::Connection object and can be manipulated accordingly
      authenticate
      Faraday.new(url: url + resource, headers: {'Content-Type' => 'application/json', 'Cookie' => cookie})
    end

    # Convenience methods
    def all_domains
      AccountDomainsRepresenter.new(AccountDomains.new).from_json(connection&.get&.body)
    end

    def all_dns
      AccountDnsRepresenter.new(AccountDns.new).from_json(connection('dns')&.get&.body)
    end

    def all_forwards
      Hovering::AccountForward::List.({'client' => self})['model']
    end

    def all_mailboxes
      AccountMailboxesRepresenter.new(AccountMailboxes.new).from_json(connection('mailboxes')&.get&.body)
    end

    private
    def authenticate
      # Go through authentication and initial login process
      return true if cookie  # Auth cookie already set
      response = login  # Get cookie if not set
      set_domains(response)
      return true if set_cookie(response)
      return false   # Not able to set the cookie
    end

    def login
      # Connect to Hover api to get initial response that contains auth cookie and list of domains
      response = Faraday.new(url: auth_url).post do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = ClientRepresenter.new(self).to_json
      end
      return response
    end

    def set_domains(response)
      # Set a list of available domains from initial login response
      Hovering::ClientRepresenter.new(self).from_json(response.body)
    end

    def set_cookie(response)
      # Set an auth cookie from initial login response that needs to go out with every request
      # It's essential an API key
      @cookie = "hoverauth=#{response.headers['set-cookie'].split(';').find{|x| x.include?('hoverauth')}.split('=').last}"
      return true if @cookie
      return false
    end
  end
end
