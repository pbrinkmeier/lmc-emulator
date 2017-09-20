module Update exposing (Msg(..), update)

import Lmc.Compiler as Compiler
import Lmc.Tokenizer as Tokenizer
import Lmc.Parser as Parser
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
            case parse model.sourceCode of
                Err msg ->
                    { model
                        | err = Just msg
                    }

                Ok parseResult ->
                    { model
                        | err = Nothing
                        , memory = parseResult
                    }


parse : String -> Result String Memory
parse =
    Tokenizer.tokenize
        >> Result.andThen Parser.parse
        >> Result.andThen Compiler.compile
        >> Debug.log "parse"
