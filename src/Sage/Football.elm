module Sage.Football exposing (..)

import Array exposing (Array)
import Dict
import Sage.Plot exposing (Data, Goals, Match, Result(..), Score, Team, oddsFraction)


pending : Team -> Team -> Match (Maybe Goals)
pending ht ot =
    Match ht ot Nothing


final : Team -> Int -> Int -> Team -> Match (Maybe Goals)
final ht hs os ot =
    Match ht ot (Just { host = hs, opponent = os })


hostPoints : Goals -> Int
hostPoints { host, opponent } =
    if host > opponent then
        3

    else if host == opponent then
        1

    else
        0


opponentPoints : Goals -> Int
opponentPoints { host, opponent } =
    hostPoints { host = opponent, opponent = host }


joinGoals : Match (Maybe Goals) -> Maybe (Match Goals)
joinGoals mg =
    mg.result
        |> Maybe.map
            (\result ->
                { host = mg.host, opponent = mg.opponent, result = result }
            )



-- |Points to the given team, which might be either side (or neither)


teamPoints : Team -> Match Result -> Float
teamPoints team match =
    case match.result of
        Final goals ->
            if team == match.host then
                goals |> hostPoints |> toFloat

            else if team == match.opponent then
                goals |> opponentPoints |> toFloat

            else
                0

        Projected odds ->
            let
                winFraction =
                    if team == match.host then
                        odds |> oddsFraction .win

                    else if team == match.opponent then
                        odds |> oddsFraction .lose

                    else
                        0

                drawValue =
                    odds |> oddsFraction .draw
            in
            3 * winFraction + drawValue


type alias Day =
    { day : String
    , date : String
    , matches : List (Match (Maybe Goals))
    }


type alias Round =
    { number : Int
    , matches : List Day
    }


type alias Season =
    List Round



-- TODO: validate
-- - sensible round numbers
-- - 10 matches per round
-- - every team plays every round
-- - every team plays every other team once


type Predictor
    = PredictHostWins
    | PredictEvenOdds


applyPredictor : Predictor -> Match (Maybe Goals) -> Match Result
applyPredictor predictor { host, opponent, result } =
    let
        predicted =
            case result of
                Just goals ->
                    Final goals

                Nothing ->
                    case predictor of
                        PredictHostWins ->
                            Projected { win = 1.0, draw = 0.0, lose = 0.0 }

                        PredictEvenOdds ->
                            Projected { win = 0.33, draw = 0.33, lose = 0.33 }
    in
    Match host opponent predicted


flatMatches : Round -> List (Match (Maybe Goals))
flatMatches =
    .matches >> List.concatMap .matches


{-| Number of the round which is probably most interesting to look at: the latest round that has any
matches completed, or the one after (if any), if _all_ matches in that round are completed.
Note: the number is the value stored in the data, not the actual position in the list (which might
be off-by-one, or worse.)
-}
currentRound : Season -> Int
currentRound rounds =
    let
        isPlayed : Match (Maybe Goals) -> Bool
        isPlayed =
            .result >> Maybe.map (always True) >> Maybe.withDefault False

        roundsRev =
            rounds |> List.reverse

        lastRound : Maybe Round
        lastRound =
            roundsRev |> List.head

        lastWithPlayed : Maybe Round
        lastWithPlayed =
            roundsRev
                |> List.filter (flatMatches >> List.any isPlayed)
                |> List.head
    in
    case ( lastWithPlayed, lastRound ) of
        ( Just lwp, _ ) ->
            lwp.number

        ( Nothing, Just l ) ->
            l.number

        ( Nothing, Nothing ) ->
            1


toScores : Predictor -> Season -> Data
toScores predict season =
    let
        teams : List Team
        teams =
            season
                |> List.concatMap .matches
                |> List.concatMap .matches
                |> List.concatMap (\m -> [ m.host, m.opponent ])
                |> uniqBy .name

        -- Find the (single) match of the round involving this team, on either side
        match : Team -> Round -> Maybe (Match (Maybe Goals))
        match team round =
            round
                |> .matches
                |> List.concatMap .matches
                |> List.filterMap
                    (\m ->
                        if m.host == team || m.opponent == team then
                            Just m

                        else
                            Nothing
                    )
                |> List.head

        scores : Team -> Array Score
        scores team =
            season
                |> List.map (match team)
                |> List.foldl
                    (\mm ( prevTotal, res ) ->
                        case mm of
                            Nothing ->
                                -- FIXME: an error state, but this shifts all subsequent matches
                                ( prevTotal, res )

                            Just m ->
                                let
                                    result : Match Result
                                    result =
                                        applyPredictor predict m

                                    pts =
                                        teamPoints team result

                                    total =
                                        prevTotal + pts
                                in
                                ( total, Score result total :: res )
                    )
                    ( 0.0, [] )
                |> Tuple.second
                |> List.reverse
                |> Array.fromList
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
