// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go github.com/weaveworks/tf-controller/api/v1alpha2

package v1alpha2

import (
	apiextensionsv1 "k8s.io/apiextensions-apiserver/pkg/apis/apiextensions/v1"
	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"github.com/fluxcd/pkg/apis/meta"
)

#CACertSecretName: "tf-controller.tls"

// RunnerTLSSecretName is the name of the secret containing a TLS cert that will be written to
// the namespace in which a terraform runner is created
#RunnerTLSSecretName:     "terraform-runner.tls"
#RunnerLabel:             "infra.contrib.fluxcd.io/terraform"
#GitRepositoryIndexKey:   ".metadata.gitRepository"
#BucketIndexKey:          ".metadata.bucket"
#OCIRepositoryIndexKey:   ".metadata.ociRepository"
#BreakTheGlassAnnotation: "break-the-glass.tf-controller/requestedAt"

#ReadInputsFromSecretSpec: {
	// +required
	name: string @go(Name)

	// +required
	as: string @go(As)
}

// WriteOutputsToSecretSpec defines where to store outputs, and which outputs to be stored.
#WriteOutputsToSecretSpec: {
	// Name is the name of the Secret to be written
	// +required
	name: string @go(Name)

	// Labels to add to the outputted secret
	// +optional
	labels?: {[string]: string} @go(Labels,map[string]string)

	// Annotations to add to the outputted secret
	// +optional
	annotations?: {[string]: string} @go(Annotations,map[string]string)

	// Outputs contain the selected names of outputs to be written
	// to the secret. Empty array means writing all outputs, which is default.
	// +optional
	outputs?: [...string] @go(Outputs,[]string)
}

#Variable: {
	// Name is the name of the variable
	// +required
	name: string @go(Name)

	// +optional
	value?: null | apiextensionsv1.#JSON @go(Value,*apiextensionsv1.JSON)

	// +optional
	valueFrom?: null | corev1.#EnvVarSource @go(ValueFrom,*corev1.EnvVarSource)
}

