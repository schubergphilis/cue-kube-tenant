// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go github.com/fluxcd/source-controller/api/v1beta2

package v1beta2

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"github.com/fluxcd/pkg/apis/acl"
	apiv1 "github.com/fluxcd/source-controller/api/v1"
	"github.com/fluxcd/pkg/apis/meta"
)

#HelmChartKind: "HelmChart"

// HelmChartSpec specifies the desired state of a Helm chart.
#HelmChartSpec: {
	// Chart is the name or path the Helm chart is available at in the
	// SourceRef.
	// +required
	chart: string @go(Chart)

	// Version is the chart version semver expression, ignored for charts from
	// GitRepository and Bucket sources. Defaults to latest when omitted.
	// +kubebuilder:default:=*
	// +optional
	version?: string @go(Version)

	// SourceRef is the reference to the Source the chart is available at.
	// +required
	sourceRef: #LocalHelmChartSourceReference @go(SourceRef)

	// Interval is the interval at which to check the Source for updates.
	// +kubebuilder:validation:Type=string
	// +kubebuilder:validation:Pattern="^([0-9]+(\\.[0-9]+)?(ms|s|m|h))+$"
	// +required
	interval: metav1.#Duration @go(Interval)

	// ReconcileStrategy determines what enables the creation of a new artifact.
	// Valid values are ('ChartVersion', 'Revision').
	// See the documentation of the values for an explanation on their behavior.
	// Defaults to ChartVersion when omitted.
	// +kubebuilder:validation:Enum=ChartVersion;Revision
	// +kubebuilder:default:=ChartVersion
	// +optional
	reconcileStrategy?: string @go(ReconcileStrategy)

	// ValuesFiles is an alternative list of values files to use as the chart
	// values (values.yaml is not included by default), expected to be a
	// relative path in the SourceRef.
	// Values files are merged in the order of this list with the last file
	// overriding the first. Ignored when omitted.
	// +optional
	valuesFiles?: [...string] @go(ValuesFiles,[]string)

	// ValuesFile is an alternative values file to use as the default chart
	// values, expected to be a relative path in the SourceRef. Deprecated in
	// favor of ValuesFiles, for backwards compatibility the file specified here
	// is merged before the ValuesFiles items. Ignored when omitted.
	// +optional
	// +deprecated
	valuesFile?: string @go(ValuesFile)

	// Suspend tells the controller to suspend the reconciliation of this
	// source.
	// +optional
	suspend?: bool @go(Suspend)

	// AccessFrom specifies an Access Control List for allowing cross-namespace
	// references to this object.
	// NOTE: Not implemented, provisional as of https://github.com/fluxcd/flux2/pull/2092
	// +optional
	accessFrom?: null | acl.#AccessFrom @go(AccessFrom,*acl.AccessFrom)

	// Verify contains the secret name containing the trusted public keys
	// used to verify the signature and specifies which provider to use to check
	// whether OCI image is authentic.
	// This field is only supported when using HelmRepository source with spec.type 'oci'.
	// Chart dependencies, which are not bundled in the umbrella chart artifact, are not verified.
	// +optional
	verify?: null | #OCIRepositoryVerification @go(Verify,*OCIRepositoryVerification)
}

// ReconcileStrategyChartVersion reconciles when the version of the Helm chart is different.
#ReconcileStrategyChartVersion: "ChartVersion"

// ReconcileStrategyRevision reconciles when the Revision of the source is different.
#ReconcileStrategyRevision: "Revision"

// LocalHelmChartSourceReference contains enough information to let you locate
// the typed referenced object at namespace level.
#LocalHelmChartSourceReference: {
	// APIVersion of the referent.
	// +optional
	apiVersion?: string @go(APIVersion)

	// Kind of the referent, valid values are ('HelmRepository', 'GitRepository',
	// 'Bucket').
	// +kubebuilder:validation:Enum=HelmRepository;GitRepository;Bucket
	// +required
	kind: string @go(Kind)

	// Name of the referent.
	// +required
	name: string @go(Name)
}

// HelmChartStatus records the observed state of the HelmChart.
#HelmChartStatus: {
	// ObservedGeneration is the last observed generation of the HelmChart
	// object.
	// +optional
	observedGeneration?: int64 @go(ObservedGeneration)

	// ObservedSourceArtifactRevision is the last observed Artifact.Revision
	// of the HelmChartSpec.SourceRef.
	// +optional
	observedSourceArtifactRevision?: string @go(ObservedSourceArtifactRevision)

	// ObservedChartName is the last observed chart name as specified by the
	// resolved chart reference.
	// +optional
	observedChartName?: string @go(ObservedChartName)

	// Conditions holds the conditions for the HelmChart.
	// +optional
	conditions?: [...metav1.#Condition] @go(Conditions,[]metav1.Condition)

	// URL is the dynamic fetch link for the latest Artifact.
	// It is provided on a "best effort" basis, and using the precise
	// BucketStatus.Artifact data is recommended.
	// +optional
	url?: string @go(URL)

	// Artifact represents the output of the last successful reconciliation.
	// +optional
	artifact?: null | apiv1.#Artifact @go(Artifact,*apiv1.Artifact)

	meta.#ReconcileRequestStatus
}

// ChartPullSucceededReason signals that the pull of the Helm chart
// succeeded.
#ChartPullSucceededReason: "ChartPullSucceeded"

// ChartPackageSucceededReason signals that the package of the Helm
// chart succeeded.
#ChartPackageSucceededReason: "ChartPackageSucceeded"

// HelmChart is the Schema for the helmcharts API.
#HelmChart: {
	metav1.#TypeMeta
	metadata?: metav1.#ObjectMeta @go(ObjectMeta)
	spec?:     #HelmChartSpec     @go(Spec)

	// +kubebuilder:default={"observedGeneration":-1}
	status?: #HelmChartStatus @go(Status)
}

// HelmChartList contains a list of HelmChart objects.
// +kubebuilder:object:root=true
#HelmChartList: {
	metav1.#TypeMeta
	metadata?: metav1.#ListMeta @go(ListMeta)
	items: [...#HelmChart] @go(Items,[]HelmChart)
}
