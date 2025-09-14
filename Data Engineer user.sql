SELECT employee_id, name, role, hire_date, branch_location
	FROM operations.employees;

SELECT trial_id, drug_id, phase, start_date, end_date, status
	FROM research.clinical_trials;

SELECT approval_id, drug_id, agency, approval_date, status
	FROM research.approvals;
	