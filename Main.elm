module Main exposing (main)

import Geolocation exposing (Location, changes, now)
import Html exposing (Html, div, text)
import Html.App
import Task


type GeolocationData a
    = Loading
    | Error Geolocation.Error
    | Success a


type alias Model =
    { locationData : GeolocationData Location
    }


main =
    Html.App.program
        { init = ( Model Loading, Task.perform LocationError UpdatedLocation now )
        , update = update
        , view = view
        , subscriptions = (\_ -> changes UpdatedLocation)
        }


type Msg
    = LocationError Geolocation.Error
    | UpdatedLocation Location


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        LocationError error ->
            { model | locationData = Error error } ! []

        UpdatedLocation location ->
            { model | locationData = Success location } ! []


view : Model -> Html Msg
view model =
    case model.locationData of
        Loading ->
            div [] [ text "Loading..." ]

        Error error ->
            div [] [ text <| toString error ]

        Success location ->
            div [] [ text <| toString location ]
