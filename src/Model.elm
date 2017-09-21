module Model exposing (Model, initialModel)

import Lmc.Vm as Vm exposing (Vm)
import Memory


type alias Model =
    { sourceCode : String
    , err : Maybe String
    , vm : Vm
    }


initialModel : Model
initialModel =
    { sourceCode = ""
    , err = Nothing
    , vm = Vm.init Memory.empty
    }
