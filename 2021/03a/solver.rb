class Solver
  def calculate_answer
    first_line = input_lines.first
    positive_counts = [0] * first_line.length

    input_lines.each_with_index do |reading, i|
      log "line #{i}: #{reading}"
      reading.length.times do |j|
        log "char #{j}: #{reading[j]}"
        log reading[j].inspect
        positive_counts[j] += 1 if reading[j] == '1'
      end
    end

    line_count = input_lines.length
    gamma_rate = positive_counts.each_with_index.map{|val, i| val > (line_count / 2) ? '1' : '0'}.join.to_i(2)
    epsilon_rate = gamma_rate ^ ('1' * first_line.length).to_i(2)
    log "gamma_rate: #{gamma_rate}, epsilon_rate: #{epsilon_rate}"
    gamma_rate * epsilon_rate
  end
end
