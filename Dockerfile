# The VM used for testing
#########################
FROM ubuntu:latest
RUN apt update && apt install openssh-server sudo -y
# Create a user “dman” and group “sshgroup”
RUN groupadd sshgroup && useradd -ms /bin/bash -g sshgroup dman
# Grant sudo privileges to user
RUN sudo usermod -a -G sudo dman
# Add the user to the NOPASSWD list
RUN echo "dman ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd
# Create dman directory in home
RUN mkdir -p /home/dman/.ssh
# Copy the ssh public key in the authorized_keys file. The key.pub below is a public key file you get from ssh-keygen. They are under ~/.ssh directory by default.
COPY key.pub /home/dman/.ssh/authorized_keys
# change ownership of the key file. 
RUN chown dman:sshgroup /home/dman/.ssh/authorized_keys && chmod 600 /home/dman/.ssh/authorized_keys
# Start SSH service
RUN service ssh start
# Expose docker port 22
EXPOSE 22
EXPOSE 80
EXPOSE 443
CMD ["/usr/sbin/sshd","-D"]