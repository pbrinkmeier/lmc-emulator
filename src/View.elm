module View exposing (view)

import Html exposing (Html, a, button, div, h1, h2, input, li, p, section, text, textarea, ul)
import Html.Attributes exposing (class, disabled, href, type_)
import Html.Events exposing (onClick, onInput)
import Model exposing (Model)
import Update exposing (Msg(Assemble, SetSourceCode))
import View.Util as Util
    exposing
        ( Register(Numerical, Stack, Flag)
        , Column(Normal, Wide)
        )
import View.Memory as Memory


view : Model -> Html Msg
view model =
    let
        runControlView =
            case model.err of
                Just err ->
                    div [ class "lmc-error" ] [ text err ]

                Nothing ->
                    div [ class "lmc-ctrl" ]
                        [ button [ class "lmc-ctrl-btn -primary" ] [ text "Run" ]
                        , button [ class "lmc-ctrl-btn" ] [ text "Step" ]
                        ]
    in
        div [ class "lmc-main" ]
            [ Util.topbarView "LMC assembler & emulator"
                [ ( "Wikipedia", "https://en.wikipedia.org/wiki/Little_man_computer" )
                , ( "Manual", "https://github.com/pbrinkmeier/lmc-emulator/README.md" )
                , ( "Source", "https://github.com/pbrinkmeier/lmc-emulator/README.md" )
                ]
            , div [ class "lmc-content" ]
                [ Util.columnsView
                    [ Normal
                        [ div [ class "lmc-ctrl" ]
                            [ button [ class "lmc-ctrl-btn", onClick Assemble ]
                                [ text "Reset & Assemble"
                                ]
                            ]
                        , Util.sectionView "Code"
                            [ div [ class "lmc-code" ]
                                [ textarea [ class "lmc-code-codebox", onInput SetSourceCode ] [ text model.sourceCode ]
                                ]
                            ]
                        ]
                    , Wide
                        [ runControlView
                        , Util.columnsView
                            [ Normal
                                [ Util.sectionView "Memory" [ Memory.view model.memory ]
                                ]
                            , Normal
                                [ Util.sectionView "Input"
                                    [ div [ class "lmc-input" ]
                                        [ input [ class "lmc-input-text", type_ "text" ] []
                                        ]
                                    ]
                                , Util.sectionView "Registers"
                                    [ Util.registersView
                                        [ ( "acc", Numerical 42 )
                                        , ( "pc", Numerical 42 )
                                        , ( "carry", Flag True )
                                        , ( "inbox", Stack [ 3, 4, 5 ] )
                                        , ( "outbox", Stack [ 1, 4 ] )
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
