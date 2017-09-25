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
        applyStep opcode argument vm |> repair


repair : Vm -> Vm
repair vm =
    { vm
        | pc = vm.pc % 100
        , acc = vm.acc % 1000
    }


applyStep : Int -> Int -> Vm -> Vm
applyStep opcode argument vm =
    let
        { pc, acc, carry, outbox, inbox, memory } =
            vm

        referred =
            Memory.get argument memory
    in
        case ( opcode, argument ) of
            ( 1, _ ) ->
                let
                    result =
                        acc + referred
                in
                    { vm
                        | acc = result
                        , carry =
                            if result <= 999 then
                                False
                            else
                                True
                        , pc = pc + 1
                    }

            ( 2, _ ) ->
                let
                    result =
                        acc - referred
                in
                    { vm
                        | acc = result
                        , carry =
                            if result >= 0 then
                                False
                            else
                                True
                        , pc = pc + 1
                    }

            ( 3, _ ) ->
                { vm
                    | memory = Memory.insert argument acc memory
                    , pc = pc + 1
                }

            ( 5, _ ) ->
                { vm
                    | acc = referred
                    , pc = pc + 1
                }

            ( 6, _ ) ->
                { vm
                    | pc = argument
                }

            ( 7, _ ) ->
                { vm
                    | pc =
                        if acc == 0 then
                            argument
                        else
                            pc + 1
                }

            ( 8, _ ) ->
                { vm
                    | pc =
                        if carry then
                            argument
                        else
                            pc + 1
                }

            ( 9, 1 ) ->
                case inbox of
                    [] ->
                        vm

                    first :: rest ->
                        { vm
                            | acc = first
                            , inbox = rest
                            , pc = pc + 1
                        }

            ( 9, 2 ) ->
                { vm
                    | outbox = acc :: outbox
                    , pc = pc + 1
                }

            ( 0, 0 ) ->
                vm

            _ ->
                vm
