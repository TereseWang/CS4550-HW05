defmodule BullsWeb.Game do 
    def new do
        %{
            secret: generateSecret("", ["1", "2", "3", "4", "5", "6", "7", "8", "9"]),
            guesses: [],
            result: [],
            message: {:ok, "Enter 4 Digits To Start!"},
            lives: 8,
            game: true,
            userInput: "", 
        }
    end

    def isOver(state) do 
        !state.game;
    end

    def generateSecret(acc, nums) do 
        random = Enum.random(nums);
        if String.length(acc) == 4 do 
            acc
        else
            if String.length(acc) == 0 do 
                generateSecret(acc <> random, nums--[random]++[0]);
            else 
                generateSecret(acc <> random, nums--[random]);
            end
        end
    end 

    def isUnique(guess) do 
        MapSet.size(MapSet.new(String.split(guess, "", trim: true))) == 4;
    end

    def validateGuesses(state, guess) do 
        cond do
            !isUnique(guess) ->
                %{state | message: {:error, "Please enter 4 Unique Number!"}};
            Enum.member?(state.guesses, guess) ->
                %{state | message: {:error, "You have guessed this, try another"}};
            String.at(guess, 0) == "0" ->
                %{state | message: {:error, "First Digit cannot be zero"}}
            String.length(guess) != 4 ->
                %{state | message: {:error, "Please enter 4 digits please"}}
            !Regex.match?(~r/^\d+$/, guess) ->
                %{state | message: {:error, "Please only enter Number please"}}
            true ->
                %{state | message: {:ok, "Guess Porcessed"}};
        end
    end
    
    def checkGuesses(guess, answer, acc, bull, cow) do 
        if(acc < String.length(guess)) do 
            guessI = String.at(guess, acc)
            answerI = String.at(answer, acc)
            cond do 
                guessI == answerI ->
                    checkGuesses(guess, answer, acc+1, bull+1, cow);
                String.contains?(answer, guessI) ->
                    checkGuesses(guess, answer, acc+1, bull, cow+1);
                true ->
                    checkGuesses(guess, answer, acc+1, bull, cow);
            end
        else 
            {bull, cow}
        end
    end

    def view(state) do 
        {_, msg} = state.message;
        %{
            guesses: state.guesses,
            result: state.result,
            userInput: state.userInput,
            message: msg,
            lives: state.lives,
        }
    end

    def returnResult(state, guess) do 
        {bull, cow} = checkGuesses(guess, state.secret, 0, 0, 0);
        state0 = %{state |
                    guesses: state.guesses++[guess], 
                    result: state.result++["#{bull}A#{cow}B"],
                    userInput: "",
                    lives: state.lives - 1};
        cond do 
            bull == 4 ->
                %{state0 | game: false, message: {:ok, "You win!"}};
            state0.lives == 0 ->
                %{state0 | game: false, message: {:ok, "You lose~"}};
            true -> 
                state0;
        end
    end
end

