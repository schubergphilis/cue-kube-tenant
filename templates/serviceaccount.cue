package templates

import (
	corev1 "k8s.io/api/core/v1"
)

#ServiceAccount: corev1.#ServiceAccount & {
	_config:    #Config
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		name:        "\(_config.name)-sa"
		namespace:   _config.metadata.namespace
		labels:      _config.metadata.labels
		if len(_config.annotations) > 0 {
			annotations: _config.annotations
		}	
	}
}
