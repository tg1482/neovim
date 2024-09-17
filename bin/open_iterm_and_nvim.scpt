on run {directory}
    tell application "iTerm"
        activate
        set newWindow to (create window with default profile)
        tell current session of newWindow
            write text "cd " & quoted form of directory & " && nvim"
        end tell
    end tell
end run
