input = IO.read('input.txt')

valid_count = 0
input.split("\n").each do |line|
  if match_parts = line.match(/([0-9]+)-([0-9]+) ([a-z]): ([a-z]+)/)
    first_pos, second_pos, letter, password = *match_parts[1,4]
    if (password[first_pos.to_i-1] == letter) ^ (password[second_pos.to_i-1] == letter)
      puts "YAY: #{line}"
      valid_count += 1
    else
      puts "BOO: #{line}"
    end
  else
    raise '??'
  end
end; nil
puts valid_count
