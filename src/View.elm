module View exposing (view)

import Html exposing (Html, a, button, div, h1, h2, input, li, p, section, text, textarea, ul)
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
        , div [ class "lmc-content lmc-columns" ]
            [ div [ class "lmc-columns-col" ]
                [ div [ class "lmc-ctrl" ]
                    [ button [ class "lmc-ctrl-btn" ]
                        [ text "Reset & Assemble"
                        ]
                    ]
                , sectionView "Code"
                    [ div [ class "lmc-code" ]
                        [ textarea [ class "lmc-code-codebox" ] []
                        ]
                    ]
                ]
            , div [ class "lmc-columns-col -wide" ]
                [ div [ class "lmc-ctrl" ]
                    [ button [ class "lmc-ctrl-btn -primary" ] [ text "Run" ]
                    , button [ class "lmc-ctrl-btn" ] [ text "Step" ]
                    ]
                , div [ class "lmc-columns" ]
                    [ div [ class "lmc-columns-col" ]
                        [ sectionView "Memory" [ memoryView ]
                        ]
                    , div [ class "lmc-columns-col" ]
                        [ sectionView "Input"
                            [ div [ class "lmc-input" ]
                                [ input [ class "lmc-input-text", type_ "text" ] []
                                ]
                            ]
                        , sectionView "Registers"
                            [ registerView
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


type RegisterVal
    = Numerical Int
    | Stack (List Int)
    | Flag Bool


registerView : List ( String, RegisterVal ) -> Html a
registerView =
    let
        registerView : ( String, RegisterVal ) -> Html a
        registerView ( registerName, registerValue ) =
            let
                registerText : String
                registerText =
                    case registerValue of
                        Numerical x ->
                            toString x

                        Stack xs ->
                            List.map toString xs |> String.join ", "

                        Flag f ->
                            if f then
                                "1"
                            else
                                "0"
            in
                li [ class "lmc-registers-reg" ]
                    [ div [ class "lmc-registers-reg-label" ] [ text registerName ]
                    , div [ class "lmc-registers-reg-value" ] [ text registerText ]
                    ]
    in
        List.map registerView >> ul [ class "lmc-registers" ]


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
