module App exposing (..)

import Array
import Browser
import Element exposing (Element, alignTop, column, el, row, spacing, text)
import Element.Font as Font
import Element.Input exposing (button, checkbox, defaultCheckbox, labelRight)
import Html exposing (Html)
import Sage.EPL2025 as EPL2025
import Sage.Football exposing (currentRound, toScores)
import Sage.Plot exposing (Dot, Result(..), Style(..), plot)
import Sage.Predict as Predict


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


type alias Model =
    { hovering : List Dot
    , predictOption : PredictOption
    , predictRounds : Int
    , style : Style
    , taller : Bool
    , recentOnly : Bool
    }


type PredictOption
    = PredictNone
    | PredictHostWins
    | PredictEvenOdds
      -- |Predict on the basis of each teams' results, each result considered equally
    | PredictStatsFlat


init : Model
init =
    { hovering = []
    , predictOption = PredictStatsFlat
    , predictRounds = 2
    , style = Simple
    , taller = False
    , recentOnly = True
    }


type Msg
    = OnHover (List Dot)
    | SelectPredictor PredictOption
    | IncrementPredictedRounds
    | DecrementPredictedRounds
    | SelectStyle Style
    | SelectTaller Bool
    | SelectRecentOnly Bool


update : Msg -> Model -> Model
update msg model =
    case msg of
        OnHover hovering ->
            { model | hovering = hovering }

        SelectPredictor predictOption ->
            { model | predictOption = predictOption }

        IncrementPredictedRounds ->
            { model | predictRounds = model.predictRounds + 1 }

        DecrementPredictedRounds ->
            { model | predictRounds = model.predictRounds - 1 }

        SelectStyle style ->
            { model | style = style }

        SelectTaller taller ->
            { model | taller = taller }

        SelectRecentOnly recentOnly ->
            { model | recentOnly = recentOnly }


plotWidth : Int
plotWidth =
    600


plotHeight : Model -> Int
plotHeight model =
    if model.taller then
        600

    else
        450


view : Model -> Html Msg
view model =
    let
        season =
            EPL2025.matches

        numRounds =
            season
                |> List.reverse
                |> List.head
                |> Maybe.map .number
                |> Maybe.withDefault 19

        isPlayed match =
            case match.result of
                Final _ ->
                    True

                Projected _ ->
                    False

        scores =
            case model.predictOption of
                PredictNone ->
                    season
                        |> toScores Predict.evenOdds
                        |> List.map (\( t, rs ) -> ( t, rs |> Array.filter (.match >> isPlayed) ))

                PredictHostWins ->
                    season
                        |> toScores Predict.hostWins

                PredictEvenOdds ->
                    season |> toScores Predict.evenOdds

                PredictStatsFlat ->
                    season
                        |> toScores (Predict.flatStats 5 Predict.evenOdds (Predict.flatMatches season))

        options =
            let
                ( minRound, maxRound ) =
                    if model.recentOnly then
                        let
                            cur =
                                currentRound season
                        in
                        ( Just (cur - 5)
                        , Just
                            (cur
                                + (if model.predictOption == PredictNone then
                                    0

                                   else
                                    model.predictRounds
                                  )
                                |> min numRounds
                            )
                        )

                    else
                        ( Nothing, Nothing )
            in
            { style = model.style
            , minRound = minRound
            , maxRound = maxRound
            , dayXOffset = 1 / 5
            , matchXOffset = 1 / 25
            }
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
                    plot OnHover options plotWidth (plotHeight model) scores model.hovering

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
                { onChange = always (SelectPredictor PredictNone)
                , icon = defaultCheckbox
                , checked = model.predictOption == PredictNone
                , label = labelRight [] (text "None")
                }
            , checkbox []
                { onChange = always (SelectPredictor PredictHostWins)
                , icon = defaultCheckbox
                , checked = model.predictOption == PredictHostWins
                , label = labelRight [] (text "Host Wins")
                }
            , checkbox []
                { onChange = always (SelectPredictor PredictEvenOdds)
                , icon = defaultCheckbox
                , checked = model.predictOption == PredictEvenOdds
                , label = labelRight [] (text "Even Odds")
                }
            , checkbox []
                { onChange = always (SelectPredictor PredictStatsFlat)
                , icon = defaultCheckbox
                , checked = model.predictOption == PredictStatsFlat
                , label = labelRight [] (text "Statistical: flat")
                }
            , row [ spacing 8 ] <|
                if model.predictOption == PredictNone then
                    []

                else
                    [ button
                        []
                        { label = row [] [ text "-" ]
                        , onPress =
                            -- Note: predicting 0 rounds means predict remaining matches in the current round
                            if model.predictRounds > 0 then
                                Just DecrementPredictedRounds

                            else
                                Nothing
                        }
                    , text (String.fromInt model.predictRounds)
                    , button
                        []
                        { label = row [] [ text "+" ]
                        , onPress = Just IncrementPredictedRounds
                        }
                    ]
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
            , checkbox []
                { onChange = always <| SelectRecentOnly (not model.recentOnly)
                , icon = defaultCheckbox
                , checked = model.recentOnly
                , label = labelRight [] (text "Recent Matches Only")
                }
            ]
        ]
