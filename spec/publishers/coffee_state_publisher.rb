# frozen_string_literal: true

class CoffeeStatePublisher
  include Wisper::Publisher
  include Wisper::Bubbleable

  def change(state)
    case state
    when true
      broadcast(:power_on, 'Power On')
    when false
      broadcast(:power_off, 'Power Off')
    when :backdoor
      broadcast(:backdoor, 'Hacker comes!')
    else
      broadcast(:invalid_state, state)
    end
  end
end
