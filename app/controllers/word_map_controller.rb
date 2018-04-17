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

        word_counts.delete('https')

        json_words = word_counts.map{ |word, count| { text: word, size: count } }
        json_words.reject!{ |w| w[:size] < 3 }
        json_words.sort!{ |x,y| y[:size] <=> x[:size] }
        json_words = normalize(json_words)

        render json: { words: json_words.first(300) }
      end
    end
  end

  def normalize(json_words)
    max = json_words.first.size
    json_words.each{ |x| w[:size] = w[:size].to_f*100/max }
  end
end
