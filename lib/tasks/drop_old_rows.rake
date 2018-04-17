task drop_old_rows: :environment do
  puts "DROPPING OLD ROWS"
  Mention.drop_old_rows
  puts "ROWS DROPPED"
end