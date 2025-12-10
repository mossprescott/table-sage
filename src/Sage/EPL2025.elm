module Sage.EPL2025 exposing (..)

import Sage.Football exposing (Day, Round, final, pending)
import Sage.Plot exposing (Team)


ars : Team
ars =
    Team "Arsenal" "#EF0107"


avl : Team
avl =
    -- TODO
    Team "Aston Villa" "#777777"


bou : Team
bou =
    Team "AFC Bournemouth" "#B70E12"


bre : Team
bre =
    Team "Brentford" "#B70E12"


bha : Team
bha =
    Team "Brighton & Hove Albion" "#0057B8"


bur : Team
bur =
    Team "Burnley" "#7A263A"


che : Team
che =
    Team "Chelsea" "#034694"


cry : Team
cry =
    -- TODO
    Team "Crystal Palace" "#FF0000"


eve : Team
eve =
    Team "Everton" "#003399"


ful : Team
ful =
    -- TODO: do something with white
    Team "Fulham" "#CCCCCC"


lee : Team
lee =
    -- TODO: do something with white
    Team "Leeds United" "#CCCCCC"


liv : Team
liv =
    Team "Liverpool" "#C8102E"


mci : Team
mci =
    Team "Manchester City" "#6CABDD"


mun : Team
mun =
    Team "Manchester United" "#DA020E"


new : Team
new =
    -- TODO: and white
    Team "Newcastle United" "#000000"


nfo : Team
nfo =
    Team "Nottingham Forest" "#C8102E"


sun : Team
sun =
    Team "Sunderland" "#FF0000"


tot : Team
tot =
    -- FIXME: white
    Team "Tottenham Hotspur" "#132257"


whu : Team
whu =
    Team "West Ham United" "#7A263A"


wol : Team
wol =
    Team "Wolverhampton Wanderers" "#FDB913"


