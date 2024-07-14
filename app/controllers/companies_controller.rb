class CompaniesController < ApplicationController
  def index
    filters = extract_filters(params)
    limit = params[:limit].presence || 10
    offset = params[:offset].presence || 0

    begin
      service = YcScraper::CompanyListService.new
      companies = service.fetch_companies(filters, limit.to_i, offset.to_i)
      render json: companies
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  private

  def extract_filters(params)
    {
      batch: params[:batch],
      industry: params[:industry],
      region: params[:region],
      tag: params[:tag],
      company_size: params[:company_size],
      is_hiring: to_boolean(params[:is_hiring]),
      nonprofit: to_boolean(params[:nonprofit]),
      black_founded: to_boolean(params[:black_founded]),
      hispanic_latino_founded: to_boolean(params[:hispanic_latino_founded]),
      women_founded: to_boolean(params[:women_founded])
    }.compact
  end

  def to_boolean(param)
    ActiveModel::Type::Boolean.new.cast(param) if param.present?
  end
end
