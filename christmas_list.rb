require 'json'
require 'open-uri'
require 'nokogiri'


puts "Welcome to your Christmas List!"
sleep 1
puts "What's your name?"
user_name = gets.chomp
  if user_name == "Zach"
    puts "Oh, you're a homosexual. That's okay."
  end

sleep 1

puts "Great #{user_name}, let's get started."
sleep 1

christmas_list = {}
user_action = "nothing yet"

def view_list(hash)
  order = 0
  hash.each do |item, status|
    order += 1
    list = { Order:"#{order}", Item:"#{item}", Status:"#{status}" }
      File.open('christmas.json', 'w') do |file|
        file.write(JSON.generate(list))
      end
    puts "#{order}: #{item} - #{status}"
  end
end

until user_action == "quit"
puts "What would you like to do? add|delete|mark|view|idea|quit"
user_action = gets.chomp

  if user_action == "add"
    puts "What would you like to add?"
    item_to_add = gets.chomp
    if !christmas_list.key?(item_to_add)
      christmas_list[item_to_add] = "| |"
    else
      puts "You already have a #{item_to_add}."
    end
  elsif user_action == "delete"
    puts "What would you like to delete?"
    item_to_delete = gets.chomp
    christmas_list.delete(item_to_delete)
  elsif user_action == "mark"
    puts "What item have you purchased?"
    item_to_mark = gets.chomp
    if christmas_list.key?(item_to_mark)
      christmas_list[item_to_mark] = "|x|"
    else
      puts "Sorry, there isn't an #{item_to_mark} on your list yet."
    end
  elsif user_action == "view"
    view_list(christmas_list)
  elsif user_action == "idea"
    puts "What are you looking for on Etsy?"
    user_search = gets.chomp
    html_content = open("https://www.etsy.com/search?q=#{user_search}").read
    doc = Nokogiri::HTML(html_content)
    etsy_results = []
    doc.search('.v2-listing-card__info .text-body').each_with_index do |element, index|
      etsy_results << "#{index + 1} #{element.text.strip}"
    end
    puts etsy_results.first(5)
    puts "Type a number to add to your list or type 0 for the main menu"
    response = gets.chomp
    if response != "0"
      new = etsy_results[response.to_i - 1].split(" ", 2)
      christmas_list[new[1]] = "| |"
    end
  elsif user_action == "quit"
    puts "Thanks for shopping today. See you next time, #{user_name}!"
  end
end






