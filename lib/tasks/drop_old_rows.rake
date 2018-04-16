task drop_old_rows: :environment do
  Mention.drop_old_rows
end