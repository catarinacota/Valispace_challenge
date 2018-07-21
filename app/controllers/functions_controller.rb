class FunctionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @functions = Function.list

    if params[:query].present?

      @function_arr = params[:query].gsub(" ", "").split(/\s+|\b/)

      # check if the user typed a DB's function
      if find(@function_arr)
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
      end

      @function_arr = replace_function(@function_arr)
      @function_arr = check_minus_sign(@function_arr)

      # calculation without DB'functions
      @solution = calculation(@function_arr).join.to_f.round(2)
      if @solution.floor == @solution
        @solution = @solution.round(0)
      end
      @function = @function_arr.join
    end
  end

  def check_minus_sign(function)
    if function.include? '-'
      minus_sign = function.each_index.select{|i| function[i] == '-'}
      minus_sign.each do |index|
        function[index + 1] = '-'+function[index + 1]
      end
      if minus_sign.include?(0)
        function.delete_at(0)
      end
    end
    function = function.map { |x| x == '-' ? '+' : x }
  end

  def replace_function(function)
    operators = function.each_index.select{|i| function[i].match(/\/\-|\/\+|\*\-|\*\+/)}
    if !operators.nil?
      operators.each do |i|
        function[i+1] = function[i][1] + function[i+1]
        function[i] = function[i][0]
      end
    end
    return function
  end

  def find(function)
    Function.where(name: function).take
  end

  def num_functions_db(function)
    num = 0
    function.each do |item|
      find(item) ? num += 1 : num
    end
    return num
  end

  def calculation(function)
    new_function = []
    number_calcs = (function.length - 1) / 2

    while number_calcs > 0
      if function.include? '/'
        index = function.index('/')
        calc = division(function[index - 1], function[index + 1])
      elsif function.include? '*'
        index = function.index('*')
        calc = multiplication(function[index - 1], function[index + 1])
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
    a.to_f * b.to_f
  end

  def division(a, b)
    a.to_f / b.to_f
  end

  def sum(a, b)
    a.to_f + b.to_f
  end

  def subtraction(a, b)
    a.to_f - b.to_f
  end

end
