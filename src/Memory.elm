module Memory exposing (Memory, empty, insert)

import Dict exposing (Dict)


type alias Memory =
    Dict Int Int

insert : Int -> Int -> Memory -> Memory
insert =
    Dict.insert

empty : Memory
empty =
    Dict.empty
