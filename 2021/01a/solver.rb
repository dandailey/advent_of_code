class Solver
  def calculate_answer
    input_lines.each_with_index.map do |measurement, i|
      true if i > 0 && measurement.to_i > input_lines[i-1].to_i
    end.compact.count
  end
end
