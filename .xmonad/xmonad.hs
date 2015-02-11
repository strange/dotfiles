import XMonad
import XMonad.Util.EZConfig(additionalKeys, additionalMouseBindings)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import qualified XMonad.StackSet as W
import XMonad.Util.Run(spawnPipe)
import XMonad.Hooks.ManageDocks

main = do
    xmproc <- spawnPipe "pkill dzen2 ; conky | dzen2 -ta r"
    xmonad $ ewmh config'

config' = defaultConfig { terminal = terminal'
                        , modMask = modMask'
                        , normalBorderColor = "#222"
                        , focusedBorderColor = "#FF0000"
                        , manageHook = manageHook'
                        , layoutHook = avoidStruts $ layoutHook defaultConfig
                        } `additionalKeys` keyBindings'
                          `additionalMouseBindings` mouseBindings'

modMask' = mod4Mask
terminal' = "xterm"

manageHook' = composeAll [ isFullscreen --> doFullFloat
                         ]

keyBindings' =
    [ ((modMask', xK_v), paste)
    , ((modMask', xK_Left), sendMessage Shrink)
    , ((modMask', xK_Right), sendMessage Expand)
    , ((0, xK_Menu), spawn "dmenu_run")
    ]

mouseBindings' =
    [ ((modMask' .|. shiftMask, button1), floatAndResize)
    ]

floatAndResize w = focus w >> mouseResizeWindow w >> windows W.shiftMaster
paste = spawn "xvkbd -xsendevent -text '\\[Shift_L]\\[Insert]'"
-- paste = spawn "xdotool key --clearmodifiers Shift+Insert"
