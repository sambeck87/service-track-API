class ApplicationController < ActionController::API
	before_action :authorize_request

  rescue_from ActionController::BadRequest, with: :render_bad_request
	rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
  rescue_from ActionController::ParameterMissing, with: :unprocessable_entity
	rescue_from ActiveRecord::RecordNotUnique, with: :handle_record_not_unique

  private

	def unprocessable_entity(errors = nil)
		negative_respond(:unprocessable_entity, errors)
	end

	def authorize_request
		token = request.headers['Authorization']&.split(' ')&.last
		return render json: { error: 'Missing token' }, status: :unauthorized unless token

		decoded_token = JsonWebToken.decode(token)
		@current_user = User.find_by(id: decoded_token[:user_id]) if decoded_token

		return unauthorized unless @current_user
	end

	def forbidden(errors = nil)
		negative_respond(:forbidden, errors)
	end

	def not_found(errors = nil)
		negative_respond(:not_found, errors)
	end

	def unauthorized(errors = nil)
		render json: { error: 'Unauthorized' }, status: :unauthorized
	end

	def negative_respond(http_respond = :bad_request, errors = nil)
		return if performed?
		errors = { error_description: errors } if errors.is_a?(String)

		if errors
			logger.error("  #{http_respond} #{errors.inspect}")
			render json: errors, status: http_respond
		else
			head http_respond
		end

		nil
	end
end
