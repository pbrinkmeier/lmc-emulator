module Model exposing (Model, initialModel)

import Lmc.Vm as Vm exposing (Vm)


type alias Model =
    { sourceCode : String
    , inputText : String
    , err : Maybe String
    , vm : Vm
    , vmIsRunning : Bool
    }


source : String
source =
    """s INP
  STA a
  ADD a
  OUT
  BRA s
a DAT 0"""


initialModel : Model
initialModel =
    { sourceCode = source
    , inputText = "1, 2, 3, 4, 5"
    , err = Nothing
    , vm = Vm.empty
    , vmIsRunning = False
    }
