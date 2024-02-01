defmodule Core.Review.Seed do
  import Ash.Seed, only: [seed!: 1]
  alias Core.Review.Review

  def run do
    users = Core.Account.User.read!()

    for user <- users do
      seed!(%Review{
        name: "First Review",
        score: 100,
        contents: ["excellent", "good", "bad"],
        writer: user
      })

      seed!(%Review{
        name: "This game is god game",
        score: 100,
        writer: user,
        contents: ["excellent", "good", "지렸다"]
      })
    end
  end
end
