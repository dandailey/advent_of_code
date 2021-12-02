class Solver
  def calculate_answer
    window_size = 3
    measurement_list = input_lines.map(&:to_i)
    measured_increases = 0

    (measurement_list.size - window_size).times do |i|
      if measurement_list[i, window_size].sum < measurement_list[i+1, window_size].sum
        measured_increases +=1
      end
    end

    measured_increases
  end
end
