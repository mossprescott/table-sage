module Sage.Plot exposing (Data, Dot, Score, Team, plot)

import Array
import Chart as C
import Chart.Attributes as CA
import Chart.Events as CE
import Chart.Item as CI
import Html exposing (Html)
import List


type alias Team =
    { name : String
    , color : String

    -- TODO: other info to show in the legend?
    }


{-| A single score value, representing total accumulated points, actual or projected.
-}
type alias Score =
    { value : Float
    , projected : Bool

    -- TODO: other info to show in the tooltip?
    }


type alias Data =
    List ( Team, List Score )


{-| Type of a single point on the plot.
TODO: embed info about match results so it can be shown in the tooltip
-}
type alias Dot =
    CI.One ( Int, Team ) CI.Dot


plot : Data -> (List Dot -> msg) -> List Dot -> Html msg
plot data onHover hovering =
    let
        toY : List Score -> Int -> Maybe Float
        toY scores round =
            Array.fromList scores
                |> Array.get round
                |> Maybe.map .value

        rounds : Team -> List Score -> C.Element ( Int, Team ) msg
        rounds team scores =
            List.range 0 19
                |> List.map (\r -> ( r, team ))
                |> C.series (Tuple.first >> toFloat)
                    [ C.interpolatedMaybe
                        (Tuple.first >> toY scores)
                        [ CA.color team.color ]
                        [ CA.circle
                        , CA.size 1
                        , CA.color team.color
                        ]
                        |> C.named team.name
                    ]
    in
    C.chart
        [ CA.height 300
        , CA.width 400
        , CA.padding { top = 0, left = 30, right = 30, bottom = 0 }

        -- , CA.range [ CA.lowest 1 CA.exactly, CA.highest 19 CA.exactly ]
        , CA.domain [ CA.lowest 0 CA.exactly, CA.highest 40 CA.orHigher ]
        , CE.onMouseMove onHover (CE.getNearest CI.dots)
        , CE.onMouseLeave (onHover [])
        ]
    <|
        [ C.xLabels [ CA.withGrid, CA.fontSize 12 ]
        , C.yLabels [ CA.withGrid, CA.fontSize 12 ]
        ]
            ++ List.map (\( t, ss ) -> rounds t ss) data
            ++ [ C.each hovering <|
                    \p item ->
                        [ C.tooltip item [] [] [] ]
               ]



-- ++ [ C.legendsAt .max
--         .max
--         [ CA.column
--         , CA.spacing 1
--         ]
--         []
--    ]
