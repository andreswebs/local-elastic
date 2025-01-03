# local-elastic

Modified the official Elastic stack Docker Compose file to stand up a single node cluster.

## Usage

I use `direnv` to set up environment variables. To set up the local environment for the first time, run this command and modify the values in the `.envrc` file (or not):

```sh
cp example.envrc .envrc
direnv allow
```

Log in using the `elastic` username and the `ELASTIC_PASSWORD` set up in the `.envrc` file.

## Authors

**Andre Silva** - [@andreswebs](https://github.com/andreswebs)

## License

This project is licensed under the [Unlicense](UNLICENSE.md).

## References

<https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html>

<https://github.com/elastic/elasticsearch/blob/8.17/docs/reference/setup/install/docker/.env>

<https://github.com/elastic/elasticsearch/blob/8.17/docs/reference/setup/install/docker/docker-compose.yml>

<https://karthiksdevopsengineer.medium.com/setting-up-elasticsearch-and-kibana-single-node-with-docker-compose-329776fa3aee>
