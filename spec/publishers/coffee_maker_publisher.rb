# frozen_string_literal: true

class CoffeeMakerPublisher
  include Wisper::Publisher
  include Wisper::Bubbleable

  def power(on_or_off)
    state = CoffeeStatePublisher.new
    state.bubble(:power_on, :power_off).to(self)
    state.on(:power_on) { broadcast(:warming) }
    state.on(:invalid_state) { |x| broadcast(:error, x) }
    state.change(on_or_off)
  end
end
