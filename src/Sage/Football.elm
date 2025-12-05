module Sage.Football exposing (..)

import Dict
import Sage.Plot exposing (Data, Score, Team)



-- import Set exposing (Set)


type alias Match =
    { host : Team
    , opponent : Team
    , result : Result
    }


type Result
    = Pending
    | Final { host : Int, opponent : Int }


pending : Team -> Team -> Match
pending ht ot =
    Match ht ot Pending


final : Team -> Int -> Int -> Team -> Match
final ht hs os ot =
    Match ht ot (Final { host = hs, opponent = os })


hostPoints : Result -> Maybe Int
hostPoints result =
    case result of
        Pending ->
            Nothing

        Final { host, opponent } ->
            Just <|
                if host > opponent then
                    3

                else if host == opponent then
                    1

                else
                    0


opponentPoints : Result -> Maybe Int
opponentPoints result =
    case result of
        Pending ->
            Nothing

        Final { host, opponent } ->
            Just <|
                if host > opponent then
                    0

                else if host == opponent then
                    1

                else
                    3


type alias Day =
    { day : String
    , date : String
    , matches : List Match
    }


type alias Round =
    { number : Int
    , matches : List Day
    }


type alias Season =
    List Round


-- TODO: validate
-- - 10 matches per round
-- - every team plays every round
-- - every team plays every other team once

toScores : Season -> Data
toScores season =
    let
        teams : List Team
        teams =
            season
                |> List.concatMap .matches
                |> List.concatMap .matches
                |> List.concatMap (\m -> [ m.host, m.opponent ])
                |> uniqBy .name

        -- TODO: sort?
        points : Team -> Round -> Maybe Int
        points team round =
            round.matches
                |> List.concatMap .matches
                |> List.filterMap
                    (\m ->
                        if m.host == team then
                            hostPoints m.result

                        else if m.opponent == team then
                            opponentPoints m.result

                        else
                            Nothing
                    )
                |> List.head

        -- FIXME: match exactly one result?
        scores : Team -> List Score
        scores team =
            season
                |> List.map (points team)
                |> List.foldl
                    (\pts ( prevTotal, res ) ->
                        let
                            total =
                                prevTotal + toFloat (pts |> Maybe.withDefault 0)
                        in
                        ( total, Score total False :: res )
                    )
                    ( 0.0, [ Score 0 False ] )
                |> Tuple.second
                |> List.reverse
    in
    teams
        |> List.map
            (\t ->
                ( t, scores t )
            )


uniqBy : (a -> comparable) -> List a -> List a
uniqBy key =
    List.map (\x -> ( key x, x ))
        >> Dict.fromList
        >> Dict.values
