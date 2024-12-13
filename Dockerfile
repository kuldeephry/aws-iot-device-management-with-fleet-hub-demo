FROM public.ecr.aws/amazonlinux/amazonlinux:latest

RUN dnf install -y \
    wget \
    python3-pip \
    python3-virtualenv

# Create and activate a virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Now upgrade pip inside the virtual environment
RUN pip install --upgrade pip
RUN pip3 install boto3 AWSIoTPythonSDK requests cryptography
ADD . /home
WORKDIR /home
RUN wget -O /tmp/AmazonRootCA1.pem https://www.amazontrust.com/repository/AmazonRootCA1.pem

CMD python3 iot_client.py
