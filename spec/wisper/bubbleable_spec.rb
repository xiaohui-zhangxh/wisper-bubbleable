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
  let(:global_listener) { double('GlobalListener') }

  before do
    Wisper.subscribe(global_listener)
  end

  after { Wisper.unsubscribe(global_listener) }

  context 'with state' do
    before { coffee_state.subscribe(state_listener) }

    context 'when change to on' do
      after { coffee_state.change(true) }

      it { expect(state_listener).to receive(:power_on).with('Power On') }
      it { expect(state_listener).not_to receive(:power_off) }
      it { expect(state_listener).not_to receive(:invalid_state) }
      it { expect(state_listener).not_to receive(:backdoor) }
    end

    context 'when change to off' do
      after { coffee_state.change(false) }

      it { expect(state_listener).not_to receive(:power_on) }
      it { expect(state_listener).to receive(:power_off).with('Power Off') }
      it { expect(state_listener).not_to receive(:invalid_state) }
      it { expect(state_listener).not_to receive(:backdoor) }
    end

    context 'when change to 1' do
      after { coffee_state.change(1) }

      it { expect(state_listener).not_to receive(:power_on) }
      it { expect(state_listener).not_to receive(:power_off) }
      it { expect(state_listener).to receive(:invalid_state).with(1) }
      it { expect(state_listener).not_to receive(:backdoor) }
    end

    context 'when change to backdoor' do
      after { coffee_state.change(:backdoor) }

      it { expect(state_listener).not_to receive(:power_on) }
      it { expect(state_listener).not_to receive(:power_off) }
      it { expect(state_listener).not_to receive(:invalid_state) }
      it { expect(state_listener).to receive(:backdoor) }
    end
  end

  context 'with coffee maker' do
    before do
      coffee_maker.subscribe(machine_listener)
    end

    context 'when power is on' do
      after { coffee_maker.power(:on) }
      it { expect(machine_listener).to receive(:power_on).with('Power On') }
      it { expect(machine_listener).not_to receive(:power_off) }
      it { expect(machine_listener).not_to receive(:invalid_state) }
      it { expect(machine_listener).to receive(:warming) }
      it { expect(machine_listener).not_to receive(:backdoor) }
      it { expect(global_listener).to receive(:power_on).twice }
      # it do
      #   allow(machine_listener).to receive(:power_on)
      #   expect(global_listener).to receive(:power_on).twice
      # end
      it { expect(global_listener).not_to receive(:power_off) }
      it { expect(global_listener).not_to receive(:invalid_state) }
      it { expect(global_listener).not_to receive(:backdoor) }
    end

    context 'when power is off' do
      after { coffee_maker.power(:off) }

      it { expect(machine_listener).not_to receive(:power_on) }
      it { expect(machine_listener).to receive(:power_off).with('Power Off') }
      it { expect(machine_listener).not_to receive(:invalid_state) }
      it { expect(machine_listener).not_to receive(:warming) }
      it { expect(machine_listener).not_to receive(:backdoor) }
      it { expect(global_listener).not_to receive(:power_on) }
      it { expect(global_listener).to receive(:power_off).twice }
      # it do
      #   allow(machine_listener).to receive(:power_off)
      #   expect(global_listener).to receive(:power_off).twice
      # end
      it { expect(global_listener).not_to receive(:invalid_state) }
      it { expect(global_listener).not_to receive(:backdoor) }
    end

    context 'when power is unknown' do
      after { coffee_maker.power(:unknown) }

      it { expect(machine_listener).not_to receive(:power_on) }
      it { expect(machine_listener).not_to receive(:power_off) }
      it { expect(machine_listener).not_to receive(:invalid_state) }
      it { expect(machine_listener).to receive(:error).with(:unknown) }
      it { expect(machine_listener).not_to receive(:backdoor) }
      it { expect(global_listener).not_to receive(:power_on) }
      it { expect(global_listener).not_to receive(:power_off) }
      it { expect(global_listener).to receive(:invalid_state) }
      it do
        allow(machine_listener).to receive(:invalid_state)
        expect(global_listener).to receive(:invalid_state)
      end
      it { expect(global_listener).to receive(:error) }
      it { expect(global_listener).not_to receive(:backdoor) }
    end

    context 'when power is backdoor' do
      after { coffee_maker.power(:backdoor) }

      it { expect(machine_listener).not_to receive(:power_on) }
      it { expect(machine_listener).not_to receive(:power_off) }
      it { expect(machine_listener).not_to receive(:invalid_state) }
      it { expect(machine_listener).not_to receive(:error) }
      it { expect(machine_listener).to receive(:backdoor) }
      it { expect(global_listener).not_to receive(:power_on) }
      it { expect(global_listener).not_to receive(:power_off) }
      it { expect(global_listener).not_to receive(:invalid_state) }
      it { expect(global_listener).to receive(:backdoor).twice }
      # it do
      #   allow(machine_listener).to receive(:backdoor)
      #   expect(global_listener).to receive(:backdoor).twice
      # end
    end
  end
end
