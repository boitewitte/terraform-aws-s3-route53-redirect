# terraform-aws-s3-route53-redirect

## Inputs

| Name         | Description                                                                               | Type                                                        | Default       | Required |
| ------------ | ----------------------------------------------------------------------------------------- | ----------------------------------------------------------- | ------------- | -------- |
| attributes   | Additional attributes (e.g. `1`)                                                          | list(string)                                                | `<list>`      | no       |
| context      | Default context to use for passing state between label invocations                        | object                                                      | `<map>`       | no       |
| delimiter    | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes` | string                                                      | `-`           | no       |
| environment  | Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'                             | string                                                      | ``            | no       |
| name         | Solution name, e.g. 'app' or 'jenkins'                                                    | string                                                      | ``            | no       |
| namespace    | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'       | string                                                      | ``            | no       |
| stage        | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'   | string                                                      | ``            | no       |
| tags         | Additional tags (e.g. `map('BusinessUnit','XYZ')`                                         | map(string)                                                 | `<map>`       | no       |
| create_zones | Create the Route53 zones                                                                  | `bool`                                                      | `true`        | no       |
| route53      | The Route53 Records & Zones to create                                                     | `list(object({ zone = string, subdomains = list(string)}))` | `-`           | yes      |
| bucket_acl   | The Canned ACL for the Bucket                                                             | `string`                                                    | `public-read` | no       |
| protocol     | The Target protocol to redirect to                                                        | `null`                                                      | no            |
| target       | The Target hostname or bucket name to redirect to                                         | `string`                                                    | yes           |

## Outputs

| Name    | Description                                |
| ------- | ------------------------------------------ |
| zones   | List of the Zones that are created or used |
| records | List of the Records that are created       |
| bucket  | The created bucket that will redirect      |
