# frozen_string_literal: true

require 'wisper/bubbleable/version'
require 'wisper/bubbleable/pipeline'

module Wisper
  module Bubbleable
    def bubble(*events)
      Pipeline.new(self, *events)
    end
  end
end
