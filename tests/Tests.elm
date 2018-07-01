module Tests exposing (..)

import Test exposing (..)
import Expect
import Main exposing (..)
import Html exposing (li, text)


-- Check out http://package.elm-lang.org/packages/elm-community/elm-test/latest to learn more about testing in Elm!


all : Test
all =
    describe "A Test Suite"
        [ test "partialMatch empty words" <|
            \_ ->
                let
                    matchedWords =
                        partialMatch [] "ab"
                in
                    Expect.equal [] matchedWords
        , test "partialMatch empty contain word" <|
            \_ ->
                let
                    matchedWords =
                        partialMatch [ "a", "b", "ab", "abc" ] ""
                in
                    Expect.equal [ "a", "b", "ab", "abc" ] matchedWords
        , test "partialMatch" <|
            \_ ->
                let
                    matchedWords =
                        partialMatch [ "a", "b", "ab", "abc" ] "b"
                in
                    Expect.equal [ "b", "ab", "abc" ] matchedWords
        , test "wordToListItem" <|
            \_ ->
                let
                    listItem =
                        wordToListItem "item"
                in
                    Expect.equal (li [] [ text "item" ]) listItem
        ]
