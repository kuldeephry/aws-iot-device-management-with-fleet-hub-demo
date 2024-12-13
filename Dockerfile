FROM public.ecr.aws/amazonlinux/amazonlinux:2

# Install required packages
RUN yum update -y && \
    yum install -y amazon-linux-extras wget ca-certificates python3-devel gcc && \
    amazon-linux-extras enable python3.8 && \
    yum clean metadata && \
    yum install -y python38 python38-pip python38-devel

# Update certificates
RUN update-ca-trust force-enable

# Set Python 3.8 as the default python3
RUN alternatives --install python3 /usr/bin/python3.8 && \
    alternatives --install /usr/bin/python python /usr/bin/python3.8 1 && \
    ln -sf /usr/bin/python3.8 /usr/bin/python3

# Configure pip to use trusted hosts globally
RUN touch /etc/pip.conf && \
    echo "[global]" > /etc/pip.conf && \
    echo "trusted-host = \
        pypi.org \
        files.pythonhosted.org \
        pypi.python.org" >> /etc/pip.conf

# Upgrade pip and install packages
RUN python3.8 -m pip install --upgrade pip && \
    python3.8 -m pip install \
        boto3 \
        aws-iot-device-sdk-python \
        requests \
        cryptography

# Verify installations
RUN python3.8 --version && \
    python3.8 -m pip list | grep boto3 && \
    python3.8 -m pip list | grep aws-iot-device-sdk-python

# Verify Python version
RUN python3 --version

ADD . /home
WORKDIR /home
RUN wget -O /tmp/AmazonRootCA1.pem https://www.amazontrust.com/repository/AmazonRootCA1.pem

CMD python3 iot_client.py
