require 'spec_helper'

describe 'games' do
  let(:game_number) { 3 }

  before(:all) do

    puts "\n*** NN TRG ***\n\n"
    visit "/"
    click_link "New Game"
    select "BoardStateOnlyOpponent", :from => "game_player_x"
    select "BoardStateWithResultOpponent", :from => "game_player_o"
    click_button "Create Game"
    expect(page).to have_text("Game ended")

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
