module Util exposing (section)

import Html exposing (Html, div, h2, text)
import Html.Attributes exposing (class)

section : String -> List (Html a) -> Html a
section title children =
    Html.section [ class "section" ] [
        h2 [ class "section-title" ] [ text title ],
        div [ class "section-content" ] children
    ]
