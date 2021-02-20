defmodule BullsWeb.GameChannel do
    use BullsWeb, :channel

    @impl true
    def join("game:" <> _id, payload, socket) do
        if authorized?(payload) do
            game = BullsWeb.Game.new()
            socket = assign(socket, :game, game)
            view = BullsWeb.Game.view(game)
            {:ok, view, socket}
        else
            {:error, %{reason: "unauthorized"}}
        end
    end

    @impl true 
    def handle_in("guess", %{"guess" => guess}, socket) do 
        game0 = socket.assigns[:game]
        if !BullsWeb.Game.isOver(game0) do 
            game1 = BullsWeb.Game.validateGuesses(game0, guess)
            case game1[:message] do 
                {:error, _message} ->
                     view = BullsWeb.Game.view(game1);
                    {:reply, {:ok, view}, socket};
                {:ok, _message} ->
                    game2 = BullsWeb.Game.returnResult(game1, guess);
                    view = BullsWeb.Game.view(game2);
                    socket1 = assign(socket, :game, game2);
                    {:reply, {:ok, view}, socket1};
            end
        else
            view = BullsWeb.Game.view(game0);
            {:reply, {:ok, view}, socket};
        end
    end

    @impl true 
    def handle_in("guess", _x, socket) do
        game = BullsWeb.Game.new();
        socket = assign(socket, :game, game);
        view = BullsWeb.Game.view(game);
        {:reply, {:ok, view}, socket}; 
    end 

    @impl true 
    def handle_in("reset", _payload, socket) do
        game = BullsWeb.Game.new()
        view = BullsWeb.Game.view(game)
        socket = assign(socket, :game, game)
        {:reply, {:ok, view}, socket};
    end 


    @impl true
    def handle_in("ping", payload, socket) do
        {:reply, {:ok, payload}, socket}
    end

    @impl true
    def handle_in("shout", payload, socket) do
        broadcast socket, "shout", payload
        {:noreply, socket}
    end

    defp authorized?(_payload) do
        true
    end
end
