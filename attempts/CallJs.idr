module Main

import IdrisScript
import IdrisScript.Timer

retString : () -> String
retString _ = "Doing stuff!"

printIt : String -> JS_IO ()
printIt s = foreign FFI_JS "console.log(%0)" (String -> JS_IO ()) s

printIt2 : (()->String) -> JS_IO ()
printIt2 s = foreign FFI_JS "console.log(%0)" (JsFn (()->String) -> JS_IO ()) (MkJsFn s)

retIt : (()->String) -> JS_IO String
retIt s = foreign FFI_JS "%0()" (JsFn (()->String) -> JS_IO String) (MkJsFn s)

main : JS_IO ()
main = do
  s <- retIt retString -- "foo"
  printIt s
