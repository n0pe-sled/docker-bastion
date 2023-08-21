Build files for docker containers and Operating Images.   If building for docker run one of the following commands depending on host architecture:

- AMD64: `docker build . -t bastion -f ./x64.Dockerfile`
- ARM8: `docker build . -t bastion -f ./arm8.Dockerfile`

If you are installing on bare metal debian11: `chmod +x ./install.sh && sudo ./install.sh`