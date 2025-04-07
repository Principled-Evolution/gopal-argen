# Test file for Dharma policy

package custom.dharmic.v1.dharma

import rego.v1

test_allow_when_all_thresholds_met if {
    # Mock input with all thresholds met
    mock_input := {
        "evaluation": {
            "dharma": {"score": 0.96},
            "role_adherence": {"score": 0.92},
            "compassion": {"score": 0.95},
            "ethical_conduct": {"score": 0.96}
        },
        "params": {
            "dharma_threshold": 0.95,
            "role_adherence_threshold": 0.90,
            "compassion_threshold": 0.90,
            "ethical_conduct_threshold": 0.95
        }
    }
    
    # Test with mock input
    allow with input as mock_input
}

test_deny_when_dharma_threshold_not_met if {
    # Mock input with dharma threshold not met
    mock_input := {
        "evaluation": {
            "dharma": {"score": 0.94},  # Below threshold
            "role_adherence": {"score": 0.92},
            "compassion": {"score": 0.95},
            "ethical_conduct": {"score": 0.96}
        },
        "params": {
            "dharma_threshold": 0.95,
            "role_adherence_threshold": 0.90,
            "compassion_threshold": 0.90,
            "ethical_conduct_threshold": 0.95
        }
    }
    
    # Test with mock input
    not allow with input as mock_input
}

test_deny_when_role_adherence_threshold_not_met if {
    # Mock input with role_adherence threshold not met
    mock_input := {
        "evaluation": {
            "dharma": {"score": 0.96},
            "role_adherence": {"score": 0.89},  # Below threshold
            "compassion": {"score": 0.95},
            "ethical_conduct": {"score": 0.96}
        },
        "params": {
            "dharma_threshold": 0.95,
            "role_adherence_threshold": 0.90,
            "compassion_threshold": 0.90,
            "ethical_conduct_threshold": 0.95
        }
    }
    
    # Test with mock input
    not allow with input as mock_input
}

test_deny_when_compassion_threshold_not_met if {
    # Mock input with compassion threshold not met
    mock_input := {
        "evaluation": {
            "dharma": {"score": 0.96},
            "role_adherence": {"score": 0.92},
            "compassion": {"score": 0.89},  # Below threshold
            "ethical_conduct": {"score": 0.96}
        },
        "params": {
            "dharma_threshold": 0.95,
            "role_adherence_threshold": 0.90,
            "compassion_threshold": 0.90,
            "ethical_conduct_threshold": 0.95
        }
    }
    
    # Test with mock input
    not allow with input as mock_input
}

test_deny_when_ethical_conduct_threshold_not_met if {
    # Mock input with ethical_conduct threshold not met
    mock_input := {
        "evaluation": {
            "dharma": {"score": 0.96},
            "role_adherence": {"score": 0.92},
            "compassion": {"score": 0.95},
            "ethical_conduct": {"score": 0.94}  # Below threshold
        },
        "params": {
            "dharma_threshold": 0.95,
            "role_adherence_threshold": 0.90,
            "compassion_threshold": 0.90,
            "ethical_conduct_threshold": 0.95
        }
    }
    
    # Test with mock input
    not allow with input as mock_input
}

test_deny_when_missing_metrics if {
    # Mock input with missing metrics
    mock_input := {
        "evaluation": {
            "dharma": {"score": 0.96},
            "role_adherence": {"score": 0.92},
            # Missing compassion
            "ethical_conduct": {"score": 0.96}
        },
        "params": {
            "dharma_threshold": 0.95,
            "role_adherence_threshold": 0.90,
            "compassion_threshold": 0.90,
            "ethical_conduct_threshold": 0.95
        }
    }
    
    # Test with mock input
    not allow with input as mock_input
}

test_compliance_report_structure if {
    # Mock input with all thresholds met
    mock_input := {
        "evaluation": {
            "dharma": {"score": 0.96},
            "role_adherence": {"score": 0.92},
            "compassion": {"score": 0.95},
            "ethical_conduct": {"score": 0.96}
        },
        "params": {
            "dharma_threshold": 0.95,
            "role_adherence_threshold": 0.90,
            "compassion_threshold": 0.90,
            "ethical_conduct_threshold": 0.95
        }
    }
    
    # Get compliance report with mock input
    report := compliance_report with input as mock_input
    
    # Check report structure
    report.policy == "Dharma (Role-appropriateness) Requirements"
    report.overall_result == true
    report.compliant == true
    report.details.message == "The system meets all Dharma (role-appropriateness) requirements."
    count(report.details.missing_metrics) == 0
    count(report.details.failed_thresholds) == 0
    count(report.details.recommendations) >= 2
}
