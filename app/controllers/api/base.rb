module Api
  class Base < ApplicationController
    protect_from_forgery with: :null_session
  end
end
