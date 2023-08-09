package templates

import (
	fluxv1 "github.com/fluxcd/notification-controller/api/v1beta1"
)

#Alert: fluxv1.#Alert & {
	_config:    #Config
	apiVersion: "notification.toolkit.fluxcd.io/v1beta1"
	kind:       "Alert"
	metadata: {
		name:        "slack-\(_config.name)"
		namespace:   _config.metadata.namespace
		labels:      _config.metadata.labels
		if len(_config.annotations) > 0 {
			annotations: _config.annotations
		}	
	}
	spec: {

		eventSeverity: "info"
		providerRef: name: "slack-\(_config.name)"
		eventSources: [
			{
				kind: "GitRepository"
				name: "*"
			},
			{
				kind: "Kustomization"
				name: "*"
			},
			{
				kind: "HelmRelease"
				name: "*"
			},
			{
				kind: "Terraform"
				name: "*"
			},
		]
		if _config.slack.summary != "" {
			summary: _config.slack.summary
		}
	}
}

#Provider: fluxv1.#Provider & {
	_config:    #Config
	apiVersion: "notification.toolkit.fluxcd.io/v1beta1"
	kind:       "Provider"
	metadata: {
		name:        "slack-\(_config.name)"
		namespace:   _config.metadata.namespace
		labels:      _config.labels
		if len(_config.annotations) > 0 {
			annotations: _config.annotations
		}
	}
	spec: {
		type:    "slack"
		channel: _config.slack.channel
		secretRef: name: "slack-\(_config.name)"
	}
}
