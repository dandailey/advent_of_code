class AdventSolver
  attr_accessor :debug

  def real_input; IO.read('input.txt'); end

  def sample_input_1
    <<-HEREDOC
16
10
15
5
1
11
7
19
6
12
4
HEREDOC
  end

  def sample_input_2
    <<-HEREDOC
28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3
HEREDOC
  end

  def input; debug ? sample_input_1 : real_input; end

  def print_answer
    puts "ADVENT ANSWER: #{answer}"
  end

  def answer
    count_gaps_of_size(1) * count_gaps_of_size(3)
  end

  def count_gaps_of_size(target_gap_size)
    previous_adapter_size = nil
    count_for_gap_size = 0
    (adapter_list + [adapter_list.last + 3]).each do |adapter_size|
      if adapter_size - previous_adapter_size.to_i == target_gap_size
        count_for_gap_size += 1
      end
      previous_adapter_size = adapter_size
    end
    count_for_gap_size
  end

  def adapter_list; @adapter_list ||= input.split("\n").map(&:to_i).sort; end
end

solver = AdventSolver.new
# solver.debug = true
solver.print_answer