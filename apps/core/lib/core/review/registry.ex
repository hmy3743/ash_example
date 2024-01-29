defmodule Core.Review.Registry do
  use Ash.Registry

  entries do
    entry Core.Review.Review
    entry Core.Review.ReviewTag
  end
end
