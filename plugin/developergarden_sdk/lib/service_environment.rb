# Possible environment variables to choose a specific service environment.
#
# See also: https://www.developergarden.com/openapi/dokumentation/ansprache_der_services_ueber_webservice_schnittstellen#A.1.
class ServiceEnvironment

  # Production environment constant
  def self.PRODUCTION    
    @@PRODUCTION  = 1
  end

  # Sandbox environment constant
  def self.SANDBOX

    @@SANDBOX     = 2
  end

  # Mock environment constant
  def self.MOCK
    @@MOCK        = 3
  end
end