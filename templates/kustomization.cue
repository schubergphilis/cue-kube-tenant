package templates

import (
	fluxv1 "github.com/fluxcd/kustomize-controller/api/v1beta2"
)

#Kustomization: fluxv1.#Kustomization & {
	_config:    #Config
	apiVersion: "kustomize.toolkit.fluxcd.io/v1beta2"
	kind:       "Kustomization"
	metadata: {
		name:        _config.name
		namespace:   _config.metadata.namespace
		labels:      _config.metadata.labels
		if len(_config.annotations) > 0 {
			annotations: _config.annotations
		}
	}
	spec: {
		if _config.role != "cluster-admin" {
			targetNamespace: _config.metadata.namespace
		}
		serviceAccountName: "flux-\(_config.name)"
		sourceRef: {
			kind: "GitRepository"
			name: _config.name
		}
		path:     _config.git.path
		prune:    true
		timeout:  "1m"
		interval: "10m"
	}
}
