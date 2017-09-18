module Main exposing (main)

import Html
import Model
import Update
import View


main : Program Never Model.Model Update.Msg
main =
    Html.beginnerProgram
        { model = Model.initialModel
        , update = Update.update
        , view = View.view
        }
