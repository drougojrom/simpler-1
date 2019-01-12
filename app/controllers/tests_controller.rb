class TestsController < Simpler::Controller

  def index
    @time = Time.now
  end

  def create
    render text: 'Create'
  end

  def show
    @test = Test.find(request_params[:id]).first
    render 'show'
  end

end
