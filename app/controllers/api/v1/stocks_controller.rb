module Api
  module V1
    class StocksController < ApplicationController
      skip_before_filter :verify_authenticity_token
      skip_before_filter :require_login, :require_acceptance_of_terms, :load_portfolio
      respond_to :json

      def search
        suggestions = Finance.search_for_stock(params[:term].to_s)

        puts params[:term].to_s

        render :json => suggestions.to_json
      end

      def details
        details = Finance.current_stock_details(params[:symbol].upcase)

        if details
          render :json => details.to_json
        else
          render :json => { }
        end
      end
    end
  end
end
