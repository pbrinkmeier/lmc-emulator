module Main exposing (main)

import Html
import Model
import Subs
import Update
import View


main : Program Never Model.Model Update.Msg
main =
    Html.program
        { init = ( Model.initialModel, Cmd.none )
        , update = Update.update
        , view = View.view
        , subscriptions = Subs.subscriptions
        }
