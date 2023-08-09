package templates

import (
	rbacv1 "k8s.io/api/rbac/v1"
)

// This binding grants full access to all objects within the specified namespace.
// With this role, a tenant can't install a Kubernetes CRD controller, but it can use
// any namespaced custom resource if its definition exists.
// Access is denied to any global objects like crds, cluster roles bindings, namespaces, etc.
// To grant the namespace admin role, set 'tenant.spec.role: "namespace-admin"' (default value).
#RoleBinding: rbacv1.#RoleBinding & {
	_config:    #Config
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "RoleBinding"
	metadata: {
		name:        "rb-\(_config.name)"
		namespace:   _config.metadata.namespace
		labels:      _config.metadata.labels
		if len(_config.annotations) > 0 {
			annotations: _config.annotations
		}	
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "cluster-admin"
	}
	subjects: [
		{
			kind: "ServiceAccount"
			name: "\(_config.metadata.namespace):\(_config.name)"
			namespace: _config.metadata.namespace
		},
		{
			kind:      "ServiceAccount"
			name:      "flux-\(_config.name)"
			namespace: _config.metadata.namespace
		},
	]
}

// This binding grants full access to all objects in the cluster
// including non-namespaced objects like crds, namespaces, etc.
// To grant the cluster admin role, set 'tenant.spec.role: "cluster-admin"'.
#ClusterRoleBinding: rbacv1.#ClusterRoleBinding & {
	_config:    #Config
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: {
		name:        "crb-\(_config.name)"
		labels:      _config.metadata.labels
		if len(_config.annotations) > 0 {
			annotations: _config.annotations
		}	
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "cluster-admin"
	}
	subjects: [
		{
			kind:      "ServiceAccount"
			name:      "sa-\(_config.name)"
			namespace: _config.metadata.namespace
		},
	]
}