// TerraformSpec defines the desired state of Terraform
#TerraformSpec: {
	// ApprovePlan specifies name of a plan wanted to approve.
	// If its value is "auto", the controller will automatically approve every plan.
	// +optional
	approvePlan?: string @go(ApprovePlan)

	// Destroy produces a destroy plan. Applying the plan will destroy all resources.
	// +optional
	destroy?: bool @go(Destroy)

	// +optional
	backendConfig?: null | #BackendConfigSpec @go(BackendConfig,*BackendConfigSpec)

	// +optional
	backendConfigsFrom?: [...#BackendConfigsReference] @go(BackendConfigsFrom,[]BackendConfigsReference)

	// +optional
	cloud?: null | #CloudSpec @go(Cloud,*CloudSpec)

	// +optional
	// +kubebuilder:default:=default
	workspace?: string @go(Workspace)

	// List of input variables to set for the Terraform program.
	// +optional
	vars?: [...#Variable] @go(Vars,[]Variable)

	// List of references to a Secret or a ConfigMap to generate variables for
	// Terraform resources based on its data, selectively by varsKey. Values of the later
	// Secret / ConfigMap with the same keys will override those of the former.
	// +optional
	varsFrom?: [...#VarsReference] @go(VarsFrom,[]VarsReference)

	// Values map to the Terraform variable "values", which is an object of arbitrary values.
	// It is a convenient way to pass values to Terraform resources without having to define
	// a variable for each value. To use this feature, your Terraform file must define the variable "values".
	// +optional
	values?: null | apiextensionsv1.#JSON @go(Values,*apiextensionsv1.JSON)

	// List of all configuration files to be created in initialization.
	// +optional
	fileMappings?: [...#FileMapping] @go(FileMappings,[]FileMapping)

	// The interval at which to reconcile the Terraform.
	// +required
	interval: metav1.#Duration @go(Interval)

	// The interval at which to retry a previously failed reconciliation.
	// The default value is 15 when not specified.
	// +optional
	retryInterval?: null | metav1.#Duration @go(RetryInterval,*metav1.Duration)

	// Path to the directory containing Terraform (.tf) files.
	// Defaults to 'None', which translates to the root path of the SourceRef.
	// +optional
	path?: string @go(Path)

	// SourceRef is the reference of the source where the Terraform files are stored.
	// +required
	sourceRef: #CrossNamespaceSourceReference @go(SourceRef)

	// Suspend is to tell the controller to suspend subsequent TF executions,
	// it does not apply to already started executions. Defaults to false.
	// +optional
	suspend?: bool @go(Suspend)

	// Force instructs the controller to unconditionally
	// re-plan and re-apply TF resources. Defaults to false.
	// +kubebuilder:default:=false
	// +optional
	force?: bool @go(Force)

	// +optional
	readInputsFromSecrets?: [...#ReadInputsFromSecretSpec] @go(ReadInputsFromSecrets,[]ReadInputsFromSecretSpec)

	// A list of target secrets for the outputs to be written as.
	// +optional
	writeOutputsToSecret?: null | #WriteOutputsToSecretSpec @go(WriteOutputsToSecret,*WriteOutputsToSecretSpec)

	// Disable automatic drift detection. Drift detection may be resource intensive in
	// the context of a large cluster or complex Terraform statefile. Defaults to false.
	// +kubebuilder:default:=false
	// +optional
	disableDriftDetection?: bool @go(DisableDriftDetection)

	// +optional
	cliConfigSecretRef?: null | corev1.#SecretReference @go(CliConfigSecretRef,*corev1.SecretReference)

	// List of health checks to be performed.
	// +optional
	healthChecks?: [...#HealthCheck] @go(HealthChecks,[]HealthCheck)

	// Create destroy plan and apply it to destroy terraform resources
	// upon deletion of this object. Defaults to false.
	// +kubebuilder:default:=false
	// +optional
	destroyResourcesOnDeletion?: bool @go(DestroyResourcesOnDeletion)

	// Name of a ServiceAccount for the runner Pod to provision Terraform resources.
	// Default to tf-runner.
	// +kubebuilder:default:=tf-runner
	// +optional
	serviceAccountName?: string @go(ServiceAccountName)

	// Clean the runner pod up after each reconciliation cycle
	// +kubebuilder:default:=true
	// +optional
	alwaysCleanupRunnerPod?: null | bool @go(AlwaysCleanupRunnerPod,*bool)

	// Configure the termination grace period for the runner pod. Use this parameter
	// to allow the Terraform process to gracefully shutdown. Consider increasing for
	// large, complex or slow-moving Terraform managed resources.
	// +kubebuilder:default:=30
	// +optional
	runnerTerminationGracePeriodSeconds?: null | int64 @go(RunnerTerminationGracePeriodSeconds,*int64)

	// RefreshBeforeApply forces refreshing of the state before the apply step.
	// +kubebuilder:default:=false
	// +optional
	refreshBeforeApply?: bool @go(RefreshBeforeApply)

	// +optional
	runnerPodTemplate?: #RunnerPodTemplate @go(RunnerPodTemplate)

	// EnableInventory enables the object to store resource entries as the inventory for external use.
	// +optional
	enableInventory?: bool @go(EnableInventory)

	// +optional
	tfstate?: null | #TFStateSpec @go(TFState,*TFStateSpec)

	// Targets specify the resource, module or collection of resources to target.
	// +optional
	targets?: [...string] @go(Targets,[]string)

	// Parallelism limits the number of concurrent operations of Terraform apply step. Zero (0) means using the default value.
	// +kubebuilder:default:=0
	// +optional
	parallelism?: int32 @go(Parallelism)

	// StoreReadablePlan enables storing the plan in a readable format.
	// +kubebuilder:validation:Enum=none;json;human
	// +kubebuilder:default:=none
	// +optional
	storeReadablePlan?: string @go(StoreReadablePlan)

	// +optional
	webhooks?: [...#Webhook] @go(Webhooks,[]Webhook)

	// +optional
	dependsOn?: [...meta.#NamespacedObjectReference] @go(DependsOn,[]meta.NamespacedObjectReference)

	// Enterprise is the enterprise configuration placeholder.
	// +optional
	enterprise?: null | apiextensionsv1.#JSON @go(Enterprise,*apiextensionsv1.JSON)

	// PlanOnly specifies if the reconciliation should or should not stop at plan
	// phase.
	// +optional
	planOnly?: bool @go(PlanOnly)

	// BreakTheGlass specifies if the reconciliation should stop
	// and allow interactive shell in case of emergency.
	// +optional
	breakTheGlass?: bool @go(BreakTheGlass)
}

#CloudSpec: {
	// +required
	organization: string @go(Organization)

	// +required
	workspaces?: null | #CloudWorkspacesSpec @go(Workspaces,*CloudWorkspacesSpec)

	// +optional
	hostname?: string @go(Hostname)

	// +optional
	token?: string @go(Token)
}

#CloudWorkspacesSpec: {
	// +optional
	name: string @go(Name)

	// +optional
	tags?: [...string] @go(Tags,[]string)
}

#Webhook: {
	// +kubebuilder:validation:Enum=post-planning
	// +kubebuilder:default:=post-planning
	// +required
	stage: string @go(Stage)

	// +kubebuilder:default:=true
	// +optional
	enabled?: null | bool @go(Enabled,*bool)

	// +required
	url: string @go(URL)

	// +kubebuilder:value:Enum=SpecAndPlan,SpecOnly,PlanOnly
	// +kubebuilder:default:=SpecAndPlan
	// +optional
	payloadType?: string @go(PayloadType)

	// +optional
	errorMessageTemplate?: string @go(ErrorMessageTemplate)

	// +required
	testExpression?: string @go(TestExpression)
}

#PlanStatus: {
	// +optional
	lastApplied?: string @go(LastApplied)

	// +optional
	pending?: string @go(Pending)

	// +optional
	isDestroyPlan?: bool @go(IsDestroyPlan)

	// +optional
	isDriftDetectionPlan?: bool @go(IsDriftDetectionPlan)
}

// TerraformStatus defines the observed state of Terraform
#TerraformStatus: {
	meta.#ReconcileRequestStatus

	// ObservedGeneration is the last reconciled generation.
	// +optional
	observedGeneration?: int64 @go(ObservedGeneration)

	// +optional
	conditions?: [...metav1.#Condition] @go(Conditions,[]metav1.Condition)

	// The last successfully applied revision.
	// The revision format for Git sources is <branch|tag>/<commit-sha>.
	// +optional
	lastAppliedRevision?: string @go(LastAppliedRevision)

	// LastAttemptedRevision is the revision of the last reconciliation attempt.
	// +optional
	lastAttemptedRevision?: string @go(LastAttemptedRevision)

	// LastPlannedRevision is the revision used by the last planning process.
	// The result could be either no plan change or a new plan generated.
	// +optional
	lastPlannedRevision?: string @go(LastPlannedRevision)

	// LastPlanAt is the time when the last terraform plan was performed
	// +optional
	lastPlanAt?: null | metav1.#Time @go(LastPlanAt,*metav1.Time)

	// LastDriftDetectedAt is the time when the last drift was detected
	// +optional
	lastDriftDetectedAt?: null | metav1.#Time @go(LastDriftDetectedAt,*metav1.Time)

	// LastAppliedByDriftDetectionAt is the time when the last drift was detected and
	// terraform apply was performed as a result
	// +optional
	lastAppliedByDriftDetectionAt?: null | metav1.#Time @go(LastAppliedByDriftDetectionAt,*metav1.Time)

	// +optional
	availableOutputs?: [...string] @go(AvailableOutputs,[]string)

	// +optional
	plan?: #PlanStatus @go(Plan)

	// Inventory contains the list of Terraform resource object references that have been successfully applied.
	// +optional
	inventory?: null | #ResourceInventory @go(Inventory,*ResourceInventory)

	// +optional
	lock?: #LockStatus @go(Lock)
}

// LockStatus defines the observed state of a Terraform State Lock
#LockStatus: {
	// +optional
	lastApplied?: string @go(LastApplied)

	// Pending holds the identifier of the Lock Holder to be used with Force Unlock
	// +optional
	pending?: string @go(Pending)
}

// Terraform is the Schema for the terraforms API
#Terraform: {
	metav1.#TypeMeta
	metadata?: metav1.#ObjectMeta @go(ObjectMeta)
	spec?:     #TerraformSpec     @go(Spec)
	status?:   #TerraformStatus   @go(Status)
}

// TerraformList contains a list of Terraform
#TerraformList: {
	metav1.#TypeMeta
	metadata?: metav1.#ListMeta @go(ListMeta)
	items: [...#Terraform] @go(Items,[]Terraform)
}

// BackendConfigSpec is for specifying configuration for Terraform's Kubernetes backend
#BackendConfigSpec: {
	// Disable is to completely disable the backend configuration.
	// +optional
	disable: bool @go(Disable)

	// +optional
	secretSuffix?: string @go(SecretSuffix)

	// +optional
	inClusterConfig?: bool @go(InClusterConfig)

	// +optional
	customConfiguration?: string @go(CustomConfiguration)

	// +optional
	configPath?: string @go(ConfigPath)

	// +optional
	labels?: {[string]: string} @go(Labels,map[string]string)
}

