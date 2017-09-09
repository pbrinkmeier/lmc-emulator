module Update exposing (Msg(..), update)

import Model exposing (Model, initialModel)

type Msg
    = SetSourceCode String
    | SetInputs String

update : Msg -> Model -> Model
update msg model =
    case Debug.log "message" msg of
        SetSourceCode newCode ->
            { model |
                sourceCode = newCode }
        SetInputs inputString ->
            { model |
                inputs = inputString }

parseInputString : String -> List Int
parseInputString =
    String.split " " >> List.map String.toInt >> List.filterMap Result.toMaybe
