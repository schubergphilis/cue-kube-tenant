package templates

import (
	"strings"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// Config defines the schema and defaults for the Instance values.
#Config: {
	name: *"tenant-name" | string
	// Metadata (common to all resources)
	metadata: metav1.#ObjectMeta
	metadata: name:      *"tenant" | string & =~"^(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$" & strings.MaxRunes(63)
	metadata: namespace: *"default" | string & strings.MaxRunes(63)
	//	metadata: labels:    *selectorLabels | {[ string]: string}
	metadata: labels: "app.kubernetes.io/tenant": metadata.name
	annotations: *{} | {[string]: string}
	gitopsAgent: *"" | string
	role:        *"namespace-admin" | string
	slack: {
		enabled:    *false | bool
		channel:    *"" | string
		secretName: *"" | string
		summary:    *"" | string
	}
	git: {
		url:      *"" | string
		branch:   *"" | string
		path:     *"" | string
		interval: *"5m" | string
		timeout:  *"1m" | string
		prune:    *true | bool
	}
}

// Instance takes the config values and outputs the Kubernetes objects.
#Instance: {
	config: #Config

	objects: {
		"\(config.metadata.name)-ns": #Namespace & {_config:      config}
		"\(config.metadata.name)-sa": #ServiceAccount & {_config: config}

		if config.role != "admin" {
			"\(config.metadata.name)-cluster-role": #ClusterRoleBinding & {_config: config}
		} // else
		{
			"\(config.metadata.name)-role": #RoleBinding & {_config: config}
		}

		if config.gitopsAgent == "flux" {
			"\(config.metadata.name)-repo": #GitRepository & {_config: config}
			"\(config.metadata.name)-ks":   #Kustomization & {_config: config}
			if config.slack.enabled {
				"\(config.metadata.name)-alert":    #Alert & {_config:    config}
				"\(config.metadata.name)-provider": #Provider & {_config: config}
			}
		}
	}
}
