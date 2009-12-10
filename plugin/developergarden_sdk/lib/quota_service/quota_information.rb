require File.dirname(__FILE__) + '/../basic_response'

module QuotaService

  # Representing the response of a <tt>get_quota_information</tt>-Call.  
  class QuotaInformation < BasicResponse
    attr_accessor :error_code, :error_message, :max_quota, :max_user_quota, :quota_level

    # Constructor.
    # ===Parameters
    # <tt>response_xml</tt>:: Xml as returned by a <tt>call_status</tt>-method call.
    # <tt>raise_exception_on_error</tt>:: Xml as returned by a <tt>call_status</tt>-method call.
    def initialize(response_xml, raise_exception_on_error = true)
      super(response_xml)

      doc = response_xml.document
      @max_quota       = doc.xpath("//maxQuota").text
      @max_user_quota  = doc.xpath("//maxUserQuota").text
      @quota_level     = doc.xpath("//quotaLevel").text

      raise_on_error(response_xml) if raise_exception_on_error
    end

    def max_quota
      @max_quota.to_i
    end

    def max_user_quota
      @max_user_quota.to_i
    end

    def quota_level
      @quota_level.to_i
    end
  end
end