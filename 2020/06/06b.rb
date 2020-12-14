class Advent
  def self.input; IO.read('input.txt'); end

  def self.sample_input
    <<-HEREDOC
abc

a
b
c

ab
ac

a
a
a
a

b
HEREDOC
  end

  def self.print_answer
    sum_of_unanimous_answer_counts_per_group = 0
    input.split("\n\n").each do |raw_group_data|
      answer_set_group = AnswerSetGroup.new(raw_group_data)
      puts 'BEGIN ANSWER SET GROUP'
      puts answer_set_group.raw_group_data
      puts ">> #{answer_set_group.unanimous_answers.count} UNANIMOUS ANSWERS: " \
        + answer_set_group.unanimous_answers.inspect + "\n\n"
      sum_of_unanimous_answer_counts_per_group += answer_set_group.unanimous_answers.count
    end
    puts "ADVENT ANSWER: #{sum_of_unanimous_answer_counts_per_group}"
  end
end

class AnswerSetGroup
  attr_accessor :raw_group_data

  def initialize(raw_group_data)
    @raw_group_data = raw_group_data
  end

  def answer_set_list
    @answer_set_list ||= raw_group_data.split("\n")
  end

  def unanimous_answers
    @unanimous_answers ||= answer_set_list.
      map{ |a| a.split('') }.
      inject{ |sum, n| sum & n }
  end
end

Advent.print_answer