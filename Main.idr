module Main

import Meteor

idris_string : () -> JS_IO String
idris_string _ = do
  putStrLn "returning idris string"
  return "This is a string from Idris"

idris_fn : String -> JS_IO String
idris_fn str = return ("Idris modifying string: "++str)

{-
instance Cast String (Maybe Bool) where
  cast "True" = Just True
  cast "False"= Just False
  cast _ = Nothing

data Operation = NavDown | NavUp

instance Cast String (Maybe Operation) where
  cast "NavDown" = Just NavDown
  cast "NavUp" = Just NavUp
  cast _ = Nothing
-}

main : JS_IO ()
main = do
  Meteor.method "idris_string" idris_string
  Meteor.method "idris_fn" idris_fn
  putStrLn "Idris main method finished!"
