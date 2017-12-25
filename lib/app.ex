defmodule App do
  use Application

  def proceed( list) do
    perm = Enum.shuffle 0..(length( list)-1)
    if Enum.with_index( perm) |> Enum.all?( fn {a,i} -> a != i end) do

      new_list = Enum.zip( list, perm)
                 |> Enum.sort_by( fn {_,i} -> i end)
                 |> Enum.map( fn {u,_} -> u end)

      Enum.zip list, new_list
    else
      proceed( list)
    end
  end

  def start(_type, _args) do
    bot_name = Application.get_env(:app, :bot_name)

    unless String.valid?(bot_name) do
      IO.warn """
      Env not found Application.get_env(:app, :bot_name)
      This will give issues when generating commands
      """
    end

    if bot_name == "" do
      IO.warn "An empty bot_name env will make '/anycommand@' valid"
    end

    import Supervisor.Spec, warn: false

    children = [
      worker(App.Poller, []),
      worker(App.Matcher, [])
    ]

    {port, _} = Integer.parse System.get_env("PORT")
    _ = :gen_tcp.listen port, [:binary, packet: :line, active: false, reuseaddr: true]

    opts = [strategy: :one_for_one, name: App.Supervisor]
    Supervisor.start_link children, opts
  end
end
