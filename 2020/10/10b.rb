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

  def input; debug ? sample_input_2 : real_input; end

  def print_answer
    puts "ADVENT ANSWER: #{answer}"
  end

  def answer
    possible_paths_from_index(0)
  end

  def possible_paths_from_index(i)
    @answer_cache ||= []
    if @answer_cache[i].nil?
      if i == adjusted_adapter_list.count - 1
        @answer_cache[i] = 1
      else
        path_count = 0
        reachable_indexes_from_index(i).each do |reacher|
          path_count += possible_paths_from_index(reacher)
        end
        @answer_cache[i] = path_count
      end
    end
    @answer_cache[i]
  end

  def reachable_indexes_from_index(i)
    list = []
    (1..3).each do |reach|
      if adjusted_adapter_list[i + reach] && (adjusted_adapter_list[i + reach] - adjusted_adapter_list[i] <= 3)
        list << i + reach
      end
    end
    list
  end

  def adjusted_adapter_list; @adjusted_adapter_list ||= [0] + adapter_list; end

  def adapter_list; @adapter_list ||= input.split("\n").map(&:to_i).sort; end
end

solver = AdventSolver.new
# solver.debug = true
solver.print_answer