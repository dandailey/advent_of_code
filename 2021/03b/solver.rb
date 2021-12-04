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
    oxygen_generator_rating(input_lines) * c02_scrubber_rating(input_lines)
  end

  def calculate_rating(reading_list, mask_maker)
    first_line = reading_list.first
    reduction_list = (reading_list || input_lines).dup

    input_line_length.times do |i|
      mask = send(mask_maker, reduction_list)
      mask = mask.to_s(2).rjust(input_line_length, '0')

      log "reduction_list (#{mask}): #{reduction_list.join(', ')}"
      reduction_list = reduction_list.map do |line|
        line[i] == mask[i] ? line : nil
      end.compact

      break if reduction_list.length <= 1
    end

    log "final: #{reduction_list.first}"

    reduction_list.first.to_i(2)
  end

  def oxygen_generator_rating(reading_list = nil)
    calculate_rating reading_list, :gamma_rate
  end

  def c02_scrubber_rating(reading_list = nil)
    calculate_rating reading_list, :epsilon_rate
  end
end
