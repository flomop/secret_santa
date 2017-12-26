defmodule App.Commands do
  use App.Router
  use App.Commander
  require Integer

#  alias App.Commands.Outside

  command "add" do
    chat_id = String.to_atom("#{update.message.chat.id}")
    dets = Agent.get :info, & &1
    chat_record = :dets.lookup dets, chat_id

    if Enum.empty? chat_record do
      send_message "Please /start me first in your group or channel!"
    else
      Logger.log :info, "Command /add received"
      user = update.message.from

      [{_,list, lang}] = chat_record

      if user in list do
        send_message "Ah-h! You are already in the list!!!"
      else
       :dets.insert dets, {chat_id, [user | list], lang}

        send_message "Greatings, #{user.first_name} #{user.last_name} (#{user.id})! You're in the army now! O-o-o!"
      end
    end
  end

  command "delete" do
    Logger.log :info, "Command /delete received"
    chat_id = String.to_atom("#{update.message.chat.id}")
    dets = Agent.get :info, & &1
    chat_record = :dets.lookup dets, chat_id

    if Enum.empty? chat_record do
      send_message "Please /start me first in your group or channel!"
    else
      user = update.message.from
      [{_,list, lang}] = chat_record

     :dets.insert dets, {chat_id, List.delete( list, user), lang}

      if user in list do
        send_message "Ok-ok! I'm deleting #{user.first_name} #{user.last_name} (#{user.id})! So sad, so sad!"
      else
        send_message "Who is that? Don't know any #{user.first_name} #{user.last_name}!"
      end
    end
  end

  command "list" do
    Logger.log :info, "Command /list received"
    chat_id = String.to_atom("#{update.message.chat.id}")
    dets = Agent.get :info, & &1
    chat_record = :dets.lookup dets, chat_id

    if Enum.empty? chat_record do
      send_message "Please /start me first in your group or channel!"
    else
      [{_,list,_}] = chat_record

      if Enum.empty? list do
        send_message "My list is empty!:'("
      else
        send_message "Hm-mem-dem, let me see what I can do!"
        list_str = Enum.map( (Enum.with_index list, 1), fn {u, i} ->
                     "(#{i}) #{u.first_name} #{u.last_name} (#{u.id})"
                   end)
                   |> Enum.join("\n")

        send_message list_str<>"\n\nDo you know them?! Can I kill them?"
      end
    end
  end

  command ["start", "restart"] do
    Logger.log :info, "Command /start received"
    chat_id = String.to_atom("#{update.message.chat.id}")
    dets = Agent.get :info, & &1

    unless Enum.empty?(:dets.lookup dets, chat_id) do
      user = update.message.from
      whoms = :dets.lookup dets, {:user, user.id}

      unless Enum.empty? whoms do
        [{{:user,_who_id}, whom}] = whoms
       :dets.delete dets, {:user, user.id}
        send_message "Let me see!"
        Process.sleep 1000
        send_message "You will be gifting #{whom.first_name} #{whom.last_name} (#{whom.id})"
      else
        send_message "I'm hot and ready!!! You can /add !"
      end
    else

     :dets.insert dets, {chat_id, [], "en_US"}
      send_message "Welcome aboard! First, add me to your group or channel!:^)"
      # send_message "Please, choose your language:",
      # reply_markup: %Model.InlineKeyboardMarkup {

      # inline_keyboard: [
      #   [
      #     %{
      #       callback_data: "/set_language en",
      #       text: "English",
      #     },
      #     %{
      #       callback_data: "/set_language ru",
      #       text: "Russian",
      #     },
      #   ]
      # ]}
    end
  end

  command "help" do
    Logger.log :info, "Command /help received"

    ["Ahtytytytyzh!!! Girls and boys, LET ME SPEEEK FROM MAY HARTS!!!",
     "Ya-ya-ya. That's not funny, I know.",
     "\nSo-o-o-o-o. First you should start a dialog with me or else I could not send private messages :'(",
     "(1) click on my icon in this chat;",
     "(2) send me a message;",
     "(3) press start.",
     "Now use /add command IN THE GROUP OR CHANNEL to participate.",
     "When everyone are ready type /go .",
     "Also, you can repeat process with /again command or /delete yourself from list."]

    |> Enum.join("\n")
    |> send_message()
  end

  command "again" do
    Logger.log :info, "Command /again received"
    chat_id = String.to_atom("#{update.message.chat.id}")
    dets = Agent.get :info, & &1
    chat_record = :dets.lookup dets, chat_id

    unless Enum.empty? chat_record do
     :dets.insert dets, {chat_id, [], "en_US"}
      send_message "Ok-ok!\nNow my magic list is empty!"
    else
      [{_,_,lang}] = chat_record
     :dets.insert dets, {chat_id, [], lang}
      send_message "Ok-ok!\nNow my magic list is empty!"
    end
  end

  command "statistics" do
    Logger.log :info, "Command /Statistics received"
    dets = Agent.get :info, & &1
    [{:helped, times}] = :dets.lookup dets, :helped
    [{:helped_users, num}] = :dets.lookup dets, :helped_users
    send_message "Helped #{times} times.\n#{num} users."
  end

  command ["no","fuckyou"] do
    [to_use|_] = Enum.shuffle ["Go fuck yourself!",
                               "Lick my pussy!",
                               "Fuck you fucking fuck!!!"]

    send_message to_use
  end

  command "yes" do
    [to_use|_] = Enum.shuffle ["I'm watching you while my mother fuck yours!"]

    send_message to_use
  end

  command "go" do
    Logger.log :info, "Command /go received"
    chat_id = String.to_atom("#{update.message.chat.id}")
    dets = Agent.get :info, & &1
    chat_record = :dets.lookup dets, chat_id

    if Enum.empty? chat_record do
      send_message "Please /start me first in your group or channel!"
    else
      send_message "Now anal magic is gonna happen!!! Prepair!"

      [{_,list,_lang}] = chat_record
      if Enum.empty? list do
        send_message "Oy-yo-yoy!!! No one in the list! Don't be shy, /add !"
      else
        Process.sleep 500
        send_message "Trahtibidoh!!!"
        Process.sleep 500
        send_message "Abracadabra!!!"
        Process.sleep 500
        send_message "Sim-salabim-ahalay-mahalay!!!"
        Process.sleep 1000
        send_message "No! It's not going anyway!!!:'("
        Process.sleep 500
        send_message "Hm, let's try another way!"
        Process.sleep 500
        send_message "BITCOIN! BIIIITCOIN!! BI-I-I-I-TTTTCCCCO-O-O-O-O-O-OIN!!!"

        if length( list) == 1 do
          [who] = list
          Nadia.send_message who.id, "You will be gifting #{who.first_name} #{who.last_name} (#{who.id}).\nKnow him?:)"
        else
          App.proceed( list)
          |> Enum.each( fn {who, whom} ->
                          Nadia.send_message who.id, "You will be gifting #{whom.first_name} #{whom.last_name} (#{whom.id})"
                         :dets.insert dets, {{:user, who.id}, whom}
                        end)
        end

        [{:helped, times}] = :dets.lookup dets, :helped
        [{:helped_users, num}] = :dets.lookup dets, :helped_users

       :dets.insert( dets, {:helped, times+1})
       :dets.insert( dets, {:helped_users, num + (length list)})

        send_message "If you don't like results, send /go again."
      end
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

  # inline_query_command "foo" do
  #   Logger.log :info, "Inline Query Command /foo"
  #   # Where do you think the message will go for?
  #   # If you answered that it goes to the user private chat with this bot,
  #   # you're right. Since inline querys can't receive nothing other than
  #   # Nadia.InlineQueryResult models. Telegram bot API could be tricky.
  #   send_message "This came from an inline query"
  # end

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
