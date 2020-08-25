## Cloud Native Buildpacks for Spring Boot Demo

### Prepare demo


```
docker pull gcr.io/paketo-buildpacks/builder:base-platform-api-0.3
docker pull gcr.io/paketo-buildpacks/build:base-cnb
docker pull gcr.io/paketo-buildpacks/run:base-cnb
docker pull making/java-native-image-cnb-builder

brew install pv
```

### Run demo

```
./run-demo.sh
```
