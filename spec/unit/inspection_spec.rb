require 'spec_helper'

describe 'inspection for common cases' do
  it 'should support the old DSL' do
    Foo.should respond_to(:aasm_states)
    Foo.aasm_states.should include(:open)
    Foo.aasm_states.should include(:closed)

    Foo.should respond_to(:aasm_initial_state)
    Foo.aasm_initial_state.should == :open

    Foo.should respond_to(:aasm_events)
    Foo.aasm_events.should include(:close)
    Foo.aasm_events.should include(:null)
  end

  it 'should support the new DSL' do
    Foo.aasm.should respond_to(:states)
    Foo.aasm.states.should include(:open)
    Foo.aasm.states.should include(:closed)

    Foo.aasm.should respond_to(:initial_state)
    Foo.aasm.initial_state.should == :open

    Foo.aasm.should respond_to(:events)
    Foo.aasm.events.should include(:close)
    Foo.aasm.events.should include(:null)
  end

  it 'should list states in the order they have been defined' do
    Conversation.aasm.states.should == [:needs_attention, :read, :closed, :awaiting_response, :junk]
  end
end

describe "special cases" do
  it "should support valid a state name" do
    Argument.aasm_states.should include(:invalid)
    Argument.aasm_states.should include(:valid)

    argument = Argument.new
    argument.invalid?.should be_true
    argument.aasm_current_state.should == :invalid

    argument.valid!
    argument.valid?.should be_true
    argument.aasm_current_state.should == :valid
  end
end

describe :aasm_states_for_select do
  it "should return a select friendly array of states" do
    Foo.should respond_to(:aasm_states_for_select)
    Foo.aasm_states_for_select.should == [['Open', 'open'], ['Closed', 'closed']]
  end
end

describe :aasm_from_states_for_state do
  it "should return all from states for a state" do
    AuthMachine.should respond_to(:aasm_from_states_for_state)
    froms = AuthMachine.aasm_from_states_for_state(:active)
    [:pending, :passive, :suspended].each {|from| froms.should include(from)}
  end

  it "should return from states for a state for a particular transition only" do
    froms = AuthMachine.aasm_from_states_for_state(:active, :transition => :unsuspend)
    [:suspended].each {|from| froms.should include(from)}
  end
end

describe :aasm_events_for_current_state do
  let(:foo) {Foo.new}

  it 'work' do
    foo.aasm_events_for_current_state.should include(:close)
    foo.aasm_events_for_current_state.should include(:null)
    foo.close
    foo.aasm_events_for_current_state.should be_empty
  end
end
