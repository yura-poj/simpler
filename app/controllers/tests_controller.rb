# frozen_string_literal: true

class TestsController < Simpler::Controller
  def index
    status 201
    # headers['Content-Type'] = 'text/plain'
    # render plain: 'Okey man lets do it'

    @time = Time.now
    @tests = Test.all
  end

  def create; end

  def show
  @time = Time.now
  @tests = Test.all end
end
