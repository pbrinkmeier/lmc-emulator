module View.Memory exposing (view)

import Html exposing (Html, table, td, text, th, tr)
import Html.Attributes exposing (class)
import Memory exposing (Memory)


view : Memory -> Html a
view memory =
    let
        rowView : Int -> Html a
        rowView rowNumber =
            let
                firstCellOfRow : Int
                firstCellOfRow =
                    rowNumber * 10

                label : Html a
                label =
                    th [ class "lmc-memory-row-label" ]
                        [ text (toString firstCellOfRow) ]

                cells : List (Html a)
                cells =
                    List.range 0 9
                        |> List.map (((+) firstCellOfRow) >> cellView)
            in
                tr [ class "lmc-memory-row" ] (label :: cells)

        cellView : Int -> Html a
        cellView address =
            let
                cellText =
                    Memory.get address memory
                        |> toString
                        |> String.padLeft 3 '0'
            in
                td [ class "lmc-memory-row-cell" ] [ text cellText ]
    in
        table [ class "lmc-memory" ] (List.range 0 9 |> List.map rowView)
