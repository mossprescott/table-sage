module Sage.Predict exposing (..)

import Dict exposing (Dict)
import Sage.Football exposing (Predictor, Season, joinGoals, withResult)
import Sage.Plot exposing (Goals, Match, TeamId)


hostWins : Predictor r
hostWins =
    always { win = 1.0, draw = 0.0, lose = 0.0 }


evenOdds : Predictor r
evenOdds =
    always { win = 0.33, draw = 0.33, lose = 0.33 }


type SimpleResult
    = Win
    | Lose
    | Draw


hostResult : Goals -> SimpleResult
hostResult goals =
    if goals.host > goals.opponent then
        Win

    else if goals.host < goals.opponent then
        Lose

    else
        Draw


opponentResult : Goals -> SimpleResult
opponentResult =
    hostResult >> invertResult


invertResult : SimpleResult -> SimpleResult
invertResult sr =
    case sr of
        Win ->
            Lose

        Lose ->
            Win

        Draw ->
            Draw


{-| A simple count for each result.
-}
type alias WLDCount =
    { win : Int, lose : Int, draw : Int }


wldEmpty : WLDCount
wldEmpty =
    { win = 0, lose = 0, draw = 0 }


wldPlayed : WLDCount -> Int
wldPlayed { win, lose, draw } =
    win + lose + draw


wldIncr : SimpleResult -> WLDCount -> WLDCount
wldIncr sr =
    \c ->
        case sr of
            Win ->
                { c | win = c.win + 1 }

            Lose ->
                { c | lose = c.lose + 1 }

            Draw ->
                { c | draw = c.draw + 1 }


{-| Build statistics accounting _only_ for W/L/D percentages, and then predict the mean of those
percentages for each side.

Note: when partially applied, statistics are constructed just once and then predicting each result
only takes a handful of simple lookups. FIXME: uh, refactor so that's true.

-}
flat : Int -> Predictor () -> List (Match Goals) -> Predictor result
flat minPlayed fallback history =
    let
        stats : Dict TeamId WLDCount
        stats =
            history
                |> List.concatMap
                    (\m ->
                        [ ( m.host.shortName, hostResult m.result )
                        , ( m.opponent.shortName, opponentResult m.result )
                        ]
                    )
                |> List.foldl
                    (\( t, sr ) -> Dict.update t (withDefault wldEmpty (wldIncr sr)))
                    Dict.empty

        -- |If enough results are present, then this is the fraction that were in the corresponding category.
        apply f s =
            let
                played =
                    s |> wldPlayed
            in
            if played >= minPlayed then
                Just <| toFloat (f s) / toFloat played

            else
                Nothing
    in
    \match ->
        let
            hostStats f =
                stats |> Dict.get match.host.shortName |> Maybe.andThen (apply f)

            opponentStats f =
                stats |> Dict.get match.opponent.shortName |> Maybe.andThen (apply f)

            mean x y =
                (x + y) / 2

            orElse f =
                Maybe.withDefault (fallback (match |> withResult ()) |> f)
        in
        { win = Maybe.map2 mean (hostStats .win) (opponentStats .lose) |> orElse .win
        , lose = Maybe.map2 mean (hostStats .lose) (opponentStats .win) |> orElse .lose
        , draw = Maybe.map2 mean (hostStats .draw) (opponentStats .draw) |> orElse .draw
        }


{-| Build statistics accounting _only_ for W/L/D percentages, and then predict the mean of those
percentages for each side.

Note: when partially applied, statistics are constructed just once and then predicting each result
only takes a handful of simple lookups. FIXME: uh, refactor so that's true.

-}
homeAndAway : Int -> Predictor () -> List (Match Goals) -> Predictor result
homeAndAway minPlayed fallback history =
    let
        stats : Dict TeamId { home : WLDCount, away : WLDCount }
        stats =
            history
                |> List.foldl
                    (\m ->
                        Dict.update m.host.shortName
                            (withDefault { home = wldEmpty, away = wldEmpty }
                                (\cs -> { cs | home = wldIncr (hostResult m.result) cs.home })
                            )
                            >> Dict.update m.opponent.shortName
                                (withDefault { home = wldEmpty, away = wldEmpty }
                                    (\cs -> { cs | away = wldIncr (opponentResult m.result) cs.away })
                                )
                    )
                    Dict.empty

        -- |If enough results are present, then this is the fraction that were in the corresponding category.
        apply f g s =
            let
                these =
                    f s

                played =
                    these.win + these.lose + these.draw
            in
            if played >= minPlayed then
                Just <| toFloat (g these) / toFloat played

            else
                Nothing
    in
    \match ->
        let
            hostStats : (WLDCount -> Int) -> Maybe Float
            hostStats f =
                stats |> Dict.get match.host.shortName |> Maybe.andThen (apply .home f)

            opponentStats : (WLDCount -> Int) -> Maybe Float
            opponentStats f =
                stats |> Dict.get match.opponent.shortName |> Maybe.andThen (apply .away f)

            mean x y =
                (x + y) / 2

            orElse f =
                Maybe.withDefault (fallback (match |> withResult ()) |> f)
        in
        { win = Maybe.map2 mean (hostStats .win) (opponentStats .lose) |> orElse .win
        , lose = Maybe.map2 mean (hostStats .lose) (opponentStats .win) |> orElse .lose
        , draw = Maybe.map2 mean (hostStats .draw) (opponentStats .draw) |> orElse .draw
        }


{-| Extract the already-played matches from a season, preserving their scheduled sequence.
-}
flatMatches : Season -> List (Match Goals)
flatMatches =
    List.concatMap .matches
        >> List.concatMap
            (.matches
                >> List.filterMap joinGoals
            )


{-| Dictionary update with a common start value and total update fn.

    Dict.update "a" (withDefault 0 (\cnt -> cnt + 1)) counts

-}
withDefault : v -> (v -> v) -> (Maybe v -> Maybe v)
withDefault def func =
    Maybe.withDefault def >> func >> Just
