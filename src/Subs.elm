module Subs exposing (subscriptions)

import Model exposing (Model)
import Time exposing (millisecond)
import Update exposing (Msg(Tick))


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.vmIsRunning then
        Time.every (100 * millisecond) Tick
    else
        Sub.none
