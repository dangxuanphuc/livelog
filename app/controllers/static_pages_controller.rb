class StaticPagesController < ApplicationController
  def home
    @songs = Song.all.order_by_live.includes(playings: :user)
      .page(params[:page])
      .per Settings.size_page_max_length
  end

  def stats
    if params[:y]
      start = Date.new(params[:y].to_i, 4, 1)
      range = (start...start + 1.year)
    else
      stop = Date.today
      range = (stop - 1.year..stop)
    end

    @songs = Song.includes(:live).where("lives.date" => range)
    @playings = Playing.includes(song: :live).where("lives.date" => range)
  end
end
