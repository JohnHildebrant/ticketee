class SessionsController < Devise::SessionsController
  force_ssl :only => [:new, :create]
end