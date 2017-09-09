module View exposing (mainView)

import Html exposing (Html, button, div, h1, h2, input, table, td, text, textarea, th, tr)
import Html.Attributes exposing (class, disabled, placeholder, type_, value)
import Html.Events exposing (onInput)
import Memory
import Model exposing (Model)
import Update exposing (Msg(..))

mainView : Model -> Html Msg
mainView model =
    div [ class "lmc" ] [
        div [ class "lmc-topbar" ] [
            h1 [ class "lmc-topbar-title" ] [ text "LMC emulator & assembler" ],
            div [ class "lmc-topbar-controls vcontrols" ] [
                button [ class "vcontrols-button" ] [ text "Assemble" ],
                button [ class "vcontrols-button" ] [ text "Step" ],
                button [ class "vcontrols-button" ] [ text "Run" ]
            ]
        ],
        div [ class "lmc-content columns" ] [
            div [ class "columns-col -wide" ] [
                section "Source code" [
                    textarea [ class "lmc-codebox", onInput SetSourceCode ] [ text model.sourceCode ]
                ]
            ],
            div [ class "columns-col -wide" ] [
                section "Input" [
                    input
                        [ class "lmc-inputbox"
                        , type_ "text"
                        , placeholder "Space-separated list of integers"
                        , value model.inputs
                        , onInput SetInputs ] []
                ],
                section "Output" [
                    input [ class "lmc-outputbox", type_ "text", disabled True ] []
                ],
                section "Registers" [
                    div [ class "registers" ] [
                        div [ class "registers-reg" ] [
                            div [ class "registers-reg-label" ] [ text "ACC" ],
                            div [ class "registers-reg-value" ] [ text "42" ]
                        ],
                        div [ class "registers-reg" ] [
                            div [ class "registers-reg-label" ] [ text "IP" ],
                            div [ class "registers-reg-value" ] [ text "42" ]
                        ],
                        div [ class "registers-reg" ] [
                            div [ class "registers-reg-label" ] [ text "C" ],
                            div [ class "registers-reg-value" ] [ text "0" ]
                        ]
                    ]
                ],
                section "Memory" [
                    Memory.view (always 0)
                ]
            ]
        ]
    ]

section : String -> List (Html a) -> Html a
section title children =
    Html.section [ class "section" ] [
        h2 [ class "section-title" ] [ text title ],
        div [ class "section-content" ] children
    ]
