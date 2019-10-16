defmodule Experts.EctoTagTest do
  use ExUnit.Case

  alias Experts.EctoTag

  describe "cast/1" do
    test "when given a string returns a list of tags" do
      assert EctoTag.cast("architecture, books") == {:ok, ["architecture", "books"]}
    end

    test "when not given a string returns an error" do
      assert EctoTag.cast(1.61) == :error
    end
  end

  describe "load/1" do
    test "returns a string of tags separated by a comma" do
      assert EctoTag.load(["architecture", "books"]) == {:ok, "architecture, books"}
    end
  end

  describe "dump/1" do
    test "when given a list of strings returns an ok" do
      assert EctoTag.dump(["architecture", "books"]) == {:ok, ["architecture", "books"]}
    end

    test "when not given a list of strings returns an error" do
      assert EctoTag.dump(["architecture", 123]) == :error
    end
  end
end
