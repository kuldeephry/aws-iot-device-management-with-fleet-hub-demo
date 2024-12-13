FROM public.ecr.aws/amazonlinux/amazonlinux:2
RUN yum update -y && \
    yum install -y amazon-linux-extras wget ca-certificates
    
RUN update-ca-trust
# List available extras and install Python 3
RUN amazon-linux-extras list
RUN amazon-linux-extras install -y python3

# Upgrade pip with trusted hosts
RUN pip3 install --trusted-host pypi.org --trusted-host files.pythonhosted.org pip --upgrade

# Install Python packages with trusted hosts
RUN pip3 install --trusted-host pypi.org --trusted-host files.pythonhosted.org \
    boto3 \
    aws-iot-device-sdk-python \
    requests \
    cryptography

# Verify installation
RUN pip3 list | grep AWS

ADD . /home
WORKDIR /home
RUN wget -O /tmp/AmazonRootCA1.pem https://www.amazontrust.com/repository/AmazonRootCA1.pem

CMD python3 iot_client.py
