module View exposing (view)

import Html exposing (Html, a, div, h1, li, text, ul)
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
