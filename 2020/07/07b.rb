class Advent
  def self.input; IO.read('input.txt'); end

  def self.sample_input_1
    <<-HEREDOC
light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.
HEREDOC
  end

  def self.sample_input_2
    <<-HEREDOC
shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags.
HEREDOC
  end

  def self.print_answer
    bag_list = {}
    input.split("\n").each do |raw_bag_rule|
      bag = Bag.new(raw_bag_rule)
      bag_list[bag.color] = bag
    end

    bag = bag_list['shiny gold']
    contained_bag_count = recursive_bag_list_counter bag_list, bag
    puts "ADVENT ANSWER: #{contained_bag_count}"
  end

  def self.recursive_bag_list_counter(bag_list, bag)
    content_count = 0
    unless bag.sub_bag_list == 'no other bags'
      contained_bag = bag.sub_bag_list.split(', ')
      contained_bag.each do |sub_bag_definition|
        if matches = sub_bag_definition.match(/([0-9]+) (.*) bag/)
          if sub_bag = bag_list[matches[2]]
            qty = matches[1].to_i
            nested_content_count = recursive_bag_list_counter(bag_list, sub_bag)
            content_count += qty + (qty * nested_content_count)
          end
        end
      end
    end
    content_count
  end
end

class Bag
  attr_accessor :raw_bag_rule
  attr_accessor :color, :sub_bag_list

  def initialize(raw_bag_rule)
    @raw_bag_rule = raw_bag_rule
    parse_raw_bag_rule
  end

  def parse_raw_bag_rule
    if parts = raw_bag_rule.match(/^(.+) bags contain (.*).$/)
      @color, @sub_bag_list = parts[1], parts[2]
    else
      raise 'BAD BAG RULE'
    end
  end

  def directly_contains?(bag_color)
    sub_bag_list.include? bag_color
  end
end

Advent.print_answer