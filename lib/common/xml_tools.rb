module Common

  # Some tools facilitating xml processing.
  class XmlTools

    # Get rid of surrounding cdata sections.
    # Attention: This method will modify the given string itself.
    # ===Parameter
    # <tt>xml_with_cdata</tt>:: Some xml string with a cdata section.
    def self.strip_cdata!(xml_with_cdata)
      xml_with_cdata.gsub!('<![CDATA[', '')
      xml_with_cdata.gsub!(']]>', '')
      return xml_with_cdata
    end

    # Get rid of surrounding cdata sections.
    # ===Parameter
    # <tt>xml_with_cdata</tt>:: Some xml string with a cdata section.
    def self.strip_cdata(xml_with_cdata)
      xml_with_cdata.gsub('<![CDATA[', '')
      xml_with_cdata.gsub(']]>', '')
      return xml_with_cdata
    end
  end
end