class Mention < ActiveRecord::Base
  validates_uniqueness_of :reddit_id

  def self.mentions_from_date(date)

    sql = <<-SQL
      SELECT *
      FROM mentions
      WHERE mentions.created_at > ?
      ORDER BY created_at DESC
    SQL

    params_arr = [date]

    Mention.find_by_sql([sql].concat(params_arr))
  end

  def self.drop_old_rows
    Mention.where('created_at < ?', Date.today.advance(days: -14)).destroy_all
  end
end
