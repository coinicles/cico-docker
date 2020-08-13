# Quickstart

## Get docker image

You might take either way:

### Pull a image from Public Docker hub

```
$ docker pull cicox/cico
```

### Or, build cico image with provided Dockerfile

```
$docker build --rm -t cicox/cico .
```

For historical versions, please visit [docker hub](https://hub.docker.com/r/cicox/cico/)

## Prepare data path and cico.conf

In order to use user-defined config file, as well as save block chain data, -v option for docker is recommended.

First chose a path to save cico block chain data:

```
sudo rm -rf /data/cico-data
sudo mkdir -p /data/cico-data
sudo chmod a+w /data/cico-data
```

Create your config file, Note rpcuser and rpcpassword to required for later `cico-cli` usage for docker, so it is better to set those two options. Then please create the file ${PWD}/cico.conf with content:

```
rpcuser=cico
rpcpassword=cicotest

# This will allow you to RPC from your localhost outside the container
rpcallowip=0.0.0.0/0
rpcbind=0.0.0.0
```
## Launch cicod

To launch cico node:

```
## to launch cicod
$ docker run -d --rm --name cico_node \
             -v ${PWD}/cico.conf:/root/.cico/cico.conf \
             -v /data/cico-data/:/root/.cico/ \
             cicox/cico cicod

## check docker processed
$ docker ps

## to stop cicod
$ docker run -i --network container:cico_node \
             -v ${PWD}/cico.conf:/root/.cico/cico.conf \
             -v /data/cico-data/:/root/.cico/ \
             -p 127.0.0.1:38890:38890 \
             cicox/cico cico-cli stop
```

`${PWD}/cico.conf` will be used, and blockchain data saved under /data/cico-data/

## Interact with `cicod` using `cico-cli`

Use following docker command to interact with your cico node with `cico-cli`:

```
$ docker run -i --network container:cico_node \
             -v ${PWD}/cico.conf:/root/.cico/cico.conf \
             -v /data/cico-data/:/root/.cico/ \
             cicox/cico cico-cli getblockchaininfo
```

For more cico-cli commands, use:

```
$ docker run -i --network container:cico_node \
             -v ${PWD}/cico.conf:/root/.cico/cico.conf \
             -v /data/cico-data/:/root/.cico/ \
             cicox/cico cico-cli help
```

## RPC from outside container

While the cico node container is running, you can do RPC outside the container on your localhost like this:

```
curl -i --user cico:cicotest --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getblockchaininfo", "params": [] }' -H 'content-type: text/plain;' http://127.0.0.1:38890/
```

