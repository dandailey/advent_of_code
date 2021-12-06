class Solver

  CYCLE_LENGTH = 7
  FRESH_CYCLE_LENGTH = 8

  attr_accessor :fish_list_by_date

  def fish_list_by_date
    @fish_list_by_date ||= [input.split(',').map(&:to_i)]
  end

  def populate_fish_list_by_date_until(day)
    if fish_list_by_date[day].nil?
      for i in @fish_list_by_date.length..day do
        fish_list = @fish_list_by_date[i - 1]
        spawn_count = 0
        @fish_list_by_date << \
          fish_list.map do |cycle_index|
            spawn_count += 1 if cycle_index == 0
            new_cycle_value = cycle_index - 1
            new_cycle_value = CYCLE_LENGTH - 1 if new_cycle_value < 0
            new_cycle_value
          end

        spawn_count.times do
          @fish_list_by_date[i] << FRESH_CYCLE_LENGTH
        end
      end
    end
    fish_list_by_date[day]
  end

  def fish_list_for_day(day)
    populate_fish_list_by_date_until(day)
  end

  def calculate_answer
    fish_list_for_day(80).length
  end
end
