module View exposing (view)

import Html exposing (Html, a, button, div, h1, h2, li, section, text, textarea, ul)
import Html.Attributes exposing (class, href)
import Model exposing (Model)
import Update exposing (Msg)

view : Model -> Html Msg
view model =
    div [ class "lmc-main" ] [
        lmcTopbar "LMC assembler & emulator" [
            ("Wikipedia", "https://en.wikipedia.org/wiki/Little_man_computer"),
            ("Manual", "https://github.com/pbrinkmeier/lmc-emulator/README.md"),
            ("Source", "https://github.com/pbrinkmeier/lmc-emulator/README.md")
        ],
        div [ class "lmc-content" ] [
            div [ class "lmc-content-controls lmc-columns" ] [
                div [ class "lmc-columns-col -narrow" ] [
                    div [ class "lmc-ctrl" ] [
                        button [ class "lmc-ctrl-btn" ] [
                            text "Assemble"
                        ]
                    ]
                ],
                div [ class "lmc-columns-col -wide" ] [
                    div [ class "lmc-ctrl" ] [
                        button [ class "lmc-ctrl-btn" ] [
                            text "Run"
                        ],
                        button [ class "lmc-ctrl-btn" ] [
                            text "Step"
                        ]
                    ]
                ]
            ],
            div [ class "lmc-content-main lmc-columns" ] [
                div [ class "lmc-columns-col -narrow" ] [
                    sectionView "Code" [
                        textarea [ class "lmc-code-codebox" ] []
                    ]
                ],
                div [ class "lmc-columns-col -wide lmc-columns" ] [
                    div [ class "lmc-columns-col -wide" ] [
                        text "mem"
                    ],
                    div [ class "lmc-columns-col -wide" ] [
                        text "registers and i/o"
                    ]
                ]
            ]
        ]
    ]

lmcTopbar : String -> List (String, String) -> Html a
lmcTopbar title links =
    let
        linkView : (String, String) -> Html a
        linkView (linkText, url) =
            li [ class "lmc-topbar-links-link" ] [
                a [ class "lmc-topbar-links-link-anchor", href url ] [ text linkText ]
            ]
    in
        div [ class "lmc-topbar" ] [
            h1 [ class "lmc-topbar-title" ] [ text title ],
            ul [ class "lmc-topbar-links" ] (List.map linkView links)
        ]

sectionView : String -> List (Html a) -> Html a
sectionView title children =
    section [ class "lmc-section" ]
        ([ h2 [ class "lmc-section-title" ] [ text title ] ]
        ++ children)

