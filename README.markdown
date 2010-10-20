# developergarden_sdk
This library provides access to open development services of the Deutsche Telekom AG.
For more details about the services see

 http://www.developergarden.com

Depending on your operating system you might want to skip the "sudo" command prior to the
commands listed here.


# Installation

Using rvm
 
    $ gem install developergarden_sdk

Using bundler

    $ gem 'developergarden_sdk', :git => 'git://github.com/nicolai86/developergarden_sdk.git'

# Basic usage
  
You can use the gem from any Ruby or Ruby on Rails applications. For examples see the examples folder.

# More Examples
In order to see more examples have a look the unit tests included in the gem's source code.
You might also want to have a look at the actual source code and source code comments.


# More Information
More information about developer garden services can be found at:
 http://www.developergarden.com

# FAQ
## Did not understand "MustUnderstand" header(s)
 
    Handsoap::Fault: Handsoap::Fault { :code => 'soapenv:MustUnderstand', :reason => 'Did not understand "MustUnderstand" header(s):{http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd}Security' }

You will receive this error message if a mandatory header element is not present or the remote service was unable to process it.
Most likely this will happen if something is wrong during the authentication process such as missing parameters like username, password.