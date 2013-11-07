import XMonad
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Paste(pasteSelection)

main = do
    xmonad $ defaultConfig
      { terminal = myTerminal
      , modMask = myModMask
      , normalBorderColor = myNormalBorderColor
      , focusedBorderColor = myFocusedBorderColor
      } `additionalKeys` [
        ((myModMask, xK_v), pasteSelection)
      ]

myModMask = mod4Mask
myNormalBorderColor = "#4C5442"
myFocusedBorderColor = "#85C175"
myTerminal = "urxvt"
