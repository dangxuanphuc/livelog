class Song < ApplicationRecord
  VALID_YOUTUBE_REGEX =
    %r(\A
      (?:https?://)?
      (?:www\.youtube\.com/watch\?(?:\S*&)*v=
      |youtu\.be/)
      (?<id>\S{11})
    )x

  belongs_to :live
  has_many :playings, dependent: :destroy, inverse_of: :song
  has_many :users, through: :playings
  accepts_nested_attributes_for :playings, allow_destroy: true

  validates :live_id, presence: true
  validates :name, presence: true
  validates :youtube_id, format: {with: VALID_YOUTUBE_REGEX}, allow_blank: true
  before_save :extract_youtube_id

  default_scope { includes(:live).order("lives.date DESC", :order) }

  def extract_youtube_id
    unless youtube_id.blank?
      m = youtube_id.match(VALID_YOUTUBE_REGEX)
      self.youtube_id = m[:id]
    end
  end

  def youtube_url
    "https://www.youtube.com/watch?v=#{youtube_id}" unless youtube_id.blank?
  end

  def youtube_embed
    %(<iframe src="https://www.youtube.com/embed/#{youtube_id}?rel=0" frameborder="0" allowfullscreen></iframe>).html_safe
  end

  def time_str
    time.strftime("%R")
  end

  def previous
    Song.find_by(id: id - 1) unless order.blank?
  end

  def next
    Song.find_by(id: id + 1) unless order.blank?
  end
end