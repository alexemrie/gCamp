class PrivateController < ApplicationController
  before_action :ensure_current_user

end
