module Lmc.Vm exposing (Vm, empty, init)

import Memory exposing (Memory)


type alias Vm =
    { acc : Int
    , pc : Int
    , carry : Bool
    , outbox : List Int
    , inbox : List Int
    , memory : Memory
    }


empty : Vm
empty =
    init [] Memory.empty


init : List Int -> Memory -> Vm
init =
    Vm 0 0 False []
