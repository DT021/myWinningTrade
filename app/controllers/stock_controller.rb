class StockController < ApplicationController
  def dashboard
    # This gives us the results of the leaders in the leader board
    leader_board_results = UserAccountSummary.find_top_results(signed_user.id)
    @world_leader_board = leader_board_results[0]
    @class_leader_board = leader_board_results[1]
  end

  def show
    symbol = params[:id].upcase
    @stock = Finance.current_stock_details(symbol)

    @user_stock = signed_user.user_stocks.includes(:stock).where('stocks.symbol' => symbol).first
    # Setting up the new records in anticipation of an user creating an order
    @buy_order = Buy.new
    @short_sell_borrow_order = ShortSellBorrow.new
    @sell_order = SellTransaction.new
    @date_time_buy_transaction = DateTimeTransaction.new
    @date_time_sell_transaction = DateTimeTransaction.new
    @date_time_short_sell_borrow_transaction = DateTimeTransaction.new
    @stop_loss_buy_transaction = StopLossTransaction.new
    @stop_loss_sell_transaction = StopLossTransaction.new
    @stop_loss_short_transaction = StopLossTransaction.new

    if @stock.nil?
      alert = I18n.t(
        'flash.stock.invalid_symbol', symbol: symbol,
        default: 'No stock matches the symbol %{symbol}.')
      redirect_to dashboard_path, alert: alert
    end
  end

  def details
    @details = Finance.stock_details_for_list(params[:stocks].to_a)
    render json: @details
  end

  def price_history
    @price_history = Finance.stock_price_history(params[:id])
    render json: @price_history.marshal_dump
  end

  def search
    @suggestions = Finance.search_for_stock(params[:term].to_s)
    render json: @suggestions
  end

  def portfolio
    render partial: 'account/portfolio'
  end

  def markets
    @suggestions = ['AAPL', 'GE', 'GOOG', 'JPM']
    @nyse_suggestions = get_symbols('nyse')
    @nasdaq_suggestions = get_symbols('nasdaq')
    @stock = Finance.stock_details_for_list(@suggestions)
    @nyse = Finance.stock_details_for_list(@nyse_suggestions[0..50])
    @nasdaq = Finance.stock_details_for_list(@nasdaq_suggestions[0..50])
    render 'account/markets'
  end

  def leaderboards
    render 'account/leaderboards'
  end

  def trading_analysis
    @stock_summary = signed_user.stock_summary
  end

  private

  def symbol
    params.require(:id).upcase
  end

  def get_symbols(market)
    require 'yahoo_finanza'
    ycl = YahooFinanza::Client.new
    ycl.symbols_by_market(market)
  end
end
