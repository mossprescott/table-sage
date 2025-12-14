module App exposing (..)

import Array
import Browser
import Element exposing (Element, alignTop, column, el, row, spacing, text)
import Element.Font as Font
import Element.Input exposing (checkbox, defaultCheckbox, labelRight)
import Html exposing (Html)
import Sage.EPL2025 as EPL2025
import Sage.Football exposing (Predictor(..), toScores)
import Sage.Plot exposing (Dot, Result(..), Style(..), plot)
import Element exposing (paddingXY)


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
    , style : Style
    , taller : Bool
    }


init : Model
init =
    { hovering = []
    , predictor = Nothing
    , style = Simple
    , taller = False
    }


type Msg
    = OnHover (List Dot)
    | SelectPredictor (Maybe Predictor)
    | SelectStyle Style
    | SelectTaller Bool


update : Msg -> Model -> Model
update msg model =
    case msg of
        OnHover hovering ->
            { model | hovering = hovering }

        SelectPredictor predictor ->
            { model | predictor = predictor }

        SelectStyle style ->
            { model | style = style }

        SelectTaller taller ->
            { model | taller = taller }

plotWidth : Int
plotWidth = 400

plotHeight : Model -> Int
plotHeight model =
    if model.taller then
        450

    else
        300


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
            [ optionsView model
            , el [ Font.size 16 ] <|
                text "Premier League 2025–6: First Half"
            , el
                [ Element.height <| Element.px (plotHeight model + 100)
                , Element.width <| Element.px (plotWidth + 100)
                , Element.padding 50
                , Font.size 8
                ]
              <|
                Element.html <|
                    plot OnHover model.style plotWidth (plotHeight model) scores model.hovering

            -- , column []
            --     (toScores EPL2025.matches |> List.map (Debug.toString >> text))
            -- , column
            --     [ Font.family [ Font.monospace ]
            --     , Font.size 8
            --     ]
            --     (model.hovering |> List.map (Debug.toString >> Debug.log "" >> text))
            ]


optionsView : Model -> Element Msg
optionsView model =
    row
        [ Font.size 12
        , spacing 20
        , Element.padding 25
        ]
        [ column
            [ spacing 10
            , alignTop
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
        , column
            [ spacing 10
            , alignTop
            ]
            [ text "Style"
            , checkbox []
                { onChange =
                    always
                        (SelectStyle
                            (if model.style == Flatter then
                                Simple

                             else
                                Flatter
                            )
                        )
                , icon = defaultCheckbox
                , checked = model.style == Flatter
                , label = labelRight [] (text "Flatter")
                }
            , checkbox []
                { onChange = always <| SelectTaller (not model.taller)
                , icon = defaultCheckbox
                , checked = model.taller
                , label = labelRight [] (text "Taller")
                }
            ]
        ]
