class Solver

  CYCLE_LENGTH = 7
  FRESH_CYCLE_LENGTH = 8

  def calculate_spawn_count(current_cycle_index, days_remaining)
    days_to_next_spawn = current_cycle_index + 1
    spawn_count = 0

    loop do
      break if days_to_next_spawn > days_remaining
      spawn_count += 1
      days_remaining -= days_to_next_spawn
      days_to_next_spawn = CYCLE_LENGTH
      spawn_count += calculate_spawn_count(FRESH_CYCLE_LENGTH, days_remaining)
    end

    spawn_count
  end

  def calculate_answer
    days_to_measure = 256
    possible_sub_counts = []
    (CYCLE_LENGTH).times do |i|
      puts "Calculating counts for starting value of #{i}..."
      possible_sub_counts << calculate_spawn_count(i, days_to_measure)
      puts "Answer is #{possible_sub_counts.last}"
    end

    original_fish_list = input.split(',').map(&:to_i)
    count = original_fish_list.length
    original_fish_list.each do |cycle_index|
      count += possible_sub_counts[cycle_index]
    end
    count
  end
end
