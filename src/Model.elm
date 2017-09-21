module Model exposing (Model, initialModel)

import Lmc.Vm as Vm exposing (Vm)


type alias Model =
    { sourceCode : String
    , inputText : String
    , err : Maybe String
    , vm : Vm
    }


initialModel : Model
initialModel =
    { sourceCode = ""
    , inputText = ""
    , err = Nothing
    , vm = Vm.empty
    }
