class Admin::FunctionsController < ApplicationController
  before_action :set_function, only: [:show, :destroy, :edit, :update]

  def index
    functions = Function.where(user: current_user.id)
    @print_functions = []
    functions.each do |function|
      sub_function = function.name + " = "
      function.content.split.each do |sub_fun|
        if sub_fun.include?("id")
          sub_function += Function.find(sub_fun.split(":").last).name
        else
          sub_function += sub_fun
        end
        sub_function
      end
      @print_functions << sub_function
    end
    @print_functions
  end

  def show
  end

  def new
    @function = Function.new
    @print_alert = []
  end

  def create
    @function = Function.new(function_params)
    check_function = @function[:content].gsub("id:", "")
    if check_function =~ /[a-zA-Z]/
      print_alert = []
      check_function.split.each do |function|
        if function =~ /[a-z]/
          print_alert << "#{function} is not defined!"
        end
      end
      @print_alert = print_alert
      @function = change_function(@function)
      render :new
    else
      @function.user = current_user
      if @function.save
        redirect_to admin_functions_path
      else
        render :new
      end
    end
  end

  def edit
    @function = change_function(@function)
    @print_alert = []
  end

  def update
    new_params = function_params

    check_function = new_params[:content].gsub("id:", "")
    if check_function =~ /[a-zA-Z]/
      print_alert = []
      check_function.split.each do |function|
        if function =~ /[a-z]/
          print_alert << "#{function} is not defined!"
        end
      end
      @print_alert = print_alert
      @function[:content] = new_params[:content]
      @function = change_function(@function)
      render :edit
    else
      if @function.update(function_params)
        redirect_to admin_functions_path
      else
        render :edit
      end
    end
  end

  def destroy
    f_array = [@function]
    more_func = []
    Function.where("content like ?", "%id:#{@function.id}%").each do |f|
      more_func << f
    end

    while !more_func.empty?
      f_array.concat(more_func)
      aux = more_func
      more_func = []
      aux.each do |f|
        Function.where("content like ?", "%id:#{f.id}%").each do |func|
          more_func << func
        end
      end
      more_func
    end

    f_array.each do |function|
      function.destroy
    end
    redirect_to admin_functions_path
  end

  private

  def set_function
    @function = Function.find(params[:id])
  end

  def function_params
    params[:function] ||= {}
    params[:function][:content] ||= []
    str = ""
    params[:function][:content].split.each do |sub|
      if Function.find_by(name: sub)
        str += " id:#{Function.find_by(name: sub).id} "
      else
        str += " " + sub + " "
      end
    end
    params[:function][:content] = str.strip.gsub(/\s+/, " ")

    params.require(:function).permit(:name, :content)
  end

  def change_function(function)
    database_functions = function[:content].scan(/id:[0-9]+/)
    database_functions.each do |f|
      sub = Function.find(f[3...f.size])
      function[:content] = function[:content].gsub(f, sub.name)
    end
    return function
  end
end
