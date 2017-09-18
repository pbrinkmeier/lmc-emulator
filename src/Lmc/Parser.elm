module Lmc.Parser exposing (Instruction, Address, parse)

import Dict exposing (Dict)
import Lmc.Tokenizer exposing (Token(Mnemonic, Label, NumberLiteral))


type Instruction
    = Add Address
    | Subtract Address
    | Store Address
    | Load Address
    | Branch Address
    | BranchIfZero Address
    | BranchIfPositive Address
    | Input
    | Output
    | CoffeeBreak


type Address
    = Labelled String
    | Immediate Int


type alias ParseState =
    { labels : Dict String Int
    , instructions : List Instruction
    , position : Int
    }


type InstructionType a
    = OneArgument (Address -> a)
    | NoArguments a


parse : List Token -> Result String ParseState
parse =
    List.filter isImportantToken >> parseUsingRules lmcInstructions (ParseState Dict.empty [] 0)


isImportantToken : Token -> Bool
isImportantToken token =
    case token of
        Mnemonic _ ->
            True

        Label _ ->
            True

        NumberLiteral _ ->
            True

        _ ->
            False


lmcInstructions : Dict String (InstructionType Instruction)
lmcInstructions =
    Dict.fromList
        [ ( "ADD", OneArgument Add )
        , ( "SUB", OneArgument Subtract )
        , ( "STA", OneArgument Store )
        , ( "LDA", OneArgument Load )
        , ( "BRA", OneArgument Branch )
        , ( "BRZ", OneArgument BranchIfZero )
        , ( "BRP", OneArgument BranchIfPositive )
        , ( "INP", NoArguments Input )
        , ( "OUT", NoArguments Output )
        , ( "COB", NoArguments CoffeeBreak )
        ]


parseUsingRules : Dict String (InstructionType Instruction) -> ParseState -> List Token -> Result String ParseState
parseUsingRules rules state tokens =
    let
        { labels, instructions, position } =
            state
    in
        case tokens of
            [] ->
                Ok state

            (Label labelText) :: rest ->
                let
                    newState =
                        { state | labels = Dict.insert labelText position labels }
                in
                    parseUsingRules rules newState rest

            (Mnemonic instText) :: rest ->
                Err "Not implemented"

            _ ->
                Err "Unexpected token"
