module Update exposing (Msg(..), update)

import Lmc.Compiler as Compiler
import Lmc.Tokenizer as Tokenizer
import Lmc.Parser as Parser
import Lmc.Vm as Vm exposing (Vm)
import Memory exposing (Memory)
import Model exposing (Model, initialModel)


type Msg
    = SetSourceCode String
    | SetInputText String
    | Assemble
    | Step


update : Msg -> Model -> Model
update msg model =
    case Debug.log "message" msg of
        SetSourceCode newCode ->
            { model
                | sourceCode = newCode
            }

        SetInputText newInputText ->
            { model
                | inputText = newInputText
            }

        Assemble ->
            let
                ( newVm, err ) =
                    case createVm model.sourceCode model.inputText of
                        Err msg ->
                            ( Vm.empty, Just msg )

                        Ok vm ->
                            ( vm, Nothing )
            in
                { model
                    | err = err
                    , vm = newVm
                }

        Step ->
            { model
                | vm = Vm.step model.vm
            }


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
