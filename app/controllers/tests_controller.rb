# frozen_string_literal: true

class TestsController < Simpler::Controller

  def index 
    #render 'tests/list'
    @time = Time.now
    @tests = Test.all
  end

  def create 

  end

end
