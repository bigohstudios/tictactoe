# Analysis of TicTacToe NN #

### Dynamic pricing parameters ###

1. Monkey-patch 'Spree::AppConfiguration' in 'config/initializers/spree_bsc.rb' to add the dynamic pricing params 
   \+ Rollover help text, to the Spree config (these then get added to the 'spree_preferences' DB table along with 
   those from 'spree.rb' 
   and the '/admin' interface).
2. Send params to browser DOM as hidden **data-** values in 'views/spree/products/show.html.erb'.
3. Retrieve sent values via javascript that is executed when the page loads. The dynamic pricing algorithm is 
   written in CoffeeScript and interfaces with the DOM via jQuery in 'assets/javascripts/store/product.js.coffee'.
4. The '<%= hidden_field_tag :price %>' in the '<%= form_for :order, ... %>' of 'views/spree/products/show.html.erb'
   is then populated with the dynamically created price and sent to 'populate_orders_path' or 
   'controllers/spree/orders_controller.rb' ('rake routes' will explain why).
5. The 'price' parameter is then forwarded onto the data model 'Spree::OrderPopulator.populate' method 
   and stored in the order.
6. This price is then used when the order is listed by data model 'Spree::OrderContents.add_to_line_item'.

### XML feedback from RomanCart ###

ROMANCARTXML to '/cart/completed':

1. Add route for 'www.bespokesilkcurtains.com/cart/completed' in 'config/routes.rb' since this is not a standard
   Spree URL so that RomanCart can send the XML file on completion of the payment.
2. Parse XML with Nokogiri in '/app/controllers/spree/orders_controller.rb::completed'.
3. Populate @order with name, address, email and payment status from RomanCart.

### TicTacToe probability ###

See "6.Games of Pure Strategy" (p.18) in http://people.sju.edu/~smith/Current_Courses/games.pdf

It is an advantage to start and with 2 players playing perfectly it will always end in a draw 

(From http://en.wikipedia.org/wiki/WarGames: "The computer stages a massive Soviet first strike with hundreds of missiles, 
submarines, and bombers. Believing the attack to be genuine, NORAD prepares to retaliate. Falken, David, and Jennifer convince 
military officials to cancel the second strike and ride out the non-existent attack. Joshua tries to launch the missiles itself,
however, using a brute force attack to obtain the launch code. Without humans in the silos as a safeguard, the computer will 
trigger a mass launch. 
All attempts to log in and order Joshua to cancel the countdown fail, and all weapons will launch if the computer is disabled. 
Instead, Falken and David direct the computer to play tic-tac-toe against itself as tic-tac-toe is so simple that perfectly 
played games will always end in a draw. This results in a long string of ties, forcing the computer to learn the concept of an 
unwinnable game. Joshua obtains the missile code but before launching, it cycles through all the nuclear war scenarios it has 
devised, finding they too all result in stalemates. Having discovered the concept of Mutually Assured Destruction ("WINNER: NONE"), 
the computer concludes that nuclear warfare is "a strange game" in which "the only winning move is not to play." 
Joshua then offers to play "a nice game of chess", and relinquishes control of NORAD and the missiles.")