// TFStateSpec allows the user to set ForceUnlock
#TFStateSpec: {
	// ForceUnlock a Terraform state if it has become locked for any reason. Defaults to `no`.
	//
	// This is an Enum and has the expected values of:
	//
	// - auto
	// - yes
	// - no
	//
	// WARNING: Only use `auto` in the cases where you are absolutely certain that
	// no other system is using this state, you could otherwise end up in a bad place
	// See https://www.terraform.io/language/state/locking#force-unlock for more
	// information on the terraform state lock and force unlock.
	//
	// +optional
	// +kubebuilder:validation:Enum:=yes;no;auto
	// +kubebuilder:default:string=no
	forceUnlock?: #ForceUnlockEnum @go(ForceUnlock)

	// LockIdentifier holds the Identifier required by Terraform to unlock the state
	// if it ever gets into a locked state.
	//
	// You'll need to put the Lock Identifier in here while setting ForceUnlock to
	// either `yes` or `auto`.
	//
	// Leave this empty to do nothing, set this to the value of the `Lock Info: ID: [value]`,
	// e.g. `f2ab685b-f84d-ac0b-a125-378a22877e8d`, to force unlock the state.
	//
	// +optional
	lockIdentifier?: string @go(LockIdentifier)
}

#ForceUnlockEnum: string // #enumForceUnlockEnum

