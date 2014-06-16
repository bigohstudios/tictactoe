# Analysis of TicTacToe NN #

### TicTacToe probability ###

See "6.Games of Pure Strategy" (p.18) in http://people.sju.edu/~smith/Current_Courses/games.pdf

It is an advantage to start and with 2 players playing perfectly it will always end in a draw.

(From http://en.wikipedia.org/wiki/WarGames: "The computer stages a massive Soviet first strike with hundreds of missiles, submarines, and bombers. Believing the attack to be genuine, NORAD prepares to retaliate. Falken, David, and Jennifer convince military officials to cancel the second strike and ride out the non-existent attack. Joshua tries to launch the missiles itself,however, using a brute force attack to obtain the launch code. Without humans in the silos as a safeguard, the computer will trigger a mass launch. 
All attempts to log in and order Joshua to cancel the countdown fail, and all weapons will launch if the computer is disabled. Instead, Falken and David direct the computer to play tic-tac-toe against itself as tic-tac-toe is so simple that perfectly played games will always end in a draw. This results in a long string of ties, forcing the computer to learn the concept of an unwinnable game. Joshua obtains the missile code but before launching, it cycles through all the nuclear war scenarios it has devised, finding they too all result in stalemates. Having discovered the concept of Mutually Assured Destruction ("WINNER: NONE"), the computer concludes that nuclear warfare is "a strange game" in which "the only winning move is not to play." Joshua then offers to play "a nice game of chess", and relinquishes control of NORAD and the missiles.")

### Adding Results table ###

### RSpec test runs ###

### Further stats ###

Adding **statsample-optimization** (https://github.com/sciruby/statsample) for all your statistical needs gave some problems since MacPorts and Homebrew failed to be able to install v1.14 which was necessary for rb-gsl.

"The amount of time between slipping on the peel and landing on the pavement is precisely 1 bananosecond."

Therefore it needed to be installed from tar-ball:  
$ curl -O http://ftp.unicamp.br/pub/gnu/gsl/gsl-1.14.tar.gz  
$ tar xvzf gsl-1.14.tar.gz  
$ cd gsl-1.14 ; ./configure ; make ; sudo make install  
$ bundle  

Use-the-force-and-read-the-source...simples!
