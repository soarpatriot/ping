defmodule Ping.BoardView do
  use Ping.Web, :view

  def render("index.json", %{boards: boards}) do
    %{data: render_many(boards, Ping.BoardView, "board.json")}
  end

  def render("show.json", %{board: board}) do
    %{data: render_one(board, Ping.BoardView, "board.json")}
  end

  def render("board.json", %{board: board}) do
    %{id: board.id,
      name: board.name,
      description: board.description}
  end
end
