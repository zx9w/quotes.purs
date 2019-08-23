module Main where

import Prelude

import Data.Nullable (Nullable)
import Data.Array (head)
import Data.Either (Either(..))
import Data.List.NonEmpty (NonEmptyList)
import Effect (Effect)
import Effect.Console (log)
import Foreign (ForeignError)
import Node.Encoding (Encoding(UTF8))
import Node.FS.Sync (readTextFile)
import Simple.JSON (readJSON)

{-- import Halogen as H --}
import Halogen.HTML as HH
{-- import Halogen.HTML.Properties as HP --}

type Quote =
  { author :: String
  , translator :: Nullable String
  , work :: String
  , passage :: Nullable String
  , lines :: Array (Array String)
  }

parseQuotes :: String -> Either (NonEmptyList ForeignError) (Array Quote)
parseQuotes = readJSON

renderQuote :: Quote -> HH.PlainHTML
renderQuote quote =
  HH.blockquote
    []
    [ HH.footer [] [renderAuthors quote]
    ]
    where renderAuthors q = HH.text $ q.author

main :: Effect Unit
main = do
  quotes <- readTextFile UTF8 "quotes.json"
  case parseQuotes quotes of
    Right qs ->
      log $ show (head qs)
    Left e ->
      log $ show e
