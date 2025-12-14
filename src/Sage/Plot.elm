module Sage.Plot exposing
    ( Data
    , Dot
    , Goals
    , Match
    , Result(..)
    , Score
    , Style(..)
    , Team
    , oddsFraction
    , plot
    )

import Array exposing (Array)
import Chart as C
import Chart.Attributes as CA
import Chart.Events as CE
import Chart.Item as CI
import FormatNumber as FN
import FormatNumber.Locales as FNL exposing (Locale, usLocale)
import Html exposing (Html)
import Html.Attributes as HA
import List


type alias Team =
    { shortName : String
    , name : String
    , longName : String
    , color : String

    -- TODO: other info to show in the legend?
    }


type alias Match result =
    { host : Team
    , opponent : Team
    , result : result
    }


type alias Goals =
    { host : Int
    , opponent : Int
    }


type alias Odds =
    { win : Float, draw : Float, lose : Float }



-- |One of the fields from an Odds, normalized so that the three values add to 1.0.


oddsFraction : (Odds -> Float) -> Odds -> Float
oddsFraction field odds =
    field odds / (odds.win + odds.draw + odds.lose)


type Result
    = Final Goals
    | Projected Odds


{-| A single score value, representing total accumulated points, actual or projected.
-}
type alias Score =
    { match : Match Result
    , total : Float
    }



-- |A series of results and total scores for each team


type alias Data =
    List ( Team, Array Score )


{-| Type of a single point on the plot.
TODO: embed info about match results so it can be shown in the tooltip
-}
type alias Dot =
    CI.One ( Int, Team ) CI.Dot


type alias Element msg =
    C.Element ( Int, Team ) msg


type Style
    = Simple
    | Flatter


scoresForTeam : Team -> Data -> Maybe (Array Score)
scoresForTeam team data =
    data
        |> List.filterMap
            (\( t, r ) ->
                if t == team then
                    Just r

                else
                    Nothing
            )
        |> List.head


pointsLocale : Locale
pointsLocale =
    { usLocale | decimals = FNL.Max 1 }


plot : (List Dot -> msg) -> Style -> Int -> Int -> Data -> List Dot -> Html msg
plot onHover style width height data hovering =
    let
        toY : Array Score -> Int -> Maybe Float
        toY scores round =
            scores
                |> Array.get (round - 1)
                |> Maybe.map
                    (\s ->
                        if style == Flatter then
                            s.total - toFloat round

                        else
                            s.total
                    )

        rounds : Team -> Array Score -> Element msg
        rounds team scores =
            List.range 1 19
                |> List.map (\r -> ( r, team ))
                |> C.series (Tuple.first >> toFloat)
                    [ C.interpolatedMaybe
                        (Tuple.first >> toY scores)
                        [ CA.color team.color
                        , CA.dashed [ 1, 2 ]
                        ]
                        [ CA.circle
                        , CA.size 1
                        , CA.color team.color
                        ]
                        |> C.named team.name
                    ]

        -- Subset of teams' data to display
        displayed =
            data

        styledTeam field team =
            Html.span
                [ HA.style "color" team.color ]
                [ Html.text (field team)
                ]

        tooltip : plane -> Dot -> List (Element msg)
        tooltip _ item =
            let
                ( round, team ) =
                    CI.getData item

                score : Maybe Score
                score =
                    data
                        |> scoresForTeam team
                        |> Maybe.andThen (Array.get (round - 1))

                scoreView : Score -> List (Html Never)
                scoreView s =
                    [ Html.div []
                        [ Html.span []
                            [ styledTeam .name team
                            , Html.text <| ": " ++ FN.format pointsLocale s.total ++ " after " ++ String.fromInt round ++ " rounds"
                            ]
                        , Html.br [] []
                        , styledTeam .shortName s.match.host
                        , Html.span []
                            [ case s.match.result of
                                Final goals ->
                                    Html.text
                                        (" "
                                            ++ String.fromInt goals.host
                                            ++ " – "
                                            ++ String.fromInt goals.opponent
                                            ++ " "
                                        )

                                Projected odds ->
                                    let
                                        total =
                                            odds.win + odds.draw + odds.lose
                                    in
                                    Html.text
                                        (" "
                                            ++ String.fromInt (truncate (100 * odds.win / total))
                                            ++ "% "
                                            ++ String.fromInt (truncate (100 * odds.draw / total))
                                            ++ "% "
                                            ++ String.fromInt (truncate (100 * odds.lose / total))
                                            ++ "% "
                                        )
                            ]
                        , styledTeam .shortName s.match.opponent
                        ]
                    ]
            in
            [ C.tooltip item
                [ CA.onLeftOrRight ]
                []
                (score
                    |> Maybe.map scoreView
                    |> Maybe.withDefault []
                )
            ]

        {- A tooltip-style decoration to the right of the last displayed match for a team, in lieu
           of a legend. Seems like the way to do this is to map over _all_ the dots and annotate
           just the ones we want.
        -}
        legendTip : plane -> Dot -> List (Element msg)
        legendTip _ item =
            let
                ( round, team ) =
                    CI.getData item

                isLast =
                    case data |> scoresForTeam team of
                        Just scores ->
                            Array.length scores == round

                        Nothing ->
                            False

                scoreMay : Maybe Score
                scoreMay =
                    if isLast then
                        data
                            |> scoresForTeam team
                            |> Maybe.andThen (Array.get (round - 1))

                    else
                        Nothing
            in
            case scoreMay of
                Just score ->
                    [ C.tooltip item
                        [ CA.onRight
                        , CA.background "#FFFFFFCC"
                        ]
                        []
                        [ Html.span []
                            [ Html.text <|
                                FN.format pointsLocale score.total
                                    ++ " "
                            , styledTeam .name team
                            ]
                        ]
                    ]

                Nothing ->
                    []
    in
    C.chart
        [ CA.height <| toFloat height
        , CA.width <| toFloat width
        , CA.padding { top = 0, left = 30, right = 30, bottom = 0 }
        , CA.range [ CA.lowest 1 CA.exactly, CA.highest 19 CA.exactly ]

        -- , CA.domain [ CA.lowest 0 CA.orLower, CA.highest 40 CA.orHigher ]
        , CE.onMouseMove onHover (CE.getNearest CI.dots)
        , CE.onMouseLeave (onHover [])
        ]
    <|
        [ C.xLabels [ CA.withGrid, CA.fontSize 12 ]

        -- , C.yLabels [ CA.withGrid, CA.fontSize 12 ]
        ]
            ++ List.map (\( t, ss ) -> rounds t ss) displayed
            ++ [ C.each hovering tooltip
               , C.eachDot legendTip

               --    , C.legendsAt .max
               --         .max
               --         [ CA.column
               --         , CA.spacing 1
               --         ]
               --         []
               ]
