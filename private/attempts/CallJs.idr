module Main

-- import IdrisScript
-- import IdrisScript.Timer

retString : () -> String
retString _ = "Doing stuff!"

retString' : () -> JS_IO String
retString' _ = return "Doing stuff!"


printIt : String -> JS_IO ()
printIt s = foreign FFI_JS "console.log(%0)" (String -> JS_IO ()) s

printIt2 : (()->String) -> JS_IO ()
printIt2 s = foreign FFI_JS "console.log(%0)" (JsFn (()->String) -> JS_IO ()) (MkJsFn s)

retIt : (()->String) -> JS_IO String
retIt s = foreign FFI_JS "%0()" (JsFn (()->String) -> JS_IO String) (MkJsFn s)

runIt : (()->JS_IO ()) -> JS_IO ()
runIt f =
  foreign FFI_JS "console.log(%0)" (JsFn (()->()) -> JS_IO ()) (MkJsFn (unsafePerformIO . f))

runIt' : (()->JS_IO String) -> JS_IO String
runIt' f =
  foreign FFI_JS "%0(null)" (JsFn (()->JS_IO String) -> JS_IO String) (MkJsFn f)

-- %inline
foocall : (fname : String) -> (ty : Type) ->
  {auto fty : FTy FFI_JS [] (ty -> JS_IO ())} -> ty -> JS_IO ()
foocall fname ty = foreign FFI_JS fname (ty -> JS_IO ())

%inline
runIt3 : (ty : Type) ->
         {auto fty : FTy FFI_JS [] (JsFn (ty -> ()) -> JS_IO ())} -> (ty->JS_IO ()) -> JS_IO ()
runIt3 ty f =
  foreign FFI_JS "%0(null)"
    (JsFn (ty->()) -> JS_IO ())
    (MkJsFn (unsafePerformIO . f))

doEffect : ()->JS_IO ()
doEffect _ = putStrLn "callback called"

main : JS_IO ()
main = do
  runIt3 () doEffect
