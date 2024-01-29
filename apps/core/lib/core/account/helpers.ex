defmodule Core.Account.Helpers do
  def viewer(resolution, _query, third) do
    IO.inspect(resolution, label: "RESOLUTION")
    IO.inspect(third, label: "THIRD")
    resolution
  end
end
