Containerized claude to let it roam freely

compatible with VS Code SSH remotes

- set the public key in the container (in coolify, it's in the env vars folder)
- restart
- you can use same key to connect to remote session with vscode
- use gnuscreen to keep long running sessions

1. Start a new session: screen -S my_session
2. Detach from the session: Ctrl + A, D
3. Reattach to the session: screen -r my_session

Suggested name: dev
