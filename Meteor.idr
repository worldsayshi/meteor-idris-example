module Meteor


%inline
method : {inTy : Type} -> {outTy : Type}
  -> String -> (inTy -> JS_IO outTy)
  -> {auto fty : FTy FFI_JS [] 
    (String -> JsFn (inTy->outTy) -> JS_IO ())
  } -> JS_IO ()
method {inTy = inTy} {outTy = outTy} name fn =
  foreign FFI_JS """function () {
    var m_name = %0;
    var callbacks = {};
    callbacks[m_name] = %1;
    Meteor.methods(callbacks);
  }()"""
  (String -> JsFn (inTy->outTy) -> JS_IO ())
  name
  (MkJsFn (unsafePerformIO . fn))
