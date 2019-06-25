require 'csv'

desc 'Import "items" CSV rows to development database'
namespace :csv_import do
  task items: :environment do
    row_count = 0
    success_count = 0
    Item.destroy_all
    CSV.foreach('./public/data/items.csv', headers: true) do |row|
      # item = Item.new(id:          row[:id],
      #                 name:        row[:name],
      #                 description: row[:description],
      #                 unit_price:  row[:unit_price],
      #                 merchant:    Merchant.find(row[:id]),
      #                 created_at:  row[:created_at],
      #                 updated_at:  row[:updated_at]
      # )
      item = Item.new(row.to_h)
      if item.save
        print ".".green
        success_count += 1
      else
        print "X".red
      end
      row_count += 1
    end
    puts "\n#{success_count} items created from #{row_count} CSV rows".yellow
  end
end
