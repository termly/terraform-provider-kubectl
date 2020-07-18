provider "kubectl" {
  apply_retry_count = 5
}


resource "kubectl_manifest" "test" {
  depends_on = ["kubectl_manifest.definecrd"]
  yaml_body = <<YAML
apiVersion: "stable.example.com/v1" 
kind: CronTab 
metadata:
  name: name-here-crd
spec: 
  cronSpec: "* * * * /5"
  image: my-awesome-cron-image 
YAML
}

resource "kubectl_manifest" "definecrd" {
    yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: name-here-crontabs.stable.example.com 
spec:
  group: stable.example.com
  conversion:
    strategy: None
  scope: Namespaced 
  names:
    plural: name-here-crontabs
    singular: crontab 
    kind: CronTab 
    shortNames:
    - ct
  version: v1
  versions:
  - name: v1
    served: true
    storage: true
    schema:
      openAPIV3Schema:
        type: object
        properties:
          spec:
            type: object
            properties:
              cronSpec:
                type: string
              image:
                type: string
              replicas:
                type: integer
YAML
}