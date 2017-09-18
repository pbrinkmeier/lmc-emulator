module Lmc.Tokenizer exposing (Token(..), tokenize)

import Regex exposing (Regex, regex)


type Token
    = Mnemonic String
    | Label String
    | NumberLiteral Int
    | Whitespace String


type alias Rule a =
    { pattern : Regex
    , tokenConstructor : String -> a
    }


tokenize : String -> Result String (List Token)
tokenize =
    tokenizeUsingRules lmcRules []


lmcRules : List (Rule Token)
lmcRules =
    [ Rule (regex "[A-Z]+") Mnemonic
    , Rule (regex "[a-z]+") Label
    , Rule (regex "[0-9]+") (ignorantToInt >> NumberLiteral)
    , Rule (regex "\\s+") Whitespace
    ]


ignorantToInt : String -> Int
ignorantToInt =
    String.toInt >> Result.withDefault 0


tokenizeUsingRules : List (Rule a) -> List a -> String -> Result String (List a)
tokenizeUsingRules rules tokens source =
    case source of
        "" ->
            Ok tokens

        _ ->
            case getToken rules source of
                Err msg ->
                    Err msg

                Ok ( token, rest ) ->
                    tokenizeUsingRules rules (token :: tokens) rest


getToken : List (Rule a) -> String -> Result String ( a, String )
getToken rules source =
    case rules of
        [] ->
            Err ("Invalid input at: " ++ (String.left 30 source))

        { pattern, tokenConstructor } :: otherRules ->
            case Regex.find (Regex.AtMost 1) pattern source of
                [] ->
                    getToken otherRules source

                { match, index } :: _ ->
                    if index == 0 then
                        Ok ( tokenConstructor match, (String.length match |> String.dropLeft) source )
                    else
                        getToken otherRules source
