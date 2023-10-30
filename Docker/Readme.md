# Docker

## build

```bash
cd /path/to/Docker
docker build --network=host -t doop:4.24.11-pure .  --no-cache
```

## container
```bash
docker container create --name doop_container -v /root/Project/SoftwareAnalysis:/data  -t doop:4.24.11-pure
docker start doop_container
docker exec -it doop_container /bin/bash
```