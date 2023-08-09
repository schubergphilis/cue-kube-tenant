@if(test)

package main

values: {
	name:       "test-tenant"
	metadata: namespace: "test-ns"
	gitopAgent: "argocd"
	role:       "admin"
	git: {
		url:      "ssh://git@testgit.com/test-repo.git"
		branch:   "main"
		path:     "./test"
		interval: 10
	}
	slack: {
		enabled: true
		channel: "testing-channel"
		summary: "Test message"
	}
	annotations: {}
}
