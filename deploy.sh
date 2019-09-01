# building the images
docker build -t raghavnayakaasaanjobs/multi-client:latest -t raghavnayakaasaanjobs/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t raghavnayakaasaanjobs/multi-server:latest -t raghavnayakaasaanjobs/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t raghavnayakaasaanjobs/multi-worker:latest -t raghavnayakaasaanjobs/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# we have already logged in to Docker hub through travis. so, no need to login again.
# pushing the images to docker hub
docker push raghavnayakaasaanjobs/multi-client:latest
docker push raghavnayakaasaanjobs/multi-client:$SHA

docker push raghavnayakaasaanjobs/multi-server:latest
docker push raghavnayakaasaanjobs/multi-server:$SHA

docker push raghavnayakaasaanjobs/multi-worker:latest
docker push raghavnayakaasaanjobs/multi-worker:$SHA

# running the kubernetes
kubectl apply -f k8s

# imperatively set latest images on each deployment
# server-deployment -> the name given in k8s/server-deployment.yaml
# server= -> the name of the server container in k8s/server-deployment.yaml
kubectl set image deployments/server-deployment server=raghavnayakaasaanjobs/multi-server:$SHA
kubectl set image deployments/client-deployment client=raghavnayakaasaanjobs/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=raghavnayakaasaanjobs/multi-worker:$SHA

