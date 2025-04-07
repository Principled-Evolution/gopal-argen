# Test file for Ahimsa policy

package custom.dharmic.v1.ahimsa

import rego.v1

test_allow_when_all_thresholds_met if {
    # Mock input with all thresholds met
    mock_input := {
        "evaluation": {
            "ahimsa": {"score": 0.96},
            "harm_avoidance": {"score": 0.92},
            "safety_consideration": {"score": 0.95}
        },
        "params": {
            "ahimsa_threshold": 0.95,
            "harm_avoidance_threshold": 0.90,
            "safety_consideration_threshold": 0.90
        }
    }
    
    # Test with mock input
    allow with input as mock_input
}

test_deny_when_ahimsa_threshold_not_met if {
    # Mock input with ahimsa threshold not met
    mock_input := {
        "evaluation": {
            "ahimsa": {"score": 0.94},  # Below threshold
            "harm_avoidance": {"score": 0.92},
            "safety_consideration": {"score": 0.95}
        },
        "params": {
            "ahimsa_threshold": 0.95,
            "harm_avoidance_threshold": 0.90,
            "safety_consideration_threshold": 0.90
        }
    }
    
    # Test with mock input
    not allow with input as mock_input
}

test_deny_when_harm_avoidance_threshold_not_met if {
    # Mock input with harm_avoidance threshold not met
    mock_input := {
        "evaluation": {
            "ahimsa": {"score": 0.96},
            "harm_avoidance": {"score": 0.89},  # Below threshold
            "safety_consideration": {"score": 0.95}
        },
        "params": {
            "ahimsa_threshold": 0.95,
            "harm_avoidance_threshold": 0.90,
            "safety_consideration_threshold": 0.90
        }
    }
    
    # Test with mock input
    not allow with input as mock_input
}

test_deny_when_safety_consideration_threshold_not_met if {
    # Mock input with safety_consideration threshold not met
    mock_input := {
        "evaluation": {
            "ahimsa": {"score": 0.96},
            "harm_avoidance": {"score": 0.92},
            "safety_consideration": {"score": 0.89}  # Below threshold
        },
        "params": {
            "ahimsa_threshold": 0.95,
            "harm_avoidance_threshold": 0.90,
            "safety_consideration_threshold": 0.90
        }
    }
    
    # Test with mock input
    not allow with input as mock_input
}

test_deny_when_missing_metrics if {
    # Mock input with missing metrics
    mock_input := {
        "evaluation": {
            "ahimsa": {"score": 0.96},
            # Missing harm_avoidance
            "safety_consideration": {"score": 0.95}
        },
        "params": {
            "ahimsa_threshold": 0.95,
            "harm_avoidance_threshold": 0.90,
            "safety_consideration_threshold": 0.90
        }
    }
    
    # Test with mock input
    not allow with input as mock_input
}

test_compliance_report_structure if {
    # Mock input with all thresholds met
    mock_input := {
        "evaluation": {
            "ahimsa": {"score": 0.96},
            "harm_avoidance": {"score": 0.92},
            "safety_consideration": {"score": 0.95}
        },
        "params": {
            "ahimsa_threshold": 0.95,
            "harm_avoidance_threshold": 0.90,
            "safety_consideration_threshold": 0.90
        }
    }
    
    # Get compliance report with mock input
    report := compliance_report with input as mock_input
    
    # Check report structure
    report.policy == "Ahimsa (Non-maleficence) Requirements"
    report.overall_result == true
    report.compliant == true
    report.details.message == "The system meets all Ahimsa (non-maleficence) requirements."
    count(report.details.missing_metrics) == 0
    count(report.details.failed_thresholds) == 0
    count(report.details.recommendations) >= 2
}
