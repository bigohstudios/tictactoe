class TurnsController < ApplicationController
  def create
    @game = Game.find(params[:game_id])

    if @game.take_turn(params[:square])
      if @game.over?
        flash[:notice] = "Game Over!"
      end
      redirect_to game_path(@game)
    else
      flash[:error] = "Error!  Still #{Game::PLAYER_MAP[@game.current_player]}'s turn"
      redirect_to game_path(@game)
    end

  end
end
