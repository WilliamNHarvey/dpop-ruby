# frozen_string_literal: true

module Dpop
  class Railtie < Rails::Railtie
    initializer "dpop.configure_rails_initialization" do
      Dpop.configure
    end
  end
end
