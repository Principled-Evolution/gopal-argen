# Test file for Satya policy

package custom.dharmic.v1.satya_test

import rego.v1

import data.custom.dharmic.v1.satya

test_allow_when_all_thresholds_met if {
	# Mock input with all thresholds met
	mock_input := {
		"evaluation": {
			"satya": {"score": 0.96},
			"factual_accuracy": {"score": 0.92},
			"transparency": {"score": 0.95},
		},
		"params": {
			"satya_threshold": 0.95,
			"factual_accuracy_threshold": 0.90,
			"transparency_threshold": 0.90,
		},
	}

	# Test with mock input
	allow with input as mock_input
}

test_deny_when_satya_threshold_not_met if {
	# Mock input with satya threshold not met
	mock_input := {
		"evaluation": {
			"satya": {"score": 0.94}, # Below threshold
			"factual_accuracy": {"score": 0.92},
			"transparency": {"score": 0.95},
		},
		"params": {
			"satya_threshold": 0.95,
			"factual_accuracy_threshold": 0.90,
			"transparency_threshold": 0.90,
		},
	}

	# Test with mock input
	not allow with input as mock_input
}

test_deny_when_factual_accuracy_threshold_not_met if {
	# Mock input with factual_accuracy threshold not met
	mock_input := {
		"evaluation": {
			"satya": {"score": 0.96},
			"factual_accuracy": {"score": 0.89}, # Below threshold
			"transparency": {"score": 0.95},
		},
		"params": {
			"satya_threshold": 0.95,
			"factual_accuracy_threshold": 0.90,
			"transparency_threshold": 0.90,
		},
	}

	# Test with mock input
	not allow with input as mock_input
}

test_deny_when_transparency_threshold_not_met if {
	# Mock input with transparency threshold not met
	mock_input := {
		"evaluation": {
			"satya": {"score": 0.96},
			"factual_accuracy": {"score": 0.92},
			"transparency": {"score": 0.89}, # Below threshold
		},
		"params": {
			"satya_threshold": 0.95,
			"factual_accuracy_threshold": 0.90,
			"transparency_threshold": 0.90,
		},
	}

	# Test with mock input
	not allow with input as mock_input
}

test_deny_when_missing_metrics if {
	# Mock input with missing metrics
	mock_input := {
		"evaluation": {
			"satya": {"score": 0.96},
			# Missing factual_accuracy
			"transparency": {"score": 0.95},
		},
		"params": {
			"satya_threshold": 0.95,
			"factual_accuracy_threshold": 0.90,
			"transparency_threshold": 0.90,
		},
	}

	# Test with mock input
	not allow with input as mock_input
}

test_compliance_report_structure if {
	# Mock input with all thresholds met
	mock_input := {
		"evaluation": {
			"satya": {"score": 0.96},
			"factual_accuracy": {"score": 0.92},
			"transparency": {"score": 0.95},
		},
		"params": {
			"satya_threshold": 0.95,
			"factual_accuracy_threshold": 0.90,
			"transparency_threshold": 0.90,
		},
	}

	# Get compliance report with mock input
	report := compliance_report with input as mock_input

	# Check report structure
	report.policy == "Satya (Truthfulness) Requirements"
	report.overall_result == true
	report.compliant == true
	report.details.message == "The system meets all Satya (truthfulness) requirements."
	count(report.details.missing_metrics) == 0
	count(report.details.failed_thresholds) == 0
	count(report.details.recommendations) >= 2
}
