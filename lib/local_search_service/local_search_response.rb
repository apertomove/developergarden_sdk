require File.dirname(__FILE__) + '/../basic_response'

module LocalSearchService
  class LocalSearchResponse < BasicResponse

    attr_accessor :search_result

    # Constructor.
    # ===Parameters
    # <tt>response_xml</tt>:: Xml as returned by a <tt>ip_location</tt>-method call.
    # <tt>raise_exception_on_error</tt>:: Xml as returned by a <tt>call_status</tt>-method call.
    #
    def initialize(response_xml, raise_exception_on_error = true)

      doc = response_xml.document

      @error_code           = LocalSearchService.xpath_query(doc, "statusCode").to_s
      @error_message        = LocalSearchService.xpath_query(doc, "statusMessage").to_s

      #TODO
      @search_result        = LocalSearchService.xpath_query(doc, "searchResult/RESULTS")
    
      raise_on_error(response_xml) if raise_exception_on_error
    end
  end
end