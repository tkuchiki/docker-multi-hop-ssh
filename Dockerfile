FROM alpine:latest

RUN apk add --update --no-cache openssh sudo && rm -rf /var/cache/apk/*
# setup sshd
RUN mkdir -p /var/run/sshd
# setup user
RUN adduser -s /bin/sh -D alice && chmod 700 /home/alice && mkdir -m 700 -p /home/alice/.ssh && chown alice:alice /home/alice/.ssh \
    && echo "alice ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && echo "root:root" | chpasswd && echo "alice:alice" | chpasswd    
ADD ssh/* /home/alice/.ssh/
RUN chown alice:alice /home/alice/.ssh/* && cp -a /home/alice/.ssh/id_rsa.pub /home/alice/.ssh/authorized_keys \
    && chmod 600 /home/alice/.ssh/id_rsa /home/alice/.ssh/authorized_keys
RUN adduser -s /bin/sh -D bob && chmod 700 /home/bob && mkdir -m 700 -p /home/bob/.ssh && chown bob:bob /home/bob/.ssh \
    && echo "bob ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && echo "root:root" | chpasswd && echo "bob:bob" | chpasswd    
ADD ssh/* /home/bob/.ssh/
RUN chown bob:bob /home/bob/.ssh/* && cp -a /home/bob/.ssh/id_rsa.pub /home/bob/.ssh/authorized_keys \
    && chmod 600 /home/bob/.ssh/id_rsa /home/bob/.ssh/authorized_keys


ADD docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
EXPOSE 22

ENTRYPOINT ["sh", "/usr/local/bin/docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]
