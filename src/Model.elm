module Model exposing (Model, initialModel)

import Memory exposing (Memory)


type alias Model =
    { sourceCode : String
    , err : Maybe String
    , memory : Memory
    }


initialModel : Model
initialModel =
    { sourceCode = ""
    , err = Nothing
    , memory = Memory.empty
    }
