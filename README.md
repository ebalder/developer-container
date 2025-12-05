Containerized claude to let it roam freely

compatible with VS Code SSH remotes

1. set the public key in the build env vars
2. you can use same key to connect to remote session with vscode
3. use gnuscreen to keep long running sessions

`note: SSH Port is hardcoded to 2212`

1. Start a new session: screen -S my_session
2. Detach: Ctrl + A, D
3. Reattach: screen -r my_session

Suggested name: dev
