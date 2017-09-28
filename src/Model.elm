module Model exposing (Model, encode, initialModel)

import Base64
import Json.Encode exposing (object, string)
import Lmc.Vm as Vm exposing (Vm)


type alias Model =
    { sourceCode : String
    , inputText : String
    , err : Maybe String
    , vm : Vm
    , vmIsRunning : Bool
    }


encode : Model -> String
encode { sourceCode, inputText } =
    let
        stateToEncode : Json.Encode.Value
        stateToEncode =
            object
                [ ( sourceKey, string sourceCode )
                , ( inputKey, string inputText )
                ]
    in
        Json.Encode.encode 0 stateToEncode
            |> Base64.encode


sourceKey : String
sourceKey =
    "s"


inputKey : String
inputKey =
    "i"


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
