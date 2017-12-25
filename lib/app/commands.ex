defmodule App.Commands do
  use App.Router
  use App.Commander
  require Integer

  alias App.Commands.Outside

  command "add" do
    agent = String.to_atom("Chat#{update.message.chat.id}")

    if GenServer.whereis agent do
      Logger.log :info, "Command /add received"
      user = update.message.from

      list = Agent.get agent, & &1
      if user in list do
        send_message "Ah-h! You are already in the list!!!"
      else
        Agent.update( agent, fn list -> [user | list] end)
        send_message "Greatings, #{user.first_name} #{user.last_name} (#{user.id})! You're in the army now! O-o-o!"
      end
    else
      send_message "Please /start me first!"
    end
  end

  command "delete" do
    agent = String.to_atom("Chat#{update.message.chat.id}")

    if GenServer.whereis agent do
      Logger.log :info, "Command /delete received"
      user = update.message.from
      list = Agent.get agent, & &1

      Agent.update( agent, fn list -> List.delete( list, user) end)

      if user in list do
        send_message "Ok-ok! I'm deleting #{user.first_name} #{user.last_name} (#{user.id})! So sad, so sad!"
      else
        send_message "Who is that? Don't know any #{user.first_name} #{user.last_name}!"
      end
    else
      send_message "Please /start me first!"
    end
  end

  command "list" do
    agent = String.to_atom("Chat#{update.message.chat.id}")

    if GenServer.whereis agent do
      list = Agent.get agent, & &1
      if Enum.empty? list do
        send_message "My list is empty!:'("
      else
        send_message "Hm, let me see!"
        Enum.each (Enum.with_index list, 1), fn {u, i} ->
          send_message "(#{i}) #{u.first_name} #{u.last_name} (#{u.id})"
        end
        send_message "Do you know them?!"
      end
    else
      send_message "Please /start me first!"
    end
  end

  command "start" do
    agent = String.to_atom("Chat#{update.message.chat.id}")

    if GenServer.whereis agent do
      send_message "I'm already hot and ready!!! You can /add !"
    else
      Agent.start_link( fn -> [] end, name: agent)

      Logger.log :info, "Command /start received"
      send_message "Welcome aboard! Add me to the group first!:^)"
    end
  end

  command "help" do
    send_message "Ahtytytytyzh!!! Girls and boys, LET ME SPEEEK FROM MAY HARTS!!!"
    send_message "Ya-ya-ya. That's not funny."
    send_message "So-o-o-o-o. First you should start a dialog with me. Or I could not send private messages :'("
    send_message "(1) click on my icon in this chat;\n(2) send message;\n(3) start."
    send_message "Now use /add command IN THE GROUP to participate.\nAnd finally command me /go ."
    send_message "You can repeat process with /again command.\nAnd finally, you can delete yourself from my list with /delete"
    send_message "BUT REMEMBER MY CHILDRENS! THERE SHOULD BE EVEN NUMBER OF PARTICIPATORS!\n\nGOOD LUCK!"
 end

  command "again" do
    agent = String.to_atom("Chat#{update.message.chat.id}")

    if GenServer.whereis agent do
      send_message "Ok-ok!"
      Agent.update agent, fn -> [] end
      send_message "Now my magic list is empty!"
    else
      send_message "Please /start me first!"
    end
  end

  command "go" do
    agent = String.to_atom("Chat#{update.message.chat.id}")

    if GenServer.whereis agent do
      Logger.log :info, "Command /go received"
      send_message "Now anal magic is gonna happen!!! Prepair!"

      list = Agent.get agent, & &1
      if Integer.is_odd( length list) do
        send_message "A-a-a-a-a-a-a-a! Can't touch this! Odd number! Hate odd numbers!!!"
        send_message "Please, PLEASE, /delete or /add someone!!!"
      else
        if Enum.empty? list do
          send_message "No one in the list!!! Don't be shy, /add !"
        else
          result = Agent.get agent, &App.proceed/1

          Process.sleep 500
          send_message "……………………………………Трахтибидох!!!"
          Process.sleep 500
          send_message "……………………………………"
          Process.sleep 500
          send_message "……………………………………Aбракадабра!!!"
          Process.sleep 500
          send_message "……………………………………Сим-салабим-ахалай-махалай!!!"
          Process.sleep 500
          send_message "……………………………………No! It's not going anyway!!!:'("
          Process.sleep 500
          send_message "……………………………………A! Of course!"
          Process.sleep 500
          send_message "……………………………………BITCOIN!!! coarse!"

          Enum.each result, fn {who, whom} ->
            Nadia.send_message who.id, "You will be gifting #{whom.first_name} #{whom.last_name} (#{whom.id})"
          end
        end
      end
    else
      send_message "Please /start me first!"
    end
  end

  # # You can create commands in the format `/command` by
  # # using the macro `command "command"`.
  # command ["hello", "hi"] do
  #   # Logger module injected from App.Commander
  #   Logger.log :info, "Command /hello or /hi"

  #   # You can use almost any function from the Nadia core without
  #   # having to specify the current chat ID as you can see below.
  #   # For example, `Nadia.send_message/3` takes as first argument
  #   # the ID of the chat you want to send this message. Using the
  #   # macro `send_message/2` defined at App.Commander, it is
  #   # injected the proper ID at the function. Go take a look.
  #   #
  #   # See also: https://hexdocs.pm/nadia/Nadia.html
  #   send_message "Hello World!"
  # end

  # You may split code to other modules using the syntax
  # "Module, :function" instead od "do..end"
  # command "outside", Outside, :outside
  # For the sake of this tutorial, I'll define everything here

  # command "question" do
  #   Logger.log :info, "Command /question"

  #   {:ok, _} = send_message "What's the best JoJo?",
  #     # Nadia.Model is aliased from App.Commander
  #     #
  #     # See also: https://hexdocs.pm/nadia/Nadia.Model.InlineKeyboardMarkup.html
  #     reply_markup: %Model.InlineKeyboardMarkup{
  #       inline_keyboard: [
  #         [
  #           %{
  #             callback_data: "/choose joseph",
  #             text: "Joseph Joestar",
  #           },
  #           %{
  #             callback_data: "/choose joseph-of-course",
  #             text: "Joseph Joestar of course",
  #           },
  #         ],
  #         [
  #           # Read about fallbacks in the end of the file
  #           %{
  #             callback_data: "/typo-:p",
  #             text: "Other",
  #           },
  #         ]
  #       ]
  #     }
  # end

  # You can create command interfaces for callback querys using this macro.
  callback_query_command "choose" do
    Logger.log :info, "Callback Query Command /choose"

    case update.callback_query.data do
      "/choose joseph" ->
        answer_callback_query text: "Indeed you have good taste."
      "/choose joseph-of-course" ->
        answer_callback_query text: "I can't agree more."
    end
  end

  # You may also want make commands when in inline mode.
  # Be sure to enable inline mode first: https://core.telegram.org/bots/inline
  # Try by typping "@your_bot_name /what-is something"
  inline_query_command "what-is" do
    Logger.log :info, "Inline Query Command /what-is"

    :ok = answer_inline_query [
      %InlineQueryResult.Article{
        id: "1",
        title: "10 Hours What is Love Jim Carrey HD",
        thumb_url: "https://img.youtube.com/vi/ER97mPHhgtM/3.jpg",
        description: "Have a great time",
        input_message_content: %{
          message_text: "https://www.youtube.com/watch?v=ER97mPHhgtM",
        }
      }
    ]
  end

  # Advanced Stuff
  #
  # Now that you already know basically how this boilerplate works let me
  # introduce you to a cool feature that happens under the hood.
  #
  # If you are used to telegram bot API, you should know that there's more
  # than one path to fetch the current message chat ID so you could answer it.
  # With that in mind and backed upon the neat macro system and the cool
  # pattern matching of Elixir, this boilerplate automatically detectes whether
  # the current message is a `inline_query`, `callback_query` or a plain chat
  # `message` and handles the current case of the Nadia method you're trying to
  # use.
  #
  # If you search for `defmacro send_message` at App.Commander, you'll see an
  # example of what I'm talking about. It just works! It basically means:
  # When you are with a callback query message, when you use `send_message` it
  # will know exatcly where to find it's chat ID. Same goes for the other kinds.

  inline_query_command "foo" do
    Logger.log :info, "Inline Query Command /foo"
    # Where do you think the message will go for?
    # If you answered that it goes to the user private chat with this bot,
    # you're right. Since inline querys can't receive nothing other than
    # Nadia.InlineQueryResult models. Telegram bot API could be tricky.
    send_message "This came from an inline query"
  end

  # Fallbacks

  # Rescues any unmatched callback query.
  callback_query do
    Logger.log :warn, "Did not match any callback query"

    answer_callback_query text: "Sorry, but there is no JoJo better than Joseph."
  end

  # Rescues any unmatched inline query.
  inline_query do
    Logger.log :warn, "Did not match any inline query"

    :ok = answer_inline_query [
      %InlineQueryResult.Article{
        id: "1",
        title: "Darude-Sandstorm Non non Biyori Renge Miyauchi Cover 1 Hour",
        thumb_url: "https://img.youtube.com/vi/yZi89iQ11eM/3.jpg",
        description: "Did you mean Darude Sandstorm?",
        input_message_content: %{
          message_text: "https://www.youtube.com/watch?v=yZi89iQ11eM",
        }
      }
    ]
  end

  # The `message` macro must come at the end since it matches anything.
  # You may use it as a fallback.
  message do
#    Logger.log :warn, "Did not match the message"

    send_message "Hi-ho-ahoy! I will explain everything. Just beg me for /help !"
  end
end
