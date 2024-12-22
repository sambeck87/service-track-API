module Params
	extend ActiveSupport::Concern

	protected

	def params_fields_include(fields)
		@serializer_opts ||= {}
		fields = fields.to_s.split(',') if fields.is_a?(String)
		(@serializer_opts[:include_fields] ||= []).concat(fields.map(&:to_s))
	end

	def include_fields
		@serializer_opts&.dig(:include_fields) || []
	end

	def params_pagination(max_limit: 200, force: true)
		limit, offset = params.values_at(:limit, :offset)
		limit = max_limit if force and !limit.present?

		if limit.present?
			limit = limit.to_s.to_i
			limit = [0, limit, max_limit].sort[1]
			offset = offset.to_s.to_i
			offset = [0, offset].sort[1]

			yield(limit, offset)
		end

		[limit, offset]
	end

	def params_filters(restrict: nil)
		filters = params[:filters]
		return unless filters.is_a?(String)

		current_string = current_key = ''
		array_stack = []
		current_values = []
		current_hash = {}

		filters.each_char{ |c|
			case c
			when 'a'..'z', 'A'..'Z', '0'..'9', '_', '-', '*', '.'
				current_string << c
			when '='
				current_key = current_string.to_sym if current_string.present?
				current_string = ''
			when ','
				current_values << current_string if current_string.present?
				current_string = ''
			when ';'
				current_values << current_string if current_string.present?
				current_hash[current_key.to_sym] = current_values if current_values.present?
				current_string = current_key = ''
				current_values = []
			when '('
				current_key = current_string.to_sym if current_string.present?
				array_stack << current_hash
				current_hash = array_stack.length <= 2 ?
					(current_hash[current_key] = {}) : {}
				current_string = current_key = ''
			when ')'
				current_values << current_string if current_string.present?
				current_hash[current_key.to_sym] = current_values if current_values.present?
				current_hash = array_stack.pop
				current_string = current_key = ''
				current_values = []
			end
		}

		current_values << current_string if current_string.present?
		current_hash[current_key.to_sym] = current_values if current_values.present?
		filters = current_hash

		filters.each{ |key, values|
			if values.is_a?(Hash)
				values.each{ |sub_key, values|
					if values.is_a?(Hash)
						values.each{ |sub_sub_key, values|
							yield(sub_sub_key, values, sub_key)
						}
					else
						yield(sub_key, values, key)
					end
				}
			else
				yield(key, values)
			end
		} if block_given?

		filters
	end
end