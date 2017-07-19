# drone-codecov
[![Build Status](https://travis-ci.org/robertstettner/drone-codecov.svg?branch=master)](https://travis-ci.org/robertstettner/drone-codecov)

Drone plugin for pushing test coverage to Codecov


This plugin allows for pushing test coverage results to Codecov.

## Configuration

The following parameters are used to configure the plugin:

- `token`: set the private repository token. Required.
- `files`: list of target files to upload. Optional.
- `flags`: flag the upload to group coverage metrics. Optional.
- `debug`: debug mode, defaults to `false`.

### Drone configuration examples

Simple example:
```yaml
pipeline:
  build:
    image: node:6
    commands:
      - npm install
      - npm test

  codecov:
    image: robertstettner/drone-codecov
    token: ${CODECOV_TOKEN}
```

Unit and component test example:

```yaml
pipeline:
  build:
    image: node:6
    commands:
      - npm install
      - npm test

  unit_codecov:
    image: robertstettner/drone-codecov
    token: ${CODECOV_TOKEN}
+   files: 
+     - app1/coverage/unit/lcov.info
+     - app2/coverage/unit/lcov.info
+   flags:
+     - unit
      
  component_codecov:
    image: robertstettner/drone-codecov
    token: ${CODECOV_TOKEN}
+   files: 
+     - app1/coverage/component/lcov.info
+     - app2/coverage/component/lcov.info
+   flags:
+     - component
```
