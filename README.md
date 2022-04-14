# Dspace7-Kubernetes
![image](https://user-images.githubusercontent.com/30222548/163345210-5184c428-7442-410a-9a96-1ccf466ec250.png)

There are two types of K8s folder, `Local` and `AKS`. `Local` is meant for user to try out using `minikube` while `AKS` is for cloud deployment. Read the PDF to find out more information.

- This Dspace Kubernetes deployment makes use of Managed Postgres to handle the database. Be sure the setup that before starting. 

- This setup also would do volume-claim. (See `assets-pvc.yaml` and `dspace-deployment.yaml` at `assetstore`)

- HTTPS is also used in this setup where we make use of the free service, `lets-encrypt` to serve us certificates. (See `cluster-issuer.yaml` and `dspace-ingress.yaml` )

## Requirements
- Images for `Cli` and `Dspace`
- You would need to copy files from this repository to the main official [Dspace7 repo](https://github.com/DSpace/DSpace)
- You would require the angular ui repo for the front end as well located [here](https://github.com/DSpace/dspace-angular)


## How to configure it for yourself
1. Replace the image to your repository's image in `docker-compose.yml` in the following line

```dockerfile
services:
  # DSpace (backend) webapp container
  dspace:
    container_name: dspace
    # image: "${DOCKER_OWNER:-dspace}/dspace:${DSPACE_VER:-dspace-7_x-test}"
    # image: "alpdspace.azurecr.io/dspace:${DSPACE_VER:-dspace-7_x-test}"
    image: "alpdspace.azurecr.io/dspace:dev-v1"
    build:
      context: .
      dockerfile: Dockerfile.test
```

Here I am configuring the image that is located in my azure image repository.

2. Do the same for `docker-compose.cli` but use the `cli` image instead

```dockerfile
services:
  dspace-cli:
    #image: "${DOCKER_OWNER:-dspace}/dspace-cli:${DSPACE_VER:-dspace-7_x}"
    image: "alpdspace.azurecr.io/dspace-cli:${DSPACE_VER:-dspace-7_x}"
    container_name: dspace-cli
```

3. Copy the solr docker file (solr-dockerfile) into your main repository at `dspace/src/main/docker/solr/Dockerfile`

4. Build the docker images for all components in your main Dspace repository

Replace `alpdspace.azurecr.io` with your image repository name

```shell
# Build dspace image
docker-compose -f docker-compose.yml build

# Build cli image
docker-compose -f docker-compose-cli.yml build

# Build solr image
docker build -t alpdspace.azurecr.io/dspace-solr -f dspace/src/main/docker/solr/Dockerfile .

# Build FE Image
docker build -t alpdspace.azurecr.io/dspace-angular:dev -f .

# Build FE Image using separate dockerfile
docker build -t alpdspace.azurecr.io/dspace-angular:dev-v0.1 -f Dockerfile.dev .

```

6. Push the docker images for all components in 

```shell
# Login to ACR Repository
az acr login --name <REPOSITORY_NAME>

# Push dspace image
docker-compose -f docker-compose.yml push

# Push cli image
docker-compose -f docker-compose-cli.yml push

# Push solr
docker image push alpdspace.azurecr.io/dspace-solr:latest

```

5. Replace the solr image name located in the deployment yamls to the one created in step 4

```
        - image: alpdspace.azurecr.io/dspace-solr:latest
          name: dspace-solr
```

5. Configure your env variables for managed postgres located at `dspace-configmap.yaml`

```
    # db.url = jdbc:postgresql://localhost:5432/dspace
    db.url = jdbc:postgresql://alp-pg-dev.postgres.database.azure.com:5432/dspace
    db.username = <FILL IN USERNAME HERE>
    db.password = <FILL IN PASSWORD HERE>
```

Here our previous postgres was located at localhost. In order to use managed Postgres, we have to change it into our url


6. Configure the location of your REST endpoint in your `dspace-configmap.yaml`

```
dspace.hostname = dspace-demo.southeastasia.cloudapp.azure.com
```

```
  environment.dev.ts: |-
    export const environment = {
      rest: {
        ssl: true,
        host: '{INSERT_HOSTNAME_HERE}',
        port: 80,
        // NOTE: Space is capitalized because 'namespace' is a reserved string in TypeScript
        nameSpace: '/server'
      },
      ui: {
        ssl: false,
        host: '0.0.0.0',
        port: 4000,
        nameSpace: '/'
      }
    };
```

The reason why ui is set at 0.0.0.0 is because we are hosting it on the same "local" host in the container network.

7. Configure our HTTPS

Edit the `dspace-ingress.yaml` files to fit your needs. The following parameters needs to be change

1. hosts: Your hostname
2. secretName: Your secret

Read the PDF under `https` for more information


This repository was a copied from the main repository located at [here](https://github.com/Deunitato/Dspace/commits/SGBLUE-156-Kubernetes)
