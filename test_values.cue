@if(test)

package main

values: {
	name: "test-tenant"
	metadata: namespace: "test-ns"
	gitopsAgent: "flux"
	role:        "admin"
	git: {
		url:      "ssh://git@testgit.com/test-repo.git"
		branch:   "main"
		path:     "./test"
		interval: "10m"
	}
	slack: {
		enabled: true
		channel: "testing-channel"
		summary: "Test message"
	}
	annotations: {}
}
