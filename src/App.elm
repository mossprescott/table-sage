module App exposing (..)

-- import Element.Background as Background
-- import Element.Border as Border

import Array
import Browser
import Element exposing (column, el, spacing, text)
import Element.Font as Font
import Element.Input exposing (checkbox, defaultCheckbox, labelRight)
import Html exposing (Html)
import Sage.EPL2025 as EPL2025
import Sage.Football exposing (Predictor(..), toScores)
import Sage.Plot exposing (Dot, Result(..), Style(..), plot)


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


type alias Model =
    { hovering : List Dot
    , predictor : Maybe Predictor
    }


init : Model
init =
    { hovering = []
    , predictor = Nothing
    }


type Msg
    = OnHover (List Dot)
    | SelectPredictor (Maybe Predictor)


update : Msg -> Model -> Model
update msg model =
    case msg of
        OnHover hovering ->
            { model | hovering = hovering }

        SelectPredictor predictor ->
            { model | predictor = predictor }


view : Model -> Html Msg
view model =
    let
        scores =
            case model.predictor of
                Nothing ->
                    EPL2025.matches
                        |> toScores PredictEvenOdds
                        |> List.map
                            (\( t, rs ) ->
                                ( t
                                , rs
                                    |> Array.filter
                                        (\s ->
                                            case s.match.result of
                                                Final _ ->
                                                    True

                                                Projected _ ->
                                                    False
                                        )
                                )
                            )

                Just predictor ->
                    EPL2025.matches
                        |> toScores predictor
    in
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
                    plot OnHover Simple scores model.hovering

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
                [ text "Prediction"
                , checkbox []
                    { onChange = always (SelectPredictor (Just PredictHostWins))
                    , icon = defaultCheckbox
                    , checked = model.predictor == Just PredictHostWins
                    , label = labelRight [] (text "Host Wins")
                    }
                , checkbox []
                    { onChange = always (SelectPredictor (Just PredictEvenOdds))
                    , icon = defaultCheckbox
                    , checked = model.predictor == Just PredictEvenOdds
                    , label = labelRight [] (text "Even Odds")
                    }
                , checkbox []
                    { onChange = always (SelectPredictor Nothing)
                    , icon = defaultCheckbox
                    , checked = model.predictor == Nothing
                    , label = labelRight [] (text "None")
                    }
                ]
            ]
