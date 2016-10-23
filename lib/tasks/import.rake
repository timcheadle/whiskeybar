require 'open-uri'
require 'csv'

namespace :import do
  desc "Import bottles via CSV"
  task bottles: :environment do
    Bottle.destroy_all if ENV["DESTROY_ALL"].present?

    csv_file = open(ENV.fetch("CSV")).read
    CSV.parse(csv_file, headers: true).each do |row|
      puts row.to_hash

      bottle = Bottle.create!(
        name: row["Name"],
        spirit: row["Type"].try(:capitalize),
        location: row["Location"].try(:capitalize),
        acquired_on: Date.strptime(row["Acquired On"] || "1990-01", "%Y-%m"),
        volume: row["Volume (ml)"],
        proof: row["Proof"],
        price: row["Price"],
        notes: row["Notes"],
        acquired: row["Acquired At"],
        release_year: row["Released"],
        open: row["Open"].present?,
        finished: ENV["FINISHED"].present?
      )
    end
  end
end
