# frozen_string_literal: true

module Dpop
  # Railtie for gem setup on Rails, to automatically configure
  class Railtie < Rails::Railtie
    initializer "dpop.configure_rails_initialization" do
      Dpop.configure
    end
  end
end
