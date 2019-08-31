# building the images
docker build -t raghavn-aasaanjobs/multi-client:latest -t raghavn-aasaanjobs/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t raghavn-aasaanjobs/multi-server:latest -t raghavn-aasaanjobs.multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t raghavn-aasaanjobs/multi-worker:latest -t raghavn-aasaanjobs.multi-worker:$SHA -f ./worker/Dockerfile ./worker

# we have already logged in to Docker hub through travis. so, no need to login again.
# pushing the images to docker hub
docker push raghavn-aasaanjobs/multi-client:latest
docker push raghavn-aasaanjobs/multi-client:$SHA

docker push raghavn-aasaanjobs/multi-server:latest
docker push raghavn-aasaanjobs/multi-server:$SHA

docker push raghavn-aasaanjobs/multi-worker:latest
docker push raghavn-aasaanjobs/multi-worker:$SHA

# running the kubernetes
kutectl apply -f k8s

# imperatively set latest images on each deployment
# server-deployment -> the name given in k8s/server-deployment.yaml
# server= -> the name of the server container in k8s/server-deployment.yaml
kubectl set image deployments/server-deployment server=raghavn-aasaanjobs/multi-server:$SHA
kubectl set image deployments/client-deployment client=raghavn-aasaanjobs/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=raghavn-aasaanjobs/multi-worker:$SHA

