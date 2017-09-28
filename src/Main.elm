module Main exposing (main)

import Html
import Model
import Subs
import Update
import View


{-
   Set up the elm architecture.
-}


main : Program Flags Model.Model Update.Msg
main =
    Html.programWithFlags
        { init = (.hash >> Model.decode)
        , update = Update.update
        , view = View.view
        , subscriptions = Subs.subscriptions
        }


{-|

    This is the type of the object that will be passed to the app from javascript on initialization.
    The field `hash` will contain the hash part of the URL without the leading hash character.
-}
type alias Flags =
    { hash : String
    }
