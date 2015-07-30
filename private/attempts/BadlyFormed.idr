module Main

{-
Possible bug: IRTS.Compiler.doForeign might handle overloading in the wrong way

The type checker does not complain about the overloading of method2 in the lower
definition. But the code generator does and fails because of it with incomprehensible
error message "Badly formed foreign function call"

In retrospect I don't really expect the latter to be valid but the error message 
should be more informative. It took me a while to figure this one out 
(I've rewritten my code to make it more apparent)
-}


%inline
method : {inTy : Type} -> {outTy : Type}
  -> String -> (inTy -> JS_IO outTy)
  -> {auto fty : FTy FFI_JS []
    (String -> JsFn (inTy->outTy) -> JS_IO ())
  } -> JS_IO ()
method {inTy = inTy} {outTy = outTy} name fn =
  foreign FFI_JS """function () {
    window[%0] = %1;
  }()"""
  (String -> JsFn (inTy->outTy) -> JS_IO ())
  name
  (MkJsFn (unsafePerformIO . fn))


-- Below doesn't work

%inline
method2 : {inTy : Type} -> {outTy : Type}
  -> String -> (inTy -> JS_IO outTy)
  -> {auto fty : FTy FFI_JS []
    (String -> JsFn (inTy->outTy) -> JS_IO ())
  } -> JS_IO ()
method2 {inTy = inTy} {outTy = outTy} name method2 =
  foreign FFI_JS """function () {
    var m_name = %0;
    var callbacks = {};
    callbacks[m_name] = %1;
    Meteor.methods(callbacks);
  }()"""
  (String -> JsFn (inTy->outTy) -> JS_IO ())
  name
  (MkJsFn (unsafePerformIO . method2))


doEffect : ()->JS_IO String
doEffect _ = do
  putStrLn "callback called"
  return "retstring"


main : JS_IO ()
main = do
  method "doeffect" doEffect
  method2 "doeffect" doEffect
