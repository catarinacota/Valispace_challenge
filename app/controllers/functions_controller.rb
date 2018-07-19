class FunctionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
  @functions = Function.all

    if params[:query].present?
      @function = params[:query]#.split(/\s+|\b/)
      @function_arr = params[:query].split(/\s+|\b/)

      num = num_functions_db(@function_arr)
      indexes =  @function_arr.each_index.select{|i| find(@function_arr[i])}
      while num != 0
        indexes.each do |index|
          a = find(@function_arr[index])
          @function_arr[index] = a.content.split(/\s+|\b/)
        end
        @function_arr = @function_arr.flatten
        num = num_functions_db(@function_arr)
        indexes =  @function_arr.each_index.select{|i| find(@function_arr[i])}
      end

      if @function_arr.include? '-'
        minus_sign = @function_arr.each_index.select{|i| @function_arr[i] == '-'}
        minus_sign.each do |index|
          @function_arr[index + 1] = '-'+@function_arr[index + 1]
        end
        if minus_sign.include?(0)
          @function_arr.delete_at(0)
        end
        @function_arr = @function_arr.map { |x| x == '-' ? '+' : x }
      end

      @solution = calculation(@function_arr).join.to_i
      @function = @function_arr.join
    end
  end

  def num_functions_db(function)
    num = 0
    function.each do |item|
      find(item) ? num += 1 : num
    end
    return num
  end

  def find(function)
    Function.where(name: function).take
  end

  def calculation(function)
    new_function = []
    number_calcs = (function.length - 1) / 2

    while number_calcs > 0
      if function.include? '*'
        index = function.index('*')
        calc = multiplication(function[index - 1], function[index + 1])
      elsif function.include? '/'
        index = function.index('/')
        calc = division(function[index - 1], function[index + 1])
      elsif function.include? '+'
        index = function.index('+')
        calc = sum(function[index - 1], function[index + 1])
      elsif function.include? '-'
        index = function.index('-')
        calc = subtraction(function[index - 1], function[index + 1])
      end

      if number_calcs == 1
        function = new_function.push(calc)
      else
        function = new_function(function, calc, index)
      end
      number_calcs -= 1
    end
    return function
  end

  def new_function(function, calc, index)
    new_function = []
    if index == 1
      new_function.push(calc, function[index + 2...function.length])
    elsif index == function.length - 1
      new_function.push(function[0..index - 2], calc)
    else
      new_function.push(function[0..index - 2], calc, function[index + 2...function.length])
    end
    return new_function.flatten
  end

  def multiplication(a, b)
    a.to_i * b.to_i
  end

  def division(a, b)
    a.to_i / b.to_f
  end

  def sum(a, b)
    a.to_i + b.to_i
  end

  def subtraction(a, b)
    a.to_i - b.to_i
  end

end
