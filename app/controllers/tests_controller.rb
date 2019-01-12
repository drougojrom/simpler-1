class TestsController < Simpler::Controller

  def index
    @time = Time.now
  end

  def create
    render text: 'Create'
  end

  def show
  end

end
