class WordMapController < ApplicationController
  def index
    respond_to do |format|
      format.html do

        @mentions = Mention.mentions_from_date(Time.now.utc - 1.hour)
      end
      format.json do
        tagger = EngTagger.new
        mentions = Mention.mentions_from_date(Time.now.utc - 1.day)
        word_counts = {}

        mentions.each do |mention|
          tagged = tagger.add_tags(mention.body)
          (tagger.get_nouns(tagged) || []).each do |noun_count|

            noun = noun_count[0].downcase
            if noun.length < 14 && noun.length > 3
              word_counts[noun] ||= 0
              word_counts[noun] += 1
            end
          end
        end

        json_words = word_counts.map{ |word, count| { text: word, size: count } }
        json_words.reject!{ |w| w[:size] < 3 }
        json_words.sort!{ |x,y| y[:size] <=> x[:size] }

        render json: { words: json_words.first(300) }
      end
    end
  end
end
