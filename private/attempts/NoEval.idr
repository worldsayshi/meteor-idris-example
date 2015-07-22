module Main

printIt : String -> JS_IO ()
printIt s =
  foreign FFI_JS "console.log(%0)"
    (String -> JS_IO ()) s

printIt2 : String -> JS_IO ()
printIt2 s =
  let name = "test2"
  in foreign FFI_JS ("console.log({"++name++":%0})")
    (String -> JS_IO ()) s

printIt3 : String -> String -> JS_IO ()
printIt3 name s =
  foreign FFI_JS ("console.log({"++name++":%0})")
    (String -> JS_IO ()) s

-- Essentially the same as above, just to rule out let syntax
printIt4 : String -> String -> JS_IO ()
printIt4 name s =
  let notUsed = "bar"
  in foreign FFI_JS ("console.log({"++name++":%0})")
    (String -> JS_IO ()) s

printIt5 : String -> String -> JS_IO ()
printIt5 name s =
  foreign FFI_JS "function (){var obj = {};obj[%0]=%1;console.log(obj);}()"
    (String -> String -> JS_IO ()) name s


-- %inline
jscall : (fname : String) -> (ty : Type) ->
  {auto fty : FTy FFI_JS [] ty} -> ty
jscall fname ty = foreign FFI_JS fname ty

-- %inline
foocall : (fname : String) -> (ty : Type) ->
          {auto fty : FTy FFI_JS [] (ty -> JS_IO ())} -> ty -> JS_IO ()
foocall fname ty = foreign FFI_JS fname (ty -> JS_IO ())

{-
printIt6 : (name : String) -> (ty : Type) -> {auto fty : FTy FFI_JS [] ty} 
           -> ty -> JS_IO ()
printIt6 name ty s =
  foreign FFI_JS "function (){var obj = {};obj[%0]=%1;console.log(obj);}()"
    (String -> ty -> JS_IO ()) name s
-}
main : JS_IO ()
main = do
  putStrLn "first test - works"
  printIt "foo"
  putStrLn "second test - works"
  printIt2 "foo"
  putStrLn "third test - doesn't work?"
  printIt3 "test3" "foo"
  putStrLn "fourth test - doesn't work?"
  printIt4 "test4" "foo"
  putStrLn "fifth test"
  printIt5 "test5" "foo"
  putStrLn "sixth test"
  jscall "console.log(%0)" (String -> JS_IO ()) "test6"
  --printIt6 "test6" (String) "foo"
  foocall "console.log(%0)" (String) "test7"
