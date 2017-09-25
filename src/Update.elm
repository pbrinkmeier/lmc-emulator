module Update exposing (Msg(..), update)

{-| This module is the most important of the whole codebase.
It is responsible for reacting to any changes made to the app state.


# Any possible change

@docs Msg

-}

import Lmc.Compiler as Compiler
import Lmc.Tokenizer as Tokenizer
import Lmc.Parser as Parser
import Lmc.Vm as Vm exposing (Vm)
import Memory exposing (Memory)
import Model exposing (Model, initialModel)
import Time exposing (Time)


{-| Messages are the only way to change the application state in Elm.
This type defines all possible changes and what additional information they carry.
-}
type
    Msg
    -- Set the source code for the assembler.
    = SetSourceCode String
      -- Set the input text (inputs for the VM).
    | SetInputText String
      -- Start/Stop the VM.
    | ToggleRunning
      -- Try assembling the source code.
    | Assemble
      -- Let the VM do a step.
    | Step
      -- Let the VM do a step. This member is needed because the message must carry a timestamp when sent by the Time module (idea: use (always Step) in Subs?).
    | Tick Time


{-| Given a message and an application state, determine the new application state and wether any commands shall be executed by Elm.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    -- Log the message to the browser console.
    case Debug.log "message" msg of
        SetSourceCode newCode ->
            ( { model
                | sourceCode = newCode
              }
            , Cmd.none
            )

        SetInputText newInputText ->
            ( { model
                | inputText = newInputText
              }
            , Cmd.none
            )

        ToggleRunning ->
            ( { model
                | vmIsRunning = not model.vmIsRunning
              }
            , Cmd.none
            )

        Assemble ->
            let
                ( newVm, err ) =
                    case createVm model.sourceCode model.inputText of
                        Err msg ->
                            ( Vm.empty, Just msg )

                        Ok vm ->
                            ( vm, Nothing )
            in
                ( { model
                    | err = err
                    , vm = newVm
                    , vmIsRunning = False
                  }
                , Cmd.none
                )

        Step ->
            ( executeVmStep model, Cmd.none )

        Tick time ->
            ( executeVmStep model, Cmd.none )


{-| A shorthand for executing a VM step.
-}
executeVmStep : Model -> Model
executeVmStep model =
    case Vm.step model.vm of
        Err message ->
            { model
                | err = Just message
                , vmIsRunning = False
            }

        Ok newVm ->
            { model
                | vm = newVm
            }


{-| Create a VM from source code and input text.
-}
createVm : String -> String -> Result String Vm
createVm sourceCode inputText =
    case ( compile sourceCode, parseInputs inputText ) of
        ( Ok memory, Ok inputList ) ->
            Ok (Vm.init inputList memory)

        ( Err compilationError, _ ) ->
            Err ("Could not compile code: " ++ compilationError)

        ( _, Err inputError ) ->
            Err ("Could not parse inputs: " ++ inputError)


compile : String -> Result String Memory
compile =
    Tokenizer.tokenize
        >> Result.andThen Parser.parse
        >> Result.andThen Compiler.compile


parseInputs : String -> Result String (List Int)
parseInputs inputText =
    let
        recurse : List Int -> List String -> Result String (List Int)
        recurse results strings =
            case strings of
                [] ->
                    Ok (List.reverse results)

                first :: rest ->
                    case String.trim first |> String.toInt of
                        Err _ ->
                            Err (first ++ " is not an integer")

                        Ok i ->
                            recurse (i :: results) rest
    in
        if inputText == "" then
            Ok []
        else
            String.split "," inputText |> recurse []
