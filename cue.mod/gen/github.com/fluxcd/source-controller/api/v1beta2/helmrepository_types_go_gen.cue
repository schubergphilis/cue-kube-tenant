// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go github.com/fluxcd/source-controller/api/v1beta2

package v1beta2

import (
	"github.com/fluxcd/pkg/apis/meta"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"github.com/fluxcd/pkg/apis/acl"
	apiv1 "github.com/fluxcd/source-controller/api/v1"
)

// HelmRepositoryKind is the string representation of a HelmRepository.
#HelmRepositoryKind: "HelmRepository"

// HelmRepositoryURLIndexKey is the key used for indexing HelmRepository
// objects by their HelmRepositorySpec.URL.
#HelmRepositoryURLIndexKey: ".metadata.helmRepositoryURL"

// HelmRepositoryTypeDefault is the default HelmRepository type.
// It is used when no type is specified and corresponds to a Helm repository.
#HelmRepositoryTypeDefault: "default"

// HelmRepositoryTypeOCI is the type for an OCI repository.
#HelmRepositoryTypeOCI: "oci"

// HelmRepositorySpec specifies the required configuration to produce an
// Artifact for a Helm repository index YAML.
#HelmRepositorySpec: {
	// URL of the Helm repository, a valid URL contains at least a protocol and
	// host.
	// +required
	url: string @go(URL)

	// SecretRef specifies the Secret containing authentication credentials
	// for the HelmRepository.
	// For HTTP/S basic auth the secret must contain 'username' and 'password'
	// fields.
	// For TLS the secret must contain a 'certFile' and 'keyFile', and/or
	// 'caFile' fields.
	// +optional
	secretRef?: null | meta.#LocalObjectReference @go(SecretRef,*meta.LocalObjectReference)

	// PassCredentials allows the credentials from the SecretRef to be passed
	// on to a host that does not match the host as defined in URL.
	// This may be required if the host of the advertised chart URLs in the
	// index differ from the defined URL.
	// Enabling this should be done with caution, as it can potentially result
	// in credentials getting stolen in a MITM-attack.
	// +optional
	passCredentials?: bool @go(PassCredentials)

	// Interval at which to check the URL for updates.
	// +kubebuilder:validation:Type=string
	// +kubebuilder:validation:Pattern="^([0-9]+(\\.[0-9]+)?(ms|s|m|h))+$"
	// +required
	interval: metav1.#Duration @go(Interval)

	// Timeout is used for the index fetch operation for an HTTPS helm repository,
	// and for remote OCI Repository operations like pulling for an OCI helm repository.
	// Its default value is 60s.
	// +kubebuilder:default:="60s"
	// +kubebuilder:validation:Type=string
	// +kubebuilder:validation:Pattern="^([0-9]+(\\.[0-9]+)?(ms|s|m))+$"
	// +optional
	timeout?: null | metav1.#Duration @go(Timeout,*metav1.Duration)

	// Suspend tells the controller to suspend the reconciliation of this
	// HelmRepository.
	// +optional
	suspend?: bool @go(Suspend)

	// AccessFrom specifies an Access Control List for allowing cross-namespace
	// references to this object.
	// NOTE: Not implemented, provisional as of https://github.com/fluxcd/flux2/pull/2092
	// +optional
	accessFrom?: null | acl.#AccessFrom @go(AccessFrom,*acl.AccessFrom)

	// Type of the HelmRepository.
	// When this field is set to  "oci", the URL field value must be prefixed with "oci://".
	// +kubebuilder:validation:Enum=default;oci
	// +optional
	type?: string @go(Type)

	// Provider used for authentication, can be 'aws', 'azure', 'gcp' or 'generic'.
	// This field is optional, and only taken into account if the .spec.type field is set to 'oci'.
	// When not specified, defaults to 'generic'.
	// +kubebuilder:validation:Enum=generic;aws;azure;gcp
	// +kubebuilder:default:=generic
	// +optional
	provider?: string @go(Provider)
}

// HelmRepositoryStatus records the observed state of the HelmRepository.
#HelmRepositoryStatus: {
	// ObservedGeneration is the last observed generation of the HelmRepository
	// object.
	// +optional
	observedGeneration?: int64 @go(ObservedGeneration)

	// Conditions holds the conditions for the HelmRepository.
	// +optional
	conditions?: [...metav1.#Condition] @go(Conditions,[]metav1.Condition)

	// URL is the dynamic fetch link for the latest Artifact.
	// It is provided on a "best effort" basis, and using the precise
	// HelmRepositoryStatus.Artifact data is recommended.
	// +optional
	url?: string @go(URL)

	// Artifact represents the last successful HelmRepository reconciliation.
	// +optional
	artifact?: null | apiv1.#Artifact @go(Artifact,*apiv1.Artifact)

	meta.#ReconcileRequestStatus
}

// IndexationFailedReason signals that the HelmRepository index fetch
// failed.
#IndexationFailedReason: "IndexationFailed"

// HelmRepository is the Schema for the helmrepositories API.
#HelmRepository: {
	metav1.#TypeMeta
	metadata?: metav1.#ObjectMeta  @go(ObjectMeta)
	spec?:     #HelmRepositorySpec @go(Spec)

	// +kubebuilder:default={"observedGeneration":-1}
	status?: #HelmRepositoryStatus @go(Status)
}

// HelmRepositoryList contains a list of HelmRepository objects.
// +kubebuilder:object:root=true
#HelmRepositoryList: {
	metav1.#TypeMeta
	metadata?: metav1.#ListMeta @go(ListMeta)
	items: [...#HelmRepository] @go(Items,[]HelmRepository)
}
