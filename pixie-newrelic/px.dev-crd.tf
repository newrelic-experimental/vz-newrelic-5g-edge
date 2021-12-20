resource "kubernetes_manifest" "customresourcedefinition_viziers_px_dev" {
  manifest = {
    "apiVersion" = "apiextensions.k8s.io/v1"
    "kind" = "CustomResourceDefinition"
    "metadata" = {
      "annotations" = {
        "controller-gen.kubebuilder.io/version" = "v0.4.1"
      }
      "name" = "viziers.px.dev"
    }
    "spec" = {
      "group" = "px.dev"
      "names" = {
        "kind" = "Vizier"
        "listKind" = "VizierList"
        "plural" = "viziers"
        "singular" = "vizier"
      }
      "scope" = "Namespaced"
      "versions" = [
        {
          "name" = "v1alpha1"
          "schema" = {
            "openAPIV3Schema" = {
              "description" = "Vizier is the Schema for the viziers API"
              "properties" = {
                "apiVersion" = {
                  "description" = "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
                  "type" = "string"
                }
                "kind" = {
                  "description" = "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
                  "type" = "string"
                }
                "metadata" = {
                  "type" = "object"
                }
                "spec" = {
                  "description" = "VizierSpec defines the desired state of Vizier"
                  "properties" = {
                    "cloudAddr" = {
                      "description" = "CloudAddr is the address of the cloud instance that the Vizier should be pointing to."
                      "type" = "string"
                    }
                    "clusterName" = {
                      "description" = "ClusterName is a name for the Vizier instance, usually specifying which cluster the Vizier is deployed to. If not specified, a random name will be generated."
                      "type" = "string"
                    }
                    "dataAccess" = {
                      "description" = "DataAccess defines the level of data that may be accesssed when executing a script on the cluster. If none specified, assumes full data access."
                      "enum" = [
                        "Full",
                        "Restricted",
                      ]
                      "type" = "string"
                    }
                    "deployKey" = {
                      "description" = "DeployKey is the deploy key associated with the Vizier instance. This is used to link the Vizier to a specific user/org."
                      "type" = "string"
                    }
                    "devCloudNamespace" = {
                      "description" = "DevCloudNamespace should be specified only for dev versions of Pixie cloud which have no ingress to help redirect traffic to the correct service. The DevCloudNamespace is the namespace that the dev Pixie cloud is running on, for example: \"plc-dev\"."
                      "type" = "string"
                    }
                    "disableAutoUpdate" = {
                      "description" = "DisableAutoUpdate specifies whether auto update should be enabled for the Vizier instance."
                      "type" = "boolean"
                    }
                    "enableClockworkIntegration" = {
                      "description" = "EnableClockworkIntegration enables getting timestamp offsets from a clockwork agent, for time-sync purposes."
                      "type" = "boolean"
                    }
                    "patches" = {
                      "additionalProperties" = {
                        "type" = "string"
                      }
                      "description" = "Patches defines patches that should be applied to Vizier resources. The key of the patch should be the name of the resource that is patched. The value of the patch is the patch, encoded as a string which follow the \"strategic merge patch\" rules for K8s."
                      "type" = "object"
                    }
                    "pemMemoryLimit" = {
                      "description" = "PemMemoryLimit is a memory limit applied specifically to PEM pods."
                      "type" = "string"
                    }
                    "pod" = {
                      "description" = "Pod defines the policy for creating Vizier pods."
                      "properties" = {
                        "annotations" = {
                          "additionalProperties" = {
                            "type" = "string"
                          }
                          "description" = "Annotations specifies the annotations to attach to pods the operator creates."
                          "type" = "object"
                        }
                        "labels" = {
                          "additionalProperties" = {
                            "type" = "string"
                          }
                          "description" = "Labels specifies the labels to attach to pods the operator creates."
                          "type" = "object"
                        }
                        "resources" = {
                          "description" = "Resources is the resource requirements for a container. This field cannot be updated once the cluster is created."
                          "properties" = {
                            "limits" = {
                              "additionalProperties" = {
                                "anyOf" = [
                                  {
                                    "type" = "integer"
                                  },
                                  {
                                    "type" = "string"
                                  },
                                ]
                                "pattern" = "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
                                "x-kubernetes-int-or-string" = true
                              }
                              "description" = "Limits describes the maximum amount of compute resources allowed. More info: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/"
                              "type" = "object"
                            }
                            "requests" = {
                              "additionalProperties" = {
                                "anyOf" = [
                                  {
                                    "type" = "integer"
                                  },
                                  {
                                    "type" = "string"
                                  },
                                ]
                                "pattern" = "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
                                "x-kubernetes-int-or-string" = true
                              }
                              "description" = "Requests describes the minimum amount of compute resources required. If Requests is omitted for a container, it defaults to Limits if that is explicitly specified, otherwise to an implementation-defined value. More info: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/"
                              "type" = "object"
                            }
                          }
                          "type" = "object"
                        }
                      }
                      "type" = "object"
                    }
                    "useEtcdOperator" = {
                      "description" = "UseEtcdOperator specifies whether the metadata service should use etcd for storage."
                      "type" = "boolean"
                    }
                    "version" = {
                      "description" = "Version is the desired version of the Vizier instance."
                      "type" = "string"
                    }
                  }
                  "required" = [
                    "deployKey",
                  ]
                  "type" = "object"
                }
                "status" = {
                  "description" = "VizierStatus defines the observed state of Vizier"
                  "properties" = {
                    "lastReconciliationPhaseTime" = {
                      "description" = "LastReconciliationPhaseTime is the last time that the ReconciliationPhase changed."
                      "format" = "date-time"
                      "type" = "string"
                    }
                    "message" = {
                      "description" = "Message is a human-readable message with details about why the Vizier is in this condition."
                      "type" = "string"
                    }
                    "reconciliationPhase" = {
                      "description" = "ReconciliationPhase describes the state the Reconciler is in for this Vizier. See the documentation above the ReconciliationPhase type for more information."
                      "type" = "string"
                    }
                    "sentryDSN" = {
                      "description" = "SentryDSN is key for Viziers that is used to send errors and stacktraces to Sentry."
                      "type" = "string"
                    }
                    "version" = {
                      "description" = "Version is the actual version of the Vizier instance."
                      "type" = "string"
                    }
                    "vizierPhase" = {
                      "description" = "VizierPhase is a high-level summary of where the Vizier is in its lifecycle."
                      "type" = "string"
                    }
                    "vizierReason" = {
                      "description" = "VizierReason is a short, machine understandable string that gives the reason for the transition into the Vizier's current status."
                      "type" = "string"
                    }
                  }
                  "type" = "object"
                }
              }
              "type" = "object"
            }
          }
          "served" = true
          "storage" = true
          "subresources" = {
            "status" = {}
          }
        },
      ]
    }
  }
}
