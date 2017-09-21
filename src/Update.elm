module Update exposing (Msg(..), update)

import Lmc.Compiler as Compiler
import Lmc.Tokenizer as Tokenizer
import Lmc.Parser as Parser
import Lmc.Vm as Vm
import Memory exposing (Memory)
import Model exposing (Model, initialModel)


type Msg
    = SetSourceCode String
    | Assemble


update : Msg -> Model -> Model
update msg model =
    case Debug.log "message" msg of
        SetSourceCode newCode ->
            { model
                | sourceCode = newCode
            }

        Assemble ->
            let
                ( compiledMemory, err ) =
                    case parse model.sourceCode of
                        Err msg ->
                            ( Memory.empty, Just msg )

                        Ok parseResult ->
                            ( parseResult, Nothing )
            in
                { model
                    | err = err
                    , vm = Vm.init compiledMemory
                }


parse : String -> Result String Memory
parse =
    Tokenizer.tokenize
        >> Result.andThen Parser.parse
        >> Result.andThen Compiler.compile
        >> Debug.log "parse"
