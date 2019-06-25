require 'csv'

class CsvImporter
  def initialize(table)
    @snake_case_singular, @upper_camel_case_sing, @large_table = table
  end

  def import
    destroy_all
    row_count = 0; success_count = 0
    puts "Importing #{@snake_case_singular}s...".yellow
    CSV.foreach("./public/data/#{@snake_case_singular}s.csv", headers: true) do |row|
      resource = eval(@upper_camel_case_sing + ".new(row.to_h)")
      @id = row["id"]
      success_count += 1 if save_and_print_result(resource)
      row_count += 1
    end
    puts "#{success_count} #{@snake_case_singular}s created from #{row_count} CSV rows".yellow
  end

  private

  def destroy_all
    puts "Destroying all #{@snake_case_singular}s... ".yellow
    eval(@upper_camel_case_sing + ".destroy_all")
    puts "done".green
  end

  def save_and_print_result(resource)
    if @large_table
      short_result(resource)
    else
      full_result(resource)
    end
  end

  def full_result(resource)
    if resource.save
      print ".".green
      true
    else
      print "X".red
      false
    end
  end

  def short_result(resource)
    if resource.save
      puts "ID #{@id} done".green if @id.to_i % 1000 == 0
      true
    else
      puts "ID #{@id} failed".red
      false
    end
  end
end
