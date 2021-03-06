require File.dirname(__FILE__) + '/../spec_helper.rb'

require 'reek/method_context'
require 'reek/stop_context'

include Reek

describe MethodContext, 'matching' do
  before :each do
    @element = MethodContext.new(StopContext.new, [0, :mod])
  end

  it 'should recognise itself in a collection of names' do
    @element.matches?(['banana', 'mod']).should == true
    @element.matches?(['banana']).should == false
  end

  it 'should recognise itself in a collection of REs' do
    @element.matches?([/banana/, /mod/]).should == true
    @element.matches?([/banana/]).should == false
  end
end

describe MethodContext, 'matching fq names' do
  before :each do
    element = StopContext.new
    element = ModuleContext.new(element, [0, :mod])
    element = ClassContext.new(element, [0, :klass])
    @element = MethodContext.new(element, [0, :meth])
  end

  it 'should recognise itself in a collection of names' do
    @element.matches?(['banana', 'meth']).should == true
    @element.matches?(['banana', 'klass#meth']).should == true
    @element.matches?(['banana']).should == false
  end

  it 'should recognise itself in a collection of names' do
    @element.matches?([/banana/, /meth/]).should == true
    @element.matches?([/banana/, /klass#meth/]).should == true
    @element.matches?([/banana/]).should == false
  end
end

describe MethodContext do
  it 'should record ivars as refs to self' do
    mctx = MethodContext.new(StopContext.new, [:defn, :feed])
    mctx.refs.refs_to_self.should == 1
    mctx.record_call_to([:call, [:ivar, :@cow], :feed_to])
    mctx.refs.refs_to_self.should == 2
  end
end
