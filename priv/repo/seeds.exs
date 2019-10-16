# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Experts.Repo.insert!(%Experts.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
import Experts.Factory

chris = insert(:user, %{name: "Chris", email: "chris@example.com"})
_alan = insert(:user, %{name: "Alan", email: "alan@example.com"})

insert(:question, %{
  title: "What book do you recommend to read this winter?",
  slug: "what-book-do-you-recommend-to-read-this-winter",
  body: "I want to expend my knowledge on the subject of...",
  tags: "architecture, books",
  user_id: chris.id
})

insert(:question, %{
  title: "What activities do you find fun to do during winter?",
  slug: "what-activities-do-you-find-fun-to-do-during-winter",
  body: "I've always wanted...",
  tags: "sports, fun, books",
  user_id: chris.id
})
