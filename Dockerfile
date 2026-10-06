FROM node:20-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        openssh-client \
        login \
        python3 \
        make \
        g++ \
        git \
        tmux \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

ENV PYTHON=/usr/bin/python3
ENV SHELL=/bin/bash

RUN npm install -g cline wetty@3

# tmux persistence: Cline runs inside a tmux session so it survives
# browser disconnects and is re-attached automatically on reconnect.
COPY tmux.conf /root/.tmux.conf
COPY tmux-attach.sh /usr/local/bin/tmux-attach.sh
# Strip CRLF (Windows checkouts) so the shebang works inside the container
RUN sed -i 's/\r$//' /usr/local/bin/tmux-attach.sh /root/.tmux.conf \
    && chmod +x /usr/local/bin/tmux-attach.sh

EXPOSE 3000

CMD ["wetty", \
     "--host", "0.0.0.0", \
     "--port", "3000", \
     "--command", "/usr/local/bin/tmux-attach.sh"]