matches : List Round
matches =
    [ Round 1
        [ Day "Friday"
            "2025-08-15"
            [ final liv 4 2 bou
            ]
        , Day "Saturday"
            "2025-08-16"
            [ final avl 0 0 new
            , final bha 1 1 ful
            , final sun 3 0 whu
            , final tot 3 0 bur
            , final wol 0 4 mci
            ]
        , Day "Sunday"
            "2025-08-17"
            [ final che 0 0 cry
            , final nfo 3 1 bre
            , final mun 0 1 ars
            ]
        , Day "Monday"
            "2025-08-18"
            [ final lee 1 0 eve ]
        ]
    , Round 2
        [ Day "Friday"
            "2025-08-22"
            [ final whu 1 5 che
            ]
        , Day "Saturday"
            "2025-08-23"
            [ final mci 0 2 tot
            , final bou 1 0 wol
            , final bre 1 0 avl
            , final bur 2 0 sun
            , final ars 5 0 lee
            ]
        , Day "Sunday"
            "2025-08-24"
            [ final cry 1 1 nfo
            , final eve 2 0 bha
            , final ful 1 1 mun
            ]
        , Day "Monday"
            "2025-08-25"
            [ final new 2 3 liv ]
        ]
    , Round 3
        [ Day "Saturday"
            "2025-08-30"
            [ final che 2 0 ful
            , final mun 3 2 bur
            , final sun 2 1 bre
            , final tot 0 1 bou
            , final wol 2 3 eve
            , final lee 0 0 new
            ]
        , Day "Sunday"
            "2025-08-30"
            [ final bha 2 1 mci
            , final nfo 0 3 whu
            , final liv 1 0 ars
            , final avl 0 3 cry
            ]
        ]
    , Round 4
        [ Day "Saturday"
            "2025-09-13"
            [ final ars 3 0 nfo
            , final bou 2 1 bha
            , final cry 0 0 sun
            , final eve 0 0 avl
            , final ful 1 0 lee
            , final new 1 0 wol
            , final whu 0 3 tot
            , final bre 2 2 che
            ]
        , Day "Sunday"
            "2025-09-14"
            [ final bur 0 1 liv
            , final mci 3 0 mun
            ]
        ]
    , Round 5
        [ Day "Saturday"
            "2025-09-20"
            [ final liv 2 1 eve
            , final bha 2 2 tot
            , final bur 1 1 nfo
            , final whu 1 2 cry
            , final wol 1 3 lee
            , final mun 2 1 che
            , final ful 3 1 bre
            ]
        , Day "Sunday"
            "2025-09-21"
            [ final bou 0 0 new
            , final sun 1 1 avl
            , final ars 1 1 mci
            ]
        ]
    , Round 6
        [ Day "Saturday"
            "2025-09-27"
            [ final bre 3 1 mun
            , final che 1 3 bha
            , final cry 2 1 liv
            , final lee 2 2 bou
            , final mci 5 1 bur
            , final nfo 0 1 sun
            , final tot 1 1 wol
            ]
        , Day "Sunday"
            "2025-09-28"
            [ final avl 3 1 ful
            , final new 1 2 ars
            ]
        , Day "Monday"
            "2025-09-29"
            [ final eve 1 1 whu
            ]
        ]
    , Round 7
        [ Day "Friday"
            "2025-10-03"
            [ final bou 3 1 ful
            ]
        , Day "Saturday"
            "2025-10-04"
            [ final lee 1 2 tot
            , final ars 2 0 whu
            , final mun 2 0 sun
            , final che 2 1 liv
            ]
        , Day "Sunday"
            "2025-10-05"
            [ final avl 2 1 bur
            , final eve 2 1 cry
            , final new 2 0 nfo
            , final wol 1 1 bha
            , final bre 0 1 mci
            ]
        ]
    , Round 8
        [ Day "Saturday"
            "2025-10-18"
            [ final bha 2 1 new
            , final bur 2 0 lee
            , final cry 3 3 bou
            , final ful 0 1 ars
            , final mci 2 0 eve
            , final che 3 0 nfo
            , final sun 2 0 wol
            ]
        , Day "Sunday"
            "2025-10-19"
            [ final liv 1 2 mun
            , final tot 1 2 avl
            ]
        , Day "Monday"
            "2025-10-20"
            [ final whu 0 2 bre ]
        ]
    , Round 9
        [ Day "Friday"
            "2025-10-24"
            [ final lee 2 1 whu
            ]
        , Day "Saturday"
            "2025-10-25"
            [ final che 1 2 sun
            , final new 2 1 ful
            , final mun 4 2 bha
            , final bre 3 2 liv
            ]
        , Day "Sunday"
            "2025-10-26"
            [ final ars 1 0 cry
            , final avl 1 0 mci
            , final bou 2 0 nfo
            , final eve 0 3 tot
            , final wol 2 3 bur
            ]
        ]
    , Round 10
        [ Day "Saturday"
            "2025-11-01"
            [ final bha 3 0 lee
            , final bur 0 2 ars
            , final cry 2 0 bre
            , final ful 3 0 wol
            , final nfo 2 2 mun
            , final tot 0 1 che
            , final liv 2 0 avl
            ]
        , Day "Sunday"
            "2025-11-02"
            [ final whu 3 1 new
            , final mci 3 1 bou
            ]
        , Day "Monday"
            "2025-11-03"
            [ final sun 1 1 eve ]
        ]
    , Round 11
        [ Day "Saturday"
            "2025-11-08"
            [ final tot 2 2 mun
            , final eve 2 0 ful
            , final whu 3 2 bur
            , final sun 2 2 ars
            , final che 3 0 wol
            , final avl 4 0 bou
            , final bre 3 1 new
            , final cry 0 0 bha
            , final nfo 3 1 lee
            , final mci 3 0 liv
            ]
        ]
    , Round 12
        [ Day "Saturday"
            "2025-11-22"
            [ final bur 0 2 che
            , final bou 2 2 whu
            , final bha 2 1 bre
            , final ful 1 0 sun
            , final liv 0 3 nfo
            , final wol 0 2 cry
            , final new 2 1 mci
            ]
        , Day "Sunday"
            "2025-11-23"
            [ final lee 1 2 avl
            , final ars 4 1 tot
            ]
        , Day "Monday"
            "2025-11-24"
            [ final mun 0 1 eve ]
        ]
    , Round 13
        [ Day "Saturday"
            "2025-11-29"
            [ final bre 3 1 bur
            , final mci 3 2 lee
            , final sun 3 2 bou
            , final eve 1 4 new
            , final tot 1 2 ful
            ]
        , Day "Sunday"
            "2025-11-30"
            [ final cry 1 2 mun
            , final avl 1 0 wol
            , final nfo 0 2 bha
            , final whu 0 2 liv
            , final che 1 1 ars
            ]
        ]
    , Round 14
        [ Day "Tuesday"
            "2025-12-02"
            [ final bou 0 1 eve
            , final ful 4 5 mci
            , final new 2 2 tot
            ]
        , Day "Wednesday"
            "2025-12-03"
            [ final ars 2 0 bre
            , final bha 3 4 avl
            , final bur 0 1 cry
            , final wol 0 1 nfo
            , final lee 3 1 che
            , final liv 1 1 sun
            ]
        , Day "Thursday"
            "2025-12-04"
            [ final mun 1 1 whu ]
        ]
    , Round 15
        [ Day "Saturday"
            "2025-12-06"
            [ final avl 2 1 ars
            , final bou 0 0 che
            , final eve 3 0 nfo
            , final mci 3 0 sun
            , final new 2 1 bur
            , final tot 2 0 bre
            , final lee 3 3 liv
            ]
        , Day "Sunday"
            "2025-12-07"
            [ final bha 1 1 whu
            , final ful 1 2 cry
            ]
        , Day "Monday"
            "2025-12-08"
            [ pending wol mun ]
        ]
    , Round 16
        [ Day "Saturday"
            "2025-12-13"
            [ pending che eve
            , pending liv bha
            , pending bur ful
            , pending ars wol
            ]
        , Day "Sunday"
            "2025-12-14"
            [ pending cry mci
            , pending nfo tot
            , pending sun new
            , pending whu avl
            , pending bre lee
            ]
        , Day "Monday"
            "2025-12-15"
            [ pending mun bou ]
        ]
    ]
