# Automatic Setup

From this folder, just run something like `ruby setup.rb 01a`. This will create a folder called `01a`, copy `main.rb` into the folder, and uses `main.rb` to stub out the needed files within that new folder.

If you'd rather do it yourself, though:

Copy `main.rb` into it's own folder, then run `ruby main.rb setup`. This will create files called `solver.rb`, `input.txt`, and `input.sample.txt`. If you pass an argument that looks like a year/day combination (ex: `2021/01`) it will attempt to load `input.txt` with your actual input.

# How it Works

Each solution folder should have it's own copy of `main.rb`, which can be ran from the command line to actually execute the solution. It expects to find a file called `solver.rb` to exist which defines the following:

```
class Solver
  def calculate_answer
  end
end
```

The `calculate_answer` method is expected to return an answer

Next, create files in that folder names `input.txt` and [optionally] `input.sample.txt`. These files should hold the input for your sample run and your real run.

Now, from the command line, if the folder were named `01a` run:

`ruby advent_solver.rb 01a`

You will get your answer, and it will be written to a file called `answer.txt`

The command line accepts some optional arguments:
  - `debug` - Runs with sample input and does not save the answer.
  - `output` - If log statements are present in your code, they'll be shown. Automatically turned on when in debug mode`.
  - `instructions` - Outputs the contents of an optional `instructions.txt` file.

# Available Methods

Within your `calculate_answer` method, you have access to an `input` method, which will be the contents of either `input.txt` or `input.sample.txt`, depending on whether you're running in debug mode or not. Manual methods are available for `real_input` and `sample_input`

- `input`: the contents of either `input.txt` or `input.sample.txt`, depending on whether you're running in debug mode or not. Wrapper method for either `real_input` or `sample_input`

- `real_input`: the contents of `input.txt`

- `sample_input`: the contents of `input.sample.txt`

- `log`: can be given log statements which will be output on the CLI if the OUTPUT option is provided

- `input_lines`: a parsed array of lines from `input`

- `instructions`: the contents of `instructions.txt`

# Hooks For Before and After Solving

You may optionally define methods named `before_run` and `after_run`, which will be executed at the beginning and end of executing the solution (effectively, before and after running your `calculate_answer` method)

# Dealing With Evolution

NOTE: a separate copy of `main.rb` is in each solution folder to eliminate dependancies. `main.rb` is expected to evolve over time, which could break old solutions. The latest version is always to be defined here, and copied to each folder to be modified as needed. That way a frozen copy of it is in each folder, which is known to work for that solution.