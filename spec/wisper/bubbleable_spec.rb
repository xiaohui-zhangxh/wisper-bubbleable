# frozen_string_literal: true

require_relative '../publishers/coffee_state_publisher'
require_relative '../publishers/coffee_maker_publisher'

RSpec.describe Wisper::Bubbleable do
  it 'has a version number' do
    expect(Wisper::Bubbleable::VERSION).not_to be nil
  end

  let(:coffee_state) { CoffeeStatePublisher.new }
  let(:coffee_maker) { CoffeeMakerPublisher.new }
  let(:state_listener) { double('StateListener') }
  let(:machine_listener) { double('MachineListener') }

  before do
    coffee_state.subscribe(state_listener)
  end

  it do
    expect(state_listener).to receive(:power_on).with('Power On')
    expect(state_listener).not_to receive(:power_off)
    expect(state_listener).not_to receive(:invalid_state)
    coffee_state.change(true)
  end

  it do
    expect(state_listener).not_to receive(:power_on)
    expect(state_listener).to receive(:power_off).with('Power Off')
    expect(state_listener).not_to receive(:invalid_state)
    coffee_state.change(false)
  end

  it do
    expect(state_listener).not_to receive(:power_on)
    expect(state_listener).not_to receive(:power_off)
    expect(state_listener).to receive(:invalid_state).with(1)
    coffee_state.change(1)
  end

  context 'with coffee maker' do
    before do
      coffee_maker.subscribe(machine_listener)
      expect(state_listener).not_to receive(:power_on)
      expect(state_listener).not_to receive(:power_off)
      expect(state_listener).not_to receive(:invalid_state)
    end

    it do
      expect(machine_listener).to receive(:power_on).with('Power On')
      expect(machine_listener).not_to receive(:power_off)
      expect(machine_listener).not_to receive(:invalid_state)
      expect(machine_listener).to receive(:warming)
      coffee_maker.power(true)
    end

    it do
      expect(machine_listener).not_to receive(:power_on)
      expect(machine_listener).to receive(:power_off).with('Power Off')
      expect(machine_listener).not_to receive(:invalid_state)
      expect(machine_listener).not_to receive(:warming)
      coffee_maker.power(false)
    end

    it do
      expect(machine_listener).not_to receive(:power_on)
      expect(machine_listener).not_to receive(:power_off)
      expect(machine_listener).not_to receive(:invalid_state)
      expect(machine_listener).to receive(:error).with('x')
      coffee_maker.power('x')
    end
  end
end
