FROM public.ecr.aws/amazonlinux/amazonlinux:2

# Install required packages and update certificates
RUN yum update -y && \
    yum install -y amazon-linux-extras wget ca-certificates python3-devel gcc && \
    yum install -y python3-pip && \
    update-ca-trust force-enable

# Configure pip to use trusted hosts globally
RUN touch -p /etc/pip.conf && \
    echo "[global]" > /etc/pip.conf && \
    echo "trusted-host = \
        pypi.org \
        files.pythonhosted.org \
        pypi.python.org" >> /etc/pip.conf

# Install Python packages
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install \
        boto3 \
        aws-iot-device-sdk-python \
        requests \
        cryptography

# Verify installations
RUN python3 -m pip list | grep boto3 && \
    python3 -m pip list | grep aws-iot-device-sdk-python

# Optional: Set Python 3 as default (if needed)
RUN alternatives --install /usr/bin/python python /usr/bin/python3 1

# Verify Python version
RUN python3 --version

ADD . /home
WORKDIR /home
RUN wget -O /tmp/AmazonRootCA1.pem https://www.amazontrust.com/repository/AmazonRootCA1.pem

CMD python3 iot_client.py
