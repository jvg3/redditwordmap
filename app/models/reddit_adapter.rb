class RedditAdapter

  def self.get_reddit_data
    puts "START GET REDDIT DATA"
    self.get_subreddit_data
    puts "END GET REDDIT DATA"
  end

  def self.get_subreddit_data
    tagger = EngTagger.new

    res = HTTP.get('https://www.reddit.com/r/the_donald/comments.json?limit=100')
    json = JSON.parse(res.to_s)
    comments = json['data']['children'].map{ |x| x['data'] }
    comments.each do |comment_json|

      comment_down = comment_json['body'].downcase
      tagged = tagger.add_tags(comment_down)
      nouns = (tagger.get_nouns(tagged) || {}).keys

      Mention.create(
        reddit_id: comment_json['id'],
        url: comment_json['permalink'],
        body: comment_json['body'],
        post_title: comment_json['link_title'],
        nouns: nouns
      )
    end
  end
end
