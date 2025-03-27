```shell
docker buildx build \
  --platform linux/amd64 \
  --tag pre-commit:latest \
  .
```

```shell
docker container run \
  --interactive \
  --mount "type=bind,source=$(pwd),target=/home/jenkins/workspace" \
  --platform linux/amd64 \
  --rm \
  --tty \
  pre-commit:latest \
  pre-commit run --all-files --show-diff-on-failure
```
