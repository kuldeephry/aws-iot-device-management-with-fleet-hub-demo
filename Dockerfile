FROM public.ecr.aws/amazonlinux/amazonlinux:2
RUN yum update -y && \
    yum install -y amazon-linux-extras wget python3 python3-pip ca-certificates
RUN update-ca-trust
RUN amazon-linux-extras enable python3.8
RUN yum install -y python3.8

# Upgrade pip with trusted hosts
RUN python3.8 -m pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org pip --upgrade

# Install Python packages with trusted hosts
RUN python3.8 -m pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org \
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
