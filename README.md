# Jamulus 🎶
[Docker](https://hub.docker.com/repository/docker/grundic/jamulus) configuration for [Jamulus](https://github.com/corrados/jamulus) music server.

The Jamulus software enables musicians to perform real-time jam sessions over the internet. There is one server running the Jamulus server software which collects the audio data from each Jamulus client, mixes the audio data and sends the mix back to each client.

# Usage

Here are some example snippets to help you get started creating a container.

## docker

```bash
docker run \
  -e TZ=America/Los_Angeles
  --name jamulus \
  -d --rm \
  -p 22124:22124/udp \
  -v $(pwd)/jam:/jam \
  grundic/jamulus \
  -n -s -p 22124 -l /jam/jamulus.log -w "Wellcome to Jamulus docker server."
```

## docker-compose

```yaml
---
version: "3.7"
services:
  jamulus:
    container_name: jamulus 
    image: grundic/jamulus
    restart: always
    ports:
      - "22124:22124/udp"
    environment:
      TZ: "America/Los_Angeles"  
    entrypoint:
      - "Jamulus"
      - "--server"
      - "--nogui"
      - "--welcomemessage"
      - "Welcome to the Jamulus rehearsal room"
      - "--numchannels"
      - "16"
```

You can monitor output with `docker logs -f jamulus`

| ⚠️ To improve performance, please consider using docker's [realtime scheduler](https://docs.docker.com/config/containers/resource_constraints/#configure-the-realtime-scheduler) |
| --- |

# Parameters

|Parameter   |Description   |
|---|---|
|-a, --servername   |server name, required for HTML status   |
|-e, --centralserver   |address of the central server   |
|-g, --pingservers   |ping servers in list to keep NAT port open   |
|-l, --log   |enable logging, set file name   |
|-L, --licence   |a licence must be accepted on a new connection   |
|-m, --htmlstatus   |enable HTML status file, set file name   |
|-n, --nogui   |disable GUI   |
|-o, --serverinfo   |infos of the server(s) in the format:<br>`[name];[city];[country as QLocale ID]; ...`<br>`[server1 address];[server1 name]; ...`<br>`[server1 city]; ...`<br>`[server1 country as QLocale ID]; ...`<br>`[server2 address]; ... `   |
|-p, --port   |local port number   |
|-s, --server   |start server   |
|-u, --numchannels   |maximum number of channels   |
|-w, --welcomemessage   |welcome message on connect   |
|-y, --history   |enable connection history and set file name   |
|-z, --startminimized   |start minimizied   |
