input = IO.read('input.txt')

valid_count = 0
input.split("\n").each do |line|
  if match_parts = line.match(/([0-9]+)-([0-9]+) ([a-z]): ([a-z]+)/)
    min, max, letter, password = *match_parts[1,4]
    stripped_password = password.gsub(/[^#{letter}]/, '')
    if (min.to_i..max.to_i).include?(stripped_password.length)
      puts "YAY: #{line} :: #{stripped_password} :: #{stripped_password.length}"
      valid_count += 1
    else
      puts "BOO: #{line} :: #{stripped_password} :: #{stripped_password.length}"
    end
  else
    raise '??'
  end
end; nil
puts valid_count
