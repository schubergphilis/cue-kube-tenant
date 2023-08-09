# Tenant

Module used to quickly generate K8s Tenants using [CUE](https://cuelang.org/) and [Timoni](https://timoni.sh/).

## Values

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | `string` | n/a | yes |
| annotations | Annotations to be added to the K8s objects | `{[string]: string}` | `{}` | yes |
| role | Currently only admin and namespace-admin are supported | `string` | `namespace-admin` | no |
| gitopsAgent | Create objects for gitops agent, currently only fluxV2(GitSource + Kustomization) is supported. | `string` | `""` | no<br>Supported: [flux](https://fluxcd.io/) |
| git | Needs to be configured with gitopsAgent | `{[string]: string}`| <pre>git: {<br>url: ""<br> branch: ""<br>path: ""<br>interval: "5m"<br>timeout: "1m"<br>prune: true<br>}</pre> | Only with gitopsAgent<br> For flux see [here](https://fluxcd.io/flux/components/kustomize/kustomization/) and [here](https://fluxcd.io/flux/components/source/gitrepositories/#working-with-gitrepositories) |
| slack |  Needs to be configured with gitopsAgent |`{[string]: string}` | <pre>slack: {<br>enabled: false<br>channel: ""<br>secretName: ""<br>summary: ""<br>}</pre> | Only with gitopsAgent<br>For Flux [see](https://fluxcd.io/flux/guides/notifications/) |
| metadata: labels | Overwrite labels | `"app.kubernetes.io/tenant": metadata.name` | `{} ` | no |


## Example usage

```cue
// tenants.cue
_module: {
	url:     "oci://ghcr.io/schubergphilis/cue-modules/tenant"
	version: "0.0.1"
}

_common_values: { // set common_values
    gitopsAgent: "flux"
	git: {
		url:      "ssh://git@testgit.com/test-repo.git"
		branch:   "main"
		interval: "5m"
	}
}

bundle: {
	apiVersion: "v1alpha1"
	name:       "tenants"
	instances: { // each instances can present a tenant
		frontend: {
			module: _module
			namespace: "frontend"
            values: _common_values
			values: role: "admin"
			values: name: "frontend-team"
            values: git: path: "./frontend"
		},
		backend: {
			module: _module
			namespace: "backend"
            values: _common_values // reuse common values
			values: {
			  name: "backend-team"
			  role: "cluster-admin"
              git: path: "./backend"
			}
		}
	}
}
```
