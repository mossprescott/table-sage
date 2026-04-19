module Sage.EPL2025 exposing (..)

import Sage.Football exposing (Day, Round, Season, final, pending)
import Sage.Plot exposing (Team)


ars : Team
ars =
    Team "ARS" "Arsenal" "Arsenal" "#EF0107"


avl : Team
avl =
    -- TODO: color(s)
    Team "AVL" "Aston Villa" "Aston Villa" "#777777"


bou : Team
bou =
    Team "BOU" "Bournemouth" "AFC Bournemouth" "#B70E12"


bre : Team
bre =
    Team "BRE" "Brentford" "Brentford" "#B70E12"


bha : Team
bha =
    Team "BHA" "Brighton" "Brighton & Hove Albion" "#0057B8"


bur : Team
bur =
    Team "BUR" "Burnley" "Burnley" "#7A263A"


che : Team
che =
    Team "CHE" "Chelsea" "Chelsea" "#034694"


cry : Team
cry =
    -- TODO
    Team "CRY" "Crystal Palace" "Crystal Palace" "#FF0000"


eve : Team
eve =
    Team "EVE" "Everton" "Everton" "#003399"


ful : Team
ful =
    -- TODO: do something with white
    Team "FUL" "Fulham" "Fulham" "#CCCCCC"


lee : Team
lee =
    -- TODO: do something with white
    Team "LEE" "Leeds" "Leeds United" "#CCCCCC"


liv : Team
liv =
    Team "LIV" "Liverpool" "Liverpool" "#C8102E"


mci : Team
mci =
    Team "MCI" "Man City" "Manchester City" "#6CABDD"


mun : Team
mun =
    Team "MUN" "Man United" "Manchester United" "#DA020E"


new : Team
new =
    -- TODO: and white
    Team "NEW" "Newcastle" "Newcastle United" "#000000"


nfo : Team
nfo =
    Team "NFO" "Nottm Forest" "Nottingham Forest" "#C8102E"


sun : Team
sun =
    Team "SUN" "Sunderland" "Sunderland" "#FF0000"


tot : Team
tot =
    -- FIXME: white
    Team "TOT" "Tottenham" "Tottenham Hotspur" "#132257"


whu : Team
whu =
    Team "WHU" "West Ham" "West Ham United" "#7A263A"


wol : Team
wol =
    Team "WOL" "Wolves" "Wolverhampton Wanderers" "#FDB913"


