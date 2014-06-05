require 'spec_helper'

describe 'games' do
  let(:game_number) { 1 }

  before(:all) do
=begin
    puts "\n*** NN TRG ***\n\n"
    visit "/"
    click_link "New Game"
    select "BoardStateOnlyOpponent", :from => "game_player_x"
    select "BoardStateWithResultOpponent", :from => "game_player_o"
    click_button "Create Game"
    expect(page).to have_text("Game ended")
=end
  end
  
  after(:all) do
    # Analyse results table
    puts "\n\n****************************"
    puts "Hmm...so what do we do here?"
    puts "****************************"
    
    puts Game::PLAYER_RESULTS_MAP
    
    totalGames = Result.all.count
    puts "\nTotal games \t\t\t\t#{totalGames}"
    
    random = Result.where("random is not null").count
    puts "Random played \t\t\t\t#{random}"
    
  end

  it "BoardStateOnly vs BoardStateWithResult" do

    game_number.times.each do |number| 
      puts "\n*** GAME #{number+1} ***\n\n"
      visit "/"
      click_link "New Game"
      select "BoardStateOnlyOpponent", :from => "game_player_x"
      select "BoardStateWithResultOpponent", :from => "game_player_o"
      click_button "Create Game"
      
      expect(page).to have_text("Game ended")

      notice = find("p#notice").text
      puts "\nNotice: #{notice}\n\n"
      path = page.current_path
      gameID = path.split('/')[2]

      puts "Winner of game #{gameID} = #{Game::PLAYER_MAP[Game.find(gameID).game_outcome]}"
    end
    
    getResults(first: "state", second: "statewithresult")

  end
  
  def getResults(args = {})
    #puts args[:first]
    #puts args[:second]
    
    player1 = Game::PLAYER_RESULTS_MAP.key(args[:first])
    player2 = Game::PLAYER_RESULTS_MAP.key(args[:second])

    subtotalGames = Result.where("first = ? and #{args[:first]} is not null and #{args[:second]} is not null",args[:first]).count
    puts "\nSub-Total games \t\t\t\t\t\t\t#{subtotalGames}"

    first = Result.where("#{args[:first]} = ?", 1).count
    puts "#{player1} won \t\t\t\t\t\t#{first} [FIRST]"
    
    second = Result.where("#{args[:second]} = ?", 1).count
    puts "#{player2} won \t\t\t\t\t#{second} [SECOND]"
    
    draw = Result.where("#{args[:first]} = ? and #{args[:second]} = ?",0,0).count
    puts "#{player1} drew against #{player2} \t#{draw}"

=begin    
    stateFirst = Result.where("first = ?","state").count
    puts "\nState went first \t\t\t#{stateFirst}"
=end
    
    if first + second + draw == subtotalGames
      puts "[Well that figures]"
    else
      puts "[Doh!  Something went wrong there...]"
    end

  end

end
