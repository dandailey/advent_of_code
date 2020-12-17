class AdventSolver
  attr_accessor :debug

  def real_input; IO.read('input.txt'); end

  def sample_input
    <<-HEREDOC
35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576
HEREDOC
  end

  def input; debug ? sample_input : real_input; end

  def print_answer
    puts "ADVENT ANSWER: #{answer}"
  end

  def answer
    first_invalid_entry
  end

  def number_list; @number_list ||= input.split("\n").map(&:to_i); end

  def preamble_length; debug ? 5 : 25; end

  def first_invalid_entry
    @first_invalid_entry ||= nil
    if @first_invalid_entry.nil?
      number_list.each_index do |i|
        if i >= preamble_length && ! entry_at_index_is_valid?(i)
          @first_invalid_entry = number_list[i]
          break
        end
      end
    end
    @first_invalid_entry
  end

  def possible_sums_between_indexes(beginning, ending)
    list = number_list[beginning, ending - beginning + 1]
    possible_values = []
    (0..(list.length - 2)).each do |j|
      (j..(list.length - 1)).each do |k|
        possible_values << list[j] + list[k]
      end
    end
    possible_values
  end

  def legal_values_for_index(i)
    possible_sums_between_indexes(i - preamble_length, i - 1)
  end

  def entry_at_index_is_valid?(i)
    legal_values_for_index(i).include? number_list[i]
  end
end

solver = AdventSolver.new
# solver.debug = true
solver.print_answer