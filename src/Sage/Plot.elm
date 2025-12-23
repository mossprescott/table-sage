module Sage.Plot exposing
    ( Data
    , Dot
    , Goals
    , Match
    , Odds
    , Result(..)
    , Score
    , Style(..)
    , Team
    , TeamId
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
import Set exposing (Set)


type alias TeamId =
    String


type alias Team =
    { shortName : TeamId
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


{-| One of the fields from an Odds, normalized so that the three values add to 1.0.
-}
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

    -- |Match scheduling hint, which indicates what day of the round and what position in the day's
    -- sequence of matches this match occurs.
    , schedule : ( Int, Int )
    }


{-| A series of results and total scores for each team
-}
type alias Data =
    List ( Team, Array Score )


{-| Type of a single point on the plot; which identifies a team and round (match week.)
-}
type alias Dot =
    CI.One ( Int, Team ) CI.Dot


type alias Element msg =
    C.Element ( Int, Team ) msg


type Style
    = Simple
    | Flatter


type alias Options =
    { style : Style
    , minRound : Maybe Int
    , maxRound : Maybe Int

    -- |How far to shift a match's dot to the right, for each day it is later than the first day of the round.
    , dayXOffset : Float

    --| How far to shift a match's dot to the right, for each position within the same day's matches, which
    -- roughly reflects start time.
    , matchXOffset : Float
    }


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


{-| Display a string in the team's color(s).
-}
styledTeam : (Team -> String) -> Team -> Html Never
styledTeam field team =
    Html.span
        [ HA.style "color" team.color ]
        [ Html.text (field team)
        ]


{-| Display a match/result, in the context of a particluar dot (i.e. the round and one of the teams.)
-}
scoreView : Int -> Team -> Score -> List (Html Never)
scoreView round team s =
    [ Html.div []
        [ styledTeam .shortName s.match.host
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
        , Html.br [] []
        , Html.text <| "Round " ++ String.fromInt round
        , Html.br [] []
        , Html.span [] [ styledTeam .name team ]
        , Html.text <| " " ++ FN.format pointsLocale s.total   ]
    ]


plot : (List Dot -> msg) -> Options -> Int -> Int -> Data -> List Dot -> Html msg
plot onHover options width height data hovering =
    let
        scoreForDot : ( Int, Team ) -> Maybe Score
        scoreForDot ( round, team ) =
            data
                |> scoresForTeam team
                |> Maybe.andThen (Array.get (round - 1))

        focusedTeams : Set TeamId
        focusedTeams =
            let
                dotTeams : ( Int, Team ) -> List TeamId
                dotTeams ( r, t ) =
                    case scoreForDot ( r, t ) of
                        Just score ->
                            [ score.match.host.shortName
                            , score.match.opponent.shortName
                            ]

                        Nothing ->
                            [ t.shortName ]
            in
            if hovering == [] then
                data
                    |> List.map
                        (Tuple.first >> .shortName)
                    |> Set.fromList

            else
                hovering
                    |> List.map CI.getData
                    |> List.concatMap dotTeams
                    |> Set.fromList

        -- Subset of teams' data to display
        displayed =
            --data |> List.filter (Tuple.first >> .shortName >> (\n -> Set.member n focusedTeams))
            data
                |> List.sortBy
                    (\( t, _ ) ->
                        if Set.member t.shortName focusedTeams then
                            1

                        else
                            0
                    )

        toY : Array Score -> Int -> Maybe Float
        toY scores round =
            scores
                |> Array.get (round - 1)
                |> Maybe.map
                    (\s ->
                        if options.style == Flatter then
                            s.total - toFloat round

                        else
                            s.total
                    )

        toX : ( Int, Team ) -> Float
        toX ( round, team ) =
            let
                score =
                    scoreForDot ( round, team )

                ( dayInRound, matchInDay ) =
                    score |> Maybe.map .schedule |> Maybe.withDefault ( 0, 0 )
            in
            toFloat round
                + (toFloat dayInRound * options.dayXOffset)
                + (toFloat matchInDay * options.matchXOffset)

        -- Color for the team's scores, based on display state (focused or not)
        teamDisplayColor team =
            if Set.member team.shortName focusedTeams then
                team.color

            else
                "#EEEEEE"

        lineAttrs team =
            [ CA.color <| teamDisplayColor team
            ]

        commonDotAttrs team =
            [ CA.circle
            , CA.size 3

            -- This becomes the fill when a border is added
            , CA.color "#FFF"
            ]

        -- Attributes that are overridden for dots where a score is known (real or projected)
        -- dotAttrs : Team -> Score -> List (CA.Attribute {a | color : String, shape : Maybe svg})
        dotAttrs team score =
            case score |> .match |> .result of
                Final _ ->
                    -- TODO: style for W/L/D result (host's POV)?
                    [ CA.color <| teamDisplayColor team
                    ]

                Projected _ ->
                    [ CA.border <| teamDisplayColor team
                    , CA.borderWidth 0.5
                    ]

        rounds : Team -> Array Score -> Element msg
        rounds team scores =
            List.range 1 19
                |> List.map (\r -> ( r, team ))
                |> C.series toX
                    [ C.interpolatedMaybe
                        (Tuple.first >> toY scores)
                        (lineAttrs team)
                        (commonDotAttrs team)
                        |> C.variation
                            (\_ ( r, t ) ->
                                scoreForDot ( r, t )
                                    |> Maybe.map (dotAttrs team)
                                    |> Maybe.withDefault []
                            )
                        |> C.named team.name
                    ]

        tooltip : plane -> Dot -> List (Element msg)
        tooltip _ item =
            let
                ( round, team ) =
                    CI.getData item

                score : Maybe Score
                score =
                    scoreForDot ( round, team )
            in
            [ C.tooltip item
                [ CA.onLeftOrRight ]
                []
                (score
                    |> Maybe.map (scoreView round team)
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
                            let
                                lastVisibleRound =
                                    Array.length scores
                                        |> (options.maxRound
                                                |> Maybe.map (\m -> min m)
                                                |> Maybe.withDefault identity
                                           )
                            in
                            round == lastVisibleRound

                        Nothing ->
                            False

                scoreMay : Maybe Score
                scoreMay =
                    if isLast then
                        scoreForDot ( round, team )

                    else
                        Nothing
            in
            case scoreMay of
                Just score ->
                    [ C.tooltip item
                        [ CA.onRight

                        -- Tricky: just slightly translucent so you can (maybe) tell when there's something hidden
                        , CA.background "#FFFFFFE7"
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
        , CA.range
            [ options.minRound
                |> Maybe.map (\r -> CA.lowest (toFloat r) CA.exactly)
                |> Maybe.withDefault (CA.lowest 1 CA.orLower)
            , options.maxRound
                |> Maybe.map (\r -> CA.highest (toFloat r + 0.5) CA.exactly)
                |> Maybe.withDefault (CA.highest 19.5 CA.orHigher)
            ]

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
