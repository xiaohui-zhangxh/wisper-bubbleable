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
          @from.on(ev) do |*args|
            # listeners = target.send(:local_registrations).map(&:listener)
            # listeners += target.send(:temporary_registrations).map(&:listener)
            # should_broadcast = target.listeners.any? { |listener| listener.respond_to?(ev) }
            # target.send(:broadcast, ev, *args) if should_broadcast
            target.send(:broadcast, ev, *args)
          end
        end
      end
    end
  end
end
