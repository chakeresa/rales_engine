require 'csv'

desc 'Import "transactions" CSV rows to development database'
namespace :csv_import do
  task transactions: :environment do
    row_count = 0
    success_count = 0
    puts "Destroying all transactions... ".yellow
    Transaction.destroy_all
    puts "done".green
    puts "Importing transactions...".yellow
    CSV.foreach('./public/data/transactions.csv', headers: true) do |row|
      transaction = Transaction.new(row.to_h)
      if transaction.save
        puts "ID #{row["id"]} done".green if row["id"].to_i % 1000 == 0
        success_count += 1
      else
        puts "ID #{row["id"]} failed".red
      end
      row_count += 1
    end
    puts "#{success_count} transactions created from #{row_count} CSV rows".yellow
  end
end
