module ConferenceCallService

  
  class ConferenceDetails
    attr_accessor :name, :description, :duration

    # Constructor
    def initialize(name, description, duration)
      @name         = name
      @description  = description
      @duration     = duration
    end

    def to_s
      "#{@name.to_s} - #{@description.to_s}: #{@duration.to_s}"
    end

    #### Static methods

    def self.build_from_xml(xml_doc)
      name        = ConferenceCallService.xpath_query(xml_doc, "name").to_s
      description = ConferenceCallService.xpath_query(xml_doc, "description").to_s
      duration    = ConferenceCallService.xpath_query(xml_doc, "duration").to_s

      new(name, description, duration)      
    end
  end
end