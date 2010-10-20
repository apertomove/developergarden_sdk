# Represents a negative service response
class ServiceException < Exception
  attr_accessor :response

  def initialize(response)
    @response = response
  end  
end