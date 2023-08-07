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

## Important Notes

Adjust the script and certificate settings according to your specific requirements.
Use these certificates responsibly and for intended purposes only.
Remember to configure Docker to use the generated certificates for secure connections.

## Contributing
Feel free to contribute to this project by opening issues or pull requests on the [GitHub repository](https://github.com/eness/create-docker-certs/).

## License
This project is licensed under the MIT License.
