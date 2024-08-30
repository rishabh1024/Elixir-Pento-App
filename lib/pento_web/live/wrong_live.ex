defmodule PentoWeb.WrongLive do
  alias Pento.Accounts
  use PentoWeb, :live_view

  # The mount fucntions loads the initial state of the live view. After the live view is mounted it passes the value of the socket assigns map to the render/1 function
  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])

    {:ok,
     assign(
       socket,
       score: 0,
       message: "Make a guess:",
       time: time(),
       answer: 6,
       session_id: session["live_socket_id"],
       current_user: user,
       win: false
     )}
  end

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>

    <h2>
      <%= @message %> It's <%= @time %>
    </h2>

    <h2>
      <%= for  n <- 1..10 do %>
        <.link href="#" phx-click="guess" phx-value-number={n}>
          <%= n %>
        </.link>
      <% end %>
       <pre>
    User: <%= @current_user.email %>
    <%= @session_id %>
    </pre>
    </h2>

    <h2>
      <%= if @win == true do %>
        <button type="button"><.link patch={~p"/guess"}>Restart</.link></button>
      <% end %>
    </h2>
    """
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    guess = String.to_integer(guess)
    score = socket.assigns.score
    time = time()

    {message, score, win} =
      if guess == socket.assigns.answer do
        {"Your guess was right. You Won", score + 1, true}
      else
        {"Your guess: #{guess}.Wrong. Guess again bro", score - 1, false}
      end

    {
      :noreply,
      assign(socket,
        score: score,
        message: message,
        time: time,
        win: win
      )
    }
  end

  def time() do
    DateTime.utc_now() |> to_string()
  end
end
