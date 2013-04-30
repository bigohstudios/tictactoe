module GamesHelper
  def square_content(square,game)
    case game.state_for_square(square)
    when -1
      'O'
    when 0
      if game.over?
        '-'
      else
        link_to 'here!', game_turns_path(:game_id => game.id, :square => square), :method => :post
      end
    when 1
      'X'
    end
  end

  def square_for(square,game)
    square_class = 
      if game.over?
        if !game.draw?
          if game.victory_pattern.include?(square.to_s)
            'victory_square'
          end
        end
      end

    content_tag :td, :class => square_class do
      square_content(square,game)
    end
  end
end
