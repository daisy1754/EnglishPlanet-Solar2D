require "csv"

entry = []
CSV.foreach("food.csv") do |row|
  entry.push("('#{row[0]}', '#{row[1]}', 'fruit')")
end
out = "[[INSERT INTO words ('word', 'translation', 'category') VALUES\n"
out += entry.join(",\n")
out += ";\n]]"

puts out
