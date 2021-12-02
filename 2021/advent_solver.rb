# USAGE: ruby advent_solver.rb 01a [debug] [output] [instructions]

module AdventTools

  attr_accessor :solver_path, :debug, :show_output, :show_instructions, :output_log, :answer

  def initialize(params = {})
    self.solver_path = params[:solver_path]
    self.debug = params[:debug] == true
    self.show_output = params[:show_output] == true
    self.show_instructions = params[:show_instructions] == true
    self.output_log = []
    self.answer = self.calculate_answer
    self.save_answer unless self.debug
  end

  def instructions; IO.read(solver_path + 'instructions.txt'); end

  def real_input; IO.read(solver_path + 'input.txt'); end
  def sample_input; IO.read(solver_path + 'input.sample.txt'); end
  def input; debug ? sample_input : real_input; end
  def input_lines; @input_lines ||= input.split("\n"); end

  def log(val); self.output_log ||= []; self.output_log << val; end

  def calculate_answer; 0; end

  def save_answer; IO.write(solver_path + 'answer.txt', answer); end

  def run
    puts instructions if show_instructions

    puts self.output_log.each { |line| puts line } if show_output

    puts "ADVENT ANSWER: #{answer}"
  end

end

solver_path = nil
params = {
  solver_path: nil,
  debug: false,
  show_output: false,
}

for i in 0 ... ARGV.length
  if i == 0
    params[:solver_path] = "./#{ARGV[i].gsub(/[^a-zA-Z0-9]/, '')}/"
  else
    if ARGV[i].upcase == 'DEBUG'
      params[:debug] = true
    elsif ARGV[i].upcase == 'OUTPUT'
      params[:show_output] = true
    elsif ARGV[i].upcase == 'INSTRUCTIONS'
      params[:show_instructions] = true
    end
  end
end

require_relative "#{params[:solver_path]}solver.rb"
Solver.include AdventTools

solver = Solver.new(params)
solver.run