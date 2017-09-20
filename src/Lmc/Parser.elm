module Lmc.Parser exposing (Instruction(..), Address(..), ParseState, parse)

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
    | Data Address


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
        , ( "DAT", OneArgument Data )
        ]


parseUsingRules : Dict String (InstructionType Instruction) -> ParseState -> List Token -> Result String ParseState
parseUsingRules rules state tokens =
    let
        { labels, instructions, position } =
            state
    in
        case tokens of
            [] ->
                Ok (ParseState labels (List.reverse instructions) position)

            (Label labelText) :: rest ->
                let
                    newState =
                        { state | labels = Dict.insert labelText position labels }
                in
                    parseUsingRules rules newState rest

            (Mnemonic instText) :: rest ->
                case Dict.get instText rules of
                    Nothing ->
                        Err ("Unknown instruction " ++ instText)

                    Just instType ->
                        case apply instType rest of
                            Err msg ->
                                Err msg

                            Ok ( inst, rest_ ) ->
                                let
                                    newState =
                                        { state
                                            | instructions =
                                                inst :: instructions
                                            , position = position + 1
                                        }
                                in
                                    parseUsingRules rules newState rest_

            t :: _ ->
                Err ("Unexpected token " ++ Lmc.Tokenizer.toString t)


apply : InstructionType a -> List Token -> Result String ( a, List Token )
apply instType tokens =
    case instType of
        NoArguments inst ->
            Ok ( inst, tokens )

        OneArgument makeInst ->
            case tokens of
                (Label txt) :: rest ->
                    Ok ( makeInst (Labelled txt), rest )

                (NumberLiteral i) :: rest ->
                    Ok ( makeInst (Immediate i), rest )

                _ ->
                    Err "Argument needed"
