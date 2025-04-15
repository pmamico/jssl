Output jssl.gif

Require echo

Set Shell "bash"
Set FontSize 12
Set Width 800
Set Height 400
Set Theme "Builtin Tango Dark"

Hide
Type 'echo "FAIL" > "$HOME/.state"'
Enter
Type clear
Enter
Show


Type "jssl install howsmyssl.com" Sleep 500ms  Enter
Sleep 1s

Type "jssl ping howsmyssl.com"  Sleep 200ms  Enter
Sleep 2s
Enter

Type "# or fix a failing maven build"  Sleep 300ms  Enter
Type "mvn clean install"  Sleep 500ms  Enter

Sleep 3s
Enter
Type "mvn clean install | jssl doctor"  Sleep 1s  Enter
Sleep 2s
Enter
Type "mvn clean install"  Sleep 500ms  Enter

Sleep 5s

