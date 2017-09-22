module Model exposing (Model, initialModel)

import Lmc.Vm as Vm exposing (Vm)


type alias Model =
    { sourceCode : String
    , inputText : String
    , err : Maybe String
    , vm : Vm
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
    , inputText = ""
    , err = Nothing
    , vm = Vm.empty
    }
