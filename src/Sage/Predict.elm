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
opponentResult { host, opponent } =
    hostResult { host = opponent, opponent = host }


{-| Build statistics accounting _only_ for W/L/D percentages, and then predict the mean of those
percentages for each side.

Note: when partially applied, statistics are constructed just once and then predicting each result
only takes a handful of simple lookups. FIXME: uh, refactor so that's true)

-}
flatStats : Int -> Predictor () -> List (Match Goals) -> Predictor result
flatStats minPlayed fallback history match =
    let
        stats : Dict TeamId { win : Int, lose : Int, draw : Int }
        stats =
            history
                |> List.concatMap
                    (\m ->
                        [ ( m.host.shortName, hostResult m.result )
                        , ( m.opponent.shortName, opponentResult m.result )
                        ]
                    )
                |> List.foldl
                    (\( t, sr ) ->
                        Dict.update t
                            (\sm ->
                                let
                                    s =
                                        sm |> Maybe.withDefault { win = 0, lose = 0, draw = 0 }
                                in
                                Just <|
                                    case sr of
                                        Win ->
                                            { s | win = s.win + 1 }

                                        Lose ->
                                            { s | lose = s.lose + 1 }

                                        Draw ->
                                            { s | draw = s.draw + 1 }
                            )
                    )
                    Dict.empty

        -- |If enough results are present, then this is the fraction that were in the corresponding category.
        apply f s =
            let
                played =
                    s.win + s.lose + s.draw
            in
            if played >= minPlayed then
                Just <| toFloat (f s) / toFloat played

            else
                Nothing

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


{-| Extract the already-played matches from a season, preserving their scheduled sequence.
-}
flatMatches : Season -> List (Match Goals)
flatMatches =
    List.concatMap .matches
        >> List.concatMap
            (.matches
                >> List.filterMap joinGoals
            )
