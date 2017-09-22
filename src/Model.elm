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
    """    BRA st
a   DAT 0
b   DAT 0
one DAT 1
st  INP
    STA a
    INP
    ADD a
    BRP ov
    BRA ct
ov  LDA one
    OUT
ct  INP
    STA b
    LDA a
    SUB b
    OUT
    BRZ end
    BRA st
end COB
    """


initialModel : Model
initialModel =
    { sourceCode = source
    , inputText = ""
    , err = Nothing
    , vm = Vm.empty
    }
