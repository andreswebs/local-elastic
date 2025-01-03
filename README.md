# local-elastic

Modified Elastic stack Docker Compose file to stand up a single node cluster with Fleet Server and APM enabled.

## Usage

I use `direnv` to set up environment variables. To set up the local environment for the first time, run this command and modify the values in the `.envrc` file (or not):

```sh
cp example.envrc .envrc
direnv allow
```

Log in using the `elastic` username and the `ELASTIC_PASSWORD` set up in the `.envrc` file.

## Fix the fleet-server

Manual updates on the `Fleet -> Settings` UI are necessary to fix the fleet-server data collection.

See: <https://www.elastic.co/blog/getting-started-with-the-elastic-stack-and-docker-compose-part-2>

1. Copy the `ca.crt` from the Elasticsearch container (assuming the name is `local-elastic-es-1`) to the local host:

```sh
docker cp local-elastic-es-1:/usr/share/elasticsearch/config/certs/ca/ca.crt /tmp/.
```

2. Save the certificate fingerprint:

```sh
openssl x509 -fingerprint -sha256 -noout -in /tmp/ca.crt | awk -F"=" {' print $2 '} | sed s/://g
```

3. Inspect the certificate:

```sh
cat /tmp/ca.crt
```

4. Save the certificate into the following YAML structure (example):

```yaml
---
ssl:
  certificate_authorities:
    - |
      -----BEGIN CERTIFICATE-----
      .... <cert data>
      -----END CERTIFICATE-----
```

Under `Fleet -> Settings`, in the `Outputs` section, click `Edit` and update the following fields:

- `Hosts`: set this to `https://es:9200`
- `Elasticsearch CA trusted fingerprint`: use value from step 2
- `Advanced YAML configuration`: use value from step 4

## Authors

**Andre Silva** - [@andreswebs](https://github.com/andreswebs)

## License

This project is licensed under the [Unlicense](UNLICENSE.md).

## References

<https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html>

<https://github.com/elastic/elasticsearch/blob/8.17/docs/reference/setup/install/docker/.env>

<https://github.com/elastic/elasticsearch/blob/8.17/docs/reference/setup/install/docker/docker-compose.yml>

<https://karthiksdevopsengineer.medium.com/setting-up-elasticsearch-and-kibana-single-node-with-docker-compose-329776fa3aee>

<https://www.elastic.co/blog/getting-started-with-the-elastic-stack-and-docker-compose>

<https://www.elastic.co/blog/getting-started-with-the-elastic-stack-and-docker-compose-part-2>

<https://github.com/elkninja/elastic-stack-docker-part-two/blob/main/docker-compose.yml>
