class Tournament
  MATCHES = [
    {:x => 'RandomOpponent',               :o => 'BoardStateOnlyOpponent'},
    {:x => 'RandomOpponent',               :o => 'BoardStateWithResultOpponent'},
    {:x => 'BoardStateOnlyOpponent',       :o => 'RandomOpponent'},
    {:x => 'BoardStateWithResultOpponent', :o => 'RandomOpponent'},
    {:x => 'BoardStateWithResultOpponent', :o => 'BoardStateOnlyOpponent'},
    {:x => 'BoardStateOnlyOpponent',       :o => 'BoardStateWithResultOpponent'}
  ]

  def self.run
    results = []

    MATCHES.each do |opponents|
      x_wins = 0
      y_wins = 0
      draws  = 0

      puts "running #{opponents.inspect}"
      100.times do
        g = Game.create :player_x => opponents[:x], :player_o => opponents[:o]
        g.process_ai_turns!

        if g.game_outcome == 0
          draws += 1
        elsif g.game_outcome == 1
          x_wins += 1
        elsif g.game_outcome == -1
          y_wins += 1
        else
          raise "OOPS! Game didn't play to completion"
        end
      end

      results << {:matchup => opponents, :x_wins => x_wins, :y_wins => y_wins, :draws => draws}
    end

    puts results.inspect
  end
end
