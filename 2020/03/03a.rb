input = IO.read('input.txt')

x_pos = 0
slope = 3
tree_count = 0
canvas_width = nil

input.split("\n").each do |line|
  canvas_width ||= line.length
  adjusted_x_pos = x_pos % canvas_width
  impact = line[adjusted_x_pos] == '#'
  tree_count += 1 if impact

  puts line
  puts (' ' * adjusted_x_pos) + (impact ? 'X' : '-')

  x_pos += slope
end

puts "You hit #{tree_count} trees"
