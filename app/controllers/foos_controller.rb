class FoosController < ApplicationController
  before_action :set_foo, only: [:show, :edit, :update, :destroy]

  # GET /foos
  def index
    @foos = Foo.all
  end

  # GET /foos/1
  def show
  end

  # GET /foos/new
  def new
    @foo = Foo.new
  end

  # GET /foos/1/edit
  def edit
  end

  # POST /foos
  def create
    @foo = Foo.new(foo_params)

    if @foo.save
      redirect_to @foo, notice: 'Foo was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /foos/1
  def update
    if @foo.update(foo_params)
      redirect_to @foo, notice: 'Foo was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /foos/1
  def destroy
    @foo.destroy
    redirect_to foos_url, notice: 'Foo was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_foo
      @foo = Foo.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def foo_params
      params.require(:foo).permit(:name)
    end
end
