module Main

runIt : (()->JS_IO ()) -> JS_IO ()
runIt f =
  foreign FFI_JS "console.log(%0)"
    (JsFn (()->()) -> JS_IO ()) (MkJsFn (unsafePerformIO . f))

runIt2 : (()->JS_IO ()) -> JS_IO ()
runIt2 f =
  let name = "test2"
  in foreign FFI_JS ("console.log({"++name++":%0})")
    (JsFn (()->()) -> JS_IO ()) (MkJsFn (unsafePerformIO . f))

runIt3 : String -> (()->JS_IO ()) -> JS_IO ()
runIt3 name f =
  foreign FFI_JS ("console.log({"++name++":%0})")
    (JsFn (()->()) -> JS_IO ()) (MkJsFn (unsafePerformIO . f))

doEffect : ()->JS_IO ()
doEffect _ = putStrLn "callback called"

main : JS_IO ()
main = do
  putStrLn "first test - should work"
  runIt doEffect
  putStrLn "second test - should work"
  runIt2 doEffect
  putStrLn "third test - doesn't work?"
  runIt3 "test3" doEffect
