module Main exposing (..)

import Html exposing (Attribute, Html, b, div, fieldset, h1, input, label, li, program, strong, text, ul)
import Html.Attributes exposing (checked, class, id, name, placeholder, type_, value)
import Html.Events exposing (onClick, onInput)
import Regex exposing (contains)


---- MODEL ----


type MatchType
    = Partial
    | Foward
    | Backward


type alias Model =
    { words : List String, searchWord : String, matchType : MatchType }


init : ( Model, Cmd Msg )
init =
    ( { words = words, searchWord = "", matchType = Partial }, Cmd.none )



---- UPDATE ----


type Msg
    = Search String
    | ChangeMatchTypeTo MatchType


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ words, searchWord, matchType } as model) =
    case msg of
        Search w ->
            ( { model | searchWord = w }, Cmd.none )

        ChangeMatchTypeTo t ->
            ( { model | matchType = t }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view { words, searchWord, matchType } =
    let
        matchedWords =
            filterList matchType searchWord words

        wordList =
            if List.isEmpty words then
                ul [ class "empty" ] []
            else
                ul [] <| words2li matchedWords searchWord

        matchCount =
            toString <| List.length matchedWords
    in
    div []
        [ h1 [] [ text "Incremental Search" ]
        , input [ placeholder "Search...", onInput Search ] []
        , div []
            [ matchTypeSelector matchType
            , text "match count: "
            , text matchCount
            , wordList
            ]
        ]


filterList : MatchType -> String -> List String -> List String
filterList match containWord =
    case match of
        Partial ->
            List.filter <| String.contains containWord

        Foward ->
            List.filter <| Regex.contains <| Regex.regex ("^" ++ containWord)

        Backward ->
            List.filter <| Regex.contains <| Regex.regex (containWord ++ "$")


words2li : List String -> String -> List (Html Msg)
words2li list searchWord =
    List.map (\word -> li [] <| emphasis word searchWord) list


emphasis : String -> String -> List (Html Msg)
emphasis word searchWord =
    String.split searchWord word
        |> List.map text
        |> List.intersperse (b [] [ text searchWord ])


matchTypeSelector : MatchType -> Html Msg
matchTypeSelector matchType =
    let
        isChecked : MatchType -> Bool
        isChecked t =
            if t == matchType then
                True
            else
                False
    in
    div [ id "match-type-selector" ]
        [ fieldset []
            [ label []
                [ input [ type_ "radio", name "match-type", checked <| isChecked Partial, onClick (ChangeMatchTypeTo Partial) ] []
                , text "Partial Match"
                ]
            , label []
                [ input [ type_ "radio", name "match-type", checked <| isChecked Foward, onClick (ChangeMatchTypeTo Foward) ] []
                , text "Foward Match"
                ]
            , label []
                [ input [ type_ "radio", name "match-type", checked <| isChecked Backward, onClick (ChangeMatchTypeTo Backward) ] []
                , text "Backward Match"
                ]
            ]
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }


{-| Search Words
-}
words : List String
words =
    [ "able", "about", "according to", "account", "acid", "across", "act", "addition", "adjustment", "advertisement", "after", "again", "against", "agreement", "air", "all", "almost", "already", "also", "among", "amount", "amusement", "and", "angle", "angry", "animal", "answer", "ant", "any", "apple", "approval", "arch", "argument", "arm", "army", "around", "art", "as", "at", "attack", "attempt", "attention", "attraction", "authority", "automatic", "awake", "baby", "back", "bad", "bag", "balance", "ball", "band", "base", "basin", "basket", "bath", "be", "beautiful", "because", "bed", "bee", "before", "behaviour", "belief", "bell", "bent", "berry", "between", "bird", "birth", "bit", "bite", "bitter", "black", "blade", "blood", "blow", "blue", "board", "boat", "body", "boiling", "bone", "book", "boot", "bottle", "box", "boy", "brain", "brake", "branch", "breath", "brick", "bridge", "bright", "broken", "brother", "brown", "brush", "bucket", "building", "bulb", "burn", "burst", "business", "but", "button", "by", "cake", "camera", "card", "care", "carriage", "cart", "cat", "cause", "certain", "chain", "chance", "change", "cheap", "cheese", "chemical", "chest", "chief", "chin", "church", "circle", "clean", "clear", "clock", "cloth", "cloud", "coat", "cold", "collar", "color", "comb", "come", "comfort", "committee", "common", "company", "comparison", "competition", "complete", "complex", "condition", "connection", "conscious", "control", "cook", "copper", "copy", "cord", "cotton", "cough", "country", "cover", "cow", "crack", "credit", "crime", "cruel", "crush", "cry", "cultivate", "cup", "current", "curtain", "curve", "cushion", "cut", "damage", "danger", "dark", "data", "daughter", "day", "dead", "dear", "death", "debt", "decision", "deep", "degree", "dependent", "design", "desire", "destruction", "detail", "development", "different", "direction", "dirty", "discovery", "discussion", "disease", "disgust", "distance", "distribution", "division", "do", "dog", "door", "doubt", "down", "drain", "drawer", "dress", "drink", "driving", "drop", "dry", "dust", "ear", "early", "earth", "east", "economic", "edge", "education", "effect", "egg", "elastic", "electric", "end", "engine", "enough", "equal", "error", "even", "event", "ever", "every", "example", "exchange", "existence", "expansion", "experience", "expert", "eye", "face", "fact", "fall", "family", "far", "farm", "fat", "father", "fear", "feather", "feeble", "feeling", "female", "fertile", "fiction", "field", "fight", "financial", "finger", "fire", "first", "fish", "fixed", "flag", "flame", "flat", "flight", "floor", "flower", "fly", "fold", "food", "foolish", "foot", "for", "force", "fork", "form", "forward", "fowl", "frame", "free", "frequent", "friend", "from", "front", "fruit", "full", "future" ] ++ [ "garden", "general", "get", "girl", "give", "glass", "glove", "go", "goat", "gold", "good", "government", "grain", "grass", "gray", "great", "green", "grip", "group", "growth", "guide", "gun", "hair", "hammer", "hand", "hanging", "happy", "harbor", "hard", "harmony", "hat", "hate", "have", "head", "healthy", "hearing", "heart", "heat", "help", "here", "high", "history", "hole", "hollow", "hook", "hope", "horn", "horse", "hospital", "hour", "house", "how", "humor", "ice", "idea", "if", "ill", "important", "impulse", "in", "increase", "industry", "information", "ink", "insect", "instrument", "insurance", "interest", "international", "into", "invention", "iron", "island", "jelly", "jewel", "join", "journey", "judge", "jump", "keep", "kettle", "key", "kick", "kind", "kiss", "knee", "knife", "knot", "knowledge", "land", "language", "last", "late", "laugh", "law", "lead", "leaf", "learning", "left", "leg", "let", "letter", "level", "library", "lift", "light", "like", "limit", "line", "lip", "liquid", "list", "little", "living", "lock", "long", "look", "loose", "loss", "loud", "love", "low", "machine", "make", "male", "man", "manager", "map", "mark", "market", "married", "mass", "match", "material", "may", "meal", "measure", "meat", "medical", "meeting", "memory", "metal", "middle", "military", "milk", "mind", "mine", "minute", "mist", "mixed", "mobile", "money", "monkey", "month", "moon", "morning", "mother", "motion", "mountain", "mouth", "move", "much", "muscle", "music", "nail", "name", "narrow", "nation", "natural", "near", "necessary", "neck", "need", "needle", "nerve", "net", "new", "news", "night", "no", "noise", "normal", "north", "nose", "note", "now", "number", "nuts", "observation", "of", "off", "offer", "office", "oil", "old", "on", "only", "open", "operation", "opinion", "opposite", "or", "orange", "order", "organization", "ornament", "other", "out", "oven", "over", "owner", "page", "pain", "paint", "paper", "parallel", "parcel", "part", "past", "paste", "payment", "peace", "pen", "pencil", "person", "physical", "picture", "pig", "pin", "pipe", "place", "plane", "plant", "plate", "play", "please", "pleasure", "pocket", "point", "poison", "polish", "political", "poor", "porter", "position", "possible", "pot", "potato", "powder", "power", "present", "president", "price", "print", "prison", "private", "probable", "process", "produce", "profit", "property", "prose", "protest", "public", "pull", "pump", "punishment", "purpose", "push", "put", "quality", "question", "quick", "quiet", "quite", "rail", "rain", "range", "rat", "rate", "ray", "reaction", "reading", "ready", "reason", "receipt", "record", "red", "regret", "regular", "relation", "religion", "representative", "request", "respect", "responsible", "rest", "reward", "rhythm", "rice", "right", "ring", "river", "road", "rod", "roll", "roof", "room", "root", "rough", "round", "rub", "rule", "run", "sad", "safe", "sail", "salt", "same", "sand", "say", "scale", "school", "science", "scissors", "screw", "sea", "seat", "second", "secret", "secretary", "see", "seed", "seem", "selection", "self", "send", "sense", "separate", "serious", "servant", "sex", "shade", "shake", "shame", "sharp", "sheep", "shelf", "ship", "shirt", "shock", "shoe", "short", "shut", "side", "sign", "silk", "silver", "simple", "sister", "size", "skin", "skirt", "sky", "sleep", "slip", "slope", "slow", "small", "smash", "smell", "smile", "smoke", "smooth", "snake", "sneeze", "snow", "so", "soap", "social", "society", "sock", "soft", "solid", "some", "son", "song", "sort", "sound", "soup", "south", "space", "spade", "special", "sponge", "spoon", "spring", "square", "stage", "stamp", "star", "start", "statement", "station", "steam", "steel", "stem", "step", "stick", "sticky", "stiff", "still", "stitch", "stocking", "stomach", "stone", "stop", "store", "story", "straight", "strange", "street", "stretch", "strong", "structure", "substance", "such", "sudden", "sugar", "suggestion", "summer", "sun", "support", "surprise", "sweet", "swim", "system", "table", "tail", "take", "talk", "tall", "taste", "tax", "teaching", "tendency", "test", "than", "then", "theory", "there", "thick", "thin", "thing", "though", "thought", "thread", "throat", "through", "thumb", "thunder", "ticket", "tight", "till", "time", "tin", "tired", "to", "together", "tomorrow", "tongue", "tooth", "top", "touch", "town", "trade", "train", "transport", "tray", "tree", "trick", "trouble", "trousers", "turn", "twist", "umbrella", "under", "unit", "up", "use", "value", "verse", "very", "vessel", "view", "violent", "voice", "waiting", "walk", "wall", "war", "warm", "wash", "waste", "watch", "water", "wave", "wax", "way", "weather", "week", "weight", "well", "west", "wet", "wheel", "when", "where", "while", "whip", "whistle", "white", "why", "wide", "will", "wind", "window", "wine", "wing", "winter", "wire", "wise", "with", "woman", "wood", "wool", "word", "work", "world", "worm", "wound", "writing", "wrong", "year", "yellow", "yes", "yesterday", "young" ]
