defmodule Bonfire.Data.Social.Named do
  use Pointers.Mixin,
    otp_app: :bonfire_data_social,
    source: "bonfire_data_social_named"

  alias Bonfire.Data.Social.Named
  alias Ecto.Changeset

  mixin_schema do
    field :name, :string
  end

  @cast [:name]

  def changeset(named \\ %Named{}, params, opts \\ []) do
    Changeset.cast(named, params, @cast)
  end

end

defmodule Bonfire.Data.Social.Named.Migration do
  use Ecto.Migration
  import Pointers.Migration
  alias Bonfire.Data.Social.Named

  # create_named_table/{0,1}

  defp make_named_table(exprs) do
    quote do
      require Pointers.Migration
      Pointers.Migration.create_mixin_table(Bonfire.Data.Social.Named) do
        Ecto.Migration.add :name, :text
        unquote_splicing(exprs)
      end
    end
  end

  defmacro create_named_table(), do: make_named_table([])
  defmacro create_named_table([do: {_, _, body}]), do: make_named_table(body)

  # drop_named_table/0

  def drop_named_table(), do: drop_mixin_table(Named)

  # migrate_named/{0,1}

  defp mn(:up), do: make_named_table([])

  defp mn(:down) do
    quote do
      Bonfire.Data.Social.Named.Migration.drop_named_table()
    end
  end

  defmacro migrate_named() do
    quote do
      if Ecto.Migration.direction() == :up,
        do: unquote(mn(:up)),
        else: unquote(mn(:down))
    end
  end
  defmacro migrate_named(dir), do: mn(dir)

end
