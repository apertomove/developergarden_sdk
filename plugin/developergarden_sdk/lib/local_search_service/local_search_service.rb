require File.dirname(__FILE__) + '/../authenticated_service'
require File.dirname(__FILE__) + '/local_search_response'

Handsoap.http_driver = :httpclient

# Print http and soap requests and reponses if ruby has been started with -d option.
Handsoap::Service.logger = $stdout if $DEBUG

module LocalSearchService
  

  # Client to access the developer garden ip location service.
  #
  # See also:
  # * https://www.developergarden.com/openapi/localsearch
  # * http://www.developergarden.com/static/docu/de/ch04s02s06.html
  class LocalSearchService < AuthenticatedService

    @@LOCAL_SEARCH_SCHEMA = 'http://localsearch.developer.telekom.com/schema/'

    @@LOCAL_SEARCH_SCHEMA_SERVICE_ENDPOINT = {
            :uri => "https://gateway.developer.telekom.com/p3gw-mod-odg-localsearch/services/localsearch",
            :version => 1
    }

    endpoint @@LOCAL_SEARCH_SCHEMA_SERVICE_ENDPOINT


    def on_create_document(doc)
      super(doc)
      doc.alias 'local', @@LOCAL_SEARCH_SCHEMA
    end


    # Retrieves spatial information about the given ip address.
    # === Parameters
    # <tt>search_parameters</tt>:: Search parameter hash specifying the terms and options to perform the search.
    #                              Have a look at the developer garden service documentation for more details about
    #                              valid parameters and their behavior.
    # <tt>environment</tt>:: Service environment as defined in ServiceLevel.
    # === Returns
    # A LocalSearchResponse object.
    # This object has a <tt>search_result</tt>-method which returns an <tt>Handsoap::XmlQueryFront::NodeSelection</tt>
    # object. NodeSelection is basically part of Handsoap's XmlQueryFront, a concept to abstract from the underlying
    # xml parser which is currently nokogiri, by default.
    # Have a closer look at the Handsoap-Framework at github (http://github.com/unwire/handsoap/) to get
    # more details about this. Don't hestitate to clone the project and have a look at its source code. It's not
    # too much code and is fairly easy to read.
    # For more information about the xml structure of the response object please refer to the Developergarden documentation.
    #
    # The tests of this gem also show some basic examples on how to parse a LocalSearchResult.
    def local_search(search_parameter = { :what => "test" }, environment = ServiceEnvironment.MOCK)
      response = nil

      response = invoke_authenticated("local:LocalSearchRequest") do |request, doc|
        request.add('environment', environment)

        search_parameter.each_pair do |param, value|
          request.add('searchParameters') do |params|
            unless value.nil? then
              params.add("parameter", param.to_s)
              params.add("value", value.to_s)
            end
          end
        end
      end

      response = LocalSearchResponse.new(response)

      return response
    end

    #### Static Methods

    def self.LOCAL_SEARCH_SCHEMA
      return @@LOCAL_SEARCH_SCHEMA
    end


    # Performs a xpath query in the ip location namespace for the given document and query string.
    # === Parameters
    # <tt>doc</tt>:: XmlQueryFront document.
    # <tt>query_string</tt>:: Element to look for
    # <tt>global_search</tt>:: Searches within all levels using "//" if <tt>global_search = true</tt>.
    def self.xpath_query(doc, query_string, global_search = true)
      self.xpath_query_for_schema(@@LOCAL_SEARCH_SCHEMA, doc, query_string, global_search)
    end
  end
end
