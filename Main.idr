module Main

printIt : String -> JS_IO ()
printIt s = foreign FFI_JS "console.log(%0)" (String -> JS_IO ()) s

runIt : (()->JS_IO ()) -> JS_IO ()
runIt f =
  foreign FFI_JS ("console.log({"++name++":%0})")
     (JsFn (()->()) -> JS_IO ()) (MkJsFn (unsafePerformIO . f))


meteor_method : String -> (() -> JS_IO ()) -> JS_IO ()
meteor_method name method =
  foreign FFI_JS ("console.log({"++name++":%0})")
    (JsFn (()->()) -> JS_IO ()) (MkJsFn (unsafePerformIO . method))

test_method : () -> JS_IO ()
test_method _ = putStrLn "test_method called!"

test_method2 : () -> JS_IO ()
test_method2 _ = putStrLn "test_method2 called!"


main : JS_IO ()
main = do
  printIt "Idris main method"
  runIt test_method2
  meteor_method "test_method" test_method
  putStrLn "Idris main method finished!"
