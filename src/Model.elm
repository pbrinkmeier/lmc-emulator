module Model exposing (Model, decode, encode, initialModel)

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

decode : String -> Model
decode _ = initialModel

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


initialModel : Model
initialModel =
    { sourceCode = ""
    , inputText = ""
    , err = Nothing
    , vm = Vm.empty
    , vmIsRunning = False
    }
