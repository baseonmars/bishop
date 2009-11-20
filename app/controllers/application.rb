# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '27a2d40245440ff878c4ee8deb59941c'
  
  # turn off layout for xhr requests
  layout proc{ |c| c.request.xhr? ? false : "application" }
end
