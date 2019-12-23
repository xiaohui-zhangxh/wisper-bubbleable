# frozen_string_literal: true

module Wisper
  module Bubbleable
    class Pipeline
      def initialize(from, *events)
        @from = from
        @events = events
      end

      def to(target)
        @events.each do |ev|
          @from.on(ev) { |*args| target.send(:broadcast, ev, *args) }
        end
      end
    end
  end
end
