defmodule Ping.ImageView do
  use Ping.Web, :view

  def render("index.json", %{images: images}) do
    %{data: render_many(images, Ping.ImageView, "image.json")}
  end

  def render("show.json", %{image: image}) do
    %{data: render_one(image, Ping.ImageView, "image.json")}
  end

  def render("image.json", %{image: image}) do
    %{id: image.id,
      key: image.key,
      hash: image.hash,
      url: image.url,
      post_id: image.post_id}
  end
end
