require "csv"

entry = []
CSV.foreach("words.csv") do |row|
  if row[0]
    entry.push("('#{row[0]}', '#{row[1]}', '#{row[2]}')")
  end
end
out = "[[INSERT INTO words ('word', 'translation', 'category') VALUES\n"
out += entry.join(",\n")
out += ";\n]]"

puts out
