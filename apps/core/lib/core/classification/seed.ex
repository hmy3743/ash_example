defmodule Core.Classification.Seed do
  import Ash.Seed, only: [seed!: 1]

  alias Core.Classification.Tag

  def run do
    reviews = Core.Review.Review.read!()

    for name <- names() do
      seed!(%Tag{
        name: name,
        reviews: Enum.take_random(reviews, Enum.random(1..3))
      })
    end
  end

  defp names do
    [
      "Action",
      "Adventure",
      "Casual",
      "Indie",
      "Massively Multiplayer",
      "Racing",
      "RPG",
      "Simulation",
      "Sports",
      "Strategy"
    ]
  end
end
