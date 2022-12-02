require 'csv'

class Holidays

  def today
    records[Date.today]
  end

  private

  def records
    @records ||= begin
      rows.each_with_object({}) do |row, all|
        date = Date.parse("#{row[1]} #{Date.today.year}")
        all[date] = {
          name: row[2],
          moon: row[3]
        }
      end
    end
  end

  def rows
    @rows ||= CSV.read("./holidays.csv")
  end
end
