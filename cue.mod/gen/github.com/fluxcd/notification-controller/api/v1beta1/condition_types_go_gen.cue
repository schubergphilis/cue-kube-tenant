// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go github.com/fluxcd/notification-controller/api/v1beta1

package v1beta1

#NotificationFinalizer: "finalizers.fluxcd.io"

// InitializedReason represents the fact that a given resource has been initialized.
#InitializedReason: "Initialized"

// ValidationFailedReason represents the fact that some part of the spec of a given resource
// couldn't be validated.
#ValidationFailedReason: "ValidationFailed"

// TokenNotFound represents the fact that receiver token can't be found.
#TokenNotFoundReason: "TokenNotFound"
