class WordMapController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json do
        mentions = Mention.mentions_from_date(Time.now.utc - 1.hour)
        word_counts = {}

        words = mentions.map(&:body).join(' ').split(/\W+/).map(&:downcase)
        words.reject!{ |w| w.length < 5 || w.length > 16 }
        words.each do |word|
          word_counts[word] ||= 0
          word_counts[word] += 1
        end

        json_words = word_counts.map{ |word, count| { text: word, size: count } }
        json_words.sort!{ |x,y| y[:size] <=> x[:size] }

        render json: { words: json_words.first(20) }
      end
    end
  end
end
