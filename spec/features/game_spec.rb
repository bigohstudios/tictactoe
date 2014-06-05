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
    puts "Total games \t\t\t\t#{totalGames}"
    
    statewithresult = Result.where("statewithresult = ?", 1).count
    puts "StateWithResult won \t\t\t#{statewithresult}"
    
    state = Result.where("state = ?", 1).count
    puts "State won \t\t\t\t#{state}"
    
    SWRvSdraw = Result.where("state = ? and statewithresult = ?",0,0).count
    puts "StateWithResult drew against State \t#{SWRvSdraw}"
    
    stateFirst = Result.where("first = ?","state").count
    puts "\nState went first \t\t\t#{stateFirst}"
    
    if statewithresult + state + SWRvSdraw == totalGames
      puts "[Well that figures]"
    else
      puts "[Doh!  Something went wrong there...]"
    end
    
    random = Result.where("random != ?", nil).count
    puts "Random played \t\t\t\t#{random}"
    
  end

  it "can run" do

    game_number.times.each do |number| 
      puts "\n*** GAME #{number+1} ***\n\n"
      visit "/"
      click_link "New Game"
      select "BoardStateOnlyOpponent", :from => "game_player_x"
      select "BoardStateWithResultOpponent", :from => "game_player_o"
      click_button "Create Game"
      
      expect(page).to have_text("Game ended")
#debugger
      notice = find("p#notice").text
      puts "\nNotice: #{notice}\n\n"
      path = page.current_path
      gameID = path.split('/')[2]

      puts "Winner of game #{gameID} = #{Game::PLAYER_MAP[Game.find(gameID).game_outcome]}"
    end
  end

end
