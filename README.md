
# Switch cluster

gcloud config set container/cluster solberg-cluster
gcloud container clusters get-credentials solberg-cluster


gcloud config set container/cluster solberg-cluster2
gcloud container clusters get-credentials solberg-cluster2

# Building docker

    
    ./build.sh
    docker build -t andreassolberg/smedstua .
    docker run -d -p 80:80 --env-file=./ENV -t gcr.io/solberg-cluster/smedstua:latest
    docker run -p 80:80 --env-file=./ENV -t gcr.io/solberg-cluster/smedstua:latest
    docker ps


# Secrets


    /etc/smedstua/sql


# Deploying to Google Cloud Engine

    # kubectl create -f secrets.yaml
    # kubectl create -f pod.json

    kubectl create -f secrets.yaml
    kubectl create -f rc.json
    # kubectl expose rc smedstua --type="LoadBalancer" --port 80
    kubectl create -f service.json

    export CLUSTER_NAME=solberg-cluster2
    export ZONE=europe-west1-b
    export NODE_PORT=$(kubectl get -o jsonpath="{.spec.ports[0].nodePort}" services smedstua-service)
    export TAG=$(basename `gcloud container clusters describe ${CLUSTER_NAME} --zone ${ZONE} | grep gke | awk '{print $2}'` | sed -e s/group/node/)
    gcloud compute firewall-rules create allow-130-211-0-0-22-http-ingress-smedstua --source-ranges 130.211.0.0/22 --target-tags $TAG --allow tcp:$NODE_PORT

-----

    docker build -t gcr.io/solberg-cluster/smedstua .
    gcloud docker push gcr.io/solberg-cluster/smedstua

    kubectl create -f ingress.json

    kubectl get ingress --watch


    kubectl rolling-update smedstuarc-v7 --image=gcr.io/solberg-cluster/smedstua:latest
    kubectl rolling-update smedstuarc-v7 -f smedstua/rc.json

Debug:

    gcloud container clusters list
    gcloud container clusters describe smedstua-cluster
    kubectl get pods
    kubectl describe pods
    kubectl get services
    kubectl describe services
    kubectl get rc
    kubectl describe rc


------

I container:

    "livenessProbe": {
        "initialDelaySeconds": 15,
        "httpGet": {
            "path": "/health",
            "port": 80
        }
    },

# References:

* https://github.com/docker-library/docs/tree/master/wordpress
* https://github.com/eugeneware/docker-wordpress-nginx


## Docker commands




    docker exec -i -t 678f15fd76e9362 bash

    export TAG=`docker ps | grep smedstua | cut -c136-200`
    docker exec -i -t $TAG bash

    



    alias dr="docker ps | grep smedstua | cut -c136-200 | xargs docker stop && docker build -t andreassolberg/smedstua . && docker run -p 80:80 --env-file=./ENV -t andreassolberg/smedstua"


    alias dstop="docker ps | grep tcp| cut -c1-20 | xargs docker stop "
    alias dbash="docker ps | grep tcp| cut -c1-20 | xargs -J % docker exec -i -t % bash"

# Deploying smedstua.com at heroku

# Set initial configuration


# Update composer

    composer update --ignore-platform-reqs
    git add composer.lock
    git commit -m 'Rebuild composer.lock'
    git push heroku master


# Migrate database







# CMD

    alias hb="composer update --ignore-platform-reqs && git add composer.json composer.lock"
    alias hp="git push heroku master"



# Plugins


To be verified and installed. (if needed)


    "wpackagist-plugin/fourteen-extended-master": "*",


# Disabled plugins


    "wpackagist-plugin/wp-retina-2x": "~3.5",

    "wpackagist-plugin/memcached-cloud": "~1.0",

    ,
        "wpackagist-plugin/memcachier": "1.0.1"



NEXT:

w3 total cache: DISK


---

enable cahce = true

For å få denne til å fungere så må vi kjøre:

        "wpackagist-plugin/memcachier": "1.0.1"

cp wordpress/wp-content/plugins/memcachier/object-cache.php wordpress/wp-content/object-cache.php


+

BATCACHE:

cp wordpress/wp-content/plugins/batcache/advanced-cache.php wordpress/wp-content/advanced-cache.php