module View.Memory exposing (view)

import Html exposing (Html, table, td, text, th, tr)
import Html.Attributes exposing (class)
import Memory exposing (Memory)


view : Int -> Memory -> Html a
view pc memory =
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

                cellClass =
                    if address == pc then
                        "lmc-memory-row-cell -pc"
                    else
                        "lmc-memory-row-cell"
            in
                td [ class cellClass ] [ text cellText ]
    in
        table [ class "lmc-memory" ] (List.range 0 9 |> List.map rowView)
