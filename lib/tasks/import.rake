require 'open-uri'
require 'csv'

namespace :import do
  desc "Import bottles via CSV"
  task bottles: :environment do
    Bottle.destroy_all if ENV["DESTROY_ALL"].present?

    CSV.foreach(open(ENV.fetch("CSV")), headers: true) do |row|
      puts row.to_hash

      bottle = Bottle.create!(
        name: row["Name"],
        spirit: row["Type"].capitalize,
        location: row["Location"].capitalize,
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
