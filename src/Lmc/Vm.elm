module Lmc.Vm exposing (Vm, init)

import Memory exposing (Memory)


type alias Vm =
    { acc : Int
    , pc : Int
    , carry : Bool
    , inbox : List Int
    , outbox : List Int
    , memory : Memory
    }


init : Memory -> Vm
init =
    Vm 0 0 False [] []
