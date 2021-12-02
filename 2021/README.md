Create a folder with an alphanumeric name. In that folder, add a file called solver.rb which defines the following:

class Solver
  def calculate_answer
  end
end

The calculate_answer() method is expected to return an answer

Next, create files in that folder names input.txt and [optionally] input.sample.txt. These files should hold the input for your sample run and your real run.

Now, from the command line, if the folder were named `01a` run:

ruby advent_solver.rb 01a

You will get your answer, and it will be written to a file called answer.txt

The command line accepts optional arguments:
  - DEBUG - runs with sample input and does not save the answer
  - OUTPUT - if log statements are present in your code, they'll be shown
  - INSTRUCTIONS - outputs the contents of an optional instructions.txt file

Within your calculate_answer method, you have access to an `input` method, which will be the contents of either input.txt or input.sample.txt, depending on whether you're running in debug mode or not. Manual methods are available for real_input() and `sample_input`

Available Methods:

- `input`: the contents of either input.txt or input.sample.txt, depending on whether you're running in debug mode or not. Wrapper method for either `real_input` or `sample_input`

- `real_input`: the contents of input.txt

- `sample_input`: the contents of input.sample.txt

- `log`: can be given log statements which will be output on the CLI if the OUTPUT option is provided

- `input_lines`: a parsed array of lines from `input`

- `instructions`: the contents of instructions.txt