class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks

  has_many :friendships
  has_many :friend, through: :friendships
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def stock_already_tracked?(ticker_symbol)
    stock = Stock.check_db(ticker_symbol)
    return false unless stock

    stocks.where(id: stock.id).exists?
  end

  def under_stock_limit?
    stocks.count < 10
  end

  def can_track_stock?(ticker_symbol)
    under_stock_limit? && !stock_already_tracked?(ticker_symbol)
  end

  def full_name
    if first_name || last_name
      "#{first_name} #{last_name}"
    else
      'Anonymous'
    end
  end

  def self.search(param)
    param.strip!
    results = (first_name_matches(param) + last_name_matches(param) + email_matches(param)).uniq
    p results
    return nil unless results

    results
  end

  def self.first_name_matches(param)
    matches('first_name', param)
  end

  def self.last_name_matches(param)
    matches('last_name', param)
  end

  def self.email_matches(param)
    matches('email', param)
  end

  def self.matches(field_name, param)
    where("#{field_name} like ?", "%#{param}%")
  end

  def except_current_user(users)
    users.reject { |user| user.id == id }
  end

  def not_friend_with?(friend_id)
    p friend_id
    # p friendships.all
    p !friendships.where(friend_id:).first
  end
end
