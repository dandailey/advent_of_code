# USAGE: ruby main.rb [debug] [output] [instructions]

require 'net/http'
require 'uri'

def open_url(url); Net::HTTP.get(URI.parse(url)); end


module AdventTools

  attr_accessor :debug, :show_output, :show_instructions, :output_log, :answer

  def initialize(params = {})
    self.debug = params[:debug] == true
    self.show_output = params[:show_output] == true
    self.show_instructions = params[:show_instructions] == true
    self.output_log = []
    self.answer = self.calculate_answer
    self.save_answer unless self.debug
  end

  def instructions
    IO.read('instructions.txt')
  rescue
    nil
  end

  def real_input; @real_input ||= IO.read('input.txt'); end

  def sample_input
    @sample_input ||= IO.read('input.sample.txt')
  rescue
    real_input
  end

  def input; debug ? sample_input : real_input; end

  def input_lines; @input_lines ||= input.split("\n"); end

  def input_line_count; @input_line_count ||= input_lines.length; end

  def input_line_length; @input_line_length ||= input_lines.first.length; end

  def log(val); self.output_log ||= []; self.output_log << val; end

  def calculate_answer; 0; end

  def save_answer; IO.write('answer.txt', answer); end

  def run
    puts instructions if show_instructions

    puts self.output_log.each { |line| puts line } if show_output

    puts "ADVENT ANSWER: #{answer}"
  end

end

params = {
  debug: false,
  show_output: false,
}

if ARGV.length > 0 && ARGV[0].upcase == 'SETUP'
  unless File.exist?('solver.rb')
    IO.write('solver.rb', <<-HEREDOC
class Solver
  def calculate_answer
  end
end
HEREDOC
)
  end

  for i in 1 ... ARGV.length
    if matchdata = ARGV[i].match(/^(20[0-9]{2})\/([0-9]{1,2})$/)
      year = matchdata[1]
      day = matchdata[2]
      page_content = open_url("https://adventofcode.com/#{year}/day/#{day.to_i}/input")
      # this line isn't working without being authenticated... something to do later?
      # IO.write('input.txt', page_content) unless File.exist?('input.txt')
    end
  end

  IO.write('input.txt', '') unless File.exist?('input.txt')
  IO.write('input.sample.txt', '') unless File.exist?('input.sample.txt')

else
  for i in 0 ... ARGV.length
    if ARGV[i].upcase == 'DEBUG'
      params[:debug] = true
    elsif ARGV[i].upcase == 'OUTPUT'
      params[:show_output] = true
    elsif ARGV[i].upcase == 'INSTRUCTIONS'
      params[:show_instructions] = true
    end
  end


  require_relative "solver.rb"
  Solver.include AdventTools

  solver = Solver.new(params)
  solver.run
end