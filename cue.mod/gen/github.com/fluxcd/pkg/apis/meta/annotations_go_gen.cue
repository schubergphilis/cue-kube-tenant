// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go github.com/fluxcd/pkg/apis/meta

package meta

// ReconcileRequestAnnotation is the annotation used for triggering a reconciliation
// outside of a defined schedule. The value is interpreted as a token, and any change
// in value SHOULD trigger a reconciliation.
#ReconcileRequestAnnotation: "reconcile.fluxcd.io/requestedAt"

// ReconcileRequestStatus is a struct to embed in a status type, so that all types using the mechanism have the same
// field. Use it like this:
//
//		type FooStatus struct {
//	 	meta.ReconcileRequestStatus `json:",inline"`
//	 	// other status fields...
//		}
#ReconcileRequestStatus: {
	// LastHandledReconcileAt holds the value of the most recent
	// reconcile request value, so a change of the annotation value
	// can be detected.
	// +optional
	lastHandledReconcileAt?: string @go(LastHandledReconcileAt)
}

// StatusWithHandledReconcileRequest describes a status type which holds the value of the most recent
// ReconcileAnnotationValue.
// +k8s:deepcopy-gen=false
#StatusWithHandledReconcileRequest: _

// StatusWithHandledReconcileRequestSetter describes a status with a setter for the most ReconcileAnnotationValue.
// +k8s:deepcopy-gen=false
#StatusWithHandledReconcileRequestSetter: _
