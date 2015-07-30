module Main

import Meteor

printIt : String -> JS_IO ()
printIt s = foreign FFI_JS "console.log(%0)" (String -> JS_IO ()) s


idris_string : () -> JS_IO String
idris_string _ = do
  putStrLn "returning idris string"
  return "This is a string from Idris"

instance Cast String (Maybe Bool) where
  cast "True" = Just True
  cast "False"= Just False
  cast _ = Nothing

data Operation = NavDown | NavUp

instance Cast String (Maybe Operation) where
  cast "NavDown" = Just NavDown
  cast "NavUp" = Just NavUp
  cast _ = Nothing


main : JS_IO ()
main = do
  Meteor.method "idris_string" idris_string
  putStrLn "Idris main method finished!"
