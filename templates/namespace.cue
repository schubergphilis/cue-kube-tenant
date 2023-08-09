package templates

import (
	corev1 "k8s.io/api/core/v1"
)

#Namespace: corev1.#Namespace & {
	_config:    #Config
	apiVersion: "v1"
	kind:       "Namespace"
	metadata: {
		name:   _config.name
		labels: _config.metadata.labels
		if len(_config.annotations) > 0 {
			annotations: _config.annotations
		}
	}
}
