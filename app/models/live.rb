class Live < ApplicationRecord
  has_many :songs, dependent: :restrict_with_exception

  validates :name, presence: true,
    uniqueness: {scope: :date}
  validates :date, presence: true
  validates :album_url,
    format: /\A#{URI.regexp(%w[http https])}\z/,
    allow_blank: true

  scope :order_by_date, -> { order(date: :desc) }
  scope :visible, -> { where("date < ?", Date.today + 1.week) }

  def title
    "#{date.year} #{name}"
  end

  def self.years
    Live.order_by_date.select(:date).map(&:nendo).uniq
  end

  def nendo
    if date.mon < 4
      date.year - 1
    else
      date.year
    end
  end
end
