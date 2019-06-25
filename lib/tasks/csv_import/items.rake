require 'csv'

desc 'Import "items" CSV rows to development database'
namespace :csv_import do
  task items: :environment do
    row_count = 0
    success_count = 0
    puts "Destroying all items... ".yellow
    Item.destroy_all
    puts "done".green
    puts "Importing items...".yellow
    CSV.foreach('./public/data/items.csv', headers: true) do |row|
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
