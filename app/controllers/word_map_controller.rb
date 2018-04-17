class WordMapController < ApplicationController
  def index
    respond_to do |format|
      format.html do
        @mentions = Mention.mentions_from_date(Time.now.utc - 1.hour)
      end
      format.json do
        mentions = Mention.mentions_from_date(Time.now.utc - 1.day)
        word_counts = {}

        mentions.each do |mention|
          mention.nouns.each do |noun|

            if noun.length < 16 && noun.length > 3
              word_counts[noun] ||= 0
              word_counts[noun] += 1
            end
          end
        end

        word_counts.delete('https')
        json_words = word_counts.map{ |word, count| { text: word, size: count } }
        json_words.reject!{ |w| w[:size] < 3 }
        json_words.sort!{ |x,y| y[:size] <=> x[:size] }

        # normalize
        max = json_words.first[:size] || 1
        json_words.each{ |w| w[:size] = (w[:size].to_f*200)/max }

        render json: { words: json_words.first(300) }
      end
    end
  end
end
