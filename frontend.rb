require 'unirest'

system 'clear'

puts "Hello, welcome to my record collection app!"
while true
  puts "Which of these options would you like to do?"
  puts "      [1] Create an account"
  puts "      [2] View your collection"
  puts "      [3] Add a record to your collection"
  puts "      [4] Remove a record from your collection"
  puts "      [5] View your wishlist"
  puts "      [6] Add a record to your wishlist"
  puts "      [login] Login to your account"
  puts "      [logout] Logout of your account"
  puts "      [quit] Exit the program"

  input_option = gets.chomp

  if input_option == '1'
    system 'clear'
    puts "I'm glad you want to make an account. I need a few pieces of information first."
    print "Please enter your first name: "
    first_name = gets.chomp
    print "Please enter your last name: "
    last_name = gets.chomp
    print "Please enter your email address (don't worry you won't receive spam email!): "
    email = gets.chomp
    print "Enter a password (try not to forget it): "
    password = gets.chomp
    print "Let's just check you spelled it right, please enter it again: "
    password_confirmation = gets.chomp

    response = Unirest.post("http://localhost:3000/users", parameters: {first_name: first_name,
                                                                        last_name: last_name,
                                                                        email: email,
                                                                        password: password,
                                                                        password_confirmation: password_confirmation}
                                                                        )
    user = response.body
    system 'clear'
    puts user['message']
  elsif input_option == '2'
    response = Unirest.get("http://localhost:3000/user_records", parameters: {status: 'owned'})
    if response.code == 401
      puts "You must be logged in to view your collection!"
      gets.chomp
      system 'clear'
    else
      system 'clear'
      user_records = response.body 
      user_records.each do |user_record|
        puts "Record ID: #{user_record["id"]}"
        puts "Album: #{user_record["title"]}"
        puts "Artist: #{user_record["artist"][0]["name"]}"
        puts "======================================"
        puts
      end
      print "Select ID of record you want details on (enter to continue): "
      record_id = gets.chomp.to_i
      if record_id > 0
        response = Unirest.get("http://localhost:3000/user_records/#{record_id}")
        record = response.body
        system 'clear'
        puts "Title: #{record["title"]}"
        puts "Artist: #{record["artist"][0]["name"]}"
        puts "Release Year: #{record["release_year"]}"
        puts "Playtime: #{record["playtime"]} minutes"
        puts "Genres: " + record["genres"].join(', ')
        puts "Tracklist: #{record["tracklist"]}"
      end
      gets.chomp
      system 'clear'
    end
  elsif input_option == '3'
    response = Unirest.get("http://localhost:3000/records")
    if response.code == 401
      puts "You must be logged in to use this feature!"
      gets.chomp
      system 'clear'
    else
      puts "Which of these records do you want to add to your collection?"
      records = response.body 
      # puts JSON.pretty_generate(records)
      records.each do |record|
        puts "ID: #{record["id"]}  Title: #{record["title"]}  Artist: #{record["artist"][0]}"
      end
      record_id = gets.chomp.to_i
      if record_id > 0
        print "How much did you pay for this record? "
        record_price = gets.chomp.to_i
        response = Unirest.post("http://localhost:3000/user_records", parameters: {record_id: record_id, price: record_price, status: 'owned'})
        record = response.body
        system 'clear'
        puts "Title: #{record["title"]}"
        puts "Artist: #{record["artist"][0]["name"]}"
        puts "Release Year: #{record["release_year"]}"
        puts "Playtime: #{record["playtime"]} minutes"
        puts "Genres: " + record["genres"].join(', ')
        puts "Tracklist: #{record["tracklist"]}"
        gets.chomp
        system 'clear'
    else
      gets.chomp
      system 'clear'
    end
    end
  elsif input_option == '4'
    response = Unirest.get("http://localhost:3000/user_records", parameters: {status: 0})
    if response.code == 401
      puts "You must be logged in to use this feature!"
      gets.chomp
      system 'clear'
    else
      puts "Which of your records do you want to remove from your collection?"
      user_records = response.body 
      user_records.each do |user_record|
        puts "Record ID: #{user_record["id"]}"
        puts "Album: #{user_record["title"]}"
        puts "Artist: #{user_record["artist"][0]["name"]}"
        puts "======================================"
        puts
      end
      print "Select ID of record you want to remove (enter to continue): "
      record_id = gets.chomp.to_i
      if record_id > 0
        response = Unirest.delete("http://localhost:3000/user_records/#{record_id}")
        puts response.body["message"]
        gets.chomp
        system 'clear'
      else
        gets.chomp
        system 'clear'
      end
    end
  elsif input_option == '5'
    response = Unirest.get("http://localhost:3000/user_records", parameters: {status: 1})
    if response.code == 401
      puts "You must be logged in to use this feature!"
      gets.chomp
      system 'clear'
    else
      user_records = response.body 
      system 'clear'
      user_records.each do |user_record|
        puts "Record ID: #{user_record["id"]}"
        puts "Album: #{user_record["title"]}"
        puts "Artist: #{user_record["artist"][0]["name"]}"
        puts "======================================"
        puts
      end
      gets.chomp
      system 'clear'
    end
  elsif input_option == '6'
    response = Unirest.get("http://localhost:3000/records")
    if response.code == 401
      puts "You must be logged in to use this feature!"
      gets.chomp
      system 'clear'
    else
      puts "Which of your records do you want to add to your wishlist?"
      records = response.body 

      records.each do |record|
        puts "ID: #{record["id"]}  Title: #{record["title"]}  Artist: #{record["artist"][0]}"
      end 

      record_id = gets.chomp.to_i
      puts "How much does the record currently cost?"
      record_price = gets.chomp.to_i 
      response = Unirest.post("http://localhost:3000/user_records", parameters: {record_id: record_id, price: record_price, status: 'wish_list'})
      record = response.body
      system 'clear'
      puts "Title: #{record["title"]}"
      puts "Artist: #{record["artist"][0]["name"]}"
      puts "Release Year: #{record["release_year"]}"
      puts "Playtime: #{record["playtime"]} minutes"
      puts "Genres: " + record["genres"].join(', ')
      puts "Tracklist: #{record["tracklist"]}"
      gets.chomp
      system 'clear'
    end
  elsif input_option == 'login'
    system 'clear'
    print "Enter your login email: "
    input_email = gets.chomp
    print "Enter your password: "
    input_password = gets.chomp
    response = Unirest.post("http://localhost:3000/user_token", parameters: {auth: { email: input_email, password: input_password }})
    if response.code == 404
      puts "No login associated with that email, try again."
      gets.chomp
      system 'clear'
    elsif response.code == 201
      jwt = response.body["jwt"]
      Unirest.default_header("Authorization","Bearer #{jwt}")
      puts 'Login successful!'
      gets.chomp
      system 'clear'
    end
  elsif input_option == 'logout'
    system 'clear'
    jwt = ""
    Unirest.clear_default_headers
    puts "Logged out successfully!"
    gets.chomp
    system 'clear'
  elsif input_option == 'quit'
    system 'clear'
    puts "Thanks for stopping by!"
    gets.chomp
    break
  end

end