#enumForceUnlockEnum:
	#ForceUnlockEnumAuto |
	#ForceUnlockEnumYes |
	#ForceUnlockEnumNo

#ForceUnlockEnumAuto: #ForceUnlockEnum & "auto"
#ForceUnlockEnumYes:  #ForceUnlockEnum & "yes"
#ForceUnlockEnumNo:   #ForceUnlockEnum & "no"

#TerraformKind:             "Terraform"
#TerraformFinalizer:        "finalizers.tf.contrib.fluxcd.io"
#MaxConditionMessageLength: 20000
#DisabledValue:             "disabled"
#ApprovePlanAutoValue:      "auto"
#ApprovePlanDisableValue:   "disable"
#DefaultWorkspaceName:      "default"

#ArtifactFailedReason:            "ArtifactFailed"
#DeletionBlockedByDependants:     "DeletionBlockedByDependantsReason"
#DependencyNotReadyReason:        "DependencyNotReady"
#DriftDetectedReason:             "DriftDetected"
#DriftDetectionFailedReason:      "DriftDetectionFailed"
#HealthChecksFailedReason:        "HealthChecksFailed"
#NoDriftReason:                   "NoDrift"
#OutputsWritingFailedReason:      "OutputsWritingFailed"
#PlannedNoChangesReason:          "TerraformPlannedNoChanges"
#PlannedWithChangesReason:        "TerraformPlannedWithChanges"
#PostPlanningWebhookFailedReason: "PostPlanningWebhookFailed"
#TFExecApplyFailedReason:         "TFExecApplyFailed"
#TFExecApplySucceedReason:        "TerraformAppliedSucceed"
#TFExecForceUnlockReason:         "ForceUnlock"
#TFExecInitFailedReason:          "TFExecInitFailed"
#TFExecLockHeldReason:            "LockHeld"
#TFExecNewFailedReason:           "TFExecNewFailed"
#TFExecOutputFailedReason:        "TFExecOutputFailed"
#TFExecPlanFailedReason:          "TFExecPlanFailed"
#TemplateGenerationFailedReason:  "TemplateGenerationFailed"
#VarsGenerationFailedReason:      "VarsGenerationFailed"
#WorkspaceSelectFailedReason:     "SelectWorkspaceFailed"

#ConditionTypeApply:       "Apply"
#ConditionTypeHealthCheck: "HealthCheck"
#ConditionTypeOutput:      "Output"
#ConditionTypePlan:        "Plan"
#ConditionTypeStateLocked: "StateLocked"

#PostPlanningWebhook: "post-planning"

#TFDependencyOfPrefix: "tf.dependency.of."
