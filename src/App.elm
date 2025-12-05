module App exposing (..)

-- import Element.Background as Background
-- import Element.Border as Border

import Browser
import Element exposing (column, el, text)
import Element.Font as Font
import Html exposing (Html)
import Sage.EPL2025 as EPL2025
import Sage.Football exposing (toScores)
import Sage.Plot exposing (Dot, plot)


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


type alias Model =
    { hovering : List Dot }


init : Model
init =
    { hovering = [] }


type Msg
    = OnHover (List Dot)


update : Msg -> Model -> Model
update msg model =
    case msg of
        OnHover hovering ->
            { model | hovering = hovering }


view : Model -> Html Msg
view model =
    Element.layout [] <|
        column
            [ Element.padding 10
            ]
            [ el [ Font.size 16 ] <|
                text "Premier League 2025–6: First Half"
            , el
                [ Element.height <| Element.px 400
                , Element.padding 20
                , Font.size 8
                ]
              <|
                Element.html <|
                    plot (toScores EPL2025.matches) OnHover model.hovering

            -- , column []
            --     (toScores EPL2025.matches |> List.map (Debug.toString >> text))
            , el
                [ Font.family [ Font.monospace ]
                , Font.size 8
                ]
                (model.hovering |> Debug.toString |> text)
            ]
