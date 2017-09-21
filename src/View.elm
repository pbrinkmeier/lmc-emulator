module View exposing (view)

import Html
    exposing
        ( Html
        , button
        , div
        , input
        , text
        , textarea
        )
import Html.Attributes exposing (class, disabled, href, placeholder, type_, value)
import Html.Events exposing (onClick, onInput)
import Model exposing (Model)
import Update exposing (Msg(Assemble, SetInputText, SetSourceCode, Step))
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
                        , button [ class "lmc-ctrl-btn", onClick Step ] [ text "Step" ]
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
                                [ Util.sectionView "Memory"
                                    [ Memory.view model.vm.pc model.vm.memory ]
                                ]
                            , Normal
                                [ Util.sectionView "Input"
                                    [ div [ class "lmc-input" ]
                                        [ input [ class "lmc-input-text", type_ "text", value model.inputText, placeholder "Comma-separated list of integers", onInput SetInputText ] []
                                        ]
                                    ]
                                , Util.sectionView "Registers"
                                    [ Util.registersView
                                        [ ( "pc", Numerical model.vm.pc )
                                        , ( "acc", Numerical model.vm.acc )
                                        , ( "carry", Flag model.vm.carry )
                                        , ( "inbox", Stack model.vm.inbox )
                                        , ( "outbox", Stack model.vm.outbox )
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
