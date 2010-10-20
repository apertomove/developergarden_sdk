# developergarden_sdk
This library provides access to open development services of the Deutsche Telekom AG.
For more details about the services see

 http://www.developergarden.com

# Installation

Assuming you are using rvm:
 
    $ gem install developergarden_sdk

Or bundler:

    $ gem 'developergarden_sdk', :git => 'git://github.com/nicolai86/developergarden_sdk.git'

**See the examples folder for details on how to use the gem.**
More information about developer garden services can be found at:
 [http://www.developergarden.com](http://www.developergarden.com)

# FAQ
## Did not understand "MustUnderstand" header(s)
 
    Handsoap::Fault: Handsoap::Fault { :code => 'soapenv:MustUnderstand', :reason => 'Did not understand "MustUnderstand" header(s):{http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd}Security' }

You will receive this error message if a mandatory header element is not present or the remote service was unable to process it.
Most likely this will happen if something is wrong during the authentication process such as missing parameters like username, password.