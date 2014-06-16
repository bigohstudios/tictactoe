# Analysis of TicTacToe Neural Network #

### TicTacToe probability ###

See "6.Games of Pure Strategy" (p.18) in http://people.sju.edu/~smith/Current_Courses/games.pdf

It is an advantage to start and with 2 players playing perfectly it will always end in a draw.

(From http://en.wikipedia.org/wiki/WarGames: "The computer stages a massive Soviet first strike with hundreds of missiles, submarines, and bombers. Believing the attack to be genuine, NORAD prepares to retaliate. Falken, David, and Jennifer convince military officials to cancel the second strike and ride out the non-existent attack. Joshua tries to launch the missiles itself,however, using a brute force attack to obtain the launch code. Without humans in the silos as a safeguard, the computer will trigger a mass launch. 
All attempts to log in and order Joshua to cancel the countdown fail, and all weapons will launch if the computer is disabled. Instead, Falken and David direct the computer to play tic-tac-toe against itself as tic-tac-toe is so simple that perfectly played games will always end in a draw. This results in a long string of ties, forcing the computer to learn the concept of an unwinnable game. Joshua obtains the missile code but before launching, it cycles through all the nuclear war scenarios it has devised, finding they too all result in stalemates. Having discovered the concept of Mutually Assured Destruction ("WINNER: NONE"), the computer concludes that nuclear warfare is "a strange game" in which "the only winning move is not to play." Joshua then offers to play "a nice game of chess", and relinquishes control of NORAD and the missiles.")

### Adding Results table ###

$ rails g model result random:integer state:integer statewithresult:integer first:string self:integer  
$ rails g migration AddResultsIDToGames result:references  
$ rake db:migrate RAILS_ENV=test  

```
class Game < ActiveRecord::Base
  belongs_to :result
  ...
  def update_scoreboard!
    [Create a hash of the winner and looser for each game and who went first]
    # Call ActiveRecord association auto generated method
    create_result(resultsHash)
    # Save the FK table (after creating a row in the PK table) to store the FK
    save
  end
end

class Result < ActiveRecord::Base
  has_one :game
end
```


### RSpec test runs ###

This uses the Capybara feature specs of RSpec to leverage the original webpage (now we're surfing big wave rails) 

### Neural Network analysis

```
Total games 1377

Sub-Total games                                                            362
BoardStateOnlyOpponent         won                                         144 (39.8 %) [FIRST]
BoardStateWithResultOpponent   won                                         185 (51.1 %) [SECOND]
BoardStateOnlyOpponent         drew against BoardStateWithResultOpponent    33 (9.1 %)
Total percentage = 100.0%
[Well that figures]

Sub-Total games                                                            137
BoardStateWithResultOpponent   won                                         136 (99.3 %) [FIRST]
BoardStateOnlyOpponent         won                                           1 (0.7 %) [SECOND]
BoardStateWithResultOpponent   drew against BoardStateOnlyOpponent           0 (0.0 %)
Total percentage = 100.0%
[Well that figures]

Sub-Total games                                                            238
RandomOpponent                 won                                          71 (29.8 %) [FIRST]
BoardStateWithResultOpponent   won                                         109 (45.8 %) [SECOND]
RandomOpponent                 drew against BoardStateWithResultOpponent    58 (24.4 %)
Total percentage = 100.0%
[Well that figures]

Sub-Total games                                                            212
BoardStateWithResultOpponent   won                                         149 (70.3 %) [FIRST]
RandomOpponent                 won                                          37 (17.5 %) [SECOND]
BoardStateWithResultOpponent   drew against RandomOpponent                  26 (12.3 %)
Total percentage = 100.1%
[Well that figures]

Sub-Total games                                                            103
RandomOpponent                 won                                          30 (29.1 %) [FIRST]
BoardStateOnlyOpponent         won                                          27 (26.2 %) [SECOND]
RandomOpponent                 drew against BoardStateOnlyOpponent          46 (44.7 %)
Total percentage = 100.0%
[Well that figures]

Sub-Total games                                                            103
BoardStateOnlyOpponent         won                                          27 (26.2 %) [FIRST]
RandomOpponent                 won                                          22 (21.4 %) [SECOND]
BoardStateOnlyOpponent         drew against RandomOpponent                  54 (52.4 %)
Total percentage = 100.0%
[Well that figures]

Sub-Total games                                                            222
RandomOpponent                 won                                          96 (43.2 %) [FIRST]
RandomOpponent                 won                                          53 (23.9 %) [SECOND]
RandomOpponent                 drew against RandomOpponent                  73 (32.9 %)
Total percentage = 100.0%
[Well that figures]
```

From this you can clearly see the advantage in going first by Random self playing.  
The NN learning advantage with BoardStateWithResultOpponent.  
However the minimal, if any, advantage of BoardStateOnlyOpponent over Random  

It's now time to combine sports science with computer science (and the reason for creating this enhancement)...

### Further stats ###

Adding **statsample-optimization** (https://github.com/sciruby/statsample) for all your statistical needs gave some problems since MacPorts and Homebrew failed to be able to install v1.14 which was necessary for rb-gsl.

"The amount of time between slipping on the peel and landing on the pavement is precisely 1 bananosecond."

Therefore it needed to be installed from tar-ball:  
$ curl -O http://ftp.unicamp.br/pub/gnu/gsl/gsl-1.14.tar.gz  
$ tar xvzf gsl-1.14.tar.gz  
$ cd gsl-1.14 ; ./configure ; make ; sudo make install  
$ cd ~/src/tictactoe ; bundle  

Use-the-force-and-read-the-source...simples!
