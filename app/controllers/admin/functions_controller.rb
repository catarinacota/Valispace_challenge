class Admin::FunctionsController < ApplicationController
  before_action :set_function, only: [:show, :destroy, :edit, :update]

  def index
    @functions = Function.where(user: current_user.id)
  end

  def show
  end

  def new
    @function = Function.new
  end

  def create
    @function = Function.new(function_params)
    @function.user = current_user
    if @function.save
      redirect_to admin_functions_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    @function.update(function_params)
    redirect_to admin_functions_path(@function)
  end

  def destroy
    @function.destroy
    redirect_to admin_functions_path
  end

  private

  def set_function
    @function = Function.find(params[:id])
  end

  def function_params
    params.require(:function).permit(:name, :content)
  end
end
