defmodule SysHealthTest do
  use ExUnit.Case
  doctest SysHealth

  test "greets the world" do
    assert SysHealth.hello() == :world
  end
end
