class Api::V1::MaintenanceServicesController < ApplicationController
  include Params

  def index
    maintenance_service = MaintenanceService.all

    params_filters{ |field, values|
      case field
      when :status
        maintenance_service = maintenance_service.by_status(values)
      when :plate_number
        maintenance_service = maintenance_service.by_plate_number(values)
      end
    }

    meta = {}

    params_pagination(max_limit: 100){ |limit, offset|
    meta[:total] = total = maintenance_service.count
    maintenance_service = offset >= total ?
      maintenance_service.none :
      maintenance_service.limit(limit).offset(offset).order(:id)
  }

    params_fields_include(params[:include_fields]) if params[:include_fields]

    render json: maintenance_service,
      each_serializer: Api::V1::MaintenanceServiceSerializer, include_fields: include_fields, meta: meta
  end

  def show
    maintenance_service = MaintenanceService.find_by(id: params[:id])
    return not_found unless maintenance_service

    render json: maintenance_service, serializer: Api::V1::MaintenanceServiceSerializer
  end

  def create
    maintenance_service = MaintenanceService.create!(maintenance_services_params)

    render json: maintenance_service, serializer: Api::V1::MaintenanceServiceSerializer
  end

  def update
    maintenance_service = MaintenanceService.find_by(id: params[:id])
    return not_found unless maintenance_service

    maintenance_service.with_lock do
      maintenance_service.update!(maintenance_services_params)
    end

    render json: maintenance_service, serializer: Api::V1::MaintenanceServiceSerializer
  end

  def destroy
    maintenance_service = MaintenanceService.find_by(id: params[:id])
    return not_found unless maintenance_service

    maintenance_service.destroy!

    head :no_content
  end

  private

  def maintenance_services_params
    params.require(:maintenance_service).permit(:car_id, :description, :status, :date)
  end

end
