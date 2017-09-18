module Model exposing (Model, initialModel)


type alias Model =
    { sourceCode : String
    , inputs : String
    }


initialModel : Model
initialModel =
    { sourceCode = ""
    , inputs = ""
    }
