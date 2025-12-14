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
import Chart.Svg exposing (Plane)
import Html exposing (Html)
import Html.Attributes as HA
import List


type alias Team =
    { name : String
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


plot : (List Dot -> msg) -> Style -> Data -> List Dot -> Html msg
plot onHover style data hovering =
    let
        toY : Array Score -> Int -> Maybe Float
        toY scores round =
            scores
                |> Array.get (round - 1)
                -- TODO: (-) round if style == Flatter
                |> Maybe.map .total

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

        styledName team =
            Html.span
                [ HA.style "color" team.color ]
                [ Html.text team.name
                ]

        tooltip : Plane -> Dot -> List (Element msg)
        tooltip _ item =
            let
                ( round, team ) =
                    CI.getData item

                score : Maybe Score
                score =
                    data
                        |> List.filterMap
                            (\( t, r ) ->
                                if t == team then
                                    Just r

                                else
                                    Nothing
                            )
                        |> List.head
                        |> Maybe.andThen (Array.get (round - 1))

                scoreView : Score -> List (Html Never)
                scoreView s =
                    [ styledName s.match.host
                    , Html.span [] <|
                        case s.match.result of
                            Final goals ->
                                [ Html.text
                                    (" "
                                        ++ String.fromInt goals.host
                                        ++ " – "
                                        ++ String.fromInt goals.opponent
                                        ++ " "
                                    )
                                ]

                            Projected odds ->
                                let
                                    total =
                                        odds.win + odds.draw + odds.lose
                                in
                                [ Html.text
                                    (" "
                                        ++ String.fromInt (truncate (100 * odds.win / total))
                                        ++ "% "
                                        ++ String.fromInt (truncate (100 * odds.draw / total))
                                        ++ "% "
                                        ++ String.fromInt (truncate (100 * odds.lose / total))
                                        ++ "% "
                                    )
                                ]
                    , styledName s.match.opponent

                    -- , Html.text <| Debug.toString score
                    ]
            in
            [ C.tooltip item
                []
                []
                (score
                    |> Maybe.map scoreView
                    |> Maybe.withDefault []
                )
            ]
    in
    C.chart
        [ CA.height 300
        , CA.width 400
        , CA.padding { top = 0, left = 30, right = 30, bottom = 0 }
        , CA.range [ CA.lowest 1 CA.exactly, CA.highest 19 CA.exactly ]

        -- , CA.domain [ CA.lowest 0 CA.orLower, CA.highest 40 CA.orHigher ]
        , CE.onMouseMove onHover (CE.getNearest CI.dots)
        , CE.onMouseLeave (onHover [])
        ]
    <|
        [ C.xLabels [ CA.withGrid, CA.fontSize 12 ]
        , C.yLabels [ CA.withGrid, CA.fontSize 12 ]
        ]
            ++ List.map (\( t, ss ) -> rounds t ss) displayed
            ++ [ C.each hovering tooltip
               , C.legendsAt .max
                    .max
                    [ CA.column
                    , CA.spacing 1
                    ]
                    []
               ]
