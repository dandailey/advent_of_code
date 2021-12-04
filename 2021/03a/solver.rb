class Solver
  def positive_bit_counts(reading_list = nil)
    unless @positive_bit_counts && reading_list.nil?
      @positive_bit_counts = [0] * input_line_length
      reading_list ||= input_lines

      reading_list.each do |reading|
        log "reading: #{reading}"
        input_line_length.times do |j|
          log "char #{j}: #{reading[j]}"
          log reading[j].inspect
          @positive_bit_counts[j] += reading[j].to_i
        end
      end
    end

    @positive_bit_counts
  end

  def gamma_rate(reading_list = nil)
    reading_count = reading_list.length
    positive_bit_counts(reading_list).each.map do |val|
      val >= (reading_count / 2.0) ? '1' : '0'
    end.join.to_i(2)
  end

  def epsilon_rate(reading_list = nil)
    gamma_rate(reading_list) ^ ('1' * input_line_length).to_i(2)
  end

  def calculate_answer
    gamma_rate(input_lines) * epsilon_rate(input_lines)
  end
end
