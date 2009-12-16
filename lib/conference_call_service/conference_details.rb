module ConferenceCallService


  class ConferenceDetails
    attr_accessor :name, :description, :duration

    # Constructor
    def initialize(name, description, duration)
      @name = name
      @description = description
      @duration = duration
    end

    def to_s
      "#{@name.to_s} - #{@description.to_s}: #{@duration.to_s}"
    end

    def add_to_handsoap_xml(xml_doc)
      xml_doc.add('name', @name.to_s)
      xml_doc.add('description', @description.to_s)
      xml_doc.add('duration', @duration.to_s)
    end

    #### Static methods

    def self.build_from_xml(xml_doc)
      if xml_doc then
        name = ConferenceCallService.xpath_query(xml_doc, "name").to_s
        description = ConferenceCallService.xpath_query(xml_doc, "description").to_s
        duration = ConferenceCallService.xpath_query(xml_doc, "duration").to_s

        new(name, description, duration)
      end
    end
  end
end