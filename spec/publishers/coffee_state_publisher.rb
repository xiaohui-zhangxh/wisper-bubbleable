# frozen_string_literal: true

class CoffeeStatePublisher
  include Wisper::Publisher
  include Wisper::Bubbleable

  def change(state)
    if state == true
      broadcast(:power_on, 'Power On')
    elsif state == false
      broadcast(:power_off, 'Power Off')
    else
      broadcast(:invalid_state, state)
    end
  end
end
