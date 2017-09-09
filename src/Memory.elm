module Memory exposing (view)

import Html exposing (Html, table, td, text, th, tr)
import Html.Attributes exposing (class)

type alias Address = Int
type alias Value = Int

view : (Address -> Value) -> Html a
view readAt =
    table [ class "memory" ] (
        List.range 0 9
        |> List.map (\rowNumber ->
            let
                memRow =
                    List.range 0 9
                    |> List.map (\colNumber ->
                        let
                            cellValue = readAt (rowNumber * 10 + colNumber)
                        in
                            td [ class "memory-row-cell" ] [ toString cellValue |> text ]
                    )
            in
                tr [ class "memory-row" ] ([
                    th [ class "memory-row-label" ] [ toString (rowNumber * 10) |> text ]
                ] ++ memRow)
        )
    )
