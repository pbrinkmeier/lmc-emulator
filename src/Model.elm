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

decode : String -> ( Model, Cmd msg )
decode encodedString =
    if encodedString == "" then
        ( initialModel, Cmd.none )
    else
        case Base64.decode encodedString |> Result.andThen decodeJson |> Debug.log "decoder" of
            Err _ ->
                ( initialModel, Hash.setHash "" )
            Ok { sourceCode, inputText } ->
                ( { initialModel
                    | sourceCode = sourceCode
                    , inputText = inputText }
                , Cmd.none )

decodeJson : String -> Result String { sourceCode : String, inputText : String }
decodeJson =
    let
        decoder : Decoder { sourceCode : String, inputText : String }
        decoder =
            Json.Decode.map2 (\src inp -> { sourceCode = src, inputText = inp })
                (field sourceKey Json.Decode.string)
                (field inputKey Json.Decode.string)
    in
        Json.Decode.decodeString decoder

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
