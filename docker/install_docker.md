![](images/apnic_logo.png)
#<center><b>Lab 0 - Setup Docker</b></center>


This section, is a step-by-step guide on installing Docker, a powerful platform for building, deploying, and managing containerised applications. 

###**Install docker**

Login to the Lubuntu desktop and use the terminal for the following exercise. 

- Install dependencies that are required for docker.

	```
	sudo apt-get update && sudo apt-get install -y ca-certificates curl gnupg lsb-release
	```

- Add Docker's gpg public key to the trusted store.

	```
	sudo mkdir -p /etc/apt/keyrings && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	```

- Add Docker's repo to the list of sources that Ubuntu can install software from.

	```
	echo \
	"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
	$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	```

- Install Docker.

	```
	sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
	```

- Add the current user to the Docker group.

	```
	sudo groupadd docker 2>/dev/null || true && sudo usermod -aG docker $USER
	```

	>[!Hint] In this command, 2>/dev/null redirects any error output of the groupadd command to /dev/null, effectively hiding it. If the group exists, the error is ignored, and the script continues to add the user to the Docker group.

- Log off and back on or restart to make the new group active or can use **su - apnic**

	```
	su - apnic
	```

- Confirm docker is installed.

	```
	docker compose version
	```

	>[!Knowledge] For more detail refer to [https://docs.docker.com/engine/install/ubuntu/](https://docs.docker.com/engine/install/ubuntu/)

###**Download the Openli docker image**	

- Download the openli lab docker image install script from [https://github.com/wanduow/openli-training-lab.git](https://github.com/wanduow/openli-training-lab.git)

	```
	git clone https://github.com/wanduow/openli-training-lab.git
	```

	>[!Hint] Always review the script before running it [https://github.com/OpenLI-NZ/openli-training-lab/blob/master/setup.sh](https://github.com/OpenLI-NZ/openli-training-lab/blob/master/setup.sh)

- Run the setup script.

	```
	cd openli-training-lab
    ./setup.sh
	```

    This script sets up a Docker-based environment for OpenLI lab. It starts by creating three Docker networks named **openli-lab**, **openli-agency**, and **openli-lab-replay**, each with specific configurations. Then, it stops any running Docker containers that have names starting with openli-. After stopping these containers, the script launches new Docker containers named **openli-agency**, **openli-provisioner**, **openli-mediator**, and **openli-collector** using images from quay.io/openli/training. These containers are then connected to the previously created networks in a specified configuration. 

    The script creates the following lab topology [https://files.openli.nz/tutorial/chapter006.pdf#page=11](https://files.openli.nz/tutorial/chapter006.pdf#page=11)
    !IMAGE[openli lab topology for docker.png](instructions245793/openli lab topology for docker.png)

- Display the openli docker images that were downloaded.

	```
	docker images
	```

- Confirm the openli docker images are running.

	```
	docker ps
	```	

- Confirm the openli docker networks are running.

	```
	docker network ls | grep open
	```

	>[!Hint] For more detail on installation watch the video at: [https://youtu.be/xsra80r1n6c](https://youtu.be/xsra80r1n6c)

To learn more about Docker refer to:

1. **Docker Official Documentation**  
   [Docker Docs](https://docs.docker.com)  
   The official Docker documentation provides comprehensive guides, tutorials, and reference materials for all Docker features and commands.

2. **Docker Get Started Guide**  
   [Docker Get Started](https://www.docker.com/get-started)  
   This guide from Docker's official website is great for beginners, offering a step-by-step introduction to Docker concepts and usage.

3. **Docker Tutorial by Docker Labs**  
   [Docker Labs](https://github.com/docker/labs)  
   Docker Labs offers a variety of tutorials and labs, hosted on GitHub, which are great for practical, hands-on learning of Docker.	


>[!Hint] Ensuring the safety of a Docker image involves several steps and considerations:

1. **Use Official or Verified Images**: Prefer images from Docker's official library or those verified by Docker. These images are typically maintained by the software's developers or Docker, ensuring a certain level of trust and security.

2. **Check the Image's Source**: Always know where your Docker images are coming from. Trusted sources like Docker Hub often have user reviews and ratings that can give you an idea of the image's reliability.

3. **Review the Dockerfile**: If available, inspect the Dockerfile used to build the image. This can give you insights into what the image contains and how it is configured.

4. **Look for Recent Updates**: Regularly updated images are more likely to have current security patches. Check when the image was last updated and whether it is actively maintained.

5. **Scan for Vulnerabilities**: Use tools like Docker's own scanning tool, Trivy, Clair, or others to scan the image for known vulnerabilities.

6. **Understand the Layers**: Docker images are built in layers. Understanding these layers and what each adds to the final image can be crucial in assessing its safety.

7. **Check Image Digests**: Docker images have a digest (a SHA256 hash). Ensure that the digest matches what you expect, especially when pulling images from registries.

8. **Consider Image Size**: Larger images might contain unnecessary software, increasing the attack surface. Leaner images are generally preferable from a security standpoint.

9. **Community and Support**: For open-source images, check the community and support around it. A strong community can be a good indicator of a reliable and safe image.

10. **Be Wary of Outdated Software**: Make sure the software within the Docker image is not outdated or end-of-life, as these can contain unpatched security vulnerabilities.

Remember, while these steps can significantly reduce the risk, no method guarantees 100% safety. It's always a balance between usability, performance, and security.   
