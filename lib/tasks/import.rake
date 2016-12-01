require 'open-uri'
require 'csv'

namespace :import do
  desc "Import bottles via CSV"
  task bottles: :environment do
    Bottle.destroy_all if ENV["DESTROY_ALL"].present?
    user = User.find_by(email: "tim@rationalmeans.com")

    csv_file = open(ENV.fetch("CSV")).read
    CSV.parse(csv_file, headers: true).each do |row|
      puts row.to_hash

      Bottle.transaction do
        Bottle.create!(
          user: user,
          name: row["Name"],
          spirit: row["Type"],
          location: row["Location"],
          acquired_on: Date.strptime(row["Acquired On"] || "1990-01", "%Y-%m"),
          volume: row["Volume (ml)"],
          proof: row["Proof"],
          price: row["Price"],
          notes: row["Notes"],
          source: row["Acquired At"],
          release_year: row["Released"],
          open: row["Open"].present?,
          finished_on: row["Finished On"].present? ? Date.strptime(row["Finished On"], "%m/%d/%Y") : nil,
        )
      end
    end
  end
end
