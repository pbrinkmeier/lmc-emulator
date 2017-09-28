module Main exposing (main)

import Html
import Model
import Subs
import Update
import View


{-
   Set up the elm architecture.
-}


main : Program { hash : String } Model.Model Update.Msg
main =
    Html.programWithFlags
        { init = \{ hash } -> (Model.decode hash, Cmd.none)
        , update = Update.update
        , view = View.view
        , subscriptions = Subs.subscriptions
        }
