# Use the Jenkins inbound-agent image as a base
FROM jenkins/inbound-agent:latest

# Switch to root user to install software
USER root

# Install Ansible
RUN apt-get update && \
    apt-get install -y ansible && \
    rm -rf /var/lib/apt/lists/*

# Switch back to the default jenkins user
USER jenkins