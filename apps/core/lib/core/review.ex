defmodule Core.Review do
  use Ash.Api

  resources do
    registry Core.Review.Registry
  end
end
