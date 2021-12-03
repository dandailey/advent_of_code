class Solver
  def calculate_answer
    oxygen_generator_rating * c02_scrubber_rating
  end

  def oxygen_generator_rating
    first_line = input_lines.first

    reduction_list = input_lines.dup

    log "reduction_list: #{reduction_list.join(', ')}"
    first_line.length.times do |i|
      gamma_rate = gamma_rate_binary(reduction_list)
      log "gamma_rate: #{gamma_rate}"

      reduction_list = reduction_list.map do |line|
        line[i] == gamma_rate[i] ? line : nil
      end.compact

      log "reduction_list: #{reduction_list.join(', ')}"

      break if reduction_list.length <= 1
    end

    reduction_list.first.to_i(2)
  end

  def c02_scrubber_rating
    first_line = input_lines.first

    reduction_list = input_lines.dup

    log "reduction_list: #{reduction_list.join(', ')}"
    first_line.length.times do |i|
      gamma_rate = gamma_rate_binary(reduction_list)
      log "gamma_rate: #{gamma_rate}"

      reduction_list = reduction_list.map do |line|
        line[i] != gamma_rate[i] ? line : nil
      end.compact

      log "reduction_list: #{reduction_list.join(', ')}"

      break if reduction_list.length <= 1
    end

    reduction_list.first.to_i(2)
  end

  def gamma_rate_binary(input)
    first_line = input.first
    positive_counts = [0] * first_line.length

    input.each_with_index do |reading, i|
      reading.length.times do |j|
        positive_counts[j] += 1 if reading[j] == '1'
      end
    end

    line_count = input.length
    positive_counts.each_with_index.map do |val, i|
      val >= (line_count / 2.0) ? '1' : '0'
    end.join
  end
end
