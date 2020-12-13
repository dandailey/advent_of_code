input = IO.read('input.txt')

tree_count_list = []

show_output = true

canvas_width = nil

[
  [1,1],
  [1,3],
  [1,5],
  [1,7],
  [2,1],
].each_with_index do |slope_definition, run_count|
  puts "\n=== RUN NUMBER #{run_count + 1} =========\n"

  x_pos = 0
  line_decrementer = 0

  descent_rate, slope = *slope_definition

  tree_count = 0

  input.split("\n").each do |line|
    canvas_width ||= line.length

    puts line if show_output

    if line_decrementer == 0
      adjusted_x_pos = x_pos % canvas_width
      impact = line[adjusted_x_pos] == '#'
      tree_count += 1 if impact

      line_decrementer = descent_rate
      x_pos += slope

      puts (' ' * adjusted_x_pos) + (impact ? "X  #{tree_count} TREES" : '-') if show_output
    else
      puts '' if show_output
    end

    line_decrementer -= 1
  end

  puts "You hit #{tree_count} trees"
  tree_count_list << tree_count
end

puts "TREE COUNT LIST: #{tree_count_list.inspect}"
puts "ADVENT ANSWER IS #{tree_count_list.inject(:*)}"
