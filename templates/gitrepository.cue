package templates

import (
	fluxv1 "github.com/fluxcd/source-controller/api/v1beta2"
)

#GitRepository: fluxv1.#GitRepository & {
	_config:    #Config
	apiVersion: "source.toolkit.fluxcd.io/v1beta2"
	kind:       "GitRepository"
	metadata: {
		name:      _config.name
		namespace: _config.metadata.namespace
		labels:    _config.metadata.labels
		if len(_config.annotations) > 0 {
			annotations: _config.annotations
		}
	}
	spec: {
		interval: "\(_config.git.interval)m"
		url:      _config.git.url
		ref: branch:     _config.git.branch
		secretRef: name: "git-\(_config.name)"
		timeout: "2m"
	}
}
