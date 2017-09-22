module Update exposing (Msg(..), update)

import Lmc.Compiler as Compiler
import Lmc.Tokenizer as Tokenizer
import Lmc.Parser as Parser
import Lmc.Vm as Vm exposing (Vm)
import Memory exposing (Memory)
import Model exposing (Model, initialModel)
import Time exposing (Time)


type Msg
    = SetSourceCode String
    | SetInputText String
    | ToggleRunning
    | Assemble
    | Step
    | Tick Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
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
            ( { model
                | vm = Vm.step model.vm
              }
            , Cmd.none
            )

        Tick time ->
            ( { model
                | vm = Vm.step model.vm
              }
            , Cmd.none
            )


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
