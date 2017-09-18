module View exposing (view)

import Html exposing (Html, a, button, div, h1, h2, input, li, section, text, textarea, ul)
import Html.Attributes exposing (class, disabled, href, type_)
import Model exposing (Model)
import Update exposing (Msg)


view : Model -> Html Msg
view model =
    div [ class "lmc-main" ]
        [ lmcTopbar "LMC assembler & emulator"
            [ ( "Wikipedia", "https://en.wikipedia.org/wiki/Little_man_computer" )
            , ( "Manual", "https://github.com/pbrinkmeier/lmc-emulator/README.md" )
            , ( "Source", "https://github.com/pbrinkmeier/lmc-emulator/README.md" )
            ]
        , div [ class "lmc-content" ]
            [ div [ class "lmc-content-controls lmc-columns" ]
                [ div [ class "lmc-columns-col" ]
                    [ div [ class "lmc-ctrl" ]
                        [ button [ class "lmc-ctrl-btn" ]
                            [ text "Reset & Assemble"
                            ]
                        ]
                    ]
                , div [ class "lmc-columns-col -wide" ]
                    [ div [ class "lmc-ctrl" ]
                        [ button [ class "lmc-ctrl-btn" ]
                            [ text "Run"
                            ]
                        , button [ class "lmc-ctrl-btn" ]
                            [ text "Step"
                            ]
                        ]
                    ]
                ]
            , div [ class "lmc-content-main lmc-columns" ]
                [ div [ class "lmc-columns-col" ]
                    [ sectionView "Code"
                        [ div [ class "lmc-code" ]
                            [ textarea [ class "lmc-code-codebox" ] []
                            ]
                        ]
                    ]
                , div [ class "lmc-columns-col" ]
                    [ sectionView "Memory"
                        [ memoryView
                        ]
                    ]
                , div [ class "lmc-columns-col" ]
                    [ sectionView "Input"
                        [ div [ class "lmc-input" ]
                            [ input [ class "lmc-input-text", type_ "text" ] []
                            ]
                        ]
                    , sectionView "Registers"
                        [ ul [ class "lmc-registers" ]
                            [ li [ class "lmc-registers-reg" ]
                                [ div [ class "lmc-registers-reg-label" ] [ text "acc" ]
                                , div [ class "lmc-registers-reg-value" ] [ text "42" ]
                                ]
                            , li [ class "lmc-registers-reg" ]
                                [ div [ class "lmc-registers-reg-label" ] [ text "pc" ]
                                , div [ class "lmc-registers-reg-value" ] [ text "42" ]
                                ]
                            , li [ class "lmc-registers-reg" ]
                                [ div [ class "lmc-registers-reg-label" ] [ text "inbox" ]
                                , div [ class "lmc-registers-reg-value" ] [ text "3, 4, 5" ]
                                ]
                            , li [ class "lmc-registers-reg" ]
                                [ div [ class "lmc-registers-reg-label" ] [ text "outbox" ]
                                , div [ class "lmc-registers-reg-value" ] [ text "2, 4" ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]


lmcTopbar : String -> List ( String, String ) -> Html a
lmcTopbar title links =
    let
        linkView : ( String, String ) -> Html a
        linkView ( linkText, url ) =
            li [ class "lmc-topbar-links-link" ]
                [ a [ class "lmc-topbar-links-link-anchor", href url ] [ text linkText ]
                ]
    in
        div [ class "lmc-topbar" ]
            [ h1 [ class "lmc-topbar-title" ] [ text title ]
            , ul [ class "lmc-topbar-links" ] (List.map linkView links)
            ]


sectionView : String -> List (Html a) -> Html a
sectionView title children =
    section [ class "lmc-section" ]
        ([ h2 [ class "lmc-section-title" ] [ text title ] ]
            ++ children
        )


memoryView : Html a
memoryView =
    let
        cellView : Html a
        cellView =
            Html.td [ class "lmc-memory-row-cell" ] [ text "000" ]

        rowView : Int -> Html a
        rowView i =
            Html.tr [ class "lmc-memory-row" ]
                ((Html.th [ class "lmc-memory-row-label" ] [ toString (i * 10) |> text ])
                    :: (List.repeat 10 cellView)
                )
    in
        Html.table [ class "lmc-memory" ] (List.range 0 9 |> List.map rowView)
