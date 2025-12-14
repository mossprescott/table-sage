module App exposing (..)

-- import Element.Background as Background
-- import Element.Border as Border

import Browser
import Element exposing (column, el, text, spacing)
import Element.Font as Font
import Element.Input exposing (checkbox, defaultCheckbox, labelRight)
import Html exposing (Html)
import Sage.EPL2025 as EPL2025
import Sage.Football exposing (Predictor(..), toScores)
import Sage.Plot exposing (Dot, Style(..), plot)


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


type alias Model =
    { hovering : List Dot
    , predictor : Predictor
    }


init : Model
init =
    { hovering = []
    , predictor = PredictHostWins
    }


type Msg
    = OnHover (List Dot)
    | SelectPredictor Predictor


update : Msg -> Model -> Model
update msg model =
    case msg of
        OnHover hovering ->
            { model | hovering = hovering }

        SelectPredictor predictor ->
            { model | predictor = predictor }


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
                , Element.width <| Element.px 500
                , Element.padding 50
                , Font.size 8
                ]
              <|
                Element.html <|
                    plot OnHover Simple (toScores model.predictor EPL2025.matches) model.hovering

            -- , column []
            --     (toScores EPL2025.matches |> List.map (Debug.toString >> text))
            -- , column
            --     [ Font.family [ Font.monospace ]
            --     , Font.size 8
            --     ]
            --     (model.hovering |> List.map (Debug.toString >> Debug.log "" >> text))
            , column
                [ Font.size 12
                , spacing 10
                ]
                [ checkbox []
                    { onChange = always (SelectPredictor PredictHostWins)
                    , icon = defaultCheckbox
                    , checked = model.predictor == PredictHostWins
                    , label = labelRight [] (text "Predict Host Wins")
                    }
                , checkbox []
                    { onChange = always (SelectPredictor PredictEvenOdds)
                    , icon = defaultCheckbox
                    , checked = model.predictor == PredictEvenOdds
                    , label = labelRight [] (text "Predict Even Odds")
                    }
                ]
            ]
