module Lmc.Compiler exposing (compile)

import Dict exposing (Dict)
import Memory exposing (Memory)
import Lmc.Parser exposing (ParseState, Instruction(..), Address(..))


compile : ParseState -> Result String Memory
compile =
    mapToBytecode
        >> Result.andThen generateMemory


mapToBytecode : ParseState -> Result String (List Int)
mapToBytecode =
    let
        recurse : List Int -> ParseState -> Result String (List Int)
        recurse results state =
            case state.instructions of
                [] ->
                    Ok (List.reverse results)

                fst :: rest ->
                    case getBytecode state.labels fst of
                        Err msg ->
                            Err msg

                        Ok code ->
                            recurse (code :: results) { state | instructions = rest }
    in
        recurse []


generateMemory : List Int -> Result String Memory
generateMemory =
    let
        recurse : Int -> Memory -> List Int -> Result String Memory
        recurse pos mem codes =
            case codes of
                [] ->
                    Ok mem

                fst :: rest ->
                    recurse (pos + 1) (Memory.insert pos fst mem) rest
    in
        recurse 0 Memory.empty


getBytecode : Dict String Int -> Instruction -> Result String Int
getBytecode labels inst =
    let
        ( base, arg ) =
            case inst of
                Add arg ->
                    ( 100, Just arg )

                Subtract arg ->
                    ( 200, Just arg )

                Store arg ->
                    ( 300, Just arg )

                Load arg ->
                    ( 500, Just arg )

                Branch arg ->
                    ( 600, Just arg )

                BranchIfZero arg ->
                    ( 700, Just arg )

                BranchIfPositive arg ->
                    ( 800, Just arg )

                Input ->
                    ( 901, Nothing )

                Output ->
                    ( 902, Nothing )

                CoffeeBreak ->
                    ( 0, Nothing )

                Data arg ->
                    ( 0, Just arg )
    in
        case arg of
            Nothing ->
                Ok base

            Just (Immediate i) ->
                Ok (base + i)

            Just (Labelled txt) ->
                case Dict.get txt labels of
                    Nothing ->
                        Err ("label " ++ txt ++ " does not exist")

                    Just i ->
                        Ok (base + i)