matches : Season
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
            [ final wol 1 4 mun ]
        ]
    , Round 16
        [ Day "Saturday"
            "2025-12-13"
            [ final che 2 0 eve
            , final liv 2 0 bha
            , final bur 2 3 ful
            , final ars 2 1 wol
            ]
        , Day "Sunday"
            "2025-12-14"
            [ final cry 0 3 mci
            , final nfo 3 0 tot
            , final sun 1 0 new
            , final whu 2 3 avl
            , final bre 1 1 lee
            ]
        , Day "Monday"
            "2025-12-15"
            [ final mun 4 4 bou ]
        ]
    , Round 17
        [ Day "Saturday"
            "2025-12-20"
            [ final new 2 2 che
            , final bou 1 1 bur
            , final bha 0 0 sun
            , final mci 3 0 whu
            , final wol 0 2 bre
            , final tot 1 2 liv
            , final eve 0 1 ars
            , final lee 4 1 cry
            ]
        , Day "Sunday"
            "2025-12-21"
            [ final avl 2 1 mun
            ]
        , Day "Monday"
            "2025-12-22"
            [ final ful 1 0 nfo ]
        ]
    , Round 18
        [ Day "Friday"
            "2025-12-26"
            [ final mun 1 0 new
            ]
        , Day "Saturday"
            "2025-12-27"
            [ final nfo 1 2 mci
            , final ars 2 1 bha
            , final bre 4 1 bou
            , final bur 0 0 eve
            , final liv 2 1 wol
            , final whu 0 1 ful
            , final che 1 2 avl
            ]
        , Day "Sunday"
            "2025-12-28"
            [ final sun 1 1 lee
            , final cry 0 1 tot
            ]
        ]
    , Round 19
        [ Day "Tuesday"
            "2025-12-30"
            [ final bur 1 3 new
            , final che 2 2 bou
            , final nfo 0 2 eve
            , final whu 2 2 bha
            , final ars 4 1 avl
            , final mun 1 1 wol
            ]
        , Day "Thursday"
            "2026-01-01"
            [ final cry 1 1 ful
            , final liv 0 0 lee
            , final bre 0 0 tot
            , final sun 0 0 mci
            ]
        ]
    , Round 20
        [ Day "Saturday"
            "2026-01-03"
            [ final avl 3 1 nfo
            , final bha 2 0 bur
            , final wol 3 0 whu
            , final bou 2 3 ars
            ]
        , Day "Sunday"
            "2026-01-04"
            [ final lee 1 1 mun
            , final eve 2 4 bre
            , final new 2 0 cry
            , final tot 1 1 sun
            , final ful 2 2 liv
            , final mci 1 1 che
            ]
        ]
    , Round 21
        [ Day "Tuesday"
            "2026-01-06"
            [ final whu 1 2 nfo
            ]
        , Day "Wednesday"
            "2026-01-07"
            [ final bou 3 2 tot
            , final bre 3 0 sun
            , final cry 0 0 avl
            , final eve 1 1 wol
            , final ful 2 1 che
            , final mci 1 1 bha
            , final bur 2 2 mun
            , final new 4 3 lee
            ]
        , Day "Thursday"
            "2026-01-08"
            [ final ars 0 0 liv
            ]
        ]
    , Round 22
        [ Day "Saturday"
            "2026-01-17"
            [ final mun 2 0 mci
            , final che 2 0 bre
            , final lee 1 0 ful
            , final liv 1 1 bur
            , final sun 2 1 cry
            , final tot 1 2 whu
            , final nfo 0 0 ars
            ]
        , Day "Sunday"
            "2026-01-18"
            [ final wol 0 0 new
            , final avl 0 1 eve
            ]
        , Day "Monday"
            "2026-01-19"
            [ final bha 1 1 bou
            ]
        ]
    , Round 23
        [ Day "Saturday"
            "2026-01-24"
            [ final whu 3 1 sun
            , final bur 2 2 tot
            , final ful 2 1 bha
            , final mci 2 0 wol
            , final bou 3 2 liv
            ]
        , Day "Sunday"
            "2026-01-25"
            [ final bre 0 2 nfo
            , final cry 1 3 che
            , final new 0 2 avl
            , final ars 2 3 mun
            ]
        , Day "Monday"
            "2026-01-26"
            [ final lee 1 1 eve
            ]
        ]
    , Round 24
        [ Day "Saturday"
            "2026-01-31"
            [ final bha 1 1 eve
            , final lee 0 4 ars
            , final wol 0 2 bou
            , final che 3 2 whu
            , final liv 4 1 new
            ]
        , Day "Sunday"
            "2026-02-01"
            [ final avl 0 1 bre
            , final mun 3 2 ful
            , final nfo 1 1 cry
            , final tot 2 2 mci
            ]
        , Day "Monday"
            "2026-02-02"
            [ final sun 3 0 bur
            ]
        ]
    , Round 25
        [ Day "Friday"
            "2026-02-06"
            [ final lee 3 1 nfo
            ]
        , Day "Saturday"
            "2026-02-07"
            [ final mun 2 0 tot
            , final bou 1 1 avl
            , final ars 3 0 sun
            , final bur 0 2 whu
            , final ful 1 2 eve
            , final wol 1 3 che
            , final new 2 3 bre
            ]
        , Day "Sunday"
            "2026-02-08"
            [ final bha 0 1 cry
            , final liv 1 2 mci
            ]
        ]
    , Round 26
        [ Day "Tuesday"
            "2026-02-10"
            [ final che 2 2 lee
            , final eve 1 2 bou
            , final tot 1 2 new
            , final whu 1 1 mun
            ]
        , Day "Wednesday"
            "2026-02-11"
            [ final avl 1 0 bha
            , final mci 3 0 ful
            , final nfo 0 0 wol
            , final cry 2 3 bur
            , final sun 0 1 liv
            ]
        , Day "Thursday"
            "2026-02-12"
            [ final bre 1 1 ars
            ]
        ]
    , Round 27
        [ Day "Saturday"
            "2026-02-21"
            [ final avl 1 1 lee
            , final bre 0 2 bha
            , final che 1 1 bur
            , final whu 0 0 bou
            , final mci 2 1 new
            ]
        , Day "Sunday"
            "2026-02-22"
            [ final cry 1 0 wol
            , final nfo 0 1 liv
            , final sun 1 3 ful
            , final tot 1 4 ars
            ]
        , Day "Monday"
            "2026-02-23"
            [ final mun 1 0 eve
            ]
        ]
    , Round 28
        [ Day "Friday"
            "2026-02-27"
            [ final wol 2 0 avl
            ]
        , Day "Saturday"
            "2026-02-28"
            [ final bou 1 1 sun
            , final bur 3 4 bre
            , final liv 5 2 whu
            , final new 2 3 eve
            , final lee 0 1 mci
            ]
        , Day "Sunday"
            "2026-03-01"
            [ final bha 2 1 nfo
            , final ful 2 1 tot
            , final mun 2 1 cry
            , final ars 2 1 che
            ]
        ]
    , Round 29
        [ Day "Tuesday"
            "2026-03-03"
            [ final bou 0 0 bre
            , final eve 2 0 bur
            , final lee 0 1 sun
            , final wol 2 1 liv
            ]
        , Day "Wednesday"
            "2026-03-04"
            [ final avl 1 4 che
            , final bha 0 1 ars
            , final ful 0 1 whu
            , final mci 2 2 nfo
            , final new 2 1 mun
            ]
        , Day "Thursday"
            "2026-03-05"
            [ final tot 1 3 cry
            ]
        ]
    , Round 30
        [ Day "Saturday"
            "2026-03-14"
            [ final bur 0 0 bou
            , final sun 0 1 bha
            , final ars 2 0 eve
            , final che 0 1 new
            , final whu 1 1 mci
            ]
        , Day "Sunday"
            "2026-03-15"
            [ final cry 0 0 lee
            , final mun 3 1 avl
            , final nfo 0 0 ful
            , final liv 1 1 tot
            ]
        , Day "Monday"
            "2026-03-16"
            [ final bre 2 2 wol
            ]
        ]
    , Round 31
        [ Day "Wednesday"
            "2026-02-18"
            [ final wol 2 2 ars
            ]
        , Day "Friday"
            "2026-03-20"
            [ final bou 2 2 mun
            ]
        , Day "Saturday"
            "2026-03-21"
            [ final bha 2 1 liv
            , final ful 3 1 bur
            , final eve 3 0 che
            , final lee 0 0 bre
            ]
        , Day "Sunday"
            "2026-03-22"
            [ final new 1 2 sun
            , final avl 2 0 whu
            , final tot 0 3 nfo
            ]
        ]
    , Round 32
        [ Day "Friday"
            "2026-04-10"
            [ final whu 4 0 wol
            ]
        , Day "Saturday"
            "2026-04-11"
            [ final ars 1 2 bou
            , final bre 2 2 eve
            , final bur 0 2 bha
            , final liv 2 0 ful
            ]
        , Day "Sunday"
            "2026-04-12"
            [ final cry 1 2 new
            , final nfo 1 1 avl
            , final sun 0 1 tot
            , final che 0 3 mci
            ]
        , Day "Monday"
            "2026-04-13"
            [ final mun 1 2 lee
            ]
        ]
    , Round 33
        [ Day "Saturday"
            "2026-04-18"
            [ final bre 0 0 ful
            , final lee 3 0 wol
            , final new 1 2 bou
            , final tot 2 2 bha
            , final che 0 1 mun
            ]
        , Day "Sunday"
            "2026-04-19"
            [ pending avl sun
            , pending nfo bur
            , pending eve liv
            , pending mci ars
            ]
        , Day "Monday"
            "2026-04-20"
            [ pending cry whu
            ]
        ]
    , Round 34
        [ Day "Friday"
            "2026-04-24"
            [ pending sun nfo
            ]
        , Day "Saturday"
            "2026-04-25"
            [ pending ful avl
            , pending bou lee
            , pending liv cry
            , pending whu eve
            , pending wol tot
            , pending ars new
            ]
        , Day "Sunday"
            "2026-04-26"
            [ pending bur mci
            , pending bha che
            ]
        , Day "Monday"
            "2026-04-27"
            [ pending mun bre
            ]
        ]
    , Round 35
        [ Day "Saturday"
            "2026-05-02"
            [ pending bou cry
            , pending ars ful
            , pending avl tot
            , pending bre whu
            , pending che nfo
            , pending eve mci
            , pending lee bur
            , pending mun liv
            , pending new bha
            , pending wol sun
            ]
        ]
    , Round 36
        [ Day "Saturday"
            "2026-05-09"
            [ pending bha wol
            , pending bur avl
            , pending cry eve
            , pending ful bou
            , pending liv che
            , pending mci bre
            , pending nfo new
            , pending sun mun
            , pending tot lee
            , pending whu ars
            ]
        ]
    , Round 37
        [ Day "Sunday"
            "2026-05-17"
            [ pending bou mci
            , pending ars bur
            , pending avl liv
            , pending bre cry
            , pending che tot
            , pending eve sun
            , pending lee bha
            , pending mun nfo
            , pending new whu
            , pending wol ful
            ]
        ]
    , Round 38
        [ Day "Sunday"
            "2026-05-24"
            [ pending bha mun
            , pending bur wol
            , pending cry ars
            , pending ful new
            , pending liv bre
            , pending mci avl
            , pending nfo bou
            , pending sun che
            , pending tot eve
            , pending whu lee
            ]
        ]
    ]
