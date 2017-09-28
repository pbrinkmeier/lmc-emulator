module Model exposing (Model, decode, encode, initialModel)

import Base64
import Hash
import Json.Decode exposing (Decoder, field)
import Json.Encode exposing (object, string)
import Lmc.Vm as Vm exposing (Vm)


type alias Model =
    { sourceCode : String
    , inputText : String
    , err : Maybe String
    , vm : Vm
    , vmIsRunning : Bool
    }



{-
   Decode a hash into the corresponding model.

   The hash is a base64-encoded JSON object that contains a field for source code and another for the comma-seperated input text.
-}


decode : String -> ( Model, Cmd msg )
decode encodedString =
    if encodedString == "" then
        ( initialModel, Cmd.none )
    else
        case Base64.decode encodedString |> Result.andThen decodeJson of
            Err _ ->
                ( initialModel, Hash.setHash "" )

            Ok { sourceCode, inputText } ->
                ( { initialModel
                    | sourceCode = sourceCode
                    , inputText = inputText
                  }
                , Cmd.none
                )


type alias SaveData =
    { sourceCode : String
    , inputText : String
    }


decodeJson : String -> Result String SaveData
decodeJson =
    let
        decoder : Decoder SaveData
        decoder =
            Json.Decode.map2 SaveData
                (field sourceKey Json.Decode.string)
                (field inputKey Json.Decode.string)
    in
        Json.Decode.decodeString decoder



{-
   Encode a model into the format described in the comment for decode.
-}


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
