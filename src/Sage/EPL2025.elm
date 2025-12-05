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
    ]
