# Docker Certificate Generator

This script generates Certificate Authority (CA), server, and client keys using OpenSSL for securing Docker connections.

Author: [Enes Sönmez](https://github.com/eness)

## Usage

1. Make sure you have OpenSSL installed on your system.

2. Clone or download this repository to your local machine:

   ```bash
   git clone https://github.com/eness/create-docker-certs.git
   ```

3. Navigate to the cloned repository:

   ```bash
   cd create-docker-certs
   ```

4. Open the generate_certs.sh script in a text editor.

5. Replace the `HOST="your_hostname_here"` value with your actual Docker host's hostname.

6. Save the script and give it executable permissions:

   ```bash
   chmod +x create-docker-certs.sh
   ```

7. The generated keys and certificates will be stored in the `./docker-certificates` folder.

8. After you have created certificates, now you need to set docker daemon to require certs on start

   ```bash
   sudo nano /lib/systemd/system/docker.service
   ```

   find lines similar to this :
   ```bash
   [Service]
   Type=notify
   # the default is not to use systemd for cgroups because the delegate issues still
   # exists and systemd currently does not support the cgroup feature set required
   # for containers run by docker
   ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
   ```

   modify it as below, so it would look like :

   ```bash
   [Service]
   Type=notify
   # the default is not to use systemd for cgroups because the delegate issues still
   # exists and systemd currently does not support the cgroup feature set required
   # for containers run by docker
   ExecStart=
   ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2375 --tlsverify --tlscacert=/path/to/certs/ca.pem --tlscert=/path/to/certs/server-cert.pem --tlskey=/path/to/certs/server-key.pem
   ```

   then, restart docker daemon :
   
   ```bash
   sudo service docker restart
   ```

9. If you want to connect your docker host using PhpStorm, you should copy `ca.pem`, `cert.pem` and `key.pem` files to your local computer, into a folder and create a connection to your instance as shown in the picture.

   

## Important Notes

Adjust the script and certificate settings according to your specific requirements.
Use these certificates responsibly and for intended purposes only.
Remember to configure Docker to use the generated certificates for secure connections.

## Contributing
Feel free to contribute to this project by opening issues or pull requests on the [GitHub repository](https://github.com/eness/create-docker-certs/).

## License
This project is licensed under the MIT License.
