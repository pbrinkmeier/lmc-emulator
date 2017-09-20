module Memory exposing (Memory, empty, get, insert)

import Dict exposing (Dict)


type alias Memory =
    Dict Int Int


get : Int -> Memory -> Int
get addr mem =
    case Dict.get addr mem of
        Nothing ->
            0

        Just x ->
            x


insert : Int -> Int -> Memory -> Memory
insert =
    Dict.insert


empty : Memory
empty =
    Dict.empty
