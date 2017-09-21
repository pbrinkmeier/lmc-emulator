module Lmc.Vm exposing (Vm, empty, init, step)

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

step : Vm -> Vm
step vm =
    let
        currentInstruction : Int
        currentInstruction =
            Memory.get vm.pc vm.memory

        opcode : Int
        opcode =
            currentInstruction // 100

        argument : Int
        argument =
            rem currentInstruction 100
    in
        applyStep opcode argument vm

applyStep : Int -> Int -> Vm -> Vm
applyStep opcode argument vm =
    let
        { pc, acc, memory } = vm
        referred = Memory.get argument memory
    in
        case opcode of
            1 ->
                let
                    result =
                        acc + referred
                in
                    { vm
                        | acc = result % 1000
                        , carry =
                            if result <= 999 then
                                False
                            else
                                True
                        , pc = pc + 1
                    }

            2 ->
                let
                    result =
                        acc - referred
                in
                    { vm
                        | acc = result % 1000
                        , carry =
                            if result >= 0 then
                                False
                            else True
                        , pc = pc + 1
                    }

            _ ->
                vm
