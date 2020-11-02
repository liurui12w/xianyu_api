class ApplicationController < ActionController::Base
  protect_from_forgery

  # rescue_from CanCan::AccessDenied do |exception|
  #   render json: {status: 400, message: "您没有权限访问！" }
  # end

  # protect_from_forgery with: :exception
  # protect_from_forgery with: :null_session

  # acts_as_token_authentication_handler_for User, only: [:show]

  # rescue_from ActiveRecord::RecordInvalid, with: :validate_error
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  # rescue_from ArgumentError, with: :enum_argument
  # rescue_from ActsAsBookable::AvailabilityError, with: :book_error

  # def authenticate_user!
  #   token = http_token
  #   unauthenticated! and return if token.empty?
  #   @current_user = User.find_by!(authentication_token: token)
  # rescue
  #   unauthenticated!
  # end

  # def unauthenticated!
  #   render json: {status: 401, message: 'Unauthorized'}
  # end
  # 
  # def http_token
  #   @http_token ||= if request.headers['Authorization'].present?
  #                     request.headers['Authorization'].split(' ').last
  #                   end
  # end

  class ParameterValueNotAllowed < ActionController::ParameterMissing
    attr_reader :values

    def initialize(param, values)
      @param = param
      @values = values
      super("param: #{param} value only allowed in: #{values}")
    end
  end

  class ParameterTypeNotAllowed < ActionController::ParameterMissing
    def initialize(param, type)
      super("param: #{param} type only allow: #{type}")
    end
  end

  class AccessDenied < StandardError;
  end
  class PageNotFound < StandardError;
  end

  rescue_from(ActionController::ParameterMissing) do |err|
    render json: {status: 400, message: "ParameterInvalid: #{err}"}, status: 400
  end
  rescue_from(ActiveRecord::RecordInvalid) do |err|
    render json: {status: 400, type: 'validate_error', message: err }
  end
  # rescue_from(ActiveRecord::RecordInvalid) do |err|
  #   render json: {status: 400, message: 'RecordInvalid'}, status: 400
  # end
  # rescue_from(AccessDenied) do |err|
  #   render json: {status: 403, message: 'AccessDenied'}, status: 403
  # end
  rescue_from(ActiveRecord::RecordNotFound) do
    render json: {status: 400, message: 'Request data not found'}
  end
  # rescue_from(Wechat::ResponseError) do |err|
  #   render json: {status: 400, message: "wechat error: #{err.message}"}
  # end


  def requires!(name, opts = {})
    opts[:require] = true
    optional!(name, opts)
  end

  # r_requires! (r = require)
  # format: r_requires! :params_parent_name,[{name: mobile, values:[1,2], type:Array},{..}] => params_parent_name[:mobile] is require
  def r_requires!(params_parent_name, attrs, opts = {})
    opts[:require] = true
    optional!(params_parent_name, opts)
    if attrs.present? && attrs.is_a?(Array)
      attrs.each { |attr|
        opts[:values] = attr[:values]
        opts[:type] = attr[:type]
        opts[:parent_name] = params_parent_name
        optional!(attr[:name], opts)
      }
    else
      render_json([400, 'System Server Require Error'])
    end
  end

  # m_requires!(m = multi)
  # [:mobile,:gender],parent_name: :user => user[mobile]、user[gender] is require
  # [:mobile,:gender] => mobile、gender is require
  def m_requires!(names, opts = {})
    opts[:require] = true
    if opts[:parent_name]
      requires! :"#{opts[:parent_name]}"
    end
    if names.present? && names.is_a?(Array)
      names.each { |name|
        optional!(name, opts)
      }
    else
      render_json([400, 'System Server Require Error'])
    end
  end

  def optional!(name, opts = {})
    parent_params = opts[:parent_name]
    if parent_params.present?
      unless params[parent_params].is_a?(ActionController::Parameters)
        raise ActionController::ParameterMissing.new(parent_params)
      end
      params[name] = params[parent_params][name]
      param_name = "#{parent_params}[#{name}]"
    else
      param_name = name
    end
    if params[name].blank? && opts[:require] == true
      raise ActionController::ParameterMissing.new(param_name)
    end

    if opts[:type].present? && opts[:type] == Array
      unless params[name].is_a?(Array)
        raise ParameterTypeNotAllowed.new(param_name, opts[:type])
      end
    end

    if opts[:values] && params[name].present?
      values = opts[:values].to_a
      if !values.include?(params[name]) && !values.include?("#{params[name]}".to_i)
        raise ParameterValueNotAllowed.new(param_name, opts[:values])
      end
    end

    if params[name].blank? && opts[:default].present?
      params[name] = opts[:default]
    end
  end

  def render_json(result)
    return render json: {status: 400 , message: 'render error'} unless result.is_a?(Array)
    result_length = result.length
    if result_length == 2
      json_data = {status: result[0], message: result[1]}
    else
      json_data = {status: result[0], message: result[1], data: result[2]}
    end
    render json: json_data
  end

  def paginate(resource)
    resource.page(params[:page] || 1).per(params[:per])
  end

  protected

  def validate_error
    render json: {status: 400, type: 'validate_error', message: @record.errors}
  end

  def not_found
    render json: {status: 400, type: 'server_error', message: 'Not found'}
  end

  # def enum_argument(exception)
  #   render json: {status: 400, type: 'argument_error', message: exception.message}
  # end

  # def book_error(exception)
  #   render json: {status: 400, type: 'book_error', message: exception.message}
  # end

  private

  def after_successful_token_authentication
    # Make the authentication token to be disposable - for example
    # renew_authentication_token!
  end
end
