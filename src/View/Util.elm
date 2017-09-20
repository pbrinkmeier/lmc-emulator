module View.Util
    exposing
        ( Register(..)
        , Column(..)
        , columnsView
        , registersView
        , sectionView
        , topbarView
        )

import Html exposing (Html, a, div, h1, h2, li, section, text, ul)
import Html.Attributes exposing (class, href)


type Column a
    = Normal (List (Html a))
    | Wide (List (Html a))


columnsView : List (Column a) -> Html a
columnsView =
    let
        columnView : Column a -> Html a
        columnView col =
            case col of
                Normal children ->
                    div [ class "lmc-columns-col" ] children

                Wide children ->
                    div [ class "lmc-columns-col -wide" ] children
    in
        List.map columnView >> div [ class "lmc-columns" ]


topbarView : String -> List ( String, String ) -> Html a
topbarView title links =
    let
        linkView : ( String, String ) -> Html a
        linkView ( linkText, url ) =
            li [ class "lmc-topbar-links-link" ]
                [ a
                    [ class "lmc-topbar-links-link-anchor"
                    , href url
                    ]
                    [ text linkText ]
                ]
    in
        div [ class "lmc-topbar" ]
            [ h1 [ class "lmc-topbar-title" ] [ text title ]
            , ul [ class "lmc-topbar-links" ] (List.map linkView links)
            ]


sectionView : String -> List (Html a) -> Html a
sectionView title children =
    let
        header : Html a
        header =
            h2 [ class "lmc-section-title" ] [ text title ]
    in
        section [ class "lmc-section" ] (header :: children)


type Register
    = Numerical Int
    | Stack (List Int)
    | Flag Bool


registersView : List ( String, Register ) -> Html a
registersView =
    let
        registerView : ( String, Register ) -> Html a
        registerView ( registerLabel, rawValue ) =
            let
                registerValue : String
                registerValue =
                    case rawValue of
                        Numerical x ->
                            toString x

                        Stack xs ->
                            List.map toString xs |> String.join ", "

                        Flag x ->
                            if x then
                                "1"
                            else
                                "0"
            in
                li [ class "lmc-registers-reg" ]
                    [ div [ class "lmc-registers-reg-label" ]
                        [ text registerLabel
                        ]
                    , div [ class "lmc-registers-reg-value" ]
                        [ text registerValue
                        ]
                    ]
    in
        List.map registerView >> ul [ class "lmc-registers" ]
