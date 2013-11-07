import XMonad
import XMonad.Util.EZConfig(additionalKeys, additionalMouseBindings)
import XMonad.Hooks.DynamicLog
import qualified XMonad.StackSet as W

main = xmonad $ config'

config' = defaultConfig { terminal = terminal'
                        , modMask = modMask'
                        , normalBorderColor = "#222"
                        , focusedBorderColor = "#85C175"
                        } `additionalKeys` keyBindings'
                          `additionalMouseBindings` mouseBindings'

modMask' = mod4Mask
terminal' = "urxvt"

keyBindings' =
    [ ((modMask', xK_v), spawn "/home/gs/bin/paste")
    ]

mouseBindings' =
    [ ((modMask' .|. shiftMask, button1), floatAndResize)
    ]

floatAndResize w = focus w >> mouseResizeWindow w >> windows W.shiftMaster
