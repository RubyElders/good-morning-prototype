require 'csv'

class SeasonalEvents

  def today
    records[Date.today]
  end

  private

  def records
    @records ||= begin
      rows.each_with_object({}) do |row, all|
        next if row[0].nil? || row[0].empty?
        date = Date.parse("#{row[0]} #{Date.today.year}")
        all[date] = {
          event: row[1]
        }
      end
    end
  end

  def rows
    @rows ||= CSV.read("./seasonal_events.csv")
  end
end

