# frozen_string_literal: true

class CoffeeMakerPublisher
  include Wisper::Publisher
  include Wisper::Bubbleable

  def power(on_or_off)
    state = CoffeeStatePublisher.new
    state.bubble(:power_on, :power_off, :backdoor).to(self)
    state.on(:power_on) { broadcast(:warming) }
    state.on(:invalid_state) { |x| broadcast(:error, x) }
    value = case on_or_off
            when :on then true
            when :off then false
            else
              on_or_off.to_sym
            end
    state.change(value)
  end
end
