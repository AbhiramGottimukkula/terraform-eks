#!/bin/bash

apt-get update

#Installing kubectl

curl -o kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/bin/linux/amd64/kubectl
curl -o kubectl.md5 https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/bin/linux/amd64/kubectl.md5
chmod +x ./kubectl
cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
kubectl version --short --client

#Installing heptio-authenticator-aws

curl -o heptio-authenticator-aws https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/bin/linux/amd64/heptio-authenticator-aws
curl -o heptio-authenticator-aws.md5 https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/bin/linux/amd64/heptio-authenticator-aws.md5
chmod +x ./heptio-authenticator-aws
cp ./heptio-authenticator-aws $HOME/bin/heptio-authenticator-aws && export PATH=$HOME/bin:$PATH
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
heptio-authenticator-aws help

#Installing aws-iam-authenticator

curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/linux/amd64/aws-iam-authenticator
chmod +x ./aws-iam-authenticator
cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator
aws-iam-authenticator help

#Installing aws-cli

apt-get install -y python-pip python-dev build-essential 
pip install awscli --upgrade --user
echo 'export PATH=~/.local/bin:$PATH' >> ~/.bashrc

mkdir -p ~/.kube
touch private-eks-master
echo "${kubectl_config}" > ~/.kube/private-eks-master
echo 'export KUBECONFIG=$KUBECONFIG:~/.kube/private-eks-master' >> ~/.bashrc
echo "${aws_auth}" > ~/.kube/aws-auth.yaml
#cd ~/.kube/
#kubectl apply -f aws-auth.yaml
