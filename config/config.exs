use Mix.Config

config :app,
  bot_name: "yet_another_secret_santa_bot"

config :nadia,
  token: "407512387:AAEDwfdYWh_S9SixR4TY1itBSl31jfc4-78"

import_config "#{Mix.env}.exs"
